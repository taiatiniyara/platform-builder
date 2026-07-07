# Feature Loop

The ongoing cycle for adding features after the platform is live — a
shorter version of the full lifecycle that skips the one-time setup phases.

Write `feature: <slug>` to `docs/SESSION.md`.

## Steps

1. **Validate context.** Read `CONTEXT.md` and `docs/ARCHITECTURE.md`. Run
   `/graphify . --update`. Query the graph for drift: "Are there nodes or
   edges that contradict current ARCHITECTURE.md claims?" If the stack or
   domain model has drifted, update the relevant file and write an ADR.

2. **Issue.** Run `/to-issues`.
   **Gate:** issues are vertical slices, agent-ready.

3. **Grill.** Run `/grill-me` against each issue's design before any code
   is written. For UI issues, also run `references/ui-ux-grill.md` §6‑§7
   — every screen-level and interaction question must be answered.
   **Gate:** every issue must pass a grill session. Unresolved design
   questions must be settled here — do not carry them into implementation.

4. **Implement.** Run `/tdd` and `/codebase-design`. Before each issue,
   `/graphify query "<issue context>" --budget 2000`. Run `/prototype`
   if interface shape is uncertain. Apply `references/testing-strategy.md`
   for test levels, `references/api-design.md` for endpoint standards, and
   `references/api-versioning.md` — verify every third-party API against
   the installed version. Apply `references/documentation.md` — every new
   public interface gets a docstring/typed signature; changed APIs update
   `docs/agents/contracts/`; CHANGELOG gets an entry. After REFACTOR,
   verify against `references/code-quality.md` § "Per-Issue Refactor".
   Squash-merge to `main` with conventional commit message per
   `references/git-strategy.md`. Delete branch.
   **Gate:** all new tests pass (unit, integration, e2e as appropriate), no
   regressions. Public interfaces documented. Linter + typechecker exit 0.

5. **Review.** Run `/review`. Verify documentation coverage from
   `references/documentation.md` — CHANGELOG entry, agent contracts
   updated, README updated if public-facing.
   **Gate:** no standards violations, no spec drift, no doc gaps.

Update `docs/SESSION.md` after each step. If the feature changes the domain
model, update `CONTEXT.md` inline. After the feature loop completes, run
`/graphify .` to fully rebuild the graph for the next session. Update agent
contracts in `docs/agents/contracts/` if API shape changed.

**Verification:** run `scripts/validate-gate.sh 3` to verify implementation
artifacts (tests, linter, typechecker, CHANGELOG, contracts).
