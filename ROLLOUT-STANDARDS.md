# Rollout Standards

## Applies when

Releasing new features, running experiments, or managing feature flags.

## Rules

### Feature Flags

- Centralized management (LaunchDarkly, Unleash, Flagsmith, custom)
- Flag types: boolean, percentage, user segment, multivariate
- Management UI (create, edit, toggle without deployment)
- Hierarchy (organization > team > user)
- Versioning (track changes, rollback)
- Cleanup (remove after full rollout, prevent flag debt)

### Gradual Rollout

- Percentage rollout (1% → 10% → 50% → 100%)
- User segment targeting (beta, premium, geography)
- Monitoring at each stage
- Automatic rollback if metrics degrade
- Scheduling (business hours, low-traffic)
- Communication (notify team/users)

### Beta Testing

- Beta program (invite users)
- Feedback collection (surveys, forms)
- Metrics (behavior, engagement, errors)
- Communication (what's new, known issues)
- Graduation criteria (beta to general availability)
- Isolation (beta doesn't affect non-beta users)

### A/B Testing

- Experimentation platform (Optimizely, VWO, GrowthBook, custom)
- Experiment design (hypothesis, variants, metrics, sample size)
- Random assignment (consistent)
- Statistical significance (before declaring winner)
- Duration (long enough for sufficient data)
- Analysis (results, learnings, sharing)

### Canary Deployments

- Deploy to small subset first
- Monitor for errors, performance issues
- Compare to baseline
- Automatic promotion if metrics good
- Automatic rollback if metrics degrade
- Defined duration

### Dark Launches

- Deploy to production but hidden
- Load testing (under production load)
- Integration testing (with other systems)
- Gradual exposure (internal → beta → all)
- Kill switch (disable instantly)
- Monitoring (even when hidden)

### Communication

- Changelog (public, new features)
- Release notes (detailed, major releases)
- In-app notifications (tooltips, modals, banners)
- Email notifications (major releases)
- Documentation updates
- Training materials (videos, guides)

## Checklist

- [ ] Feature flag system configured
- [ ] Gradual rollout implemented
- [ ] Rollout monitoring configured
- [ ] Automatic rollback configured
- [ ] Beta program exists
- [ ] A/B testing infrastructure exists
- [ ] Canary deployments configured
- [ ] Kill switch exists
- [ ] Changelog maintained
- [ ] Release notes written
- [ ] In-app notifications configured
- [ ] Documentation updated
- [ ] Feature flags cleaned up after rollout

## Anti-patterns

- No feature flags → add feature flag system
- No gradual rollout → implement gradual rollout
- No A/B testing → add experimentation
- No beta program → create beta program
- No rollback strategy → add rollback
- No flag cleanup → clean up flags
- No monitoring → add monitoring
- No communication → communicate changes
- No canary → add canary deployments
- No experimentation culture → build experimentation culture
