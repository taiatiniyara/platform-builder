# Observability & Incident Management Standards

## Applies when

Writing production code, configuring monitoring/alerting, or setting up incident response.

## Checklist

### Logging
- [ ] Structured logging (JSON); correlation IDs (X-Request-ID) across services
- [ ] Appropriate log levels (DEBUG/INFO/WARN/ERROR/FATAL); context enrichment
- [ ] No sensitive data in logs (passwords, tokens, PII); centralized log aggregation

### Metrics
- [ ] Request metrics: rate, error rate, latency p50/p95/p99
- [ ] Business metrics: signups, conversions, active users, revenue
- [ ] Infrastructure metrics: CPU, memory, disk, network; custom metrics (queue depth, cache hit rate)

### Tracing
- [ ] Distributed tracing (W3C Trace Context); spans for each operation
- [ ] Visualization (Jaeger, Zipkin, Datadog APM, X-Ray); sampling in production

### Alerting
- [ ] Rules on metrics/logs/traces; routed to right team (PagerDuty, Slack)
- [ ] Severity: P1 critical, P2 high, P3 medium, P4 low; on-call rotation + escalation
- [ ] Actionable alerts only (tune thresholds, prevent fatigue)

### Debugging
- [ ] Feature flags (toggle without deploy); admin endpoints (user lookup, data inspection)
- [ ] Request replay in staging; searchable logs with filters; profile in production with caution

### Incident Response
- [ ] Incident commander + on-call rotation; severity classification
- [ ] War room + status page communication; timeline documentation
- [ ] Runbooks for common incidents; rollback procedures documented and tested
- [ ] Mitigation before root cause fix; verified resolution

### Post-Mortem
- [ ] Blameless (focus on systems); root cause analysis (5 whys)
- [ ] Action items tracked to completion; documented and shared with team

### Prevention & Metrics
- [ ] Chaos engineering (Chaos Monkey, Gremlin); game days (simulated scenarios)
- [ ] Track: MTTD, MTTR, MTBF, incident frequency, severity distribution
- [ ] Public status page with updates every 15-30min during incident; SLA tracking
