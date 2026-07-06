# Phase Details

Expanded breakdown of each phase with gate criteria and deliverables.

---

## Phase 0 — Bootstrap

Write `phase: 0` to `docs/SESSION.md`. Run `/setup-matt-pocock-skills`.

Init git. Generate `.gitignore`, `README.md`, `CONTRIBUTING.md`
(template: `templates/CONTRIBUTING.md`), `CHANGELOG.md`
(template: `templates/CHANGELOG.md`). Create `docs/`, `docs/adr/`, `docs/agents/contracts/`,
`docs/agents/schemas/`, `.scratch/`. Interrogate the stack for linter,
formatter, typechecker — adapt, don't assume. Before installing any
dependency, run the latest-stable check from
`references/api-versioning.md` § "Installing" — never install from memory.
Pin exact versions in the manifest with a registry check timestamp comment.
Run `/setup-pre-commit` to wire up automated quality checks on every commit.
Create blank `CONTEXT.md` (template: `templates/CONTEXT.md`) and
`docs/ARCHITECTURE.md` (template: `templates/ARCHITECTURE.md`).

**Gate:** Linter and typechecker exit `0`. README is non-empty (project name
+ one-liner). CHANGELOG.md follows `keepachangelog.com` format. If the stack
supports a test runner without source files, run it — otherwise skip.
**Verification:** re-read Phase 0 checklist in `docs/SESSION.md`. Confirm
every ticked step has a corresponding artifact. If any artifact is missing,
complete the step before advancing.

---

## Phase 1 — Blueprint

Write `phase: 1` to `docs/SESSION.md`.

If the user hasn't articulated a clear product vision, run `/to-prd` first
to synthesize one from the conversation. If the design space has open
architectural unknowns — fog of war — run `/decision-mapping` to create
investigation tickets and resolve them before grilling.

Run `/grill-with-docs`. This produces `CONTEXT.md` (domain glossary) and
any ADRs in `docs/adr/`.

After the session, extract the architectural decisions that emerged and
record them in `docs/ARCHITECTURE.md`:

- **Stack choices** — language, framework, data store, auth provider,
  hosting target. Each with rationale.
- **System topology** — what talks to what, across which boundaries.
  Include event-driven patterns if applicable (message queues, pub/sub,
  webhooks, async processing). Decide if the domain needs events or
  synchronous calls are sufficient — document the rationale.
- **API or IPC contracts** — route shapes and payloads (web), module
  interfaces, event contracts, or CLI signatures (everything else).
  Apply the standards in `references/api-design.md` (versioning,
  pagination, error shape, idempotency, rate limiting, async operations).
- **Multi-tenancy** — if the platform serves multiple organizations,
  decide the isolation strategy: separate databases, row-level tenant
  columns, or schema-per-tenant. Document in an ADR. If single-tenant,
  state that explicitly so it is a decision, not an omission.
- **Internationalization (i18n)** — decide whether the platform supports
  multiple languages now, later, or never. If now: define the translation
  key convention, RTL strategy, and locale-aware formatting plan per
  `references/ui-ux.md`. If later: note the trigger for revisiting. If
  never: document the assumption. No silent ambiguity.
- **UI/UX** — design tokens (colors, spacing, typography, radii, shadows),
  component catalog with state coverage per component, layout strategy,
  navigation pattern, form UX, feedback pattern, accessibility baseline
  (WCAG 2.1 AA minimum). Every section of the template must be filled
  before advancing. Apply the heuristics in `references/ui-ux.md`.
- **Compliance posture** — declare which regulations apply (GDPR, CCPA,
  HIPAA, SOC2, PCI, none). State data residency requirements. Apply the
  framework in `references/compliance.md` to identify what must be built
  vs what can be deferred. At minimum: classify data stores by sensitivity
  and define the PII handling policy.
- **Cost model** — estimate monthly cost at expected, 2x, and 10x usage.
  Document in `docs/ARCHITECTURE.md`. Set budget alerts at 1.5x expected.

Run the full UI/UX grill from `references/ui-ux-grill.md` §1‑§4 against the
entire product vision. This is mandatory. Every unresolved answer becomes an
ADR or an issue. Do not advance until the visual language, IA, mental model,
and state design are sharp enough that the user can answer every question
without hedging.

Present `CONTEXT.md` and `docs/ARCHITECTURE.md` for review.

**Gate:** User writes `Confirm CONTEXT.md` and `Confirm ARCHITECTURE.md`.
ARCHITECTURE.md includes documentation posture: who writes what, where agent
docs live (contracts, schemas, graph), where human docs live (README,
CHANGELOG, ADRs).
**Verification:** re-read Phase 1 checklist in `docs/SESSION.md`. Confirm
every ticked step has a corresponding artifact. Verify ARCHITECTURE.md
contains all required sections (stack, topology, API, UI/UX, compliance,
cost, documentation). If any artifact is missing, complete the step before
advancing.

---

## Phase 2 — Backlog

Write `phase: 2` to `docs/SESSION.md`. Run `/to-issues`.

Map user stories. Identify the tracer bullet — the thinnest vertical slice
through every layer.

Break remaining work into vertical-slice issues with: input/output
definitions, validation requirements, acceptance criteria, `Blocked by`
field. Save the dependency graph to `docs/ISSUES.md`. Publish each issue to
`.scratch/<feature-slug>/issue.md` (or the issue tracker if configured).

**Gate:** Every issue is a vertical slice, self-contained, agent-ready.
**Verification:** re-read Phase 2 checklist in `docs/SESSION.md`. Confirm
every ticked step has a corresponding artifact. Verify `docs/ISSUES.md`
exists and contains the dependency graph. If any artifact is missing,
complete the step before advancing.

---

## Phase 3 — Implement

Write `phase: 3` to `docs/SESSION.md`. Run `/tdd` and `/codebase-design`.

Apply the testing strategy from `references/testing-strategy.md`: unit tests
for business logic, integration tests for boundaries, e2e tests for critical
user journeys. Every issue ships with tests at the appropriate level.

Before implementing an issue with tricky design trade-offs, run `/grill-me`
to stress-test the decisions — no doc output needed since Phase 1 already
wrote the blueprint.

If an interface shape is uncertain, run `/design-an-interface` to generate
multiple alternatives and pick the deepest one. If a specific alternative
needs hands-on testing, run `/prototype` — answer the question, then delete
the prototype.

For each issue in dependency order:
1. Branch `issue-<n>-<slug>` from `main`.
2. `/graphify query "<issue context>" --budget 2000` to understand the
   surrounding code before touching it.
3. RED → GREEN → REFACTOR. One test at a time.
4. **After REFACTOR:** verify against `references/code-quality.md` §
   "Per-Issue Refactor". At minimum: linter + typechecker exit 0, no
   copy-pasted block inside the same file.
5. **API endpoints:** verify against `references/api-design.md` (error
   shape, pagination, idempotency on mutations, rate limiting headers).
6. **Library imports:** verify against `references/api-versioning.md` —
   every third-party import must be verified against the installed version
   before the first call.
7. **Documentation:** verify against `references/documentation.md` —
   every new public interface has a docstring or typed signature. API
   contracts in `docs/agents/contracts/` match implementation. CHANGELOG
   gets an entry.
8. Summarise trajectory into `docs/SESSION.md`.
9. Squash-merge to `main` on 100% pass. Delete branch.

**Gate:** All backlog issues merged. Full test suite passes (unit,
integration, e2e). No regressions. Linter + typechecker exit 0. Every
public interface has docstrings or typed signatures (agent-facing).
CHANGELOG updated per issue. API contracts in `docs/agents/contracts/`
match implementation.
**Verification:** re-read Phase 3 checklist in `docs/SESSION.md`. Confirm
every ticked step has a corresponding artifact. Run `git log` to verify
all issues merged. Run test suite, linter, typechecker to verify they
exit 0. If any artifact is missing, complete the step before advancing.

---

## Phase 4 — Productionization

Write `phase: 4` to `docs/SESSION.md`.

### Deployment Artifacts

Build deployment artifacts for the target declared in
`docs/ARCHITECTURE.md`: containers (Dockerfile, compose, volumes),
serverless (provider config, env bindings), static/SPA (CDN, cache,
routing), mobile/desktop (pipeline, signing, store metadata), or
equivalent.

### Environment Strategy

Set up at minimum three environments per `references/operations.md`:
`dev`, `staging`, `production`. If the hosting target supports preview
deployments, configure ephemeral environments for every PR with automatic
teardown on merge.

Config and secrets: all environment-specific values via environment
variables or a config service. Secrets injected at deploy time from a
secret manager — never in files, never in the repo.

### CI Pipeline

Wire up CI to run on every push and block merges on failure. Pipeline
order per `references/testing-strategy.md`:
1. Linter
2. Typechecker
3. Unit tests (parallel where possible)
4. Integration tests
5. E2e tests (on main branch, or PRs touching critical paths)

Add automated accessibility checks per `references/ui-ux.md` §8: run
axe-core or equivalent on preview deployments, block critical violations.

### Feature Flags & Rollout (if declared in architecture)

If Phase 1 decided on gradual rollout, implement the feature flag
infrastructure: flag definitions, per-environment defaults, a kill-switch
mechanism for emergency rollback. Document in `docs/DEPLOYMENT.md`.

### Deploy & Verify

Single-command launch for the declared target. Verify liveness. Verify
data survives a restart cycle. If Phase 1 declared a cost model, verify
the deployment matches the expected cost tier; set budget alerts.

**Gate:** Single-command launch succeeds. Liveness signal returns success.
Data survives a restart cycle. Preview deployments work (if applicable).
CI pipeline passes all stages.
**Verification:** re-read Phase 4 checklist in `docs/SESSION.md`. Confirm
every ticked step has a corresponding artifact. Test single-command launch
on clean clone. Verify health check returns 200. If any artifact is missing,
complete the step before advancing.

---

## Phase 5 — Data Integrity & Security

Write `phase: 5` to `docs/SESSION.md`.

- **Schema evolution:** reversible, lossless migrations appropriate to the
  store declared in `docs/ARCHITECTURE.md`. Run `migrate up`, `migrate
  down`, `migrate up` — all three must succeed.
- **Database indexing:** for every query pattern exercised in integration
  tests, confirm an index exists. Add compound indexes for queries that
  filter on multiple columns. No table scan should appear in a query
  executed on every request.
- **Runtime validation:** strict at every boundary (API, CLI, IPC, events).
  Apply `references/api-design.md` input validation rules: reject unknown
  fields, validate types/ranges/formats, return all validation errors at
  once, sanitize strings.
- **Idempotency:** every mutation endpoint with side effects supports an
  `Idempotency-Key` header per `references/api-design.md`. Payment,
  order creation, and account mutations are mandatory; others are
  recommended.
- **Rate limiting:** apply to all endpoints, not just auth — per IP for
  unauthenticated, per user/token for authenticated. Return rate limit
  headers on every response.
- **Auth:** enforce at the boundary — reject unauthenticated before
  business logic. Rate-limit auth endpoints against brute-force. Enable
  CSRF protection for cookie-based sessions. Verify tokens expire and renew
  correctly.
- **Compliance:** if GDPR applies per Phase 1 declaration, verify consent
  mechanism, data export path, data deletion path per
  `references/compliance.md`. Confirm no PII in application logs or error
  messages. Verify HSTS header on production.
- **Input fuzzing:** send malformed payloads to every boundary. Confirm all
  responses are 4xx (not 5xx). No crashes, no leaked stack traces.

**Gate:** Unauthenticated request → 401. Malformed input → 400 with
structured error body. Rate-limited (429) on all endpoints. Idempotency
keys prevent double-processing. Fuzz input returns zero 500s. Migration
up/down/up cycle exits `0`. Compliance checklist items verified.
**Verification:** re-read Phase 5 checklist in `docs/SESSION.md`. Confirm
every ticked step has a corresponding artifact. Test unauthenticated,
malformed, and fuzz inputs. Verify migration cycle. If any artifact is
missing, complete the step before advancing.

---

## Phase 6 — Observability & Operations

Write `phase: 6` to `docs/SESSION.md`.

All standards below are detailed in `references/operations.md`. Apply the
relevant sections based on what was declared in `docs/ARCHITECTURE.md`.

### Telemetry & Monitoring

- **Structured logs:** correlation IDs on every request. Error tracking
  wired up.
- **Metrics:** RED method (Rate, Errors, Duration) on every endpoint.
  Application-level metrics for queues, connection pools, caches, auth
  events, and background jobs.
- **Dashboards:** service overview dashboard with request rate, error rate,
  p95 latency, saturation, and key business metrics.

### SLOs & Alerting

- **SLOs:** define at least one per critical user journey (page load p95,
  API availability, core transaction error rate).
- **Alerts:** symptom-based, runbook-linked, owner-assigned. Minimum set:
  error rate burn, p99 latency spike, health check failure, SSL expiry.
- **On-call:** escalation path documented in `docs/DEPLOYMENT.md`.

### Disaster Recovery

- **RTO/RPO:** state targets in `docs/ARCHITECTURE.md`. RTO < 1 hour, RPO
  < 5 minutes unless the domain demands tighter targets.
- **Backups:** automated, 30-day retention, quarterly restore test to
  staging.
- **Multi-region:** if declared in Phase 1, implement active-passive
  failover and document the failover procedure.

### Performance

- **Load testing:** 2x expected peak for 10+ minutes. Zero 5xx. P95 within
  2x baseline.
- **Profiling:** top 5 highest-traffic endpoints + top 3 slowest endpoints.
  File findings for anything exceeding 2x expected latency or showing N+1
  patterns.
- **Caching:** implement the strategy declared in Phase 1. At minimum: CDN
  cache for static assets with content-hash filenames.
- **Idempotent deployments:** migrations run before new code serves traffic.
  Health check failure triggers automatic rollback.

### Docs

Finalize `docs/DEPLOYMENT.md` and `docs/ARCHITECTURE.md`. Write a runbook
per alert in `docs/runbooks/` (template: `templates/runbook.md`).

### Cost Review

Compare actual month-1 costs against the Phase 1 estimate. Clean up unused
resources. Right-size based on actual utilization.

**Gate:** Health check confirms store connectivity. Metrics visible on
dashboard. Load test passes (zero 500s, p95 within threshold). Shutdown
test passes — zero leaked resources. Backup/restore succeeds. Alerts
configured and routing to a real destination. Every alert has a runbook
in `docs/runbooks/`. DEPLOYMENT.md is finalized.
**Verification:** re-read Phase 6 checklist in `docs/SESSION.md`. Confirm
every ticked step has a corresponding artifact. Verify dashboard shows
metrics. Run load test, shutdown test, backup/restore. Check alerts route
to real destination. If any artifact is missing, complete the step before
advancing.

---

## Phase 7 — Upkeep

Write `phase: 7` to `docs/SESSION.md`. Run `/review` and
`/improve-codebase-architecture`.

Two-axis review against `CONTEXT.md` and `docs/ARCHITECTURE.md`.

### UX Audit

Run the full checklist in `references/ui-ux.md` §9. Verify every item
against the running application. Flag every failure as a finding.
Common failures: missing empty states, raw error messages visible to users,
low-contrast text, missing focus rings, layout shift on load, inconsistent
spacing, placeholder-as-label pattern, missing alt text, non-semantic
headings. File each failure as a separate QA issue.

### Code Quality Audit

Run the full audit from `references/code-quality.md` § "Codebase Audit":
dead code, duplication, complexity, and coupling. File each finding as a
QA issue with severity (blocking / non-blocking).

### Performance Audit

Re-run profiling from Phase 6. Compare p95 latencies against baseline.
Verify caching strategy is effective (cache hit rates). File regressions.

### Compliance Audit

Run the `references/compliance.md` checklist: verify audit logging for
auth/financial operations, confirm data retention policies are enforced,
verify no PII in logs or error messages, check dependency licenses and
known vulnerabilities (SBOM if available).

### i18n Audit (if applicable)

If Phase 1 declared i18n support: verify no hardcoded strings remain in
components, confirm RTL layout works, check date/number/currency formatting
uses locale-aware APIs.

### Structural Integrity

Flag structural drift — code that contradicts the blueprint. Fix or issue
a superseding ADR.

Ecosystem dependency audit. The architecture scan identifies shallow
modules — places where a large, complex interface sits in front of little
behavior. Pick the highest-value opportunity and run
`/request-refactor-plan` to turn it into a sequence of safe, incremental
commits. Apply the plan.

Run `/qa` for an interactive bug-filing session — surface any issues found
during review as trackable items.

Run `/handoff` to produce the session handoff document.

**Gate:** Zero critical vulnerabilities. Code quality audit findings for
dead code and duplication resolved or filed. Performance audit confirms no
regressions. Compliance audit passes. UX audit checklist passes (all items
checked, failures filed as issues). Every ADR honored or explicitly
superseded. Write `status: complete` to `docs/SESSION.md`.
**Verification:** re-read Phase 7 checklist in `docs/SESSION.md`. Confirm
every ticked step has a corresponding artifact. Run `npm audit` (or
equivalent) to verify zero critical CVEs. Verify all audits completed.
If any artifact is missing, complete the step before advancing.
