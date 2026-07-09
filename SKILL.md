---
name: platform-builder
description: Build whole platforms from loose idea to shipped code. Orchestrates grilling, wayfinding, ticketing, implementation, and review.
---

# Platform Builder

Five phases. Each delegates to an existing skill and gates on the verify protocol.

```
┌─────────────────┐     ┌─────────────┐     ┌────────────┐     ┌────────────┐     ┌─────────┐
│  1. GRILL+DOCS  │ ──▶ │ 2. WAYFIND  │ ──▶ │ 3. TICKETS │ ──▶ │ 4. IMPLEMENT│ ──▶ │ 5. REVIEW│
└─────────────────┘     └─────────────┘     └────────────┘     └────────────┘     └─────────┘
```

## Phase 1: Grill + Document

**Skill:** `/grill-with-docs`

Create in `docs/`:
- `CONTEXT.md` — domain glossary (≥5 terms)
- `docs/adr/` — hard-to-reverse decisions
- `docs/SESSION.md` — copy from `scripts/SESSION.md.template`
- Domain docs: UX, security, compliance, performance, observability, monetization, analytics, notifications, search, real-time, background jobs, rollout, incident management, cost management, DX

Also create `AGENTS.md` in project root — copy from `scripts/AGENTS.md.template`.

**Gate:**
- [ ] All docs exist, CONTEXT.md has ≥5 terms
- [ ] Run verify protocol
- [ ] User confirms shared understanding

## Phase 2: Wayfind

**Skill:** `/wayfinder`

Chart the path as investigation tickets. Create research/prototype tickets for each domain.

**Gate:**
- [ ] Wayfinder map exists
- [ ] All wayfinder tickets closed, prototypes exist for critical architecture
- [ ] Run verify protocol — reconcile findings with CONTEXT.md and ADRs
- [ ] SESSION.md phase → 3

## Phase 3: To Tickets

**Skill:** `/to-tickets`

Break decisions into vertical-slice implementation tickets. Every ticket must include acceptance criteria from relevant `*-STANDARDS.md` files.

**Tooling setup (do before coding):**
- Lint, format, typecheck, security scanning, test framework, CI/CD, observability, design system
- Copy standards and scripts (see below)
- Wire pre-commit hook

**Gate:**
- [ ] Tickets published, blocking edges wired, acceptance criteria complete
- [ ] Tooling configured, standards/scripts copied, pre-commit active
- [ ] Run verify protocol — every ticket references correct CONTEXT.md terms and ADRs
- [ ] SESSION.md phase → 4, user approves breakdown

## Phase 4: Implement

**Skill:** `/implement`

Per ticket:
1. Claim
2. Prefactor if needed
3. TDD (tests first)
4. Minimal implementation
5. Run verify protocol (before commit)
6. Commit, update SESSION.md

**Gate:**
- [ ] All tickets closed
- [ ] Run verify protocol — all tests pass, no stale docs
- [ ] SESSION.md phase → 5

## Phase 5: Review

**Skill:** `/review`

Parallel sub-agents check:
- **Standards** — code compliance
- **Spec** — matches originating issues
- **Quality** — all `*-STANDARDS.md` files
- **Docs** — term drift, stale references, contradictions, code alignment

**Gate:**
- [ ] Review report delivered, issues addressed
- [ ] Run verify protocol
- [ ] SESSION.md status → complete

## Resuming

1. Read `docs/SESSION.md`
2. Verify against filesystem + issue tracker
3. Continue from detected phase:

| State | Action |
|-------|--------|
| No artifacts | Phase 1 |
| Docs exist, no wayfinder map | Phase 2 |
| Map exists, open tickets | Continue Phase 2 |
| Map closed, no impl tickets | Phase 3 |
| Impl tickets exist, some open | Continue Phase 4 |
| All tickets closed | Phase 5 |
| All closed + review done | Feature mode |

## Feature Mode

Lighter re-entry for post-ship features:

1. **Mini-grill** — update CONTEXT.md if new terms, ADR only if hard-to-reverse
2. **Mini-wayfind** — investigation tickets only if uncharted architecture; else skip
3. **To-tickets** — vertical-slice tickets with inherited acceptance criteria
4. **Implement** — standard Phase 4 flow per ticket
5. **Review** — diff against standards + spec + docs

Run verify protocol after every step. Tooling persists; no re-setup needed.

## Verify Protocol

Runs at **every phase gate, every pre-commit, every review.** No exceptions.

```
1. scripts/verify.sh        → fix all failures
2. npm run typecheck        → fix all failures (skip if no code yet)
3. npm run lint             → fix all failures (skip if no code yet)
4. npm test                 → fix all failures (skip if no code yet)
5. Manual: read applicable *-STANDARDS.md checklists, verify every item
6. Manual: read all docs in docs/, check:
   - All CONTEXT.md terms used consistently (no synonyms, no drift)
   - All ADR decisions reflected in tickets + code
   - No two docs contradict each other
   - No stale docs (code matches what docs describe)
   - SESSION.md matches filesystem reality
   - No orphan docs, no broken links
```

**Outcome:**
- All pass → proceed
- Any fail → blocked until fixed
- Update SESSION.md `## Doc consistency` with result

## Tooling Setup

Run once in Phase 3:

```bash
cp ~/.config/opencode/skills/platform-builder/*-STANDARDS.md standards/
cp ~/.config/opencode/skills/platform-builder/scripts/verify.sh scripts/
cp ~/.config/opencode/skills/platform-builder/scripts/pre-commit-standards-hook.sh .husky/
```

Wire into `.husky/pre-commit`:

```bash
bash .husky/pre-commit-standards-hook.sh || exit 1
```

## SESSION.md

Living file at `docs/SESSION.md`. Read first on resume. Update after every session, ticket, and phase gate.

```markdown
Phase: 3
Status: in_progress
Last active: 2026-07-10
## Active work
- ...
## Recent decisions
- ...
## Doc consistency
- Last verify: passed | failed (date)
- Drift items: 0 (or list with ticket refs)
## Standards
- Pre-commit: active | not configured
- Last check: passed | failed (date)
```

**Rules:** Phase is `1`–`5` or `feature`. Status is `in_progress`, `blocked`, or `complete`. Keep entries one line. Do not proceed past a gate with unresolved drift items.

## Key Principles

1. **One ticket per session**
2. **SESSION.md is source of truth** — always read first, update last
3. **Docs before code** — CONTEXT.md and ADRs precede implementation
4. **Decisions before tickets** — wayfinder before to-tickets
5. **Vertical slices** — each ticket cuts all layers
6. **Prefactor before implement** — make the change easy first
7. **YAGNI** — build only what the ticket asks
8. **Verify protocol blocks all** — no commit, no gate, no review passes without it
9. **No stale docs, no term drift** — unify at every step

## Standards Files

See `*-STANDARDS.md` files. Each contains: applies-when rules, checklist, anti-patterns.
