---
name: platform-builder
description: Build whole platforms from loose idea to shipped code. Orchestrates grilling, wayfinding, ticketing, implementation, and review.
---

# Platform Builder

Five phases, each delegates to an existing skill. All gates blocked by verify protocol. UX is non-negotiable: every phase has UX requirements baked in, not bolted on.

## Phase 0: Scope

**Pre-flight:** verify all required skills exist. The 5 direct delegations plus their transitive dependencies. If any are missing, print: `"npx skills add mattpocock/skills -y -g"` and stop — do not proceed.

```bash
required=(grill-with-docs wayfinder to-tickets implement review grilling domain-modeling prototype tdd code-review setup-matt-pocock-skills)
for skill in "${required[@]}"; do
  if [ ! -d "$HOME/.agents/skills/$skill" ]; then
    echo "Missing skill: $skill"
    echo "Install: npx skills add mattpocock/skills -y -g"
    exit 1
  fi
done
```

Present domain list (ux, security, compliance, performance, observability, monetization, analytics, search, real-time, background-jobs, cost-management). User marks each needed/deferred/N/A. Always-on (code-quality, data-management, deployment, reliability, api-design, documentation) not presented. Record in `docs/SESSION.md`.

**Design System Selection.** Before proceeding to Phase 1, user must choose a UI framework and component library. Record in SESSION.md. Options include: Tailwind CSS + shadcn/ui (recommended), NextUI, Chakra UI, Mantine, MUI, Ant Design, or custom. If the platform has no UI (API-only), record "API-only" and skip UI phases. Gate: framework choice recorded in SESSION.md.

## Phase 1: Grill + Docs → `/grill-with-docs`
Create `docs/CONTEXT.md` (≥5 terms), `docs/adr/`, `docs/SESSION.md` (from `scripts/SESSION.md.template`), `docs/ux-principles.md`, `docs/design-system.md` (from `scripts/DESIGN-SYSTEM.md.template`), `AGENTS.md` (from `scripts/AGENTS.md.template`), and `<domain>.md` per needed domain. Gate: docs exist, people-love-it checklist passed, verify protocol green, user confirms.

The grill MUST cover:
- Visual identity: color palette, typography, spacing rhythm, elevation model
- Motion philosophy: when and why things move
- Voice & tone: how the product talks to the user
- States philosophy: how loading, empty, error, success are handled uniformly
- The "first 30 seconds" experience: what the user sees, feels, and accomplishes

## Phase 2: Wayfind → `/wayfinder`
Investigation tickets + UX prototype of core "time-to-wow" path, hallway-tested (≥2 people). The prototype MUST use the design system from `docs/design-system.md` — no raw CSS, no ad-hoc styling. Gate: map exists, tickets closed, prototype done, prototype matches design-system.md, verify protocol, SESSION.md → 3.

## Phase 3: Tickets → `/to-tickets`
Vertical-slice tickets with ≥1 loveability AC each AND a UX checklist section listing specific items from UX-STANDARDS.md that this ticket must satisfy. Setup tooling (lint, format, typecheck, tests, pre-commit). Setup graphify: `uv tool install graphifyy && graphify install --platform opencode --project && /graphify .` to build initial graph. Gate: tickets published with edges, every UI ticket has UX checklist, tooling configured, graph exists, verify protocol, user approves.

## Phase 4: Implement → `/implement`
Per ticket:
1. `/graphify . --update` (sync before context)
2. **Read ticket's UX checklist** — identify every UX-STANDARDS.md item this ticket touches
3. **Read `docs/design-system.md`** — confirm all components and tokens needed
4. Claim → query graph for existing architecture → prefactor
5. `/graphify . --update` (sync after structural change)
6. TDD → implement (using design system ONLY — no ad-hoc styles, no raw HTML where a component exists)
7. **UX walkthrough** — interact with the feature, check EACH UX-STANDARDS item from the ticket's checklist. Fix discrepancies. Do not skip or wave through.
8. Simplicity check (what did this remove? If nothing was removed, justify why) → hallway test (≥1 person)
9. `/graphify . --update` (sync after implementation)
10. Verify protocol → commit
Gate: all closed, verify protocol, SESSION.md → 5.

## Phase 5: Review → `/review`
Parallel sub-agents on standards, spec, quality, docs, lovable, **ux** (dedicated sub-agent that walks UX-STANDARDS.md checklist for every UI-involved ticket, checking actual rendered UI against each item). Gate: issues addressed, verify protocol, hallway by reviewer, SESSION.md → complete.

## Session Startup

**Every session starts here. No exceptions.** Before any work:

1. Run `bash scripts/startup.sh $PWD` — blocks if skills missing, standards absent, graphify missing/stale (Phase 3+), or SESSION.md invalid
2. Read `docs/SESSION.md` — the `Phase` field determines what you're allowed to do
3. Read `docs/design-system.md` if it exists — you must use these tokens and components for any UI work
4. If Phase ≥ 3, run `/graphify . --update` — sync graph before any work. This is mandatory, not optional.

**Phase enforcement rules:**
- Phase in SESSION.md is the gatekeeper. Do not skip phases.
- If Phase is N, you cannot do work from Phase N+1 or higher.
- If you finish a phase's gate, update SESSION.md to the next phase before starting it.
- After Phase 5 review passes, set Phase to `feature` and Status to `complete`.
- If you're blocked, set `Status: blocked` with a reason — do not proceed past a blocked state.

**Resume detection:** No artifacts → P1. Docs only → P2. Map open → P2. Map closed, no impl tickets → P3. Impl tickets open → P4. All closed → P5. Review done → feature.

## Bootstrap Mode (existing projects)

When platform-builder is loaded on a project that has code but no `docs/SESSION.md`, `standards/`, or `AGENTS.md`, the project was not created by platform-builder. Do not run the standard Phase 0 flow. Instead, bootstrap:

1. **Detect:** Code exists (e.g. `src/`, `package.json`, `pyproject.toml`) but `docs/SESSION.md` is missing.
2. **Graph first:** Run `/graphify .` to map the existing codebase. This is the single highest-value first step.
3. **Domain scope:** Present the domain list (same as Phase 0). User marks each needed/deferred/N/A. Record in SESSION.md.
4. **Infer design system:** Analyze existing UI code (CSS, components, theme files) — extract colors, typography, spacing, component inventory. Create `docs/design-system.md` from findings. If no UI exists, mark as API-only.
5. **Create docs:** Create `docs/SESSION.md` (Phase = 2, Status = in_progress), `docs/CONTEXT.md` (≥5 terms from codebase analysis), `docs/ux-principles.md`, `AGENTS.md` (from template), and `<domain>.md` per needed domain.
6. **Audit UX:** Walk the existing UI against UX-STANDARDS.md. File loveability tickets for every violation found — these become the first batch of implementation tickets.
7. **Set up tooling:** Copy standards files, install verify.sh, wire pre-commit hook (same as Phase 3 tooling setup).
8. **Gate:** docs exist, graph exists (verify.sh confirms), UX audit filed as tickets, user approves.
9. **Promote:** Set SESSION.md Phase = 3, Status = in_progress. Resume normal Phase 3 → Phase 4 → Phase 5 flow.

**Bootstrap rationale:** The project already has direction (no need to grill/wayfind from scratch), but it lacks platform-builder discipline (no standards enforcement, no design system, no graph). Bootstrapping brings the gap-closing artifacts online without the greenfield overhead.

## Feature Mode
Mini-grill → mini-wayfind (skip if known) → to-tickets → `/graphify . --update` → implement (simplicity + hallway + verify per ticket) → review. Verify after every step. Every UI ticket must have a UX checklist section — same as Phase 3 rule.

## Verify Protocol
Runs at every gate, pre-commit, and review. No exceptions.
1. `scripts/verify.sh` → fix all
2. Phase 3+: graphify installed, graph exists, graph stale check (verify.sh enforces)
3. `npm run typecheck` → fix all (skip if no code)
4. `npm run lint` → fix all (skip if no code)
5. `npm test` → fix all (skip if no code)
6. Manual: UX-STANDARDS.md lovability checklist, every item
7. Manual: all domain *-STANDARDS.md checklists, every item
8. Manual: all docs/ — term consistency, no contradictions, no stale docs, SESSION.md matches reality
9. Gate check: SESSION.md Phase must match what you're doing. If you just completed Phase 2's gate, Phase must be 3 before starting Phase 3 work.
All pass → proceed. Any fail → blocked.

## Tooling Setup (Phase 3)
```bash
SKILL_DIR="${SKILL_DIR:-$HOME/.config/opencode/skills/platform-builder}"
cp "$SKILL_DIR"/*-STANDARDS.md standards/
cp "$SKILL_DIR"/scripts/verify.sh scripts/
cp "$SKILL_DIR"/scripts/startup.sh scripts/
mkdir -p .husky
cp "$SKILL_DIR"/scripts/pre-commit-standards-hook.sh .husky/
uv tool install graphifyy
graphify install --platform opencode --project
/graphify .
echo "graphify-out/" >> .gitignore
```
Wire: `bash .husky/pre-commit-standards-hook.sh || exit 1` in `.husky/pre-commit`.

## Graphify Guardrails

**Required from Phase 3 onward.** Graphify saves tokens by replacing file-reading with targeted graph queries. Every file read skipped is tokens saved.

**Prerequisites:** code must exist (≥1 source file). During Phase 1-2, graphify is not required (no code yet). Phase 3+: graphifyy must be installed (`uv tool install graphifyy`; on Windows: `winget install astral-sh.uv` first) and graph must exist — startup.sh and verify.sh both enforce this.

**First build:** `/graphify .` (once, at Phase 3 tooling setup). **Incremental:** `/graphify . --update` (fast — only changed files). If `--update` reports no graph exists, run `/graphify .` instead.

**Sync schedule (mandatory):**
- Every session startup (Phase 3+): `--update` before any context queries
- Phase 4 per-ticket: `--update` before context, after prefactor, after implementation
- Phase 5 + Feature mode: `--update` before any sub-agent work
- Skipping `--update` is a verify protocol violation — stale graph = stale context = bad decisions

**Edge confidence (critical):**
- EXTRACTED — structural fact (import, call, citation). **Trust.**
- INFERRED — educated guess. **Verify with file read** before acting on it.
- AMBIGUOUS — weak signal. **Treat as clue only**, never make decisions on it.

**Usage (primary):** `/graphify query "<q>"` for context, `/graphify path "A" "B"` for dependency chains. Prefer graph queries over file reads — they're faster and use fewer tokens.

**Fallback chain** — use only when graph is unavailable (pre-Phase 3, or `--update` fails):
1. Graph fails or is unavailable → read files directly
2. INFERRED/AMBIGUOUS-only paths → read the source file
3. Query returns nothing → grep the codebase instead

**Anti-patterns:**
- Querying code you're editing this session (you know it better)
- Querying files modified since last `--update` (graph is stale for those)
- Treating INFERRED edges as architecture decisions
- Skipping `--update` on resume (branch switch, other agent's changes)

## Key Principles
1. One ticket per session
2. SESSION.md is source of truth
3. Docs before code
4. UX before pixels — design system, states, and accessibility come before implementation
5. Decisions before tickets
6. Vertical slices
7. Prefactor before implement
8. YAGNI
9. Verify protocol blocks all gates, commits, reviews
10. No stale docs, no term drift
11. Simple, delightful, shareable — every feature reduces effort, creates joy, or gives a reason to tell someone
12. Graph before grep — query the knowledge graph (`/graphify query`) before reading files
13. No ad-hoc styles — every visual decision comes from the design system

## Standards Files
See `*-STANDARDS.md` files. Each: applies-when line + checklist.
