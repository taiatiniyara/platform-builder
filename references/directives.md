# Standing Directives

Rules the agent follows in every phase.

## 1. Baseline

On every entry, read `docs/SESSION.md`, `CONTEXT.md`, and
`docs/ARCHITECTURE.md`. If the project has source files, run
`/graphify . --update` to refresh the knowledge graph, then scan
`graphify-out/GRAPH_REPORT.md` for god nodes and surprising connections.
State phase, last action, next step before doing anything else.

When navigating the codebase to understand architecture or dependencies,
query the graph (`/graphify query "<question>" --budget 2000`) instead of
reading source files directory-by-directory. The graph is the structural
index — use it first, fall back to raw file reads only when the graph
answers are insufficient.

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

## 6. Documentation

Every code change that introduces or modifies a public interface must update
the corresponding documentation. Agent docs (`docs/agents/`, `graphify-out/`)
and human docs (README, CHANGELOG, ADRs) are equally required — neither is
optional. A public interface without docstrings, contract, or graph node is
a gate failure. During Phase 7, run the full doc audit from
`references/documentation.md` § "Doc Audit".

## 7. Write Against Installed, Not Remembered

Never call a library API from memory. Before writing any code that imports
a third-party package, verify the API signature, options, and return type
against the version actually installed in the project. Read the installed
types, docs, or README from `node_modules/`, `pip show`, `go doc`, etc. See
`references/api-versioning.md` for per-ecosystem workflows. The installed
`.d.ts` file is the authority — the model's training data is not.

When adding or upgrading a dependency, never install from memory either.
Check the latest stable version against the package registry first
(`npm view`, `pip index versions`, `go list -m -versions`, etc.) and pin
exact versions with a registry-check timestamp comment in the manifest.

## 8. Prerequisites

On first entry (greenfield) and at the start of every phase transition,
verify that every delegated skill required by the current phase is
available. Cross-reference the phase against `references/delegated-skills.md`
and `references/skill-prerequisites.md`. If a required skill is missing,
install it or halt and ask the user. Do not enter a phase without its tools.

## 9. Circuit Breaker

Sessions are not infinite. Track three signals to avoid drift:

- **Issue depth:** if more than 20 issues are open in Phase 3, pause.
  Compact completed work to `docs/SESSION.md`, run `/handoff`, and yield
  to the user with a summary of what's done and what's next. Do not
  silently accumulate unfinished issues.

- **Session length:** update `last_compaction` in `docs/SESSION.md` every
  40 tool calls or after completing every 5th issue, whichever comes
  first. Record the ISO timestamp. If `last_compaction` is more than 2
  hours old with no phase progress, compact and yield.

- **Stuck loop:** if the same bug reoccurs across 3 or more compactions,
  stop. Write `BLOCKED: <phase> — loop detected on <bug> — investigate
  root cause before continuing` to `docs/SESSION.md`. Do not retry the
  same fix a fourth time.

- **Brownfield entry:** if the project already has source files when
  Phase 0 begins, treat it as a brownfield. Do not scaffold from scratch.
  Instead: (a) survey existing stack and record it in
  `docs/ARCHITECTURE.md`, (b) build `CONTEXT.md` from existing code
  (run `/domain-modeling`), (c) run `/graphify .` to index what's there,
  (d) skip Phase 0 scaffolding — jump to Phase 1 (Blueprint) with the
  existing codebase as working material. Gate: ARCHITECTURE.md accurately
  describes what's already deployed.
