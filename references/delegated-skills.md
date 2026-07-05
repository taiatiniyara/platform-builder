# Delegated Skills

Each phase invokes specialist skills. Load them by name via the skill tool.

| Phase | Skill | Purpose |
|-------|-------|---------|
| 0 | `setup-matt-pocock-skills` | Configure issue tracker, triage labels, domain doc layout |
| 0 | `setup-pre-commit` | Wire up Husky, lint-staged, typecheck, tests on commit |
| 1 | `to-prd` | Synthesize product vision from conversation |
| 1 | `decision-mapping` | Map open architectural unknowns as investigation tickets |
| 1 | `grill-with-docs` | Interview relentlessly; produce CONTEXT.md and ADRs |
| 1 | `domain-modeling` | Brownfield: extract domain glossary from existing codebase |
| 2 | `to-issues` | Break plan into vertical-slice issues with dependency graph |
| 3 | `tdd` | Red-green-refactor cycle per issue |
| 3 | `codebase-design` | Deep module design vocabulary |
| 3 | `grill-me` | Stress-test design decisions (no doc output) |
| 3 | `design-an-interface` | Generate multiple interface alternatives |
| 3 | `prototype` | Throwaway prototype to answer a design question |
| 7 | `review` | Two-axis review: standards + spec conformance |
| 7 | `improve-codebase-architecture` | Scan for deepening opportunities; visual report |
| 7 | `request-refactor-plan` | Safe incremental refactor plan from an architecture finding |
| 7 | `qa` | Interactive bug-filing session |
| 7 | `handoff` | Compact session into handoff document |
| FL | `to-issues` | Feature Loop: break feature into issues |
| FL | `grill-me` | Feature Loop: mandatory design stress-test before implementation |
| FL | `tdd` | Feature Loop: implement |
| FL | `codebase-design` | Feature Loop: deep module design |
| FL | `prototype` | Feature Loop: answer design question |
| FL | `review` | Feature Loop: review before merge |
| * | `graphify` | Structural codebase index — used as baseline directive, replaces file-by-file scanning with 2k-token graph queries (71.5x reduction) |
| CB | `handoff` | Circuit breaker: compact session into handoff document when yielding |
