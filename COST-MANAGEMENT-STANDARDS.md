# Cost Management Standards

## Applies when

Provisioning cloud resources, designing architecture, or optimizing infrastructure costs.

## Rules

### Cloud Optimization

- Right-size instances (based on actual usage)
- Reserved instances for predictable workloads (30-60% savings)
- Spot instances for fault-tolerant workloads (70-90% savings)
- Auto-scaling (scale down during low-traffic)
- Resource cleanup (delete unused: orphaned disks, snapshots, IPs)
- Multi-cloud strategy (avoid vendor lock-in, compare pricing)

### Monitoring

- Budget alerts at 50%, 75%, 90% of threshold
- Cost dashboards (real-time spending by service, team, project)
- Cost allocation (tag resources by team, project, environment)
- Anomaly detection (alert on unexpected spikes)
- Daily/weekly automated cost reports
- Forecasting (project future costs based on trends)

### Architecture

- Serverless first (Lambda, Cloud Functions for sporadic workloads)
- Caching (reduce database/API calls)
- Compression (reduce bandwidth costs)
- Batch processing (reduce API calls and compute time)
- CDN usage (offload static content, cheaper than origin)
- Storage tiers (hot, warm, cold, archive)

### Database

- Connection pooling (major cost driver)
- Read replicas (offload read traffic)
- Query optimization (reduce compute time)
- Data archiving (move old data to cheap storage)
- Partitioning (faster queries, easier maintenance)
- Right-size instances (based on actual usage)

### Operational

- Dev environments (shut down outside business hours)
- Ephemeral environments (auto-delete after use)
- Log management (control retention, logs expensive at scale)
- API rate limiting (prevent abuse that drives costs)
- Dependency management (minimize usage-based pricing)
- Monthly cost reviews (identify optimization opportunities)

## Checklist

- [ ] Instances right-sized
- [ ] Reserved instances for predictable workloads
- [ ] Auto-scaling configured
- [ ] Resource cleanup automated
- [ ] Budget alerts configured
- [ ] Cost dashboards available
- [ ] Resources tagged for allocation
- [ ] Serverless used where appropriate
- [ ] Caching implemented
- [ ] CDN used for static content
- [ ] Storage tiers used appropriately
- [ ] Connection pooling configured
- [ ] Dev environments shut down when not in use
- [ ] Monthly cost reviews scheduled

## Anti-patterns

- Over-provisioning → right-size based on actual usage
- No auto-scaling → configure auto-scaling
- No cost monitoring → add budget alerts and dashboards
- Dev environments running 24/7 → shut down outside business hours
- No resource cleanup → automate cleanup
- Expensive storage for cold data → use storage tiers
- No connection pooling → configure pooling
- Ignoring data transfer costs → optimize cross-region traffic
- No budget alerts → add alerts at 50%, 75%, 90%
- Vendor lock-in → evaluate multi-cloud
