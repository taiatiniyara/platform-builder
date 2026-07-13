#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="${1:-$PWD}"
FAILED=0

ok()   { echo "  OK: $*"; }
fail() { echo "FAIL: $*"; FAILED=$((FAILED + 1)); }
skip() { echo "SKIP: $*"; }

echo "=== PLATFORM-BUILDER STARTUP ==="
echo ""

# 1. Skills check
echo "-- Required skills --"
required=(grill-with-docs wayfinder to-tickets implement review grilling domain-modeling prototype tdd code-review setup-matt-pocock-skills)
for skill in "${required[@]}"; do
  if [ -d "$HOME/.agents/skills/$skill" ]; then
    ok "$skill"
  else
    fail "$skill — run: npx skills add mattpocock/skills -y -g"
  fi
done

echo ""
echo "-- Project health --"

# 2. SESSION.md
SESSION_FILE="$PROJECT_ROOT/docs/SESSION.md"
if [ -f "$SESSION_FILE" ]; then
  PHASE=$(grep -E '^Phase:' "$SESSION_FILE" | sed 's/Phase: *//' | xargs)
  ok "SESSION.md exists (Phase $PHASE)"
else
  HAS_CODE=false
  for dir in src lib app packages; do
    if [ -d "$PROJECT_ROOT/$dir" ] && [ -n "$(ls -A "$PROJECT_ROOT/$dir" 2>/dev/null)" ]; then
      HAS_CODE=true; break
    fi
  done
  if [ -f "$PROJECT_ROOT/package.json" ] || [ -f "$PROJECT_ROOT/pyproject.toml" ] || [ -f "$PROJECT_ROOT/Cargo.toml" ]; then
    HAS_CODE=true
  fi
  if [ "$HAS_CODE" = true ]; then
    fail "SESSION.md not found — this looks like an existing project. Run platform-builder bootstrap mode: create docs/SESSION.md with Phase=2 and follow the Bootstrap section in SKILL.md"
  else
    fail "SESSION.md not found at $SESSION_FILE"
  fi
fi

# 3. Standards files
STANDARDS_DIR="$PROJECT_ROOT/standards"
if [ -d "$STANDARDS_DIR" ] && [ -n "$(ls -A "$STANDARDS_DIR" 2>/dev/null)" ]; then
  count=$(ls -1 "$STANDARDS_DIR"/*-STANDARDS.md 2>/dev/null | wc -l)
  ok "Standards dir: $count files"
else
  fail "standards/ missing or empty — run Phase 3 tooling setup"
fi

# 4. Scripts
for script in verify.sh; do
  if [ -f "$PROJECT_ROOT/scripts/$script" ]; then
    ok "scripts/$script"
  else
    fail "scripts/$script missing"
  fi
done

# 5. Pre-commit hook
if [ -f "$PROJECT_ROOT/.husky/pre-commit" ]; then
  if grep -q "pre-commit-standards-hook" "$PROJECT_ROOT/.husky/pre-commit" 2>/dev/null; then
    ok "Pre-commit hook wired"
  else
    fail "Pre-commit hook not wired to standards hook"
  fi
else
  fail ".husky/pre-commit missing"
fi

# 6. Graphify (required Phase 3+, or Phase 2 with existing code)
GRAPH_REQUIRED=false
if [ -n "${PHASE:-}" ] && [ "$PHASE" -ge 3 ] 2>/dev/null; then
  GRAPH_REQUIRED=true
elif [ "${PHASE:-}" = "2" ] 2>/dev/null; then
  HAS_CODE=false
  for dir in src lib app packages; do
    if [ -d "$PROJECT_ROOT/$dir" ] && [ -n "$(ls -A "$PROJECT_ROOT/$dir" 2>/dev/null)" ]; then
      HAS_CODE=true; break
    fi
  done
  [ -f "$PROJECT_ROOT/package.json" ] || [ -f "$PROJECT_ROOT/pyproject.toml" ] || [ -f "$PROJECT_ROOT/Cargo.toml" ] && HAS_CODE=true
  [ "$HAS_CODE" = true ] && GRAPH_REQUIRED=true
fi

if [ "$GRAPH_REQUIRED" = true ]; then
  if python3 -c "import graphify" 2>/dev/null; then
    ok "Graphify installed"
    if [ -f "$PROJECT_ROOT/graphify-out/graph.json" ]; then
      ok "Graph exists"
      LAST_GRAPH=$(stat -c %Y "$PROJECT_ROOT/graphify-out/graph.json" 2>/dev/null || stat -f %m "$PROJECT_ROOT/graphify-out/graph.json" 2>/dev/null)
      NOW=$(date +%s)
      AGE=$(( (NOW - LAST_GRAPH) / 3600 ))
      if [ "$AGE" -gt 24 ]; then
        fail "Graph is $AGE hours stale — run '/graphify . --update' before proceeding"
      else
        ok "Graph fresh ($AGE hours old)"
      fi
    else
      fail "No graph found at graphify-out/graph.json — run '/graphify .' to build"
    fi
  else
    fail "Graphify not installed — run: uv tool install graphifyy"
  fi
else
  skip "Graphify not required until Phase 3 (current: ${PHASE:-0})"
fi

echo ""
echo "=== RESULT ==="
if [ "$FAILED" -gt 0 ]; then
  echo "STARTUP FAILED ($FAILED issue(s)) — fix above before proceeding."
  exit 1
fi
echo "STARTUP OK — session ready."
exit 0
