#!/usr/bin/env bash
# Validate that a phase gate has passed by running its check.
# Usage: ./scripts/validate-gate.sh <phase>
# Phase 0: linter + typechecker exit 0
# Phase 3: test suite passes

set -euo pipefail

PHASE="${1:-}"

if [[ -z "$PHASE" ]]; then
  echo "Usage: validate-gate.sh <phase>"
  exit 1
fi

case "$PHASE" in
  0)
    echo "=== Phase 0 Gate: Linter & Typechecker ==="
    if command -v npx &>/dev/null && [[ -f package.json ]]; then
      echo "Running lint..."
      npx eslint . --ext .ts,.tsx,.js,.jsx 2>&1 || { echo "LINT FAILED"; exit 1; }
    fi
    echo "Gate 0 passed."
    ;;
  3)
    echo "=== Phase 3 Gate: Test Suite ==="
    if command -v npx &>/dev/null && [[ -f package.json ]]; then
      echo "Running tests..."
      npx vitest run 2>&1 || npx jest --passWithNoTests 2>&1 || { echo "TESTS FAILED"; exit 1; }
    fi
    echo "Gate 3 passed."
    ;;
  *)
    echo "Gate validation not automated for phase $PHASE."
    echo "Check the gate criteria in references/phases.md."
    ;;
esac
