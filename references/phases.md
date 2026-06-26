# Phase Details

Expanded breakdown of each phase with gate criteria and deliverables.

---

## Phase 0 — Bootstrap

Write `phase: 0` to `docs/SESSION.md`. Run `/setup-matt-pocock-skills`.

Init git. Generate `.gitignore`, `README.md`, `CONTRIBUTING.md`. Create
`docs/`, `docs/adr/`, `.scratch/`. Interrogate the stack for linter,
formatter, typechecker — adapt, don't assume. Run `/setup-pre-commit` to
wire up automated quality checks on every commit. Create blank
`CONTEXT.md` and `docs/ARCHITECTURE.md`.

**Gate:** Linter and typechecker exit `0`. If the stack supports a test
runner without source files, run it — otherwise skip.

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
- **API or IPC contracts** — route shapes and payloads (web), module
  interfaces, event contracts, or CLI signatures (everything else).
- **UI/UX** — design tokens (colors, spacing, typography, radii, shadows),
  component catalog with state coverage per component, layout strategy,
  navigation pattern, form UX, feedback pattern, accessibility baseline
  (WCAG 2.1 AA minimum). Every section of the template must be filled
  before advancing. Apply the heuristics in `references/ui-ux.md`.

Present `CONTEXT.md` and `docs/ARCHITECTURE.md` for review.

**Gate:** User writes `Confirm CONTEXT.md` and `Confirm ARCHITECTURE.md`.

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

---

## Phase 3 — Implement

Write `phase: 3` to `docs/SESSION.md`. Run `/tdd` and `/codebase-design`.

Before implementing an issue with tricky design trade-offs, run `/grill-me`
to stress-test the decisions — no doc output needed since Phase 1 already
wrote the blueprint.

If an interface shape is uncertain, run `/design-an-interface` to generate
multiple alternatives and pick the deepest one. If a specific alternative
needs hands-on testing, run `/prototype` — answer the question, then delete
the prototype.

For each issue in dependency order:
1. Branch `issue-<n>-<slug>` from `main`.
2. RED → GREEN → REFACTOR. One test at a time.
3. Summarise trajectory into `docs/SESSION.md`.
4. Squash-merge to `main` on 100% pass. Delete branch.

**Gate:** All backlog issues merged. Full test suite passes. No regressions.

---

## Phase 4 — Productionization

Write `phase: 4` to `docs/SESSION.md`. Build deployment artifacts for the
target declared in `docs/ARCHITECTURE.md`: containers (Dockerfile, compose,
volumes), serverless (provider config, env bindings), static/SPA (CDN,
cache, routing), mobile/desktop (pipeline, signing, store metadata), or
equivalent.

Wire up CI to run the full test suite on every push and block merges on
failure. For GitHub: a minimal Actions workflow. For other forges: the
equivalent.

**Gate:** Single-command launch succeeds for the declared target. Liveness
signal returns success. Data survives a restart cycle.

---

## Phase 5 — Data Integrity & Security

Write `phase: 5` to `docs/SESSION.md`.

- **Schema evolution:** reversible, lossless migrations appropriate to the
  store declared in `docs/ARCHITECTURE.md`. Run `migrate up`, `migrate
  down`, `migrate up` — all three must succeed.
- **Runtime validation:** strict at every boundary (API, CLI, IPC, events).
- **Auth:** enforce at the boundary — reject unauthenticated before
  business logic. Rate-limit auth endpoints against brute-force. Enable
  CSRF protection for cookie-based sessions. Verify tokens expire and renew
  correctly.
- **Input fuzzing:** send malformed payloads to every boundary. Confirm all
  responses are 4xx (not 5xx). No crashes, no leaked stack traces.

**Gate:** Unauthenticated request → 401 (or equivalent). Malformed input →
400 (or equivalent) with structured error body. Auth endpoints rate-limited
(429 on burst). Fuzz input returns zero 500s. Migration up/down/up cycle
exits `0`.

---

## Phase 6 — Observability & Operations

Write `phase: 6` to `docs/SESSION.md`.

- **Telemetry:** structured logs with correlation IDs. Error tracking wired
  up.
- **Health signals:** a health check returning the store's connectivity
  status (or equivalent for non-service targets).
- **Lifecycle:** test shutdown — confirm the process drains in-flight work
  and exits cleanly with no leaked resources (or equivalent).
- **Docs:** finalize `docs/DEPLOYMENT.md` and `docs/ARCHITECTURE.md`.

**Gate:** Health check returns valid status with store connectivity
confirmed (or equivalent). Shutdown test passes — zero leaked resources.
Backup/restore script runs successfully.

---

## Phase 7 — Upkeep

Write `phase: 7` to `docs/SESSION.md`. Run `/review` and
`/improve-codebase-architecture`.

Two-axis review against `CONTEXT.md` and `docs/ARCHITECTURE.md`.

**UX audit:** Run the full checklist in `references/ui-ux.md` §7. Verify
every item against the running application. Flag every failure as a finding.
Common failures: missing empty states, raw error messages visible to users,
low-contrast text, missing focus rings, layout shift on load, inconsistent
spacing, placeholder-as-label pattern, missing alt text, non-semantic
headings. File each failure as a separate QA issue.

Run ecosystem dependency audit. Flag structural drift — code that
contradicts the blueprint. Fix or issue a superseding ADR.

The architecture scan identifies shallow modules — places where a large,
complex interface sits in front of little behavior. Pick the highest-value
opportunity and run `/request-refactor-plan` to turn it into a sequence of
safe, incremental commits. Apply the plan.

Run `/qa` for an interactive bug-filing session — surface any issues found
during review as trackable items.

Run `/handoff` to produce the session handoff document.

**Gate:** Zero critical vulnerabilities. Every ADR honored or explicitly
superseded. Write `status: complete` to `docs/SESSION.md`.
