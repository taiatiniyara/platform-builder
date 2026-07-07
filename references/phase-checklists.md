# Phase Checklists

Mandatory steps per phase. Each step has an **artifact** — proof the step was
completed. The agent MUST tick each step in `docs/SESSION.md` after completing
it. Gates cannot pass until every step is ticked and every artifact exists.

**Rules:**
- Tick a step ONLY after the artifact exists and is verifiable.
- If a step is not applicable, write `N/A — <reason>` instead of ticking it.
- Do NOT advance to the next phase until every step is ticked or marked N/A.
- If a required skill is unavailable, write `BLOCKED — <skill> missing` and
  yield to the user.

---

## Phase 0 — Bootstrap

- [ ] `/setup-matt-pocock-skills` run
  - Artifact: issue tracker configured, triage labels exist
- [ ] git initialized
  - Artifact: `.git/` directory exists
- [ ] `.gitignore` generated
  - Artifact: `.gitignore` file exists and covers sensitive paths
- [ ] `README.md` generated
  - Artifact: file exists, contains project name + one-liner
- [ ] `CONTRIBUTING.md` generated from template
  - Artifact: file exists, non-empty, documents branching + commit convention
- [ ] `CHANGELOG.md` generated
  - Artifact: file exists, follows keepachangelog.com format
- [ ] Directory structure created
  - Artifact: `docs/`, `docs/adr/`, `docs/agents/contracts/`, `docs/agents/schemas/`, `.scratch/` all exist
- [ ] Linter + typechecker identified and configured
  - Artifact: config files exist (e.g., `.eslintrc`, `tsconfig.json`)
- [ ] All deps version-checked against registry
  - Artifact: manifest has registry-check timestamp comments
- [ ] `/setup-pre-commit` run (or equivalent for the stack)
  - Artifact: pre-commit hook configured (formatter + typecheck + test)
- [ ] Commit message validation configured (agent suggests based on stack)
  - Artifact: commit-msg hook installed, validates conventional commits
- [ ] pre-push hook installed
  - Artifact: pre-push hook exists, blocks force-push to main, runs full test suite
- [ ] `CONTEXT.md` created from template
  - Artifact: file exists (blank is OK for Phase 0)
- [ ] `docs/ARCHITECTURE.md` created from template
  - Artifact: file exists (blank is OK for Phase 0)
- [ ] Linter exits 0
  - Artifact: linter command (stack-appropriate) exits 0
- [ ] Typechecker exits 0
  - Artifact: typechecker command (stack-appropriate) exits 0
- [ ] `scripts/validate-gate.sh 0` passes
  - Artifact: script exits 0

---

## Phase 1 — Blueprint

- [ ] `/to-prd` run (if no clear product vision)
  - Artifact: PRD exists (in conversation or as issue)
- [ ] `/decision-mapping` run (if open architectural unknowns)
  - Artifact: investigation tickets resolved, ADRs filed
- [ ] `/grill-with-docs` run
  - Artifact: `CONTEXT.md` populated with domain glossary terms
  - Artifact: ADRs exist in `docs/adr/`
- [ ] `docs/ARCHITECTURE.md` populated
  - Artifact: file contains all required sections:
    - Stack choices (with rationale)
    - System topology (including event-driven patterns if applicable)
    - API/IPC contracts (per `references/api-design.md`)
    - Multi-tenancy strategy
    - Internationalization posture
    - UI/UX decisions (per `references/ui-ux.md`)
    - Compliance posture (per `references/compliance.md`)
    - Cost model (expected, 2x, 10x)
    - Documentation posture
- [ ] UI/UX section complete
  - Artifact: design tokens defined (colors, spacing, typography, radii, shadows)
  - Artifact: component catalog with state coverage
  - Artifact: accessibility baseline (WCAG 2.1 AA minimum)
- [ ] Domain model defined (if complex domain, per `references/ddd.md`)
  - Artifact: bounded contexts identified and documented in `docs/ARCHITECTURE.md`
  - Artifact: context map created (if 2+ bounded contexts)
  - Artifact: context files in `docs/agents/schemas/contexts/` (if applicable)
- [ ] Service decomposition defined (if microservices, per `references/microservices.md`)
  - Artifact: service boundaries documented in `docs/ARCHITECTURE.md`
  - Artifact: communication patterns chosen (sync vs async)
  - Artifact: resilience patterns chosen (circuit breaker, retry, timeout)
- [ ] Event-driven architecture defined (if applicable, per `references/event-driven.md`)
  - Artifact: events identified and documented
  - Artifact: messaging pattern chosen (point-to-point, pub-sub, streaming)
  - Artifact: event contracts in `docs/agents/contracts/`
- [ ] Team topology defined (if 3+ teams, per `references/multi-team.md`)
  - Artifact: team types documented (stream-aligned, platform, enabling, subsystem)
  - Artifact: ownership model defined (code, data, API)
  - Artifact: communication patterns documented
- [ ] Multi-region strategy defined (if global, per `references/multi-region.md`)
  - Artifact: deployment topology chosen (active-passive, active-active, regional isolation)
  - Artifact: data replication strategy chosen
  - Artifact: traffic routing strategy chosen
- [ ] Security strategy defined (if sensitive data, per `references/advanced-security.md`)
  - Artifact: authentication strategy chosen (mTLS, JWT, API keys)
  - Artifact: secrets management strategy chosen
  - Artifact: network security strategy chosen (WAF, DDoS)
- [ ] Mobile strategy defined (if building mobile apps, per `references/mobile.md`)
  - Artifact: platform strategy chosen (iOS, Android, cross-platform)
  - Artifact: architecture pattern chosen (offline-first, state management)
  - Artifact: device constraints documented (app size, memory, battery)
- [ ] Full UI/UX grill run (§1‑§4 from `references/ui-ux-grill.md`)
  - Artifact: every question answered (no hedging)
  - Artifact: unresolved answers filed as ADRs or issues
- [ ] `CONTEXT.md` presented for review
  - Artifact: user writes `Confirm CONTEXT.md`
- [ ] `docs/ARCHITECTURE.md` presented for review
  - Artifact: user writes `Confirm ARCHITECTURE.md`
- [ ] `scripts/validate-gate.sh 1` passes
  - Artifact: script exits 0

---

## Phase 2 — Backlog

- [ ] `/to-issues` run
  - Artifact: issues exist in `.scratch/` or issue tracker
- [ ] `/graphify .` run (if source files exist)
  - Artifact: `graphify-out/graph.json` exists
  - Artifact: `graphify-out/GRAPH_REPORT.md` exists
- [ ] Tracer-bullet identified
  - Artifact: tracer-bullet issue marked in `docs/ISSUES.md`
- [ ] All issues are vertical slices
  - Artifact: each issue has input/output definitions, validation requirements, acceptance criteria, `Blocked by` field
- [ ] All issues have `Docs:` field
  - Artifact: each issue lists what documentation it will produce
- [ ] Dependency graph saved
  - Artifact: `docs/ISSUES.md` contains dependency graph
- [ ] High-risk issues tagged
  - Artifact: issues crossing community boundaries or modifying god nodes have `risk: high`
- [ ] `scripts/validate-gate.sh 2` passes
  - Artifact: script exits 0

---

## Phase 3 — Implement

For EACH issue in dependency order:

- [ ] `/graphify . --update` run before starting issue
  - Artifact: `graphify-out/graph.json` updated (check timestamp)
- [ ] `/graphify query "<issue context>" --budget 2000` run
  - Artifact: structural overview obtained (not file-by-file scan)
- [ ] Branch created
  - Artifact: branch named `issue-<n>-<slug>`
- [ ] RED step: failing test written
  - Artifact: test exists, fails with expected message
- [ ] GREEN step: minimal code to pass
  - Artifact: test passes
- [ ] REFACTOR step: code quality verified
  - Artifact: linter exits 0
  - Artifact: typechecker exits 0
  - Artifact: no copy-pasted blocks within same file
- [ ] API endpoints verified against `references/api-design.md`
  - Artifact: error shape, pagination, idempotency, rate limiting all correct
- [ ] Library imports verified against installed version
  - Artifact: every third-party import checked against `node_modules/` (or equivalent)
- [ ] Documentation updated
  - Artifact: every new public interface has docstring or typed signature
  - Artifact: `docs/agents/contracts/` updated if API changed
  - Artifact: `CHANGELOG.md` has entry for this issue
- [ ] UI/UX grill run (if issue touches UI)
  - Artifact: screen-level grill (§6) completed
  - Artifact: interaction design (§7) completed
  - Artifact: every question answered before code written
- [ ] Session summarized
  - Artifact: `docs/SESSION.md` updated with trajectory
- [ ] Squash-merged with conventional commit message
  - Artifact: branch merged to `main` with `type(scope): description` format, `Closes #<n>` in footer, branch deleted

Phase 3 gate:

- [ ] All backlog issues merged
  - Artifact: `git log` shows all issues merged
- [ ] Full test suite passes
  - Artifact: `npm test` (or equivalent) exits 0
- [ ] No regressions
  - Artifact: all previously-passing tests still pass
- [ ] Linter + typechecker exit 0
  - Artifact: both commands exit 0
- [ ] Every public interface documented
  - Artifact: docstrings or typed signatures on all public interfaces
- [ ] CHANGELOG updated per issue
  - Artifact: one entry per issue in `CHANGELOG.md`
- [ ] API contracts match implementation
  - Artifact: `docs/agents/contracts/` matches code
- [ ] `scripts/validate-gate.sh 3` passes
  - Artifact: script exits 0

---

## Phase 4 — Productionization

- [ ] Deployment artifacts built
  - Artifact: Dockerfile, serverless config, or equivalent exists
- [ ] Environments set up (dev, staging, production)
  - Artifact: environment configs exist per `references/operations.md`
- [ ] Preview deployments configured (if supported)
  - Artifact: PR triggers ephemeral environment
- [ ] CI pipeline wired up
  - Artifact: CI config exists (`.github/workflows/`, etc.)
  - Artifact: pipeline runs linter, typechecker, unit, integration, e2e tests
  - Artifact: pipeline blocks merges on failure
- [ ] Accessibility checks in CI
  - Artifact: axe-core or equivalent runs on preview deployments
- [ ] Feature flags implemented (if declared in Phase 1)
  - Artifact: flag infrastructure exists, documented in `docs/DEPLOYMENT.md`
- [ ] Single-command launch works
  - Artifact: `npm start` (or equivalent) succeeds
- [ ] Liveness signal returns success
  - Artifact: health check endpoint returns 200
- [ ] Data survives restart cycle
  - Artifact: data persists after restart
- [ ] README has one-command setup + deploy instructions
  - Artifact: instructions work on clean clone
- [ ] Platform engineering setup (if 3+ teams, per `references/platform-engineering.md`)
  - Artifact: golden paths created (service, database, frontend templates)
  - Artifact: self-service portal configured (if applicable)
  - Artifact: service catalog populated
- [ ] Security setup (if sensitive data, per `references/advanced-security.md`)
  - Artifact: authentication/authorization implemented
  - Artifact: secrets manager configured (Vault, AWS Secrets Manager)
  - Artifact: encryption at rest and in transit enabled
  - Artifact: network security configured (WAF, DDoS protection)
- [ ] Observability setup (per `references/observability-scale.md`)
  - Artifact: all services instrumented with OpenTelemetry
  - Artifact: metrics collection configured (Prometheus)
  - Artifact: log aggregation configured (Loki, ELK)
  - Artifact: distributed tracing configured (Jaeger, Zipkin)
  - Artifact: SLOs defined per service
- [ ] Multi-region setup (if global, per `references/multi-region.md`)
  - Artifact: infrastructure deployed in each region
  - Artifact: data replication configured
  - Artifact: traffic routing configured (DNS, load balancer)
  - Artifact: CDN configured
- [ ] Mobile setup (if building mobile apps, per `references/mobile.md`)
  - Artifact: CI/CD configured (Fastlane, Bitrise, Codemagic)
  - Artifact: beta testing configured (TestFlight, Internal Testing)
  - Artifact: app store metadata prepared (screenshots, description)
  - Artifact: push notifications configured (APNs, FCM)
- [ ] `scripts/validate-gate.sh 4` passes
  - Artifact: script exits 0

---

## Phase 5 — Data Integrity & Security

- [ ] Schema migrations reversible
  - Artifact: `migrate up`, `migrate down`, `migrate up` all succeed
- [ ] Database indexes for all query patterns
  - Artifact: no table scans on frequent queries
- [ ] Runtime validation at every boundary
  - Artifact: strict validation on API, CLI, IPC, events
- [ ] Idempotency on mutation endpoints
  - Artifact: `Idempotency-Key` header supported
- [ ] Rate limiting on all endpoints
  - Artifact: rate limit headers on every response
- [ ] Auth enforcement at boundary
  - Artifact: unauthenticated → 401
- [ ] CSRF protection (if cookie-based sessions)
  - Artifact: CSRF tokens validated
- [ ] Compliance verified (per `references/compliance.md`)
  - Artifact: consent mechanism, data export, data deletion paths exist
  - Artifact: no PII in logs or error messages
- [ ] Input fuzzing passes
  - Artifact: malformed payloads → 4xx (not 5xx)
- [ ] Data model documented
  - Artifact: `docs/agents/schemas/` contains schemas
- [ ] Auth flow documented
  - Artifact: `docs/ARCHITECTURE.md` or ADR describes auth flow
- [ ] `scripts/validate-gate.sh 5` passes
  - Artifact: script exits 0

---

## Phase 6 — Observability & Operations

- [ ] Structured logs with correlation IDs
  - Artifact: every log entry has correlation ID
- [ ] Error tracking wired up
  - Artifact: errors sent to tracking service
- [ ] RED metrics on every endpoint
  - Artifact: Rate, Errors, Duration metrics visible
- [ ] Service dashboard exists
  - Artifact: dashboard URL documented in `docs/DEPLOYMENT.md`
- [ ] SLOs defined per critical journey
  - Artifact: SLOs documented in `docs/ARCHITECTURE.md`
- [ ] Symptom-based alerts configured
  - Artifact: alerts route to real destination
- [ ] Every alert has a runbook
  - Artifact: `docs/runbooks/` contains one runbook per alert
- [ ] On-call escalation path documented
  - Artifact: path in `docs/DEPLOYMENT.md`
- [ ] Disaster recovery plan
  - Artifact: RTO/RPO targets in `docs/ARCHITECTURE.md`
  - Artifact: automated backups configured, 30-day retention
  - Artifact: quarterly restore test scheduled
- [ ] Load testing passes
  - Artifact: 2x peak for 10+ minutes, zero 5xx, p95 within 2x baseline
- [ ] Profiling of hot paths done
  - Artifact: top 5 highest-traffic + top 3 slowest endpoints profiled
- [ ] Caching strategy implemented
  - Artifact: CDN cache for static assets with content-hash filenames
- [ ] Idempotent deployments
  - Artifact: migrations run before new code serves traffic
- [ ] Cost review against Phase 1 estimate
  - Artifact: actual costs compared, unused resources cleaned up
- [ ] FinOps practices applied (if cloud spend >$5K/month, per `references/finops.md`)
  - Artifact: cost allocation tags configured
  - Artifact: budget alerts configured
  - Artifact: cost dashboards created
  - Artifact: right-sizing review done
- [ ] Chaos engineering setup (if microservices, per `references/chaos-engineering.md`)
  - Artifact: chaos experiments defined
  - Artifact: game day plan created
  - Artifact: continuous chaos configured in CI/CD (if applicable)
- [ ] Multi-team coordination setup (if 3+ teams, per `references/multi-team.md`)
  - Artifact: ownership model documented
  - Artifact: RFC process established
  - Artifact: cross-team dependency management configured
- [ ] `docs/DEPLOYMENT.md` finalized
  - Artifact: single-command launch, env setup, operational checklist verified
- [ ] `docs/ARCHITECTURE.md` finalized
  - Artifact: all sections complete and accurate
- [ ] `scripts/validate-gate.sh 6` passes
  - Artifact: script exits 0

---

## Phase 7 — Upkeep

- [ ] `/graphify .` full rebuild run
  - Artifact: `graphify-out/graph.json` rebuilt (check timestamp)
  - Artifact: `graphify-out/GRAPH_REPORT.md` updated
- [ ] `/review` run
  - Artifact: two-axis review completed (Standards + Spec)
- [ ] `/improve-codebase-architecture` run
  - Artifact: architecture scan completed, shallow modules identified
- [ ] Documentation audit run
  - Artifact: every ADR cross-referenced against implementation
  - Artifact: agent contracts match code
  - Artifact: README setup instructions work on clean clone
  - Artifact: every public module has a graph node
- [ ] Live review grill run (§8 from `references/ui-ux-grill.md`)
  - Artifact: real device, throttled connection, screen reader, 200% zoom, performance profile tested
  - Artifact: every failure filed as issue
- [ ] Dependency freshness audit run
  - Artifact: every direct dependency checked against registry
  - Artifact: upgrade issues filed for packages >1 major behind
  - Artifact: `npm audit` (or equivalent) run, CVEs filed as `risk: critical`
- [ ] UX audit run (§9 from `references/ui-ux.md`)
  - Artifact: full checklist completed, every failure filed
- [ ] Code quality audit run
  - Artifact: dead code, duplication, complexity, coupling audited
  - Artifact: findings resolved or filed
- [ ] Performance audit run
  - Artifact: p95 latencies compared against Phase 6 baseline
  - Artifact: no regressions
- [ ] Compliance audit run
  - Artifact: audit logging, data retention, PII hygiene, dependency licenses verified
- [ ] i18n audit run (if applicable)
  - Artifact: no hardcoded strings, RTL works, locale-aware formatting
- [ ] FinOps audit run (if cloud spend >$5K/month, per `references/finops.md`)
  - Artifact: cost allocation tags reviewed
  - Artifact: unused resources identified and removed
  - Artifact: right-sizing review done
  - Artifact: reserved instance coverage reviewed
- [ ] `/request-refactor-plan` run on highest-value shallow module
  - Artifact: refactor plan applied
- [ ] `/qa` run
  - Artifact: interactive bug-filing session completed
- [ ] `/handoff` run
  - Artifact: session handoff document produced
- [ ] Zero critical vulnerabilities
  - Artifact: no unresolved critical CVEs
- [ ] Every ADR honored or superseded
  - Artifact: no orphaned ADRs
- [ ] `status: complete` written to `docs/SESSION.md`
  - Artifact: `docs/SESSION.md` contains `status: complete`
- [ ] `scripts/validate-gate.sh 7` passes
  - Artifact: script exits 0

---

## Feature Loop

For EACH feature:

- [ ] `feature: <slug>` written to `docs/SESSION.md`
  - Artifact: `docs/SESSION.md` updated
- [ ] `/graphify . --update` run
  - Artifact: graph refreshed
- [ ] Graph queried for drift
  - Artifact: drift check documented (or ADR written if drifted)
- [ ] `/to-issues` run
  - Artifact: vertical-slice issues created
- [ ] `/grill-me` run against each issue's design
  - Artifact: every issue passed grill session
- [ ] UI/UX grill run (if UI issues)
  - Artifact: §6‑§7 from `references/ui-ux-grill.md` completed
- [ ] `/tdd` and `/codebase-design` run
  - Artifact: RED → GREEN → REFACTOR for each issue
- [ ] `/graphify query` run before each issue
  - Artifact: structural overview obtained
- [ ] `/prototype` run (if uncertain)
  - Artifact: prototype answered question, then deleted
- [ ] API verified against `references/api-design.md`
  - Artifact: endpoints match standards
- [ ] Library imports verified against installed version
  - Artifact: every import checked
- [ ] Documentation updated
  - Artifact: public interfaces documented, contracts updated, CHANGELOG entry
- [ ] Code quality verified against `references/code-quality.md`
  - Artifact: linter + typechecker exit 0
- [ ] Squash-merged with conventional commit message
  - Artifact: branch merged to `main` with `type(scope): description` format, branch deleted
- [ ] `/review` run
  - Artifact: no standards violations, no spec drift, no doc gaps
- [ ] `docs/SESSION.md` updated after each step
  - Artifact: session state current
- [ ] `CONTEXT.md` updated (if domain model changed)
  - Artifact: glossary reflects new terms
- [ ] `/graphify .` full rebuild after feature complete
  - Artifact: graph fully rebuilt
- [ ] `scripts/validate-gate.sh 3` passes
  - Artifact: script exits 0
