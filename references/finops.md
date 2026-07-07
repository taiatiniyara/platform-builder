# FinOps (Cloud Financial Operations)

Practices for managing and optimizing cloud costs. Apply when cloud spend
is significant or growing unexpectedly.

## Tool Selection

This file describes **patterns**, not specific tools. Tools mentioned are
**examples** to illustrate the pattern — not recommendations. When selecting
tools for this project, the agent MUST:
1. Check `docs/ARCHITECTURE.md` for the declared stack
2. Research current options (never suggest from memory)
3. Present 2-3 options with trade-offs
4. Let the user decide

## When to Apply

- Monthly cloud spend >$5,000
- Costs growing >20% month-over-month
- Multiple teams using cloud resources
- Need to allocate costs to teams/products
- Want to optimize cloud spend

## FinOps Framework

### Phases

1. **Inform:** visibility into costs (who spends what, where)
2. **Optimize:** reduce waste, right-size resources
3. **Operate:** continuous improvement, governance

### Principles

1. **Teams need to collaborate:** engineering, finance, business work together
2. **Everyone takes ownership:** engineers are responsible for cloud costs
3. **Central team provides governance:** platform team sets policies, tools
4. **Reports should be timely and accessible:** real-time cost visibility
5. **Decisions driven by business value:** cost vs. performance trade-offs

## Cost Visibility

### Cost Allocation

Tag all resources for cost allocation.

**Tags:**
- `team`: team that owns the resource
- `service`: service that uses the resource
- `environment`: dev, staging, production
- `project`: project or product

**Example:**
```
EC2 instance:
  team: payments
  service: payment-processor
  environment: production
  project: checkout
```

**Tools:**
- AWS Cost Explorer (built-in)
- GCP Billing Reports (built-in)
- CloudHealth (commercial)
- Cloudability (commercial)

### Showback vs Chargeback

**Showback:** show teams their costs (informational)
- Teams see their cloud spend
- No actual money transfer
- Encourages awareness

**Chargeback:** charge teams for their costs (financial)
- Teams pay for their cloud spend
- Actual money transfer (internal accounting)
- Strong incentive to optimize

**Recommendation:** start with showback, move to chargeback when mature.

### Cost Dashboards

Real-time cost visibility.

**Dashboards:**
- Overall cloud spend (total, trend)
- Spend by team (breakdown)
- Spend by service (breakdown)
- Spend by environment (dev, staging, production)
- Top 10 most expensive resources

**Tools:**
- AWS Cost Explorer (built-in)
- GCP Billing Reports (built-in)
- Grafana (custom dashboards)
- CloudHealth (commercial)

## Cost Optimization

### Right-Sizing

Match resource size to actual usage.

**Process:**
1. Monitor resource utilization (CPU, memory, disk)
2. Identify over-provisioned resources (low utilization)
3. Downsize resources (smaller instance types)
4. Monitor after change (ensure no performance impact)

**Tools:**
- AWS Compute Optimizer (built-in)
- GCP Recommender (built-in)
- CloudHealth (commercial)

**Example:**
```
Current: r5.2xlarge (8 vCPU, 64 GB RAM)
Utilization: 10% CPU, 20% memory
Recommendation: t3.medium (2 vCPU, 4 GB RAM)
Savings: $300/month
```

### Reserved Instances / Savings Plans

Commit to usage for discounts.

**Reserved Instances (RIs):**
- Commit to specific instance type for 1 or 3 years
- Discount: 30-60%
- Less flexible (locked to instance type)

**Savings Plans:**
- Commit to spend amount for 1 or 3 years
- Discount: 30-60%
- More flexible (applies to any instance type)

**When to use:**
- Stable, predictable workloads
- Long-term commitment (1+ years)
- Want to reduce costs significantly

**Tools:**
- AWS Cost Explorer (RI recommendations)
- GCP Committed Use Discounts (built-in)

### Spot Instances

Use spare capacity for discounts.

**Discount:** 60-90% off on-demand price

**Use cases:**
- Batch processing (can tolerate interruptions)
- CI/CD pipelines (temporary workers)
- Data processing (can restart if interrupted)

**Challenges:**
- Instances can be terminated (2-minute warning)
- Not suitable for stateful workloads
- Need fault-tolerant architecture

**Tools:**
- AWS Spot Instances (built-in)
- GCP Preemptible VMs (built-in)
- Spot.io (commercial, auto-optimization)

### Auto-Scaling

Scale resources based on demand.

**Strategies:**
- **Horizontal scaling:** add/remove instances
- **Vertical scaling:** increase/decrease instance size
- **Scheduled scaling:** scale based on time (e.g., business hours)
- **Dynamic scaling:** scale based on metrics (CPU, request rate)

**Tools:**
- AWS Auto Scaling (built-in)
- GCP Autoscaler (built-in)
- Kubernetes HPA (horizontal pod autoscaler)

**Example:**
```
Scale up: CPU > 70% for 5 minutes
Scale down: CPU < 30% for 10 minutes
Min instances: 2
Max instances: 10
```

### Storage Optimization

Optimize storage costs.

**Strategies:**
- **Lifecycle policies:** move data to cheaper storage tiers
- **Compression:** compress data before storage
- **Deduplication:** remove duplicate data
- **Delete unused data:** remove old backups, logs

**Storage tiers (AWS S3 example):**
- S3 Standard: frequent access ($0.023/GB)
- S3 Intelligent-Tiering: automatic tiering ($0.023/GB)
- S3 Glacier: archival ($0.004/GB)
- S3 Glacier Deep Archive: long-term archival ($0.00099/GB)

**Example savings:**
```
1 TB data, accessed once per month
S3 Standard: $23/month
S3 Glacier: $4/month
Savings: $19/month (83%)
```

### Network Optimization

Reduce data transfer costs.

**Strategies:**
- **CDN:** cache content at edge (reduce origin transfers)
- **Compression:** compress data in transit
- **Regional routing:** keep traffic within region
- **VPC endpoints:** avoid internet routing for AWS services

**Costs:**
- Data transfer out of cloud: $0.09/GB (AWS)
- Data transfer between regions: $0.02/GB (AWS)
- Data transfer within region: free (AWS)

## Budget Management

### Budget Alerts

Alert when spend exceeds thresholds.

**Alerts:**
- 50% of budget (warning)
- 80% of budget (critical)
- 100% of budget (exceeded)
- Forecasted to exceed budget

**Tools:**
- AWS Budgets (built-in)
- GCP Budget Alerts (built-in)
- CloudHealth (commercial)

### Budget Allocation

Allocate budget to teams.

**Process:**
1. Set overall cloud budget (e.g., $50,000/month)
2. Allocate to teams based on headcount, projects
3. Teams manage within their budget
4. Platform team monitors overall spend

**Example:**
```
Total budget: $50,000/month
Payments team: $15,000/month
Checkout team: $10,000/month
Platform team: $20,000/month
Reserve: $5,000/month
```

## Cost Governance

### Policies

Set policies for cloud usage.

**Examples:**
- All resources must be tagged (team, service, environment)
- Production resources must use reserved instances
- Dev/staging resources must be shut down on weekends
- No resources larger than r5.4xlarge without approval

**Enforcement:**
- AWS Service Control Policies (SCPs)
- GCP Organization Policies
- Terraform policies (Sentinel, Open Policy Agent)

### Approval Workflows

Require approval for expensive resources.

**Process:**
1. Engineer requests resource (e.g., large EC2 instance)
2. System checks cost (e.g., >$100/month)
3. If expensive, requires manager approval
4. Manager approves or denies
5. Resource provisioned if approved

**Tools:**
- AWS Service Catalog (pre-approved resources)
- CloudHealth (approval workflows)
- Custom approval system

## Waste Detection

### Unused Resources

Detect and remove unused resources.

**Examples:**
- Unattached EBS volumes (AWS)
- Unassociated Elastic IPs (AWS)
- Idle load balancers (AWS)
- Unused snapshots (AWS)

**Tools:**
- AWS Trusted Advisor (built-in)
- GCP Recommender (built-in)
- CloudHealth (commercial)

**Example savings:**
```
10 unattached EBS volumes, 100 GB each
Cost: $10/volume/month = $100/month
Action: delete volumes
Savings: $100/month
```

### Zombie Resources

Detect resources with no traffic.

**Examples:**
- EC2 instances with <1% CPU for 7 days
- Load balancers with 0 requests for 7 days
- Databases with 0 connections for 7 days

**Process:**
1. Identify zombie resources (low utilization)
2. Notify owner (team)
3. Owner confirms if needed
4. If not needed, terminate resource

## Integration with Platform Builder

### Phase 1 (Blueprint)

- Estimate cloud costs (see `operations.md`)
- Define cost allocation strategy (tags)
- Set budget alerts
- Document cost optimization strategy in `docs/ARCHITECTURE.md`

### Phase 4 (Productionization)

- Set up cost allocation tags
- Set up budget alerts
- Set up cost dashboards
- Implement auto-scaling

### Phase 6 (Operations)

- Monitor costs (weekly review)
- Right-size resources (monthly review)
- Purchase reserved instances (quarterly review)
- Detect and remove waste (continuous)
- Review budget vs actual (monthly)

## Anti-Patterns

- **No Cost Visibility:** surprise bills at end of month
- **No Tagging:** can't allocate costs to teams
- **Over-Provisioning:** resources sized for peak, not average
- **Ignoring Waste:** unused resources running 24/7
- **No Budget Alerts:** spend exceeds budget without warning
- **No Optimization:** never review or right-size resources
- **Manual Cost Management:** spreadsheets instead of tools
