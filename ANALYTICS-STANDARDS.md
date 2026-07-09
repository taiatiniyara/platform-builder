# Analytics Standards

## Applies when

Tracking user behavior, defining KPIs, building dashboards, or implementing event tracking.

## Rules

### Business Metrics

- Define KPIs early (DAU, MAU, retention, conversion, revenue)
- Track user actions (signups, purchases, feature usage)
- Funnel analysis (track flows, identify drop-off)
- Cohort analysis (group by signup date, behavior, demographics)
- A/B testing infrastructure (feature flags, variant tracking)
- Attribution (track sources: marketing channels, referrers)

### Infrastructure

- Analytics platform (Mixpanel, Amplitude, Google Analytics, Segment)
- Reliable data pipeline (no data loss)
- Consistent event schema (name, properties, timestamp, user ID)
- Data warehouse (BigQuery, Snowflake, Redshift)
- ETL/ELT processes
- Data quality (validate integrity, handle missing data, deduplicate)

### Dashboards

- Executive dashboards (revenue, growth, retention)
- Product dashboards (feature usage, engagement)
- Marketing dashboards (acquisition, conversion, campaigns)
- Real-time dashboards (live metrics, status)
- Automated reports (daily, weekly, monthly)
- Self-service analytics (non-technical users explore data)

### User Behavior

- User segmentation (behavior, demographics, tier)
- Behavioral analytics (journeys, session flows, feature adoption)
- Retention analysis (measure and improve over time)
- Churn analysis (identify why users leave, early warnings)
- Lifetime value (LTV) calculation
- Customer acquisition cost (CAC) tracking

### Product Analytics

- Feature usage (used vs ignored)
- Engagement metrics (session length, frequency, depth)
- Conversion tracking (free to paid, trial to subscription)
- Error tracking (user-facing errors, impact on behavior)
- Performance metrics (page load, API response, effect on usage)
- Feedback collection (NPS, user feedback, support tickets)

### Privacy

- Consent management (track consent for tracking)
- PII protection (no PII in analytics, or encrypted)
- GDPR compliance (right to deletion, data portability)
- Cookie consent (proper banner for tracking cookies)
- Data retention (define how long to keep analytics data)
- Opt-out mechanism (allow users to opt out)

## Checklist

- [ ] KPIs defined
- [ ] Event tracking implemented
- [ ] Analytics platform configured
- [ ] Data pipeline reliable
- [ ] Event schema consistent
- [ ] Dashboards created
- [ ] Automated reports configured
- [ ] User segmentation implemented
- [ ] Retention analysis configured
- [ ] Feature usage tracked
- [ ] Conversion tracking implemented
- [ ] Consent management configured
- [ ] No PII in analytics
- [ ] Opt-out mechanism exists

## Anti-patterns

- No analytics → implement tracking
- Tracking everything → focus on KPIs
- No KPI definition → define success metrics
- Inconsistent event naming → standardize naming
- PII in analytics → remove or encrypt PII
- No consent management → add consent tracking
- No dashboards → create dashboards
- No A/B testing → add experimentation infrastructure
- Ignoring analytics → use data for decisions
- No data quality checks → validate data
