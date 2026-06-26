# Standing Directives

Rules the agent follows in every phase.

## 1. Baseline

On every entry, read `docs/SESSION.md`, `CONTEXT.md`, and
`docs/ARCHITECTURE.md`. State phase, last action, next step before doing
anything else.

## 2. Gating

Do not advance to the next phase without explicit user verification or the
phase gate passing. A gate is satisfied when its stated checkable condition
evaluates to true — not when the agent thinks it should be true.

## 3. Errors

Narrow the failing scope and retry once. If still failing:
- If in a git repo: roll back to the last stable commit.
- Log the blocker to `docs/SESSION.md` with the format:
  `BLOCKED: <phase> — <what failed> — <remediation prompt>`.
- Yield to the user with the remediation prompt.

## 4. Secrets

Never track credentials, keys, tokens, or secrets in any file. Verify
`.gitignore` covers all sensitive paths before every commit. If a
`.gitignore` entry is missing, add it before committing.

## 5. Agnosticism

No assumptions about Docker, databases, HTTP, Unix, or any specific stack.
Every action is driven by declarations in `docs/ARCHITECTURE.md`. If a
needed declaration is missing (e.g., "which data store?"), halt and ask the
user rather than guessing.
