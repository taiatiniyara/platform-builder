# Reliability Standards

## Applies when

Making external calls, handling errors, implementing retries, or building fault-tolerant systems.

## Rules

### Error Handling

- Graceful degradation (system works when components fail)
- Circuit breakers (fail fast after threshold)
- Retry with exponential backoff + jitter
- Fallback mechanisms (default responses when unavailable)
- Error boundaries (isolate failures to components)
- User-friendly errors (clear messages, actionable steps)

### Timeouts

- All external calls have timeouts (HTTP, database, queues)
- Configurable per environment
- Propagate timeout context through call chains
- Handle partial success (return what succeeded, report failures)
- Monitor timeout rates, alert on spikes

### Idempotency

- Safe retries (mutations without side effects)
- Idempotency keys (client-generated for deduplication)
- Database constraints (unique constraints prevent duplicates)
- Optimistic locking (version fields prevent conflicts)
- Event deduplication (message queues deduplicate by event ID)

### Disaster Recovery

- Automated backups (daily full, hourly incremental)
- Tested restore procedures
- RTO/RPO defined and documented
- Multi-region deployment for critical systems
- Documented and tested failover procedures
- Data replication (synchronous for critical, async for non-critical)

### Health Checks

- `/health` endpoint (liveness)
- `/ready` endpoint (readiness)
- Check dependencies (database, cache, external services)
- Graceful shutdown (drain connections, finish in-flight requests)
- Startup checks (verify config, dependencies before traffic)
- Self-healing (auto-restart on failure, auto-scale on load)

## Checklist

- [ ] All external calls have timeouts
- [ ] Circuit breakers implemented
- [ ] Retry with exponential backoff
- [ ] Fallback mechanisms in place
- [ ] Error boundaries isolate failures
- [ ] Idempotency keys for mutations
- [ ] Database constraints prevent duplicates
- [ ] Backups automated and tested
- [ ] Health endpoints implemented
- [ ] Graceful shutdown implemented
- [ ] No swallowed exceptions

## Anti-patterns

- No timeout on external calls → add timeouts
- Swallowing exceptions → log and handle
- Retry without backoff → add exponential backoff + jitter
- No circuit breaker → add circuit breaker
- Blocking on external calls → use async with timeout
- No error handling → add error handling for edge cases
- Assuming external services always available → add fallbacks
- No graceful degradation → implement partial failure handling
- Manual failover → automate failover
- No health checks → add health endpoints
