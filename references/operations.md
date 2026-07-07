# Operations

Covers monitoring, alerting, disaster recovery, performance engineering,
environment strategy, and cost management. Applied during Phase 4
(Productionization) and Phase 6 (Observability & Operations).

## Tool Selection

This file describes **patterns**, not specific tools. Tools mentioned are
**examples** to illustrate the pattern — not recommendations. When selecting
tools for this project, the agent MUST:
1. Check `docs/ARCHITECTURE.md` for the declared stack
2. Research current options (never suggest from memory)
3. Present 2-3 options with trade-offs
4. Let the user decide

---

## Environment Strategy

### Environments

At minimum three environments, each declared in `docs/ARCHITECTURE.md`:

| Environment | Purpose | Config source | Access |
|-------------|---------|---------------|--------|
| `dev` | Developer machines, ephemeral preview branches | Local `.env` or equivalent, never checked in | Developer only |
| `staging` | Pre-production validation, matches prod topology | Environment-specific config, secrets from store | Team + CI |
| `production` | Live traffic | Secrets only through secret manager, never in config files | CI only for deploys |

### Preview Deployments

Every PR gets an ephemeral preview deployment (if the hosting target
supports it). The preview URL is posted as a PR comment. Preview
environments are destroyed when the branch is merged or closed.

### Config & Secrets

- All config values that differ between environments are stored in
  environment-specific files or a config service, never hardcoded.
- Secrets (keys, tokens, passwords, connection strings) are never in
  files — they are injected at deploy time from a secret manager.
- The `.gitignore` covers all `.env` files, service account keys, and
  local credential files before Phase 0 completes.

---

## Monitoring

### Metrics

Instrument every endpoint with the **RED** method:
- **Rate** — requests per second
- **Errors** — failed requests per second (4xx client errors optional, 5xx mandatory)
- **Duration** — p50, p95, p99 latency

Add application-level metrics:
- Queue depth (if using queues)
- Database connection pool utilization
- Cache hit rate (if caching)
- Auth success/failure rate
- Background job completion time and failure rate

### Dashboards

Create at minimum a **service overview** dashboard with:
- Request rate, error rate, p95 latency (all on one row)
- Saturation: CPU/memory/connection pool (second row)
- Business metrics: signups, transactions, active users (third row)

### SLOs & SLIs

Define at least one SLO per critical user journey:

| Journey | SLI | SLO |
|---------|-----|-----|
| Page load | p95 latency | < 2s |
| API availability | Success rate | 99.9% over 30 days |
| Core transaction | Error rate | < 0.1% over 30 days |

SLOs guide alerting: alert on the error budget burning rate, not on the raw
metric.

---

## Alerting

### Alert Rules

Every alert must:
- Fire on **symptoms**, not causes (e.g., "error rate > 1%" not "disk full")
- Link to a **runbook** (even if the runbook starts as one paragraph)
- Have a **defined owner** (team or person)

Minimum alert set:
1. Error rate exceeds SLO burn rate threshold
2. p99 latency exceeds 2x baseline for 5+ minutes
3. Health check fails for 2+ consecutive intervals
4. SSL certificate expiring within 14 days
5. Any secret or credential approaching expiry

### On-Call

Document an escalation path in `docs/DEPLOYMENT.md`:
1. Primary responder and contact method
2. Fallback if no response in 15 minutes
3. Steps to declare an incident

---

## Disaster Recovery

### Recovery Targets

State RTO and RPO in `docs/ARCHITECTURE.md`:

- **RTO** (Recovery Time Objective) — how long to restore service. Target: <1 hour.
- **RPO** (Recovery Point Objective) — how much data loss is acceptable. Target: <5 minutes.

### Backup Strategy

- Automated backups at the frequency dictated by RPO.
- Backup retention: 30 days minimum.
- Quarterly restore test: restore the latest backup to staging and verify
  the health check passes and core user journeys work.

### Multi-Region (if declared in architecture)

- Active-passive: one region serves traffic, standby region is warm.
- Failover procedure documented in `docs/DEPLOYMENT.md`.
- Failover tested during the quarterly restore drill.

---

## Performance Engineering

### Load Testing

Before launch (Phase 4 gate, reinforced in Phase 6):
- Load test at **2x expected peak traffic** for 10+ minutes.
- No 5xx errors. p95 latency within 2x baseline.
- Identify the bottleneck resource (CPU, memory, DB connections, I/O).

### Profiling

In Phase 6, before declaring the platform live:
- Profile the top 5 highest-traffic endpoints under load.
- Profile the top 3 slowest endpoints (by p99) under load.
- File findings that exceed 2x expected latency or show N+1 patterns.

### Caching Strategy

Document in `docs/ARCHITECTURE.md`:
- **What** gets cached (query results, rendered pages, API responses, assets)
- **Where** (CDN, application memory, dedicated cache store)
- **How long** (TTL per cache entry type)
- **Invalidation** (what events cause which cache entries to expire)

At minimum: CDN cache for static assets, with cache-busting via content hashes
in filenames.

### Idempotent Deployments

- Deployments are atomic: the new version is fully deployed before routing
  traffic to it.
- Database migrations run before the new code serves traffic.
- Rollback plan: if the new version fails health checks, automatically
  revert to the previous version and roll back the migration.

---

## Cost Management

### Before Launch (Phase 4)

- Estimate monthly cost at expected usage, 2x usage, and 10x usage.
- Document in `docs/ARCHITECTURE.md` under a `## Cost Model` section.
- Set budget alerts at 1.5x expected cost.

### Ongoing (Phase 6+)

- Review costs monthly against the estimate.
- Clean up unused resources (old preview environments, unattached volumes,
  stale DNS records, idle load balancers).
- Right-size instances based on actual utilization, not launch guesses.
