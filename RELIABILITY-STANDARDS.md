# Reliability Standards

## Applies when

Making external calls, handling errors, implementing retries, or building fault-tolerant systems.

## Checklist

### Error Handling
- [ ] Graceful degradation (works when components fail); error boundaries isolate failures
- [ ] Circuit breakers (fail fast after threshold); retry with exponential backoff + jitter
- [ ] Fallback mechanisms; user-friendly errors (clear messages, actionable); no swallowed exceptions

### Timeouts & Idempotency
- [ ] All external calls have timeouts (HTTP, DB, queues); configurable per environment
- [ ] Idempotency keys for mutations; database constraints prevent duplicates; optimistic locking

### Health & Recovery
- [ ] /health (liveness) + /ready (readiness); check dependencies (DB, cache, services)
- [ ] Graceful shutdown (drain connections, finish in-flight); startup checks before traffic
- [ ] Self-healing (auto-restart, auto-scale); automated failover

### Disaster Recovery
- [ ] Automated backups (daily full, hourly incremental); tested restore procedures
- [ ] RTO/RPO defined and documented; multi-region for critical; data replication
- [ ] Encrypted at rest; off-site storage; point-in-time recovery
