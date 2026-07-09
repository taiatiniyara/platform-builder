# Observability Standards

## Applies when

Writing any code that runs in production, especially request handling, background jobs, or external integrations.

## Rules

### Logging

- JSON format (machine-readable, not plain text)
- Correlation IDs (X-Request-ID header, track across services)
- Appropriate log levels (DEBUG, INFO, WARN, ERROR, FATAL)
- Context enrichment (user ID, request ID, timestamp, service name)
- No sensitive data (passwords, tokens, PII, secrets)
- Centralized logging (ELK, Datadog, CloudWatch)

### Metrics

- Request metrics: rate, error rate, latency percentiles (p50, p95, p99)
- Business metrics: signups, conversions, active users, revenue
- Infrastructure metrics: CPU, memory, disk, network, connections
- Custom metrics: queue depth, cache hit rate
- Metric collection: Prometheus, StatsD, CloudWatch, Datadog
- Retention: short-term (high res) and long-term (aggregated)

### Tracing

- Trace propagation (W3C Trace Context, trace ID flows through services)
- Span collection (each operation is a span with start/end time)
- Visualization: Jaeger, Zipkin, Datadog APM, AWS X-Ray
- Critical path analysis (identify bottlenecks)
- Sampling in production (not all traces, reduce overhead)

### Alerting

- Rules based on metrics, logs, or traces (thresholds, anomalies)
- Routing to right team/channel (PagerDuty, Slack, email)
- Severity levels: P1 (critical), P2 (high), P3 (medium), P4 (low)
- On-call rotation with escalation policies
- Actionable alerts only (tune thresholds, prevent fatigue)

### Debugging

- Feature flags (toggle without deployment)
- Admin endpoints (user lookup, data inspection)
- Request replay (replay production requests in staging)
- Log search (searchable logs with filters)
- Profiling tools (CPU, memory, I/O in production with caution)

## Checklist

- [ ] Structured logging (JSON format)
- [ ] Correlation IDs present
- [ ] No sensitive data in logs
- [ ] Request metrics collected (rate, errors, latency)
- [ ] Business metrics collected
- [ ] Distributed tracing configured
- [ ] Alerts configured for critical metrics
- [ ] Feature flags implemented
- [ ] Admin endpoints available
- [ ] Log aggregation configured

## Anti-patterns

- console.log in production → use structured logging
- No correlation IDs → add X-Request-ID
- Logging sensitive data → sanitize logs
- No metrics → add metric collection
- Alerts without runbooks → create runbooks
- Too many alerts → tune thresholds
- No distributed tracing → add tracing
- No feature flags → add feature flag system
- Manual debugging → add admin endpoints
- Scattered logs → centralize logging
