# Documentation Standards

## Applies when

Creating or updating any documentation, API specs, runbooks, or onboarding materials.

## Rules

### API Documentation

- OpenAPI/Swagger specification (machine-readable)
- Request/response examples for every endpoint
- Authentication guide (API key, OAuth, JWT)
- Error code reference with explanations
- Rate limiting documentation (limits, headers, 429 handling)
- Changelog (version history, breaking changes, deprecations)
- Interactive documentation (Swagger UI, Redoc)

### ADRs

- Format: title, status, context, decision, consequences
- Create for: hard-to-reverse decisions, surprising without context, real trade-offs
- Location: `docs/adr/0001-decision-name.md`
- Index: `docs/adr/README.md`
- Mark superseded ADRs, link to new
- Periodically review for relevance

### Runbooks

- Incident response procedures (step-by-step)
- On-call guide (what to do when paged, escalation)
- Troubleshooting guides (diagnose common issues)
- Recovery procedures (recover from failures)
- Contact information (who to contact)
- Location: `docs/runbooks/` or wiki

### Onboarding

- Quick start (<5 minutes to running)
- Prerequisites (what to install, accounts to create)
- Development setup (local environment)
- Testing guide (run tests, write tests)
- Deployment guide (deploy to environments)
- Code conventions (standards, patterns, best practices)
- Location: `README.md`, `CONTRIBUTING.md`, `docs/onboarding/`

### README

- Project description (what, why)
- Quick start (get running)
- Installation (dependencies)
- Usage (how to use)
- Configuration (env vars, config files)
- Testing (run tests)
- Deployment (deploy)
- Contributing (how to contribute)
- License
- Badges (build, coverage, version)

### Code Documentation

- Docstrings for public APIs (functions, classes, methods)
- Inline comments explain why (not what)
- README per module (purpose, usage, dependencies)
- Type annotations (better IDE support)
- Code examples in documentation
- Update when code changes

## Checklist

- [ ] OpenAPI spec exists and current
- [ ] API examples provided
- [ ] ADRs created for key decisions
- [ ] Runbooks exist for common incidents
- [ ] Onboarding guide exists
- [ ] Quick start <5 minutes
- [ ] README complete
- [ ] Public APIs documented
- [ ] Comments explain why (not what)
- [ ] Documentation updated with code changes
- [ ] `scripts/verify.sh` returns 0
- [ ] All domain terms consistent across docs (no term drift)
- [ ] All cross-document links resolve (no broken references)
- [ ] SESSION.md matches filesystem state
- [ ] All ADRs listed in ADR index
- [ ] No orphan docs (all docs referenced by at least one other doc)
- [ ] No contradictions between any two docs
- [ ] All ADR decisions reflected in implementation
- [ ] Code matches what docs describe (no stale docs)

## Anti-patterns

- No documentation → write docs
- Outdated documentation → update with code
- Docs don't match code → sync docs
- Verbose docs → be concise
- No examples → add examples
- No README → write README
- No API docs → add OpenAPI spec
- No runbooks → write runbooks
- No onboarding → write onboarding guide
- Comments explain what → explain why
- Docs in multiple places → single source of truth
