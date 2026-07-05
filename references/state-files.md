# State File Formats

The skill tracks progress across two persistent files inside the user's
project. Architecture and backlog live alongside them.

## `docs/SESSION.md`

Phase tracker. A single markdown file that records the current phase,
active task, and last compaction.

```
# Session

phase: <0-7>
task: <what the agent is currently doing>
last_compaction: <ISO timestamp>
```

`last_compaction` is updated every 40 tool calls or after every 5th
completed issue — whichever comes first. If more than 2 hours have elapsed
since the last compaction with no phase progress, the agent must compact
and yield to the user. An empty `last_compaction` means no compaction has
been recorded — this is valid for fresh sessions.

On a brownfield entry (source files exist but no SESSION.md):
```
# Session

phase: 1
task: Surveying existing codebase — extracted ARCHITECTURE.md from stack
last_compaction:
```

On a block:
```
BLOCKED: <phase> — <what failed> — <remediation prompt>
```

On completion:
```
status: complete
```

During a feature loop:
```
feature: <slug>
step: <1-5>
```

## `CONTEXT.md`

Domain glossary only — terms, aliases, relationships, example dialogue.
A glossary, not a spec — per `/domain-modeling`.

Never put stack choices or implementation details here.

## `docs/ARCHITECTURE.md`

Stack, deployment target, data store, auth model, network topology, API/IPC
contracts, design system & UX patterns — with rationale for each choice.

## `docs/ISSUES.md`

Backlog dependency graph produced by Phase 2. Each issue references its
detail file at `.scratch/<feature-slug>/issue.md`.

## `docs/DEPLOYMENT.md`

Deployment guide finalized in Phase 6. Single-command launch instructions,
environment setup, and operational runbook.

## `docs/adr/`

Architectural Decision Records. One file per decision, numbered
sequentially. Produced by `/grill-with-docs` in Phase 1 and updated in
Phase 7 when decisions are superseded.
