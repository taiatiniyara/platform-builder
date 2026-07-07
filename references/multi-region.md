# Multi-Region Deployment

Patterns for deploying platforms across multiple geographic regions.
Apply when you need low latency globally, disaster recovery, or data residency.

## Tool Selection

This file describes **patterns**, not specific tools. Tools mentioned are
**examples** to illustrate the pattern — not recommendations. When selecting
tools for this project, the agent MUST:
1. Check `docs/ARCHITECTURE.md` for the declared stack
2. Research current options (never suggest from memory)
3. Present 2-3 options with trade-offs
4. Let the user decide

## When to Apply

- Users are distributed globally (>100ms latency from single region)
- Disaster recovery requires geographic redundancy
- Data residency requirements (GDPR, etc.)
- Regulatory requirements (data must stay in country)

**Don't apply when:**
- Users are in one geographic area
- No latency requirements
- No compliance requirements
- Budget is limited (multi-region is expensive)

## Deployment Topologies

### Active-Passive

One region serves traffic; other regions are standby.

**Setup:**
```
Region A (Active) → serves all traffic
Region B (Passive) → standby, replicated data
Region C (Passive) → standby, replicated data
```

**Failover:**
- Detect failure in active region
- Promote passive region to active
- Update DNS to point to new active region
- RTO: 5-30 minutes
- RPO: 0-5 minutes (depends on replication lag)

**Benefits:**
- Simple to implement
- Lower cost (only one region serves traffic)
- Easy to reason about

**Challenges:**
- Failover is manual or semi-automated
- Passive regions are underutilized
- Data replication lag during failover

**When to use:**
- Disaster recovery is primary concern
- Budget is limited
- Team lacks multi-region experience

### Active-Active

Multiple regions serve traffic simultaneously.

**Setup:**
```
Region A (Active) → serves traffic for users in region A
Region B (Active) → serves traffic for users in region B
Region C (Active) → serves traffic for users in region C
```

**Traffic routing:**
- DNS-based routing (GeoDNS)
- Load balancer routing (based on user location)
- Anycast routing (network-level)

**Benefits:**
- Low latency for all users
- Automatic failover (if one region fails, traffic routes to others)
- Better resource utilization

**Challenges:**
- Data consistency across regions (eventual consistency)
- Conflict resolution (same data modified in multiple regions)
- Complex to implement
- Higher cost (all regions serve traffic)

**When to use:**
- Low latency is critical
- High availability is critical
- Team has distributed systems experience

### Active-Active with Regional Isolation

Each region serves its own users; no cross-region traffic.

**Setup:**
```
Region A → serves users in North America
Region B → serves users in Europe
Region C → serves users in Asia
```

**Data:**
- Each region has its own database
- No data replication between regions
- Users in region A can only access data in region A

**Benefits:**
- Simple data model (no cross-region consistency)
- Data residency compliance (data stays in region)
- Low latency for regional users

**Challenges:**
- Users can't access data from other regions
- Global queries require aggregation across regions
- Regional failures affect regional users

**When to use:**
- Data residency requirements
- Users are region-specific
- No need for global data access

## Data Replication

### Synchronous Replication

Writes are committed in all regions before returning success.

**Benefits:**
- Strong consistency
- No data loss

**Challenges:**
- High latency (wait for all regions)
- Single region failure blocks writes
- Not suitable for active-active

**When to use:**
- Active-passive with zero data loss requirement

### Asynchronous Replication

Writes are committed in primary region; replicated to other regions later.

**Benefits:**
- Low latency (don't wait for other regions)
- Region failures don't block writes
- Suitable for active-active

**Challenges:**
- Eventual consistency (replication lag)
- Potential data loss (if primary fails before replication)
- Conflict resolution needed

**When to use:**
- Active-active with eventual consistency
- Low latency is critical

### Conflict Resolution

When same data is modified in multiple regions, conflicts occur.

**Strategies:**
- **Last-write-wins:** most recent write wins (simple, but data loss)
- **CRDTs (Conflict-free Replicated Data Types):** automatic merge (complex, but no conflicts)
- **Manual resolution:** flag conflict for human resolution (safe, but slow)
- **Vector clocks:** track causality (complex, but accurate)

**Recommendation:** use CRDTs for simple data types (counters, sets), last-write-wins for most cases, manual resolution for critical data.

## Traffic Routing

### DNS-Based Routing

Use DNS to route users to nearest region.

**Tools:**
- AWS Route 53 (Geo DNS)
- Cloudflare DNS
- Google Cloud DNS

**Setup:**
```
api.example.com → resolves to:
  - Region A IP for users in North America
  - Region B IP for users in Europe
  - Region C IP for users in Asia
```

**Benefits:**
- Simple to implement
- Works with any load balancer

**Challenges:**
- DNS caching (slow failover)
- Limited granularity (country-level, not city-level)

### Load Balancer Routing

Use load balancer to route based on user location.

**Tools:**
- AWS Global Accelerator
- Cloudflare Load Balancing
- Google Cloud Load Balancing

**Benefits:**
- Fast failover (no DNS caching)
- Granular routing (city-level)
- Health checks (automatic failover)

**Challenges:**
- More expensive than DNS
- Vendor lock-in

### Anycast Routing

Network-level routing to nearest region.

**Tools:**
- Cloudflare (built-in)
- AWS Global Accelerator (partial)

**Benefits:**
- Fastest routing (network-level)
- Automatic failover

**Challenges:**
- Requires BGP (complex)
- Limited control over routing

## Content Delivery

### CDN Strategy

Use CDN for static assets and cached content.

**Setup:**
- Static assets (JS, CSS, images) → CDN (global edge)
- API responses → origin server (regional)
- Dynamic content → origin server (regional)

**Cache strategy:**
- Immutable assets (with content hash) → cache forever
- API responses → cache with short TTL (5-60 seconds)
- Dynamic content → no cache

### Edge Computing

Run compute at edge (close to users).

**Tools:**
- Cloudflare Workers
- AWS Lambda@Edge
- Fastly Compute@Edge

**Use cases:**
- A/B testing at edge
- Authentication at edge
- Image optimization at edge
- API response transformation at edge

## Database Strategies

### Regional Databases

Each region has its own database.

**Benefits:**
- Low latency (database is close to application)
- Data residency (data stays in region)
- Independent scaling

**Challenges:**
- Cross-region queries are complex
- No global transactions
- Data replication needed for global reads

**When to use:**
- Active-active with regional isolation
- Data residency requirements

### Global Database

Single database replicated across regions.

**Tools:**
- CockroachDB (distributed SQL)
- YugabyteDB (distributed SQL)
- Amazon Aurora Global Database
- Google Cloud Spanner

**Benefits:**
- Global reads with low latency
- Automatic replication
- Strong consistency (within region)

**Challenges:**
- Expensive
- Complex to operate
- Write latency (cross-region writes)

**When to use:**
- Active-active with global data access
- Strong consistency needed

## Monitoring

### Regional Monitoring

Monitor each region independently.

**Metrics:**
- Latency per region
- Error rate per region
- Traffic per region
- Database replication lag

**Alerts:**
- Region-specific alerts (high latency in region A)
- Cross-region alerts (replication lag > threshold)

### Global Monitoring

Aggregate metrics across regions.

**Metrics:**
- Global latency (p50, p95, p99)
- Global error rate
- Global traffic
- Failover status

**Dashboard:**
- Map view (show latency per region)
- Time series (show metrics over time)
- Region comparison (compare regions side-by-side)

## Integration with Platform Builder

### Phase 1 (Blueprint)

- Decide if multi-region is needed (see "When to Apply")
- Choose topology (active-passive, active-active, regional isolation)
- Choose data replication strategy (sync, async)
- Choose traffic routing strategy (DNS, load balancer, anycast)
- Document in `docs/ARCHITECTURE.md` with diagram

### Phase 4 (Productionization)

- Set up infrastructure in each region
- Configure data replication
- Configure traffic routing
- Set up CDN and edge computing

### Phase 6 (Operations)

- Monitor regional metrics
- Test failover procedures
- Review RTO/RPO targets
- Optimize costs

## Anti-Patterns

- **Split-Brain:** two regions think they're active (use consensus)
- **No Failover Testing:** failover doesn't work when needed (test regularly)
- **Ignoring Replication Lag:** assume instant replication (measure and plan for lag)
- **No Conflict Resolution:** conflicts cause data corruption (choose strategy)
- **Over-Engineering:** active-active when active-passive is sufficient (start simple)
- **Ignoring Costs:** multi-region is expensive (monitor and optimize)
