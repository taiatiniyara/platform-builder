# Documentation Standards

## Applies when

Creating or updating docs, ADRs, runbooks, README, or onboarding materials.

## Checklist

### ADRs
- [ ] Format: title, status, context, decision, consequences; in `docs/adr/0001-decision-name.md`
- [ ] Index at `docs/adr/README.md`; mark superseded; periodically review

### Runbooks
- [ ] Incident response procedures (step-by-step); on-call guide; troubleshooting guides
- [ ] Recovery procedures; contact info; in `docs/runbooks/` or wiki

### README & Onboarding
- [ ] Quick start <5min; prerequisites; dev setup; testing + deployment guides
- [ ] README: what, why, install, usage, config, contributing, license, badges
- [ ] Code conventions documented; public APIs have docstrings (why, not what)

### Doc Health
- [ ] All domain terms consistent across docs (no term drift)
- [ ] All cross-document links resolve; no orphan docs; no contradictions between docs
- [ ] SESSION.md matches filesystem state; all ADR decisions reflected in implementation
- [ ] Code matches what docs describe (no stale docs); docs updated with code changes
- [ ] `scripts/verify.sh` returns 0
