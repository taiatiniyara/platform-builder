# Observability at Scale

Patterns for observing complex, distributed systems. Apply when you have
multiple services and need to debug cross-service issues.

## Tool Selection

This file describes **patterns**, not specific tools. Tools mentioned are
**examples** to illustrate the pattern — not recommendations. When selecting
tools for this project, the agent MUST:
1. Check `docs/ARCHITECTURE.md` for the declared stack
2. Research current options (never suggest from memory)
3. Present 2-3 options with trade-offs
4. Let the user decide

## When to Apply

- 5+ services communicating with each other
- Need to debug cross-service issues
- High availability requirements (need to detect issues fast)
- Complex user journeys spanning multiple services
- Team >5 engineers (need shared observability)

## Three Pillars of Observability

### 1. Metrics

Numerical measurements over time.

**Types:**
- **Counter:** cumulative value (requests, errors)
- **Gauge:** instantaneous value (CPU, memory, connections)
- **Histogram:** distribution of values (latency, request size)

**Standard metrics per service:**
- Request rate (requests/second)
- Error rate (errors/requests)
- Latency (p50, p95, p99)
- Saturation (CPU, memory, disk, connections)

**Tools:**
- Prometheus (metrics collection)
- VictoriaMetrics (scalable Prometheus)
- Datadog (commercial)
- New Relic (commercial)

**Best practices:**
- Use standard metric names (OpenTelemetry conventions)
- Label metrics (service, environment, endpoint)
- Set up alerts on SLOs (not raw metrics)
- Create dashboards per service

### 2. Logs

Discrete events with context.

**Structure:**
```json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "level": "error",
  "service": "order-service",
  "traceId": "abc123",
  "spanId": "def456",
  "message": "Failed to process order",
  "error": "Payment service timeout",
  "data": {
    "orderId": "order-123",
    "customerId": "cust-456"
  }
}
```

**Rules:**
- Structured logging (JSON)
- Include trace ID (for distributed tracing)
- Include service name
- Standard log levels (debug, info, warn, error)
- Don't log sensitive data (PII, secrets)

**Tools:**
- ELK stack (Elasticsearch, Logstash, Kibana)
- Loki (lightweight, Grafana-native)
- Datadog Logs (commercial)
- Splunk (commercial)

**Best practices:**
- Centralized logging (all services to one place)
- Log aggregation (collect from all instances)
- Log rotation (don't fill disk)
- Log correlation (link logs to traces)

### 3. Traces

End-to-end request flow across services.

**Concepts:**
- **Trace:** complete journey of a request
- **Span:** unit of work within a trace (one service)
- **Context:** trace ID, span ID, parent span ID

**Example trace:**
```
Trace: abc123
├── Span: API Gateway (100ms)
│   ├── Span: Order Service (80ms)
│   │   ├── Span: Database (20ms)
│   │   └── Span: Payment Service (50ms)
│   │       └── Span: Database (10ms)
│   └── Span: Notification Service (10ms)
```

**Tools:**
- OpenTelemetry (standard, vendor-neutral)
- Jaeger (open source)
- Zipkin (open source)
- Datadog APM (commercial)
- New Relic (commercial)

**Best practices:**
- Instrument all services (OpenTelemetry)
- Propagate trace context across service boundaries
- Sample traces (100% in dev, 1-10% in production)
- Set up alerts on trace errors

## OpenTelemetry

### What is OpenTelemetry?

Vendor-neutral standard for observability.

**Components:**
- **API:** instrumentation API (language-specific)
- **SDK:** implementation (collects, processes, exports)
- **Collector:** receives, processes, exports telemetry
- **Instrumentation:** auto/manual instrumentation for libraries

**Benefits:**
- Vendor-neutral (switch backends without re-instrumenting)
- Standard (consistent across languages)
- Active community (wide adoption)

### Instrumentation

**Auto-instrumentation:**
- Zero code changes (library injects instrumentation)
- Supports popular frameworks (Express, Django, Spring)

**Example (Node.js):**
```bash
npm install @opentelemetry/auto-instrumentations-node
```

```javascript
// Tracer initialization
const { getNodeAutoInstrumentations } = require('@opentelemetry/auto-instrumentations-node');
const { registerInstrumentations } = require('@opentelemetry/sdk-instrumentation');

registerInstrumentations({
  instrumentations: [getNodeAutoInstrumentations()],
});
```

**Manual instrumentation:**
- Custom spans, metrics, logs
- Business-specific telemetry

**Example (Node.js):**
```javascript
const { trace } = require('@opentelemetry/api');

const tracer = trace.getTracer('order-service');

async function processOrder(orderId) {
  return tracer.startActiveSpan('processOrder', async (span) => {
    span.setAttribute('orderId', orderId);
    try {
      // ... process order
      span.setStatus({ code: SpanStatusCode.OK });
    } catch (error) {
      span.setStatus({ code: SpanStatusCode.ERROR, message: error.message });
      throw error;
    } finally {
      span.end();
    }
  });
}
```

### OpenTelemetry Collector

Receives, processes, exports telemetry data.

**Setup:**
```yaml
# otel-collector-config.yaml
receivers:
  otlp:
    protocols:
      grpc:
      http:

processors:
  batch:
    timeout: 5s
    send_batch_size: 1000

exporters:
  otlp/jaeger:
    endpoint: jaeger:4317
  prometheus:
    endpoint: ":8889"
  loki:
    endpoint: http://loki:3100/loki/api/v1/push

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlp/jaeger]
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [prometheus]
    logs:
      receivers: [otlp]
      processors: [batch]
      exporters: [loki]
```

## Distributed Tracing

### Context Propagation

Pass trace context across service boundaries.

**HTTP:**
```
Headers:
  traceparent: 00-abc123-def456-01
  tracestate: key1=value1,key2=value2
```

**Message queues:**
```
Message headers:
  traceparent: 00-abc123-def456-01
```

**gRPC:**
```
Metadata:
  traceparent: 00-abc123-def456-01
```

### Sampling

Reduce trace volume by sampling.

**Strategies:**
- **Head-based sampling:** sample at entry point (e.g., 10% of requests)
- **Tail-based sampling:** sample based on outcome (e.g., all errors, 1% of successes)
- **Adaptive sampling:** adjust sampling rate based on load

**Example (head-based):**
```javascript
const { TraceIdRatioBasedSampler } = require('@opentelemetry/sdk-trace-base');

const provider = new NodeTracerProvider({
  sampler: new TraceIdRatioBasedSampler(0.1), // 10% of traces
});
```

**Example (tail-based):**
```yaml
# OpenTelemetry Collector config
processors:
  tail_sampling:
    policies:
      - name: errors-policy
        type: status_code
        status_code: {status_codes: [ERROR]}
      - name: rate-policy
        type: rate_limiting
        rate_limiting: {spans_per_second: 100}
```

### Trace Visualization

View traces in UI.

**Tools:**
- Jaeger UI (open source)
- Zipkin UI (open source)
- Datadog APM (commercial)

**Features:**
- Trace timeline (spans over time)
- Span details (attributes, events, logs)
- Service dependencies (service map)
- Critical path analysis (bottlenecks)

## Service Level Objectives (SLOs)

### Define SLOs

Set objectives for service reliability.

**Example SLOs:**
- **Availability:** 99.9% (43 minutes downtime/month)
- **Latency:** p95 < 200ms
- **Error rate:** < 0.1%

**Calculate SLOs:**
```
Availability = (successful requests / total requests) * 100
Latency p95 = 95th percentile of request latency
Error rate = (error responses / total responses) * 100
```

### Monitor SLOs

Track SLO compliance.

**Tools:**
- Prometheus + Grafana (open source)
- Datadog (commercial)
- Sloth (open source, SLO management)

**Dashboard:**
- Current SLO compliance (e.g., 99.95% availability)
- Error budget remaining (e.g., 20 minutes left this month)
- SLO trend (improving/degrading)

### Alert on SLO Burn

Alert when SLO is at risk.

**Error budget:**
```
SLO: 99.9% availability
Error budget: 0.1% = 43 minutes/month

If we've used 30 minutes in first week:
  Burn rate: 30 / 7 * 30 = 128 minutes/month
  Projected: 128 / 43 = 2.98x too fast
  Alert: SLO burn rate too high
```

**Alert thresholds:**
- **Page:** burn rate > 14.4x (will exhaust budget in 1 day)
- **Ticket:** burn rate > 6x (will exhaust budget in 3 days)
- **Warning:** burn rate > 2x (will exhaust budget in 2 weeks)

## Observability-Driven Development

### Instrument First

Before writing business logic, instrument the code.

**Process:**
1. Define SLOs for service
2. Instrument metrics (request rate, error rate, latency)
3. Instrument traces (spans for key operations)
4. Instrument logs (structured logs with trace context)
5. Write business logic
6. Verify observability (can you see metrics, traces, logs?)

### Observability as Code

Define observability in code (not manual configuration).

**Example (Terraform):**
```hcl
resource "grafana_dashboard" "service" {
  config_json = file("dashboards/order-service.json")
}

resource "prometheus_rule_group" "service" {
  name      = "order-service"
  interval  = "1m"
  
  rule {
    alert = "HighErrorRate"
    expr  = "rate(order_service_errors_total[5m]) > 0.01"
    for   = "5m"
    labels = {
      severity = "critical"
    }
  }
}
```

## Integration with Platform Builder

### Phase 4 (Productionization)

- Instrument all services with OpenTelemetry
- Set up metrics collection (Prometheus)
- Set up log aggregation (Loki, ELK)
- Set up distributed tracing (Jaeger, Zipkin)
- Define SLOs per service

### Phase 6 (Operations)

- Create dashboards per service
- Set up SLO monitoring
- Set up alerts on SLO burn
- Review observability (can you debug issues?)
- Run chaos experiments (see `chaos-engineering.md`)

## Anti-Patterns

- **No Distributed Tracing:** can't debug cross-service issues
- **Unstructured Logs:** can't search or correlate logs
- **No SLOs:** no clear reliability targets
- **Alert Fatigue:** too many alerts, ignore important ones
- **No Error Budgets:** no tolerance for failures
- **Observability as Afterthought:** bolted on later (should be first)
- **Vendor Lock-In:** hard to switch observability backends (use OpenTelemetry)
