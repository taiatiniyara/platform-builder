# References

Quick reference for what each file contains. Read the full file when you need the details.

## Core Workflow

- **phase-checklists.md** — Mandatory checklists for each phase. Copy to `docs/SESSION.md` and tick steps.
- **phases.md** — Expanded phase details with gate criteria and verification steps.
- **delegated-skills.md** — Which skills to run at each phase.
- **skill-prerequisites.md** — Required skills before entering a phase.
- **directives.md** — 14 standing rules that apply in every phase: baseline, gating, errors, secrets, git safety, agnosticism with suggestions, documentation, write against installed, prerequisites, circuit breaker, checklist compliance, anti-hallucination & verification, gate validation failures, contradictory & ambiguous input, user confirmation requirements.
- **state-files.md** — Format for `docs/SESSION.md` and `CONTEXT.md`.
- **feature-loop.md** — Compressed workflow for adding features after Phase 7.
- **enforcement-summary.md** — How the skill ensures agents follow the process and don't skip steps or fabricate information.

## Standards (read when working in that area)

- **api-design.md** — API endpoint standards: versioning, pagination, error shapes, idempotency, rate limiting.
- **api-versioning.md** — Verify library API calls against installed versions, not training data.
- **testing-strategy.md** — Test pyramid, test data, flaky tests, CI pipeline structure.
- **code-quality.md** — Code quality rules for REFACTOR steps and Phase 7 audit.
- **documentation.md** — Documentation standards for agents and humans; doc-audit checklist.
- **git-strategy.md** — Conventional commits, branching, hooks, signing, semver tagging.

## Architecture & Design (read when designing system structure)

- **ddd.md** — Domain-Driven Design: bounded contexts, context mapping, aggregates, domain events, strategic design for complex domains.
- **microservices.md** — Microservices: service decomposition, communication patterns, resilience, data management, deployment.
- **event-driven.md** — Event-driven architecture: event sourcing, CQRS, sagas, messaging patterns, schema evolution.
- **multi-region.md** — Multi-region deployment: topologies (active-passive, active-active), data replication, traffic routing, content delivery.

## Operations & Scale (read when operating at scale)

- **multi-team.md** — Multi-team coordination: team topologies, ownership models, communication patterns, dependency management, governance.
- **platform-engineering.md** — Platform engineering: internal developer platform (IDP), golden paths, self-service, service catalog, environment management.
- **data-engineering.md** — Data engineering: data pipelines, warehouses, lakes, ETL/ELT, analytics infrastructure, data governance.
- **observability-scale.md** — Observability at scale: metrics, logs, traces, OpenTelemetry, distributed tracing, SLOs, observability-driven development.
- **chaos-engineering.md** — Chaos engineering: chaos experiments, game days, continuous chaos, resilience patterns.
- **finops.md** — FinOps: cost visibility, optimization, budget management, governance, waste detection.

## Security & Compliance (read when handling sensitive data)

- **advanced-security.md** — Advanced security: zero trust, mTLS, secrets management, network security, data security, compliance (SOC2, HIPAA, PCI, GDPR), security testing.
- **compliance.md** — Compliance fundamentals: GDPR, data privacy, audit logging, retention, PII handling.
- **ui-ux.md** — Design tokens, component architecture, accessibility, Phase 7 UX audit.
- **ui-ux-grill.md** — Mandatory grill sessions for UI/UX at Phase 1, Phase 3, Feature Loop, Phase 7.

## Platform-Specific (read when building for specific platforms)

- **mobile.md** — Mobile development: iOS/Android deployment, offline-first, push notifications, device constraints, app store optimization, testing on real devices.
