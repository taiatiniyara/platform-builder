# Templates

Copy these files to create project documentation. Each template has placeholder comments showing what to fill in.

## Usage

```bash
# Example: create SESSION.md for your project
cp templates/SESSION.md docs/SESSION.md
```

## Files

- **SESSION.md** → `docs/SESSION.md` — Phase tracker. Copy the checklist for your current phase here and tick steps.
- **ARCHITECTURE.md** → `docs/ARCHITECTURE.md` — Stack choices, system topology, API contracts, UI/UX decisions, compliance, cost model.
- **CONTEXT.md** → `CONTEXT.md` — Domain glossary only. Terms, relationships, example dialogue.
- **ISSUES.md** → `docs/ISSUES.md` — Backlog dependency graph. Issues with input/output, acceptance criteria, blockers.
- **DEPLOYMENT.md** → `docs/DEPLOYMENT.md` — Deployment guide: environments, CI/CD, runbooks, on-call, disaster recovery.
- **CHANGELOG.md** → `CHANGELOG.md` — Versioned change log in keepachangelog.com format.
- **CONTRIBUTING.md** → `CONTRIBUTING.md` — Setup, development, branching, commit convention, git hooks, CI, releases.
- **runbook.md** → `docs/runbooks/<alert-name>.md` — One runbook per alert. Symptoms, impact, resolution steps.
