# Cost Management Standards

## Applies when

Provisioning cloud resources, designing architecture, or optimizing infrastructure costs.

## Checklist

### Cloud Optimization
- [ ] Right-size instances based on actual usage; reserved instances (30-60% savings); spot instances (70-90%)
- [ ] Auto-scaling (scale down during low-traffic); automated resource cleanup (orphaned disks, IPs)

### Monitoring
- [ ] Budget alerts at 50%, 75%, 90% of threshold; cost dashboards (real-time by service/team/project)
- [ ] Resource tagging for cost allocation; anomaly detection; daily/weekly automated reports; forecasting

### Architecture
- [ ] Serverless first for sporadic workloads; caching (reduce DB/API calls); compression (reduce bandwidth)
- [ ] Batch processing; CDN for static content; storage tiers (hot, warm, cold, archive)

### Database & Operations
- [ ] Connection pooling; read replicas; query optimization; data archiving; partitioning
- [ ] Dev environments: shut down outside business hours; ephemeral (auto-delete after use)
- [ ] Log management (control retention); API rate limiting (prevent abuse-driven costs)
- [ ] Monthly cost reviews; dependency management (minimize usage-based pricing)
