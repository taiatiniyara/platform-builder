# Analytics Standards

## Applies when

Tracking user behavior, defining KPIs, building dashboards, or implementing event tracking.

## Checklist

### Business Metrics
- [ ] KPIs defined early (DAU, MAU, retention, conversion, revenue); event tracking live
- [ ] Funnel analysis (identify drop-off); cohort analysis; attribution (marketing channels, referrers)
- [ ] A/B testing infrastructure (feature flags, variant tracking)

### Infrastructure
- [ ] Analytics platform (Mixpanel, Amplitude, Segment, GA); reliable data pipeline (no data loss)
- [ ] Consistent event schema (name, properties, timestamp, user ID); data warehouse (BigQuery, Snowflake)
- [ ] ETL/ELT processes; data quality (validate integrity, deduplicate)

### Dashboards & Reports
- [ ] Executive, product, marketing, real-time dashboards; automated reports (daily/weekly/monthly)
- [ ] Self-service analytics for non-technical users

### User & Product Analysis
- [ ] User segmentation (behavior, demographics, tier); retention + churn analysis
- [ ] LTV calculation; CAC tracking; feature usage (used vs ignored)
- [ ] Engagement metrics (session length, frequency, depth); conversion tracking

### Privacy
- [ ] Consent management for tracking; no PII in analytics (or encrypted)
- [ ] GDPR compliance (deletion, portability); cookie consent; opt-out mechanism; data retention policy
