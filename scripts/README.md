# Scripts

Executable scripts for validation and git safety. All are agent-agnostic — work for humans and AI agents equally.

## Usage

```bash
# Validate a phase gate
./scripts/validate-gate.sh 0

# Check session status
./scripts/session-status.sh
```

## Files

- **validate-gate.sh** — Verify all artifacts for a phase gate. Usage: `./scripts/validate-gate.sh <phase>`. Checks files exist, commands exit 0, and key sections are present. Run before declaring a gate passed.

- **session-status.sh** — Show current session state from `docs/SESSION.md`. Displays phase, active task, last compaction timestamp.

- **pre-push.sh** — Git pre-push hook. Blocks force-push to `main`/`master`, runs full test suite (lint + typecheck + tests) before allowing push. Install to `.husky/pre-push` or `.git/hooks/pre-push`.
