# Feature Loop

The ongoing cycle for adding features after the platform is live — a
shorter version of the full lifecycle that skips the one-time setup phases.

Write `feature: <slug>` to `docs/SESSION.md`.

## Steps

1. **Validate context.** Read `CONTEXT.md` and `docs/ARCHITECTURE.md`. If
   the stack or domain model has drifted, update the relevant file and
   write an ADR.

2. **Issue.** Run `/to-issues`.
   **Gate:** issues are vertical slices, agent-ready.

3. **Implement.** Run `/tdd` and `/codebase-design`. For complex issues,
   run `/grill-me` to stress-test the design. If interface shape is
   uncertain, run `/prototype`.
   **Gate:** all new tests pass, no regressions.

4. **Review.** Run `/review`.
   **Gate:** no standards violations, no spec drift.

Update `docs/SESSION.md` after each step. If the feature changes the domain
model, update `CONTEXT.md` inline.
