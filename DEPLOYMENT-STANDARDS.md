# Deployment Standards

## Applies when

Setting up CI/CD, infrastructure, deployment pipelines, or environment configuration.

## Rules

### CI/CD

- Automated testing on every commit (unit, integration, E2E)
- Security scanning (secret scanning, dependency audit, SAST)
- Versioned, immutable artifacts (Docker images, binaries)
- No manual deployments (everything through pipeline)
- Environment promotion (dev → staging → production with gates)
- Fast pipelines (<10 minutes, parallel jobs, caching)

### Infrastructure as Code

- Declarative (Terraform, Pulumi, CloudFormation, CDK)
- Version controlled (all infra in git)
- Modular (reusable modules: VPC, database, service)
- Remote state storage (S3, Terraform Cloud)
- Drift detection (detect manual changes)
- Environment parity (same code, different parameters)

### Environments

- Consistent (dev, staging, production as similar as possible)
- Containerized (Docker for consistent runtime)
- Config via environment variables (not hardcoded)
- Secrets injected at runtime (not in code/config)
- Feature flags per environment
- Realistic test data (anonymized production data)

### Rollback

- One-click rollback (instant revert to previous version)
- Backward-compatible migrations (rollback scripts tested)
- Feature flags (disable without rollback)
- Blue-green deployment (two environments, instant switch)
- Canary deployment (small percentage, gradually increase)
- Regular rollback testing

### Strategies

- Blue-green (two environments, instant switch, instant rollback)
- Canary (1% → 10% → 50% → 100%, monitor metrics)
- Rolling (update instances gradually, zero downtime)
- Immutable (replace instances, don't update in place)
- Expand-contract for database migrations
- Feature flags (decouple deployment from release)

### Monitoring

- Track deployment success/failure rate
- Track response times, error rates after deployment
- Automated rollback if metrics degrade
- Notify team on deployment (Slack, email)
- Track deployment frequency (DORA metric)
- Track lead time from commit to production (DORA metric)

## Checklist

- [ ] CI/CD pipeline automated
- [ ] Tests run on every commit
- [ ] Security scanning in CI
- [ ] Artifacts versioned and immutable
- [ ] Infrastructure as code
- [ ] Environments consistent
- [ ] Config via environment variables
- [ ] Secrets not in code
- [ ] Rollback strategy documented
- [ ] Rollback tested
- [ ] Deployment strategy chosen (blue-green, canary, rolling)
- [ ] Post-deployment monitoring configured
- [ ] Deployment notifications configured

## Anti-patterns

- Manual deployments → automate with CI/CD
- No CI/CD → set up pipeline
- Console infrastructure changes → use IaC
- No rollback strategy → document and test rollback
- Environment drift → use same code for all environments
- Secrets in code → use environment variables
- No environment parity → standardize environments
- No post-deployment monitoring → add monitoring
- Big bang releases → use canary or blue-green
- No feature flags → add feature flag system
