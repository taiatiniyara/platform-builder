#!/usr/bin/env bash
# Wire into .husky/pre-commit after husky init.
# This runs automated standards checks before every commit.
# If it fails, the commit is blocked.

PROJECT_ROOT="$(git rev-parse --show-toplevel)"
STANDARDS_DIR="$PROJECT_ROOT/standards"

if [ -f "$PROJECT_ROOT/scripts/check-standards.sh" ]; then
  bash "$PROJECT_ROOT/scripts/check-standards.sh" "$STANDARDS_DIR"
  exit_code=$?
  if [ $exit_code -ne 0 ]; then
    echo ""
    echo "Standards check blocked this commit."
    echo "Fix the issues above and try again."
    exit 1
  fi
else
  echo "WARNING: scripts/check-standards.sh not found."
  echo "  Copy it from the platform-builder skill directory:"
  echo "  cp ~/.config/opencode/skills/platform-builder/scripts/check-standards.sh scripts/"
fi
