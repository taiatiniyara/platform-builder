#!/usr/bin/env bash
# Read docs/SESSION.md and report current phase, task, and status.
# Usage: ./scripts/session-status.sh

SESSION_FILE="docs/SESSION.md"

if [[ ! -f "$SESSION_FILE" ]]; then
  echo '{"status": "greenfield", "message": "No SESSION.md found. Start at Phase 0."}'
  exit 0
fi

PHASE=$(grep -oP 'phase:\s*\K\d+' "$SESSION_FILE" 2>/dev/null || echo "")
TASK=$(grep -oP 'task:\s*\K.*' "$SESSION_FILE" 2>/dev/null || echo "")
FEATURE=$(grep -oP 'feature:\s*\K\S+' "$SESSION_FILE" 2>/dev/null || echo "")
COMPLETE=$(grep -c 'status: complete' "$SESSION_FILE" 2>/dev/null || echo "0")
BLOCKED=$(grep -oP 'BLOCKED:\s*\K.*' "$SESSION_FILE" 2>/dev/null || echo "")

if [[ -n "$BLOCKED" ]]; then
  echo "{\"status\": \"blocked\", \"phase\": \"$PHASE\", \"blocked\": \"$BLOCKED\"}"
elif [[ "$COMPLETE" -gt 0 ]]; then
  echo '{"status": "complete", "message": "Phase 7 complete. Use the Feature Loop."}'
elif [[ -n "$FEATURE" ]]; then
  echo "{\"status\": \"feature\", \"feature\": \"$FEATURE\", \"task\": \"$TASK\"}"
elif [[ -n "$PHASE" ]]; then
  echo "{\"status\": \"in_progress\", \"phase\": \"$PHASE\", \"task\": \"$TASK\"}"
else
  echo "{\"status\": \"unknown\", \"message\": \"SESSION.md exists but phase not found.\"}"
fi
