---
name: platform-builder
description:
  7-phase gated lifecycle for greenfield builds. Compressed feature-loop for
  adding to finished projects. Use when the user wants to build a platform,
  scaffold a SaaS, start a new project, or add features to an existing one.
  Delegates to /setup-matt-pocock-skills, /grill-with-docs, /to-issues, /tdd,
  /codebase-design, /prototype, /review, and /handoff at each phase.
license: MIT
compatibility: opencode
metadata:
  workflow: lifecycle-orchestrator
  audience: solo-founders
---

# Platform Lifecycle Orchestrator

> **What this is:** A step-by-step recipe for turning an idea into a working,
> live platform. It prevents the common mistake of jumping into code before the
> plan is solid. Each phase must pass a quality check before moving on.

## Invocation

> **What this section does:** Decides whether we're starting fresh or picking up
> where we left off, by checking a tiny status file called `SESSION.md`.

Read `docs/SESSION.md`. Branch on what you find:

- **No `SESSION.md`** → greenfield. Start at Phase 0.
- **Phase < 7** → resume. Pick up at the recorded phase.
- **Phase 7 complete** → the platform is live. Use the **Feature Loop**.

State tracked across two files:

- `docs/SESSION.md` — current phase number, active task, last compaction.
  Write the phase number on every entry.
- `CONTEXT.md` — domain glossary only (terms, aliases, relationships, example
  dialogue). A glossary, not a spec — per `/domain-modeling`. Never put stack
  choices or implementation details here.

Architecture lives in `docs/ARCHITECTURE.md` (stack, deployment target, data
store, auth model, network topology, API/IPC contracts — with rationale).

Deliverables layout:

```
CONTEXT.md                         ← domain glossary
docs/
  SESSION.md                       ← phase tracker
  ARCHITECTURE.md                  ← stack & topology decisions (Phase 1)
  ISSUES.md                        ← backlog dependency graph (Phase 2)
  DEPLOYMENT.md                    ← deployment guide (Phase 6)
  adr/                             ← architectural decision records
.scratch/<feature-slug>/issue.md   ← individual work items
```

---

## Phase 0 — Bootstrap

> **What this phase does:** Sets up the project's skeleton — version control,
> folder structure, and automated quality checks — so every future step has a
> clean foundation.

Write `phase: 0` to `docs/SESSION.md`. Run `/setup-matt-pocock-skills`.

Init git. Generate `.gitignore`, `README.md`, `CONTRIBUTING.md`. Create
`docs/`, `docs/adr/`, `.scratch/`. Set up pre-commit hooks. Interrogate the
stack for linter, formatter, typechecker — adapt, don't assume. Create blank
`CONTEXT.md` and `docs/ARCHITECTURE.md`.

**Gate:** Linter and typechecker exit `0`. If the stack supports a test runner
without source files, run it — otherwise skip.

---

## Phase 1 — Blueprint

> **What this phase does:** Interviews you relentlessly to nail down exactly what
> you're building, what words you'll use for things, and what technical pieces
> you'll need — before writing a single line of code.

Write `phase: 1` to `docs/SESSION.md`. Run `/grill-with-docs`.

This produces `CONTEXT.md` (domain glossary) and any ADRs in `docs/adr/`.

After the session, extract the architectural decisions that emerged and record
them in `docs/ARCHITECTURE.md`:

- Stack choices — language, framework, data store, auth provider, hosting
  target. Each with rationale.
- System topology — what talks to what, across which boundaries.
- API or IPC contracts — route shapes and payloads (web), module interfaces,
  event contracts, or CLI signatures (everything else).

Present `CONTEXT.md` and `docs/ARCHITECTURE.md` for review.

**Gate:** User writes `Confirm CONTEXT.md` and `Confirm ARCHITECTURE.md`.

---

## Phase 2 — Backlog

> **What this phase does:** Turns the blueprint into a prioritized to-do list of
> small, self-contained pieces — each one a complete slice of the product, not a
> technical layer.

Write `phase: 2` to `docs/SESSION.md`. Run `/to-issues`.

Map user stories. Identify the tracer bullet — the thinnest vertical slice
through every layer.

Break remaining work into vertical-slice issues with: input/output definitions,
validation requirements, acceptance criteria, `Blocked by` field. Save the
dependency graph to `docs/ISSUES.md`. Publish each issue to
`.scratch/<feature-slug>/issue.md` (or the issue tracker if configured).

**Gate:** Every issue is a vertical slice, self-contained, agent-ready.

---

## Phase 3 — Implement

> **What this phase does:** Builds the to-do list one item at a time. For each
> piece: write a test that fails, write the minimum code to pass it, then clean
> up. Merge only when everything works.

Write `phase: 3` to `docs/SESSION.md`. Run `/tdd` and `/codebase-design`. If
an interface shape is uncertain, run `/prototype` first — answer the question,
then delete the prototype.

For each issue in dependency order:

1. Branch `issue-<n>-<slug>` from `main`.
2. RED → GREEN → REFACTOR. One test at a time.
3. Summarise trajectory into `docs/SESSION.md`.
4. Squash-merge to `main` on 100% pass. Delete branch.

**Gate:** All backlog issues merged. Full test suite passes. No regressions.

---

## Phase 4 — Productionization

> **What this phase does:** Packages the app so it can run on the internet, an
> app store, or whatever destination you chose in Phase 1. Verifies it starts,
> stays healthy, and keeps its data across restarts.

Write `phase: 4` to `docs/SESSION.md`. Build deployment artifacts for the
target declared in `docs/ARCHITECTURE.md`: containers (Dockerfile, compose,
volumes), serverless (provider config, env bindings), static/SPA (CDN, cache,
routing), mobile/desktop (pipeline, signing, store metadata), or equivalent.

**Gate:** Single-command launch succeeds for the declared target. Liveness
signal returns success. Data survives a restart cycle.

---

## Phase 5 — Data Integrity & Security

> **What this phase does:** Makes sure only the right people can access the right
> things, bad data gets rejected at the door, and the database can evolve
> without breaking anything.

Write `phase: 5` to `docs/SESSION.md`.

- Schema evolution: reversible, lossless migrations appropriate to the store
  declared in `docs/ARCHITECTURE.md`. Run `migrate up`, `migrate down`, `migrate
  up` — all three must succeed.
- Runtime validation: strict at every boundary (API, CLI, IPC, events).
- Auth: enforce at the boundary — reject unauthenticated before business logic.

**Gate:** Unauthenticated request → 401 (or equivalent). Malformed input → 400
(or equivalent) with structured error body. Migration up/down/up cycle exits
`0`.

---

## Phase 6 — Observability & Operations

> **What this phase does:** Wires up monitoring so you can see if the app is
> healthy, what's happening inside it, and detect problems before users do.
> Writes the deployment and architecture guides.

Write `phase: 6` to `docs/SESSION.md`.

- Telemetry: structured logs with correlation IDs. Error tracking wired up.
- Health signals: a health check returning the store's connectivity status (or
  equivalent for non-service targets).
- Lifecycle: test shutdown — confirm the process drains in-flight work and
  exits cleanly with no leaked resources (or equivalent).
- Docs: finalize `docs/DEPLOYMENT.md` and `docs/ARCHITECTURE.md`.

**Gate:** Health check returns valid status with store connectivity confirmed (or
equivalent). Shutdown test passes — zero leaked resources. Backup/restore script
runs successfully.

---

## Phase 7 — Upkeep

> **What this phase does:** The final audit. Checks that the code matches the
> plan, scans for security holes, and hands off a clean summary so the next
> session knows exactly where things stand.

Write `phase: 7` to `docs/SESSION.md`. Run `/review`.

Two-axis review against `CONTEXT.md` and `docs/ARCHITECTURE.md`. Run ecosystem
dependency audit. Flag structural drift — code that contradicts the blueprint.
Fix or issue a superseding ADR.

Run `/handoff` to produce the session handoff document.

**Gate:** Zero critical vulnerabilities. Every ADR honored or explicitly
superseded. Write `status: complete` to `docs/SESSION.md`.

---

## Feature Loop

> **What this section does:** The ongoing cycle for adding features after the
> platform is live — a shorter version of the full lifecycle that skips the
> one-time setup phases.

For adding features to a completed project. Write `feature: <slug>` to
`docs/SESSION.md`.

1. **Validate context.** Read `CONTEXT.md` and `docs/ARCHITECTURE.md`. If the
   stack or domain model has drifted, update the relevant file and write an ADR.
2. **Issue.** Run `/to-issues`. Gate: issues are vertical slices, agent-ready.
3. **Implement.** Run `/tdd` and `/codebase-design`. If interface shape is
   uncertain, run `/prototype`. Gate: all new tests pass, no regressions.
4. **Review.** Run `/review`. Gate: no standards violations, no spec drift.

Update `docs/SESSION.md` after each step. If the feature changes the domain
model, update `CONTEXT.md` inline.

---

## Directives

> **What these are:** Standing rules the agent follows in every phase — no
> skipping quality checks, no tracking passwords, no hardcoding assumptions
> about your tech choices.

1. **Baseline.** On every entry, read `docs/SESSION.md`, `CONTEXT.md`, and
   `docs/ARCHITECTURE.md`. State phase, last action, next step.
2. **Gating.** Do not advance without user verification or the gate passing.
3. **Errors.** Narrow and retry once. If still failing, if in a git repo roll
   back to the last stable commit; log the block to `docs/SESSION.md`; yield
   with a remediation prompt.
4. **Secrets.** Never track credentials. Verify `.gitignore` before every commit.
5. **Agnosticism.** No assumptions about Docker, databases, HTTP, Unix, or any
   stack. Every action driven by `docs/ARCHITECTURE.md`. If a needed declaration
   is missing, halt and ask.
