# Deployment Standards

## Applies when

Setting up CI/CD, infrastructure, release pipelines, feature flags, or rollout strategies.

## Checklist

### CI/CD
- [ ] Automated testing on every commit (unit, integration, E2E)
- [ ] Security scanning: secret scanning, dependency audit, SAST
- [ ] Versioned, immutable artifacts; no manual deployments
- [ ] Environment promotion (dev → staging → production with gates); fast pipelines (<10min)

### Infrastructure as Code
- [ ] Declarative (Terraform, Pulumi, CDK); version controlled in git
- [ ] Modular; remote state; drift detection; environment parity

### Environments
- [ ] Containerized (Docker); config via env vars; secrets injected at runtime
- [ ] Feature flags per environment; realistic test data

### Deployment Strategies
- [ ] Blue-green or canary: 1% → 10% → 50% → 100% with metric monitoring
- [ ] Immutable (replace, don't update); expand-contract for DB migrations
- [ ] One-click rollback; backward-compatible migrations; rollback tested

### Feature Flags & Rollout
- [ ] Centralized flag management (LaunchDarkly, Unleash); kill switch on every feature
- [ ] Gradual rollout by percentage/user segment; auto-rollback on metric degradation
- [ ] Beta program with feedback + metrics; A/B testing with statistical significance
- [ ] Dark launches: deploy hidden → internal → beta → full; load test under production
- [ ] Flag cleanup after full rollout (prevent flag debt)

### Monitoring
- [ ] Track deployment success/failure rate; auto-rollback if metrics degrade
- [ ] Post-deployment: response times, error rates; deploy notifications
- [ ] Track DORA metrics: deployment frequency, lead time from commit to prod
