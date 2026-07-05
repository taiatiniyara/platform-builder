#!/usr/bin/env bash
# Read docs/SESSION.md and report current phase, task, and status.
# Usage: ./scripts/session-status.sh

set -euo pipefail

SESSION_FILE="docs/SESSION.md"

if [[ ! -f "$SESSION_FILE" ]]; then
  echo '{"status": "greenfield", "message": "No SESSION.md found. Start at Phase 0."}'
  exit 0
fi

PHASE=$(grep -E 'phase:' "$SESSION_FILE" 2>/dev/null | sed -E 's/.*phase:\s*//;s/[^0-9].*//' | head -1 || true)
TASK=$(grep -E 'task:' "$SESSION_FILE" 2>/dev/null | sed -E 's/.*task:\s*//' | head -1 || true)
FEATURE=$(grep -E 'feature:' "$SESSION_FILE" 2>/dev/null | sed -E 's/.*feature:\s*//;s/\s.*//' | head -1 || true)
LAST_COMPACTION=$(grep -E 'last_compaction:' "$SESSION_FILE" 2>/dev/null | sed -E 's/.*last_compaction:\s*//' | head -1 || true)

# grep -c exits 1 on no match; capture safely
COMPLETE=$(grep -c 'status: complete' "$SESSION_FILE" 2>/dev/null || true)
COMPLETE="${COMPLETE:-0}"

BLOCKED=$(grep -E 'BLOCKED:' "$SESSION_FILE" 2>/dev/null | sed -E 's/.*BLOCKED:\s*//' | head -1 || true)

if [[ -n "$BLOCKED" ]]; then
  echo "{\"status\": \"blocked\", \"phase\": \"$PHASE\", \"blocked\": \"$BLOCKED\"}"
elif [[ "$COMPLETE" -gt 0 ]]; then
  echo "{\"status\": \"complete\", \"message\": \"Phase 7 complete. Use the Feature Loop.\"}"
elif [[ -n "$FEATURE" ]]; then
  echo "{\"status\": \"feature\", \"feature\": \"$FEATURE\", \"task\": \"$TASK\"}"
elif [[ -n "$PHASE" ]]; then
  echo "{\"status\": \"in_progress\", \"phase\": \"$PHASE\", \"task\": \"$TASK\", \"last_compaction\": \"$LAST_COMPACTION\"}"
else
  echo "{\"status\": \"unknown\", \"message\": \"SESSION.md exists but phase not found.\"}"
fi
