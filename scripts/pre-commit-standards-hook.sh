#!/usr/bin/env bash
PROJECT_ROOT="$(git rev-parse --show-toplevel)"

if [ -f "$PROJECT_ROOT/scripts/verify.sh" ]; then
  bash "$PROJECT_ROOT/scripts/verify.sh" "$PROJECT_ROOT"
  exit_code=$?
  if [ $exit_code -ne 0 ]; then
    echo ""
    echo "Verify blocked this commit. Fix the issues above and try again."
    exit 1
  fi
else
  echo "WARNING: scripts/verify.sh not found."
  echo "  cp ~/.config/opencode/skills/platform-builder/scripts/verify.sh scripts/"
fi
