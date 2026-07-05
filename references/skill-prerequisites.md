# Skill Prerequisites

Delegated skills required by each phase. The agent must verify these are
available before entering the phase. If a skill is missing, install it or
halt and ask the user — do not silently skip it.

## Pre-Flight Checklist

On first entry (greenfield or brownfield), run this check:

```
For each skill listed in this file:
  1. Check if the skill exists: scan the available skills list.
  2. If missing: report "Missing: <skill> — required for Phase <N>.
     Install before continuing."
  3. If all present: record "Prerequisites verified" in docs/SESSION.md.
```

Re-run at every phase transition. A phase that skips its checklist is
entering without its tools.

## Phase Requirements

| Phase | Required Skills |
|-------|----------------|
| 0 | `setup-matt-pocock-skills`, `setup-pre-commit`, `graphify` |
| 1 | `to-prd` (if no vision), `decision-mapping` (if unknowns), `grill-with-docs`, `domain-modeling` (brownfield), `graphify` |
| 2 | `to-issues`, `graphify` (if source files exist) |
| 3 | `tdd`, `codebase-design`, `grill-me`, `design-an-interface`, `prototype`, `graphify` |
| 4 | `graphify` |
| 5 | `graphify` |
| 6 | `graphify` |
| 7 | `review`, `improve-codebase-architecture`, `request-refactor-plan`, `qa`, `handoff`, `graphify` |
| FL | `to-issues`, `grill-me`, `tdd`, `codebase-design`, `prototype`, `review`, `graphify` |

## Always Available

`graphify` is required in every phase. It is the structural index. If
`graphify` is missing, do not proceed — the agent's ability to navigate
the codebase efficiently depends on it.

## What Happens If a Skill Is Missing

1. **Core skill absent** (graphify, tdd, codebase-design, grill-with-docs):
   halt. These are non-negotiable.
2. **Optional skill absent** (prototype, design-an-interface, decision-mapping):
   proceed but note the absence in `docs/SESSION.md`. The phase may take
   longer or produce lower-quality output.
3. **Review skill absent** (review, qa, handoff):
   proceed but the gate is weakened — flag in `docs/SESSION.md` that
   automated review was skipped.
