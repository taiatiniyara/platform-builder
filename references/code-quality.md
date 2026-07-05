# Code Quality Standards

Checkable criteria applied during the REFACTOR step of every issue (Phase 3)
and audited codebase-wide in Phase 7. Stack-agnostic — the agent determines
which tools to use for each check.

---

## Per-Issue Refactor (Phase 3 REFACTOR step)

After tests pass, verify each item before squash-merging. Only commit the
refactored code if tests still pass after the changes.

### Naming

- [ ] Names describe **what**, not **how** (e.g., `getNextBatch()` not `queryLimitOffset()`)
- [ ] Names read in the consumer's domain language, not the implementation's
- [ ] No single-letter variables except loop indices in scopes under 5 lines
- [ ] No abbreviations that aren't in the domain glossary (`CONTEXT.md`)

### Shape

- [ ] Functions have 3 or fewer parameters (pack into an object beyond that)
- [ ] No boolean flag parameters — split into two functions instead
- [ ] No output/reference parameters — return the value
- [ ] Functions do one thing: you can name them without "and"

### Control Flow

- [ ] No `else` after `return`/`throw`/`break` in the `if` block
- [ ] Conditionals extract to well-named variables when the expression spans more than one line
- [ ] No nested ternaries
- [ ] Early returns for guard clauses at the top, not buried mid-function

### Data

- [ ] Magic numbers and strings extracted to named constants
- [ ] No `null`/`undefined` passthrough — handle at the boundary
- [ ] Default values declared at the boundary, not scattered through call sites

### Comments

- [ ] No comments that repeat what the code already says
- [ ] No commented-out code — delete it (git remembers)
- [ ] If a block needs a comment, extract it to a named function instead

### Duplication (local)

- [ ] No copy-pasted block appears within the same file
- [ ] Repeated patterns across the new code extracted to a shared helper

### Dependencies

- [ ] New imports are from declared dependencies in the project manifest
- [ ] No circular imports introduced
- [ ] The import depth is as shallow as the abstraction allows (don't import internals)

---

## Codebase Audit (Phase 7)

Run these checks across the full codebase. File a finding for each violation.

### Dead Code

- [ ] **Unused exports.** Scan for exported symbols never imported elsewhere.
- [ ] **Unreachable code.** Flag code after unconditional `return`/`throw`/`break`.
- [ ] **Stale dependencies.** Dependencies in the manifest that no source file imports.

### Duplication

- [ ] **Copy-paste blocks.** Detect blocks of 6+ lines that appear in 2+ files with
  fewer than 2 lines of difference. For each cluster, extract to a shared module
  or justify why the duplication is deliberate.
- [ ] **Repeated conditionals.** The same `if`/`switch` shape appearing in 3+
  unrelated places — likely a missing polymorphic dispatch.

### Complexity

- [ ] **Line length.** Functions over 40 lines (excluding blank lines and comments).
  Extract subtasks to well-named helper functions.
- [ ] **Parameter count.** Functions with 4+ parameters.
- [ ] **Branching depth.** Functions with 4+ levels of indentation — flatten with
  early returns or extracted helpers.
- [ ] **File size.** Files over 400 lines — split along domain boundaries.
- [ ] **Cyclomatic complexity.** (If static analysis tool available) Functions above 10.

### Coupling

- [ ] **Import depth.** Files importing more than 3 layers deep into other modules.
- [ ] **Circular dependencies.** Any cycle in the module dependency graph.
- [ ] **God modules.** Files with 15+ exports — likely several modules forced into one.

### Performance (when profiling data is available)

- [ ] No N+1 queries in data-access paths
- [ ] No allocations in hot loops
- [ ] No unnecessary copies of large data structures

---

## Quality Gate Script Integration

The Phase 3 gate (`scripts/validate-gate.sh 3`) and Phase 7 review both
reference this file. For automated checks, the agent should:

1. Run the project's linter (catches unused variables, unreachable code)
2. Run the project's typechecker (catches dead branches, impossible states)
3. If available, run a duplication detector (jscpd, copy-paste-detector, etc.)
4. If available, run a complexity analyzer (radon, eslint complexity rule, etc.)

The **minimum bar** for gate-passing: linter + typechecker exit 0, and no
copy-pasted block appears inside the same file that the issue touched.
