---
name: platform-builder
description:
  7-phase gated lifecycle for greenfield builds. Compressed feature-loop for
  adding to finished projects. Use when the user wants to build a platform,
  scaffold a SaaS, start a new project, or add features to an existing one.
  Delegates to specialist skills at each phase — see
  references/delegated-skills.md.
license: MIT
compatibility: opencode
metadata:
  workflow: lifecycle-orchestrator
  audience: solo-founders
additional_skills:
  - setup-matt-pocock-skills
  - setup-pre-commit
  - to-prd
  - decision-mapping
  - grill-with-docs
  - grill-me
  - to-issues
  - tdd
  - codebase-design
  - design-an-interface
  - prototype
  - review
  - improve-codebase-architecture
  - request-refactor-plan
  - qa
  - handoff
  - domain-modeling
  - graphify
---

# Platform Lifecycle Orchestrator

Step-by-step recipe for turning an idea into a working, live platform. Each
phase must pass a quality gate before moving on.

## File Index

**When you need to...** | **Read this file**
------------------------|------------------
Know what to do right now | `docs/SESSION.md` (in the project)
Understand the domain | `CONTEXT.md` (in the project)
Understand the stack | `docs/ARCHITECTURE.md` (in the project)
Know what phase you're in | `docs/SESSION.md` → `phase: N`
See the checklist for a phase | `references/phase-checklists.md` → search for `## Phase N`
Know which skills to run | `references/delegated-skills.md`
Understand enforcement mechanisms | `references/enforcement-summary.md`
Verify a gate | `scripts/validate-gate.sh <phase>`
Set up git hooks | `references/git-strategy.md`
Design an API | `references/api-design.md`
Write tests | `references/testing-strategy.md`
Verify library versions | `references/api-versioning.md`
Check code quality | `references/code-quality.md`
Handle UI/UX | `references/ui-ux.md` + `references/ui-ux-grill.md`
Set up operations | `references/operations.md`
Handle compliance | `references/compliance.md`
Write documentation | `references/documentation.md`
Design domain model | `references/ddd.md`
Build microservices | `references/microservices.md`
Design event-driven system | `references/event-driven.md`
Coordinate multiple teams | `references/multi-team.md`
Deploy across regions | `references/multi-region.md`
Build internal platform | `references/platform-engineering.md`
Build data pipelines | `references/data-engineering.md`
Implement advanced security | `references/advanced-security.md`
Manage cloud costs | `references/finops.md`
Test resilience | `references/chaos-engineering.md`
Observe distributed systems | `references/observability-scale.md`
Build mobile apps | `references/mobile.md`
Create a template file | `templates/README.md` (then copy the specific template)
Run validation | `scripts/README.md` (then run the specific script)
Browse reference files | `references/README.md` (one-line summary of each)

**Templates** (copy these to create project files):
- `templates/SESSION.md` → `docs/SESSION.md`
- `templates/ARCHITECTURE.md` → `docs/ARCHITECTURE.md`
- `templates/CONTEXT.md` → `CONTEXT.md`
- `templates/ISSUES.md` → `docs/ISSUES.md`
- `templates/DEPLOYMENT.md` → `docs/DEPLOYMENT.md`
- `templates/CHANGELOG.md` → `CHANGELOG.md`
- `templates/CONTRIBUTING.md` → `CONTRIBUTING.md`
- `templates/runbook.md` → `docs/runbooks/<alert-name>.md`

**Scripts** (run these to validate):
- `scripts/validate-gate.sh <phase>` — verify all artifacts for a phase gate
- `scripts/session-status.sh` — show current session state
- `scripts/pre-push.sh` — git pre-push hook (blocks force-push to main)

## Phase Reading Lists

**Phase 0 (Bootstrap):** `references/git-strategy.md`, `references/api-versioning.md` (for installing deps)

**Phase 1 (Blueprint):** `references/api-design.md`, `references/ui-ux.md`, `references/ui-ux-grill.md` (§1-§4), `references/compliance.md`, `references/ddd.md` (if complex domain), `references/microservices.md` (if distributed), `references/event-driven.md` (if event-driven), `references/multi-team.md` (if 3+ teams), `references/multi-region.md` (if global), `references/advanced-security.md` (if sensitive data), `references/mobile.md` (if building mobile apps)

**Phase 2 (Backlog):** `references/testing-strategy.md` (to understand test levels for issues), `references/ddd.md` (align issues with bounded contexts)

**Phase 3 (Implement):** `references/code-quality.md`, `references/api-design.md`, `references/api-versioning.md`, `references/testing-strategy.md`, `references/documentation.md`, `references/ui-ux-grill.md` (§6-§7 if UI), `references/microservices.md` (resilience patterns), `references/event-driven.md` (if event-driven), `references/observability-scale.md` (instrument services), `references/mobile.md` (if building mobile apps)

**Phase 4 (Productionization):** `references/operations.md`, `references/testing-strategy.md` (CI pipeline), `references/platform-engineering.md` (if platform team), `references/advanced-security.md` (security setup), `references/observability-scale.md` (set up observability), `references/multi-region.md` (if multi-region), `references/mobile.md` (if building mobile apps)

**Phase 5 (Security):** `references/api-design.md` (validation, idempotency), `references/compliance.md`, `references/advanced-security.md` (zero trust, secrets management)

**Phase 6 (Operations):** `references/operations.md`, `references/observability-scale.md` (distributed tracing, SLOs), `references/chaos-engineering.md` (resilience testing), `references/finops.md` (cost optimization), `references/multi-team.md` (team coordination), `references/mobile.md` (app store monitoring, crash reporting)

**Phase 7 (Upkeep):** `references/code-quality.md` (audit), `references/documentation.md` (doc audit), `references/ui-ux.md` (§9 audit), `references/compliance.md` (compliance audit), `references/api-versioning.md` (dependency audit), `references/finops.md` (cost review)

**Feature Loop:** Same as Phase 3, plus `references/documentation.md` for CHANGELOG/contracts

## Quick Start

**Minimum to read first:**
1. This file (SKILL.md) — you're reading it now
2. `docs/SESSION.md` (in the project) — tells you what phase you're in
3. `references/phase-checklists.md` — copy the checklist for your current phase
4. The "Phase Reading List" above for your current phase

**Optional first reads** (if you want an overview):
- `references/README.md` — one-line summary of each reference file
- `templates/README.md` — what each template is for
- `scripts/README.md` — what each script does

**Then follow the checklist.** Each step tells you what to do and what artifact to produce. When you're done, run `scripts/validate-gate.sh <phase>` to verify.

## Invocation

Read `docs/SESSION.md`. Branch on what you find:

- **No `SESSION.md`** → greenfield. Start at Phase 0.
- **No `SESSION.md` but source files exist** → brownfield. Survey existing
  stack into `docs/ARCHITECTURE.md`, build `CONTEXT.md` from existing domain
  code, run `/graphify .`, skip Phase 0 scaffolding, jump to Phase 1.
- **Phase < 7** → resume. Pick up at the recorded phase.
- **Phase 7 complete** → platform is live. Use the **Feature Loop**.

**Phase checklists are mandatory.** Before starting any phase, copy its
checklist from `references/phase-checklists.md` into `docs/SESSION.md`.
Tick each step AFTER completing it and verifying its artifact. Do NOT
declare a gate passed until every step is ticked or marked N/A with
reason. This is the primary enforcement mechanism — if a step is not
ticked, it was not done.

State tracked across two files (formats: see `references/state-files.md`):

- `docs/SESSION.md` — current phase number, active task, last compaction. Write
  the phase number on every entry.
- `CONTEXT.md` — domain glossary only. A glossary, not a spec. Never put stack
  choices or implementation details here.

Architecture lives in `docs/ARCHITECTURE.md` (stack, deployment target, data
store, auth model, network topology, API/IPC contracts, design system & UX
patterns — with rationale).

Code quality standards live in `references/code-quality.md` — applied during
every REFACTOR step and audited codebase-wide in Phase 7.

Cross-cutting standards referenced by multiple phases:
- `references/api-design.md` — versioning, pagination, error shapes,
  idempotency, rate limiting, async operations
- `references/testing-strategy.md` — test pyramid, test data, flaky tests,
  CI pipeline
- `references/documentation.md` — documentation standards for agents and
  humans; doc-audit checklist
- `references/ui-ux.md` — design tokens, state coverage, component
  architecture, accessibility, anti-patterns, Phase 7 audit checklist
- `references/ui-ux-grill.md` — mandatory UI/UX grill sessions at
  Phase 1, Phase 3, Feature Loop, and Phase 7
- `references/api-versioning.md` — verify every library API call against
  the installed version, not the model's training data
- `references/operations.md` — environments, monitoring, alerting, DR,
  performance, cost management
- `references/compliance.md` — GDPR, data privacy, audit logging, retention
- `references/git-strategy.md` — conventional commits, branching, hooks,
  signing, semver tagging, agent-agnostic guardrails
- `references/ddd.md` — bounded contexts, context mapping, aggregates,
  domain events, strategic design for complex domains
- `references/microservices.md` — service decomposition, communication
  patterns, resilience, data management, deployment
- `references/event-driven.md` — event sourcing, CQRS, sagas, messaging
  patterns, schema evolution
- `references/multi-team.md` — team topologies, ownership models,
  communication patterns, dependency management, governance
- `references/multi-region.md` — deployment topologies, data replication,
  traffic routing, content delivery, database strategies
- `references/platform-engineering.md` — internal developer platform,
  golden paths, self-service, service catalog, environment management
- `references/data-engineering.md` — data pipelines, warehouses, lakes,
  ETL/ELT, analytics infrastructure, data governance
- `references/advanced-security.md` — zero trust, mTLS, secrets management,
  network security, data security, compliance, security testing
- `references/finops.md` — cost visibility, optimization, budget management,
  governance, waste detection
- `references/chaos-engineering.md` — chaos experiments, game days,
  continuous chaos, resilience patterns
- `references/observability-scale.md` — metrics, logs, traces, OpenTelemetry,
  distributed tracing, SLOs, observability-driven development
- `references/mobile.md` — iOS/Android deployment, offline-first, push
  notifications, device constraints, app store optimization

Deliverable layout:

```
CONTEXT.md                         ← domain glossary
docs/
  SESSION.md                       ← phase tracker (template: templates/SESSION.md)
  ARCHITECTURE.md                  ← stack & topology (template: templates/ARCHITECTURE.md)
  ISSUES.md                        ← backlog dependency graph (template: templates/ISSUES.md)
  DEPLOYMENT.md                    ← deployment guide (template: templates/DEPLOYMENT.md)
  CHANGELOG.md                     ← versioned change log
  adr/                             ← architectural decision records
  agents/                          ← machine-readable agent documentation
    contracts/                     ← typed API contracts (OpenAPI, GraphQL, gRPC proto)
    schemas/                       ← data model schemas (JSON Schema, DDL, etc.)
graphify-out/                      ← knowledge graph (structural codebase index)
  graph.json                       ← persistent, queryable graph
  GRAPH_REPORT.md                  ← god nodes, surprises, community cohesion
.scratch/<feature-slug>/issue.md   ← individual work items
```

---

## Phase 0 — Bootstrap

Write `phase: 0` to `docs/SESSION.md`. Run `/setup-matt-pocock-skills`.

Init git. Generate `.gitignore`, `README.md`, `CONTRIBUTING.md`
(template: `templates/CONTRIBUTING.md`), `CHANGELOG.md`
(template: `templates/CHANGELOG.md`). Create `docs/`, `docs/adr/`,
`docs/agents/contracts/`, `docs/agents/schemas/`, `.scratch/`. Interrogate
the stack for linter, formatter, typechecker — adapt, don't assume. Before
installing any dependency, run the latest-stable check from
`references/api-versioning.md` § "Installing" — never install from memory.
Pin exact versions in the manifest with a registry check timestamp comment.
Set up git hooks per `references/git-strategy.md`: agent suggests the
appropriate hook framework for the stack (Husky, lefthook, pre-commit, etc.),
commit message validation (conventional commits), and pre-push hook (blocks
force-push to main, runs full test suite). Create blank `CONTEXT.md`
(template: `templates/CONTEXT.md`) and `docs/ARCHITECTURE.md`
(template: `templates/ARCHITECTURE.md`).

**Gate:** Linter and typechecker exit `0`. README is non-empty (project name
+ one-liner). CHANGELOG.md follows `keepachangelog.com` format. Git hooks
installed (pre-commit, commit-msg, pre-push). Run `scripts/validate-gate.sh 0`
to verify all Phase 0 artifacts.

---

## Phase 1 — Blueprint

Write `phase: 1` to `docs/SESSION.md`.

If no clear product vision: run `/to-prd`. If open architectural unknowns: run
`/decision-mapping` first. Then run `/grill-with-docs` to produce `CONTEXT.md`
and ADRs in `docs/adr/`.

After the session, extract architectural decisions into
`docs/ARCHITECTURE.md`: stack choices, system topology (including
event-driven patterns), API/IPC contracts (apply `references/api-design.md`),
multi-tenancy strategy, internationalization (i18n) posture, compliance
posture (`references/compliance.md`), cost model,
and UI/UX decisions following the heuristics in `references/ui-ux.md`. Every
section of the UI/UX template must be filled — design tokens, component state
coverage, accessibility baseline — before advancing.

Run the full UI/UX grill from `references/ui-ux-grill.md` §1‑§4 against the
entire product vision. This is mandatory. Every unresolved answer becomes an
ADR or an issue. Do not advance until the visual language, IA, mental model,
and state design are sharp enough that the user can answer every question
without hedging.

Present `CONTEXT.md` and `docs/ARCHITECTURE.md` for review.

**Gate:** User writes `Confirm CONTEXT.md` and `Confirm ARCHITECTURE.md`.
ARCHITECTURE.md includes documentation posture: who writes what, where agent
docs live (contracts, schemas, graph), where human docs live (README,
CHANGELOG, ADRs). Run `scripts/validate-gate.sh 1` to verify all Phase 1 artifacts.

Full details: `references/phases.md#phase-1`.

---

## Phase 2 — Backlog

Write `phase: 2` to `docs/SESSION.md`. Run `/to-issues`.

If the project already has source files (e.g., from a prototype or scaffold),
run `/graphify .` to build a knowledge graph. Feed god nodes and surprising
connections from `graphify-out/GRAPH_REPORT.md` into the backlog — issues that
cross community boundaries or modify god nodes get a `risk: high` tag.

Identify the tracer bullet — thinnest vertical slice through every layer. Break
remaining work into vertical-slice issues with input/output definitions,
validation requirements, acceptance criteria, and `Blocked by` field. Save
dependency graph to `docs/ISSUES.md` (template: `templates/ISSUES.md`).

**Gate:** Every issue is a vertical slice, self-contained, agent-ready. Each
issue includes a `Docs:` field listing what documentation it will produce
or update (README section, CHANGELOG entry, agent contract, ADR, etc.).
Run `scripts/validate-gate.sh 2` to verify all Phase 2 artifacts.

---

## Phase 3 — Implement

Write `phase: 3` to `docs/SESSION.md`. Run `/tdd` and `/codebase-design`.

Before starting each issue, run `/graphify . --update` to refresh the knowledge
graph, then `/graphify query "<issue context>" --budget 2000` for a sub-2k-token
structural overview instead of file-by-file scanning. This replaces reading
source files to understand architecture — query the graph, not the raw codebase.

For every issue that touches UI (new screen, new component, changed layout),
run the screen-level grill from `references/ui-ux-grill.md` §6 against the
specific screen or flow. Apply `references/ui-ux-grill.md` §7 for interaction
design. Every question must be answered before code is written. Unresolved
answers block the issue.

For tricky design trade-offs: run `/grill-me`. For uncertain interfaces: run
`/design-an-interface`. For hands-on testing: run `/prototype` then delete it.

For each issue in dependency order: branch → RED → GREEN → REFACTOR (verify
against `references/code-quality.md`, `references/api-design.md`, and
`references/api-versioning.md` — every third-party import must be verified
against the installed version before the first call) →
summarise in `docs/SESSION.md` → squash-merge to `main` with conventional
commit message (`feat(scope): description`, `fix(scope): description`) →
delete branch.

Apply the testing strategy from `references/testing-strategy.md`: unit tests
for business logic, integration for boundaries, e2e for critical journeys.

**Gate:** All backlog issues merged. Full test suite passes. No regressions.
Linter + typechecker exit 0. Every public interface has docstrings or typed
signatures (agent-facing). CHANGELOG updated per issue. API contracts in
`docs/agents/contracts/` match implementation. Run `scripts/validate-gate.sh 3`
to verify all Phase 3 artifacts.

---

## Phase 4 — Productionization

Write `phase: 4` to `docs/SESSION.md`. Build deployment artifacts for the
target declared in `docs/ARCHITECTURE.md`: containers, serverless, static/SPA,
or mobile/desktop. Set up `dev`, `staging`, `production` environments per
`references/operations.md` with preview deployments if supported. Wire up CI
to run linter, typechecker, unit/integration/e2e tests, and accessibility
checks (per `references/ui-ux.md`) — block merges on failure. Implement feature
flags if declared in Phase 1.

**Gate:** Single-command launch succeeds. Liveness signal returns success.
Data survives a restart cycle. CI pipeline passes all stages. Preview
deployments work (if applicable). README has one-command setup + deploy
instructions that succeed on a clean clone. DEPLOYMENT.md matches deployed
artifacts. Run `scripts/validate-gate.sh 4` to verify all Phase 4 artifacts.

---

## Phase 5 — Data Integrity & Security

Write `phase: 5` to `docs/SESSION.md`.

Schema migrations (up/down/up cycle), database indexing for all query
patterns, runtime validation at every boundary, idempotency on mutation
endpoints, rate-limiting on all endpoints, auth enforcement, input fuzzing
across all boundaries, and compliance verification per
`references/compliance.md` (consent, data export/deletion, audit logging,
PII hygiene).

**Gate:** Unauthenticated → 401. Malformed input → 400. Idempotency keys
prevent double-processing. All endpoints rate-limited (429). Zero 500s from
fuzzing. Migration cycle exits `0`. Compliance checklist verified. Data model
documented in `docs/agents/schemas/`. Auth flow documented in
`docs/ARCHITECTURE.md` (or an ADR). Run `scripts/validate-gate.sh 5` to verify all Phase 5 artifacts.

---

## Phase 6 — Observability & Operations

Write `phase: 6` to `docs/SESSION.md`.

Structured logs with correlation IDs, error tracking, RED metrics on every
endpoint, service dashboard, SLOs per critical journey, symptom-based alerts
with runbooks, on-call escalation path. Disaster recovery plan (RTO/RPO,
automated backups, restore test). Load testing at 2x peak, profiling of hot
paths, caching strategy implementation, idempotent deployments. Cost review
against Phase 1 estimate. Finalize `docs/DEPLOYMENT.md` and
`docs/ARCHITECTURE.md`. Write a runbook per alert in `docs/runbooks/`
(template: `templates/runbook.md`).
Full details in `references/operations.md`.

**Gate:** Health check confirms store connectivity. Metrics visible on
dashboard. Load test passes. Shutdown test passes. Backup/restore succeeds.
Alerts configured. Every alert has a runbook in `docs/runbooks/`.
DEPLOYMENT.md is finalized (single-command launch, env setup, operational
checklist all verified). Run `scripts/validate-gate.sh 6` to verify all Phase 6 artifacts.

---

## Phase 7 — Upkeep

Write `phase: 7` to `docs/SESSION.md`. Run `/review` and
`/improve-codebase-architecture`.

Run `/graphify .` (full rebuild) to produce a fresh graph. Use community
cohesion scores from `graphify-out/GRAPH_REPORT.md` to prioritize shallow
modules for the architecture scan — weakest clusters first. Feed surprising
connections into `/qa` as potential bug areas.

Run the documentation audit from `references/documentation.md` § "Doc Audit":
cross-reference every ADR against current implementation, verify agent
contracts match code, verify README setup instructions work on a clean clone,
check that every public module has a graph node. File gaps as issues.

Run the live review grill from `references/ui-ux-grill.md` §8 against the
deployed product: real device, throttled connection, screen reader, 200% zoom,
performance profile. File every failure.

Run the dependency freshness audit from `references/api-versioning.md` §
"Dependency freshness audit": check every direct dependency against its
registry for latest stable. File upgrade issues for packages more than one
major behind. Run `npm audit`, `pip audit`, `cargo audit`, or equivalent —
file any vulnerability with a CVE as `risk: critical`.

Two-axis review + UX audit + dependency audit + performance audit +
compliance audit + i18n audit (if applicable). Run the full code quality
audit from `references/code-quality.md` § "Codebase Audit" (dead code,
duplication, complexity, coupling). The UX audit must run the full checklist
in `references/ui-ux.md` §9 — flag every failure as a finding. Architecture
scan identifies shallow modules — pick the highest-value one and run
`/request-refactor-plan`, then apply it. Run `/qa` for interactive
bug-filing. Run `/handoff` for the session handoff.

**Gate:** Zero critical vulnerabilities. No dependency more than one major
behind latest stable (or upgrade issue filed). Code quality audit findings
for dead code and duplication resolved or filed. Documentation audit passes
(no gaps). Performance audit confirms no regressions. Compliance audit passes.
UX audit checklist passes (all items checked, failures filed as issues).
Every ADR honored or explicitly superseded. Write `status: complete` to
`docs/SESSION.md`. Run `scripts/validate-gate.sh 7` to verify all Phase 7 artifacts.

---

## Feature Loop

Ongoing cycle after the platform is live. Write `feature: <slug>` to
`docs/SESSION.md`. Copy the Feature Loop checklist from
`references/phase-checklists.md` into `docs/SESSION.md` and tick each
step after completion.

1. **Validate context.** Read `CONTEXT.md` and `docs/ARCHITECTURE.md`. Run
   `/graphify . --update`. Query the graph for drift: "Are there nodes or
   edges that contradict current ARCHITECTURE.md claims?" Update if drifted;
   write ADR if needed.
2. **Issue.** Run `/to-issues`. Gate: vertical slices, agent-ready.
3. **Grill.** Run `/grill-me` against each issue's design before coding.
   For UI issues, also run `references/ui-ux-grill.md` §6‑§7 — every
   screen-level and interaction question must be answered.
   Gate: every issue must pass a grill session. If the grill exposes
   unresolved design questions, resolve them here — do not carry them
   into implementation.
4. **Implement.** Run `/tdd` and `/codebase-design`. Before each issue,
   `/graphify query "<issue context>" --budget 2000`. Run `/prototype` if
   uncertain. Apply `references/testing-strategy.md` for test levels,
   `references/api-design.md` for endpoint standards, and
   `references/api-versioning.md` — verify every third-party API against
   the installed version. Apply
   `references/documentation.md` — every new public interface gets a
   docstring/typed signature; changed APIs update `docs/agents/contracts/`;
   CHANGELOG gets an entry. After REFACTOR, verify against
   `references/code-quality.md`.
    Gate: all new tests pass, no regressions. Public interfaces documented.
    Linter + typechecker exit 0.
5. **Review.** Run `/review`. Verify documentation coverage from
    `references/documentation.md` — CHANGELOG entry, agent contracts updated,
    README updated if public-facing.
    Gate: no standards violations, no spec drift, no doc gaps.

Update `docs/SESSION.md` after each step. If the domain model changed, update
`CONTEXT.md` inline. After the feature loop completes, run `/graphify .` to
fully rebuild the graph so future sessions and features start with an
up-to-date structural map.

Full details: `references/feature-loop.md`.

---

## Directives

See `references/directives.md` for the full text. Summary:

1. **Baseline.** Read SESSION.md, CONTEXT.md, ARCHITECTURE.md. Update the
   knowledge graph. Query graph for structural understanding before reading
   raw files.
2. **Gating.** Do not advance without user verification or gate passing.
3. **Errors.** Narrow → retry once → rollback + log blocker → yield.
4. **Secrets.** Never track credentials. Verify `.gitignore` before commits.
5. **Agnosticism with suggestions.** No stack assumptions. Every action
   driven by ARCHITECTURE.md. But when the user is choosing tools, suggest
   2-3 concrete options with trade-offs — verify each is current before
   presenting. Never suggest from memory.
6. **Documentation.** Every public interface change updates agent docs
   (contracts, graph, schemas) and human docs (README, CHANGELOG, ADRs).
   Neither is optional.
7. **Write against installed.** Verify every library API call against the
    version installed in the project — never call from memory. When installing
    new deps, check the registry for latest stable — never install from
    memory. See `references/api-versioning.md`.
8. **Prerequisites.** Verify required delegated skills are available before
    entering a phase. See `references/skill-prerequisites.md`.
9. **Circuit breaker.** Compact every 40 tool calls or 5 issues. Yield if
    20+ open issues or 2h without progress. Never retry the same fix 4 times.
    See `references/directives.md` §9 for brownfield entry rules.
10. **Checklist compliance.** Copy the phase checklist from
    `references/phase-checklists.md` into `docs/SESSION.md` before starting
    the phase. Tick each step ONLY after its artifact exists and is
    verifiable. Do NOT declare a gate passed until every step is ticked or
    marked N/A with reason. This is non-negotiable — the checklist is the
    proof of work. See `references/directives.md` §10.
11. **Anti-hallucination & verification.** Never fabricate tools, patterns,
    metrics, or technical claims. Verify all suggestions against current
    sources. When uncertain, say so. If caught fabricating, correct immediately,
    log the error, and yield to the user. See `references/directives.md` §11.
12. **Gate validation failures.** When `validate-gate.sh` fails, stop immediately.
    Fix the issues and re-run. If still failing after 2 attempts, log the blocker
    and yield to the user. Never proceed to the next phase with a failed gate.
    See `references/directives.md` §12.
13. **Contradictory & ambiguous input.** When the user provides contradictory
    or ambiguous requirements, identify the issue, ask for clarification, and
    do not proceed until resolved. Never assume what the user meant. Document
    all clarifications. See `references/directives.md` §13.
14. **User confirmation requirements.** Beyond phase gates, certain decisions
    require explicit user confirmation: stack choices, architecture decisions,
    third-party services, security approach, deployment strategy, cost implications,
    and breaking changes. Present options with trade-offs, make a recommendation,
    and wait for confirmation before implementing. See `references/directives.md` §14.
