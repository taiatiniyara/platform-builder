# Incident Management Standards

## Applies when

Setting up monitoring, alerting, on-call processes, or incident response workflows.

## Rules

### Detection

- Comprehensive monitoring (infrastructure, application, business)
- Alerting on anomalies, threshold breaches, errors (PagerDuty, Opsgenie, Slack)
- Automated health checks (all services, dependencies)
- Synthetic monitoring (simulate user actions)
- Log analysis (error patterns, anomalies)
- User reports channel (support tickets, status page)

### Response

- Incident commander (designated leader)
- On-call rotation (documented schedule, escalation paths)
- Severity classification (P1 critical, P2 high, P3 medium, P4 low)
- Communication (status page, Slack, email)
- War room (dedicated channel/room)
- Timeline documentation (detection, investigation, resolution)

### Resolution

- Runbooks (step-by-step procedures)
- Troubleshooting guides (diagnose issues)
- Rollback procedures (documented, tested)
- Mitigation strategies (reduce impact while fixing root cause)
- Root cause fix (not just symptoms)
- Verification (fix resolves issue)

### Post-Mortem

- Blameless (focus on systems, not people)
- Root cause analysis (5 whys)
- Action items (prevent recurrence)
- Document (details, timeline, root cause, actions)
- Review (with team, share learnings)
- Track action items to completion

### Metrics

- MTTD (Mean Time to Detect)
- MTTR (Mean Time to Resolve)
- MTBF (Mean Time Between Failures)
- Incident frequency (per time period)
- Severity distribution
- Cost (downtime, engineering time)

### Prevention

- Chaos engineering (test resilience: Chaos Monkey, Gremlin)
- Game days (simulated scenarios)
- Capacity planning (prevent capacity issues)
- Dependency management (prevent outages)
- Security patches (prevent security incidents)
- Technical debt (address to prevent incidents)

### Status Page

- Public status page (Statuspage, Instatus, custom)
- Regular updates during incident (every 15-30 minutes)
- Post-incident report (public)
- Subscriber notifications (status changes)
- Historical record (incidents, uptime)
- SLA tracking (uptime vs commitments)

## Checklist

- [ ] Comprehensive monitoring configured
- [ ] Alerting configured
- [ ] Health checks implemented
- [ ] On-call rotation documented
- [ ] Severity levels defined
- [ ] Incident communication plan exists
- [ ] Runbooks exist for common incidents
- [ ] Rollback procedures documented
- [ ] Post-mortem process defined
- [ ] Incident metrics tracked
- [ ] Status page exists
- [ ] SLA tracking configured

## Anti-patterns

- No monitoring → add monitoring
- No alerting → add alerting
- No on-call → document on-call rotation
- No runbooks → write runbooks
- No post-mortems → conduct post-mortems
- Blame culture → focus on systems
- No status page → create status page
- No metrics → track metrics
- No prevention → implement prevention
- No communication → communicate incidents
