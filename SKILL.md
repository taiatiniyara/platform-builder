---
name: platform-builder
description: Build whole platforms from loose idea to shipped code. Orchestrates grilling, wayfinding, ticketing, implementation, and review. Use when user wants to build a platform, a large system, or end-to-end product from scratch.
---

# Platform Builder

Build whole platforms by orchestrating five phases. Each phase uses an existing skill — this skill sequences them.

## Phases

```
┌─────────────────┐     ┌─────────────┐     ┌────────────┐     ┌────────────┐     ┌─────────┐
│  1. GRILL+DOCS  │ ──▶ │ 2. WAYFIND  │ ──▶ │ 3. TICKETS │ ──▶ │ 4. IMPLEMENT│ ──▶ │ 5. REVIEW│
│  (clarify idea) │     │ (chart path)│     │(break down)│     │  (build it) │     │(verify it)│
└─────────────────┘     └─────────────┘     └────────────┘     └────────────┘     └─────────┘
```

## Phase 1: Grill + Document

**Skill:** `/grill-with-docs`

Run a relentless interview. Capture requirements in `docs/`:
- Domain glossary → `CONTEXT.md`
- Hard-to-reverse decisions → `docs/adr/`
- Session tracker → `docs/SESSION.md` (copy from `scripts/SESSION.md.template`, agent fills in)
- UX, security, compliance, performance, observability, monetization, analytics, notifications, search, real-time, background jobs, rollout, incident management, cost management, DX

**Exit criteria:** All requirement docs exist. User confirmed shared understanding.

## Phase 2: Wayfind

**Skill:** `/wayfinder`

Chart the path as investigation tickets on the issue tracker.

Create research/prototype tickets for each domain (UX, security, performance, etc.).

**Exit criteria:** Map exists, all tickets closed, prototypes created for critical architecture.

## Phase 3: To Tickets

**Skill:** `/to-tickets`

Break decisions into implementation tickets (vertical slices).

Before coding: verify tooling (lint, format, typecheck, security scanning, test framework, CI/CD, observability, design system). Create setup tickets if not.

**Standards enforcement tooling (MANDATORY):**
- Copy `scripts/check-standards.sh` into the target project's `scripts/` directory
- Wire it into the pre-commit hook so it runs on every commit
- The script reads `*-STANDARDS.md` files and exits with non-zero if any checklist item applicable to the current changes is not met
- This ensures no commit can land without passing the standards gate

Every ticket must include acceptance criteria from relevant standards files (see `*-STANDARDS.md` files).

**Exit criteria:** Tickets published with all criteria. Blocking edges wired.

## Phase 4: Implement

**Skill:** `/implement`

For each ticket:
1. Claim ticket
2. Prefactor if needed
3. Use `/tdd` (tests first)
4. Minimal implementation
5. Self-review (simplest solution? dead code? clearer?)
6. **Standards compliance (MANDATORY — do not skip):**
   a. Determine which standards files apply by reading each `*-STANDARDS.md` "Applies when" section
   b. For every matching standard, go through its Checklist line by line and verify each item
   c. Run `scripts/check-standards.sh` to mechanically cross-check
   d. If any checklist item fails, fix before proceeding
7. Pre-commit checklist:
   a. `npm run typecheck` (or equivalent) — must pass
   b. `npm run lint` (or equivalent) — must pass
   c. `npm test` (or equivalent) — must pass
   d. Security scan (gitleaks, npm audit, etc.) — must pass
   e. No dead code, no secrets, no console.log, no TODO without ticket ref
8. Commit and close ticket

**Enforcement:** The pre-commit hook (set up in Phase 3) runs typecheck + lint + tests + security scan automatically.
The `scripts/check-standards.sh` script must return exit code 0 before commit.
No ticket can be marked done without all checklist items verified.

**Exit criteria:** All tickets done. Tests pass. All standards checks passed.

## Phase 5: Review

**Skill:** `/review`

Multi-axis review (parallel sub-agents):
- **Standards** — coding standards compliance
- **Spec** — matches originating issues
- **Quality axes** — check all relevant `*-STANDARDS.md` files

**Exit criteria:** Review report delivered. Issues addressed.

## Resuming After Closing

Just invoke the skill. The agent reads `docs/SESSION.md` first (fastest path), then falls back to filesystem + issue tracker detection:

1. Read `docs/SESSION.md` for current phase, active tickets, and context
2. Verify against filesystem (docs exist?) and issue tracker (tickets state?)
3. Determine phase and continue

| Detected state | Agent does |
|----------------|------------|
| No artifacts | Starts Phase 1 |
| Docs exist, no map | Starts Phase 2 |
| Map exists, open tickets | Continues Phase 2 |
| Map closed, no impl tickets | Starts Phase 3 |
| Impl tickets exist, some open | Continues Phase 4 |
| All tickets closed | Starts Phase 5 |
| All tickets closed + review done | **Feature mode** (see below) |

## Adding Features After Completion

When the platform is shipped and you describe a new feature, the agent detects this (all tickets closed + review done + user wants something new) and restarts the loop with a **lighter touch**:

1. **Mini-grill** — grill the new feature against existing docs. Update `CONTEXT.md` if the feature introduces new domain terms. Write an ADR only if it introduces a new hard-to-reverse decision. Update `docs/SESSION.md` phase to `feature`.
2. **Mini-wayfind** — create investigation tickets if the feature touches uncharted architecture. Otherwise skip.
3. **To-tickets** — break the feature into vertical-slice tickets. Reuse existing tooling and standards. Each ticket inherits acceptance criteria from the relevant `*-STANDARDS.md` files.
4. **Implement** — same Phase 4 flow: claim, prefactor, TDD, implement, standards check, pre-commit, close. Update SESSION.md after each ticket.
5. **Review** — review the diff against standards and the feature spec. Update SESSION.md status to `complete`.

Tooling persists from the original build. No setup needed.

## Phase Transition Gates

Before each transition, verify all criteria are met and get user confirmation:

**Phase 1 → 2:**
- [ ] `CONTEXT.md` exists (≥5 terms)
- [ ] ADRs exist (if decisions made)
- [ ] All requirement docs exist in `docs/`
- [ ] User confirmed shared understanding

**Phase 2 → 3:**
- [ ] Wayfinder map exists with `wayfinder:map` label
- [ ] All wayfinder tickets closed
- [ ] Prototypes created for critical architecture

**Phase 3 → 4:**
- [ ] Implementation tickets published with all acceptance criteria
- [ ] Tooling configured (lint, format, typecheck, security scanning, test framework, CI/CD, observability)
- [ ] Design system in place
- [ ] User approved breakdown

**Phase 4 → 5:**
- [ ] All tickets closed
- [ ] Tests pass (typecheck, lint, test suite, security tools)
- [ ] All standards checks passed (`scripts/check-standards.sh` returns 0)
- [ ] Security tooling passes (no secrets, no vulnerable dependencies)
- [ ] Observability configured (logs, metrics, traces)
- [ ] Documentation updated
- [ ] `docs/SESSION.md` updated (phase, status, decisions)

## SESSION.md

A living file at `docs/SESSION.md` tracks progress across invocations. The agent reads it first on resume, writes to it at the end of each session, and updates it at every phase transition.

### Format

```markdown
# Session Tracking

Phase: 3 (To Tickets)
Status: in_progress
Last active: 2026-07-10

## Active work
- What was being done when the session ended
- Which ticket is in progress (if any)
- What the next step is

## Recent decisions
- Decision made + why (one line each)
- Links to relevant ADRs

## Standards
- Pre-commit hook: active | not configured
- Last check: passed | failed (date)
```

### Agent rules for SESSION.md

1. **Read first** on any invoke — it's the single source of truth for "where are we"
2. **Update on every write** — after each ticket closed, each phase transition, each session end
3. **Keep concise** — one-line decisions, one-line active work, no essays
4. **Phase field** is canonical: `1`, `2`, `3`, `4`, `5`, or `feature`
5. **Status**: `in_progress`, `blocked`, `complete`

## Key Principles

1. **Never resolve more than one ticket per session** (wayfinder rule)
2. **Clear context between tickets** (implement rule)
3. **Docs before code** — CONTEXT.md and ADRs precede implementation
4. **Decisions before tickets** — wayfinder resolves the path before to-tickets breaks it down
5. **Vertical slices** — each ticket cuts through all layers
6. **Make the change easy, then make the easy change** — prefactor before implementing
7. **YAGNI** — no speculative features. Build only what the ticket asks for.
8. **Tooling enforces quality** — lint, format, typecheck, security scan on every commit

## Standards Enforcement Architecture

Standards are enforced at **four** independent layers — no single layer must be trusted:

| Layer | Mechanism | When | Can agent skip? |
|-------|-----------|------|-----------------|
| 1. Pre-commit hook | `scripts/check-standards.sh` wired into `.husky/pre-commit` | Every `git commit` | **No** — mechanical gate |
| 2. CI pipeline | Same script + typecheck + lint + test + security scan | Every push/PR | **No** — CI blocks merge |
| 3. Implement checklist | Agent verifies every relevant standards checklist item | Per ticket, before commit | Could, but pre-commit catches it |
| 4. Review sub-agents | Parallel sub-agents check all `*-STANDARDS.md` files | Phase 5, after all tickets | **No** — independent agents verify |

The pre-commit hook is the primary enforcement mechanism. If the agent forgets to check standards manually, the hook blocks the commit. If hooks are bypassed, CI catches it. If CI is bypassed, review catches it.

### Setup (Phase 3)

```bash
cp ~/.config/opencode/skills/platform-builder/scripts/check-standards.sh scripts/
cp ~/.config/opencode/skills/platform-builder/scripts/pre-commit-standards-hook.sh .husky/
```

Then wire into `.husky/pre-commit`:

```bash
bash .husky/pre-commit-standards-hook.sh || exit 1
```

## Standards Files

See `*-STANDARDS.md` files for detailed standards. Each file includes:
- **Applies when** — when to apply this standard
- **Rules** — what to do
- **Checklist** — verifiable items
- **Anti-patterns** — what to avoid
