---
name: platform-builder
description: Build whole platforms from loose idea to shipped code. Orchestrates grilling, wayfinding, ticketing, implementation, and review.
---

# Platform Builder

Five phases, each delegates to an existing skill. All gates blocked by verify protocol.

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

## Phase 1: Grill + Docs → `/grill-with-docs`
`docs/CONTEXT.md` (≥5 terms), `docs/adr/`, `docs/SESSION.md`, `docs/ux-principles.md`, `AGENTS.md` (from templates), `<domain>.md` per needed domain. Gate: docs exist, people-love-it checklist passed, verify protocol green, user confirms.

## Phase 2: Wayfind → `/wayfinder`
Investigation tickets + UX prototype of core "time-to-wow" path, hallway-tested (≥2 people). Gate: map exists, tickets closed, prototype done, verify protocol, SESSION.md → 3.

## Phase 3: Tickets → `/to-tickets`
Vertical-slice tickets with ≥1 loveability AC each. Setup tooling (lint, format, typecheck, tests, pre-commit). Gate: tickets published with edges, tooling configured, verify protocol, user approves.

## Phase 4: Implement → `/implement`
Per ticket:
1. `/graphify . --update` (sync before context)
2. Claim → query graph for existing architecture → prefactor
3. `/graphify . --update` (sync after structural change)
4. TDD → implement → simplicity check (what did this remove?) → hallway test (≥1 person)
5. `/graphify . --update` (sync after implementation)
6. Verify protocol → commit
Gate: all closed, verify protocol, SESSION.md → 5.

## Phase 5: Review → `/review`
Parallel sub-agents on standards, spec, quality, docs, lovable. Gate: issues addressed, verify protocol, hallway by reviewer, SESSION.md → complete.

## Resuming
Read `docs/SESSION.md`, detect phase. If `graphify-out/graph.json` exists, run `/graphify . --update` first to sync with filesystem, then query it for context before reading any file. No artifacts → P1. Docs only → P2. Map open → P2. Map closed, no impl tickets → P3. Impl tickets open → P4. All closed → P5. Review done → Feature mode.

## Feature Mode
Mini-grill → mini-wayfind (skip if known) → to-tickets → `/graphify . --update` → implement (simplicity + hallway + verify per ticket) → review. Verify after every step.

## Verify Protocol
Runs at every gate, pre-commit, and review. No exceptions.
1. `scripts/verify.sh` → fix all
2. `npm run typecheck` → fix all (skip if no code)
3. `npm run lint` → fix all (skip if no code)
4. `npm test` → fix all (skip if no code)
5. Manual: UX-STANDARDS.md lovability checklist, every item
6. Manual: all domain *-STANDARDS.md checklists, every item
7. Manual: all docs/ — term consistency, no contradictions, no stale docs, SESSION.md matches reality
All pass → proceed. Any fail → blocked.

## Tooling Setup (Phase 3)
```bash
SKILL_DIR="${SKILL_DIR:-$HOME/.config/opencode/skills/platform-builder}"
cp "$SKILL_DIR"/*-STANDARDS.md standards/
cp "$SKILL_DIR"/scripts/verify.sh scripts/
mkdir -p .husky
cp "$SKILL_DIR"/scripts/pre-commit-standards-hook.sh .husky/
python3 -m pip install graphifyy -q --break-system-packages 2>/dev/null || true
echo "graphify-out/" >> .gitignore
```
Wire: `bash .husky/pre-commit-standards-hook.sh || exit 1` in `.husky/pre-commit`.

## Graphify Guardrails

**Prerequisites:** code must exist (≥1 source file). During Phase 1-3, read files directly. If graphifyy not installed, fall back to reading files — the graph is a shortcut, never a requirement.

**First build:** `/graphify .` (once). **Incremental:** `/graphify . --update` (fast — only changed files). If `--update` reports no graph exists, run `/graphify .` instead.

**Sync schedule:** resume → `--update` first. Phase 4: `--update` before context, after prefactor, after implementation. Phase 5 + Feature mode: `--update` before any sub-agent queries.

**Edge confidence (critical):**
- EXTRACTED — structural fact (import, call, citation). **Trust.**
- INFERRED — educated guess. **Verify with file read** before acting on it.
- AMBIGUOUS — weak signal. **Treat as clue only**, never make decisions on it.

**Fallback chain** — use when graph fails, returns empty, or gives suspicious results:
1. Read files directly. The graph is optional.
2. INFERRED/AMBIGUOUS-only paths → read the source file.
3. Query returns nothing → grep the codebase instead.

**Anti-patterns:**
- Querying code you're editing this session (you know it better)
- Querying files modified since last `--update` (graph is stale for those)
- Treating INFERRED edges as architecture decisions
- Skipping `--update` on resume (branch switch, other agent's changes)

**Usage:** `/graphify query "<q>"` for context, `/graphify path "A" "B"` for dependency chains.

## Key Principles
1. One ticket per session
2. SESSION.md is source of truth
3. Docs before code
4. Decisions before tickets
5. Vertical slices
6. Prefactor before implement
7. YAGNI
8. Verify protocol blocks all gates, commits, reviews
9. No stale docs, no term drift
10. Simple, delightful, shareable — every feature reduces effort, creates joy, or gives a reason to tell someone
11. Graph before grep — query the knowledge graph (`/graphify query`) before reading files

## Standards Files
See `*-STANDARDS.md` files. Each: applies-when line + checklist.
