---
name: platform-builder
description:
  7-phase gated lifecycle for greenfield builds. Compressed feature-loop for
  adding to finished projects. Use when the user wants to build a platform,
  scaffold a SaaS, start a new project, or add features to an existing one.
  Delegates to specialist skills at each phase — see references/delegated-skills.md.
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
---

# Platform Lifecycle Orchestrator

Step-by-step recipe for turning an idea into a working, live platform. Each
phase must pass a quality gate before moving on.

## Invocation

Read `docs/SESSION.md`. Branch on what you find:

- **No `SESSION.md`** → greenfield. Start at Phase 0.
- **Phase < 7** → resume. Pick up at the recorded phase.
- **Phase 7 complete** → platform is live. Use the **Feature Loop**.

State tracked across two files (formats: see `references/state-files.md`):

- `docs/SESSION.md` — current phase number, active task, last compaction.
  Write the phase number on every entry.
- `CONTEXT.md` — domain glossary only. A glossary, not a spec. Never put
  stack choices or implementation details here.

Architecture lives in `docs/ARCHITECTURE.md` (stack, deployment target, data
store, auth model, network topology, API/IPC contracts, design system & UX
patterns — with rationale).

Deliverable layout:

```
CONTEXT.md                         ← domain glossary
docs/
  SESSION.md                       ← phase tracker (template: templates/SESSION.md)
  ARCHITECTURE.md                  ← stack & topology (template: templates/ARCHITECTURE.md)
  ISSUES.md                        ← backlog dependency graph (template: templates/ISSUES.md)
  DEPLOYMENT.md                    ← deployment guide (template: templates/DEPLOYMENT.md)
  adr/                             ← architectural decision records
.scratch/<feature-slug>/issue.md   ← individual work items
```

---

## Phase 0 — Bootstrap

Write `phase: 0` to `docs/SESSION.md`. Run `/setup-matt-pocock-skills`.

Init git. Generate `.gitignore`, `README.md`, `CONTRIBUTING.md`. Create
`docs/`, `docs/adr/`, `.scratch/`. Interrogate the stack for linter,
formatter, typechecker — adapt, don't assume. Run `/setup-pre-commit`.
Create blank `CONTEXT.md` (template: `templates/CONTEXT.md`) and
`docs/ARCHITECTURE.md` (template: `templates/ARCHITECTURE.md`).

**Gate:** Linter and typechecker exit `0`. Run `scripts/validate-gate.sh 0`
if the stack supports it.

---

## Phase 1 — Blueprint

Write `phase: 1` to `docs/SESSION.md`.

If no clear product vision: run `/to-prd`. If open architectural unknowns: run
`/decision-mapping` first. Then run `/grill-with-docs` to produce
`CONTEXT.md` and ADRs in `docs/adr/`.

After the session, extract architectural decisions into
`docs/ARCHITECTURE.md`: stack choices, system topology, API/IPC contracts,
and UI/UX decisions following the heuristics in `references/ui-ux.md`. Every
section of the UI/UX template must be filled — design tokens, component state
coverage, accessibility baseline — before advancing.

Present `CONTEXT.md` and `docs/ARCHITECTURE.md` for review.

**Gate:** User writes `Confirm CONTEXT.md` and `Confirm ARCHITECTURE.md`.

Full details: `references/phases.md#phase-1`.

---

## Phase 2 — Backlog

Write `phase: 2` to `docs/SESSION.md`. Run `/to-issues`.

Identify the tracer bullet — thinnest vertical slice through every layer.
Break remaining work into vertical-slice issues with input/output
definitions, validation requirements, acceptance criteria, and `Blocked by`
field. Save dependency graph to `docs/ISSUES.md` (template: `templates/ISSUES.md`).

**Gate:** Every issue is a vertical slice, self-contained, agent-ready.

---

## Phase 3 — Implement

Write `phase: 3` to `docs/SESSION.md`. Run `/tdd` and `/codebase-design`.

For tricky design trade-offs: run `/grill-me`. For uncertain interfaces: run
`/design-an-interface`. For hands-on testing: run `/prototype` then delete it.

For each issue in dependency order: branch → RED → GREEN → REFACTOR →
summarise in `docs/SESSION.md` → squash-merge → delete branch.

**Gate:** All backlog issues merged. Full test suite passes. No regressions.
Run `scripts/validate-gate.sh 3` if the stack supports it.

---

## Phase 4 — Productionization

Write `phase: 4` to `docs/SESSION.md`. Build deployment artifacts for the
target declared in `docs/ARCHITECTURE.md`: containers, serverless, static/SPA,
or mobile/desktop. Wire up CI to run tests on push and block merges on failure.

**Gate:** Single-command launch succeeds. Liveness signal returns success.
Data survives a restart cycle.

---

## Phase 5 — Data Integrity & Security

Write `phase: 5` to `docs/SESSION.md`.

Schema migrations (up/down/up cycle), runtime validation at every boundary,
auth enforcement with rate-limiting, and input fuzzing across all boundaries.

**Gate:** Unauthenticated → 401. Malformed input → 400. Auth endpoints
rate-limited (429). Zero 500s from fuzzing. Migration cycle exits `0`.

---

## Phase 6 — Observability & Operations

Write `phase: 6` to `docs/SESSION.md`.

Structured logs with correlation IDs, error tracking, health check with store
connectivity, shutdown test (drain + clean exit), backup/restore script.
Finalize `docs/DEPLOYMENT.md` (template: `templates/DEPLOYMENT.md`) and
`docs/ARCHITECTURE.md`.

**Gate:** Health check confirms store connectivity. Shutdown test passes.
Backup/restore succeeds.

---

## Phase 7 — Upkeep

Write `phase: 7` to `docs/SESSION.md`. Run `/review` and
`/improve-codebase-architecture`.

Two-axis review + UX audit + dependency audit. The UX audit must run the full
checklist in `references/ui-ux.md` §7 — flag every failure as a finding.
Architecture scan identifies shallow modules — pick the highest-value one and
run `/request-refactor-plan`, then apply it. Run `/qa` for interactive
bug-filing. Run `/handoff` for the session handoff.

**Gate:** Zero critical vulnerabilities. UX audit checklist passes (all items
checked, failures filed as issues). Every ADR honored or explicitly
superseded. Write `status: complete` to `docs/SESSION.md`.

---

## Feature Loop

Ongoing cycle after the platform is live. Write `feature: <slug>` to
`docs/SESSION.md`.

1. **Validate context.** Read `CONTEXT.md` and `docs/ARCHITECTURE.md`. Update
   if drifted; write ADR if needed.
2. **Issue.** Run `/to-issues`. Gate: vertical slices, agent-ready.
3. **Implement.** Run `/tdd` and `/codebase-design`. Grill/prototype if
   uncertain. Gate: all new tests pass, no regressions.
4. **Review.** Run `/review`. Gate: no standards violations, no spec drift.

Update `docs/SESSION.md` after each step. If the domain model changed, update
`CONTEXT.md` inline.

Full details: `references/feature-loop.md`.

---

## Directives

See `references/directives.md` for the full text. Summary:

1. **Baseline.** Read SESSION.md, CONTEXT.md, ARCHITECTURE.md on every entry.
2. **Gating.** Do not advance without user verification or gate passing.
3. **Errors.** Narrow → retry once → rollback + log blocker → yield.
4. **Secrets.** Never track credentials. Verify `.gitignore` before commits.
5. **Agnosticism.** No stack assumptions. Every action driven by ARCHITECTURE.md.
