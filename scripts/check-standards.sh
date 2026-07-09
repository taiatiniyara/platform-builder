#!/usr/bin/env bash
set -euo pipefail

if [ "${BASH_VERSINFO[0]:-0}" -lt 4 ]; then
  echo "ERROR: bash 4.0+ required (found ${BASH_VERSION:-unknown})"
  echo "  macOS: brew install bash"
  exit 2
fi

STANDARDS_DIR="${1:-$PWD/standards}"
STAGED_FILES=$(git diff --cached --name-only 2>/dev/null || echo "")
DIFF_FILES=$(git diff --name-only 2>/dev/null || echo "")
CHANGED_CONTENT=$( (git diff --cached -U0 2>/dev/null && git diff -U0 2>/dev/null) || echo "")
FAILED=0
PASSED=0
declare -A APPLIES

die() { echo "FAIL: $*"; FAILED=$((FAILED + 1)); }
ok()   { echo "PASS: $*"; PASSED=$((PASSED + 1)); }

echo "=== STANDARDS COMPLIANCE CHECK ==="
echo ""

dedupe() {
  local key="$1"
  APPLIES["$key"]=1
}

# maps changed file paths to standards files
determine_standards() {
  local files="$1"
  local f

  APPLIES=()
  declare -A APPLIES

  for f in $files; do
    case "$f" in
      *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs)
        dedupe "CODE-QUALITY"
        dedupe "TESTING"
        ;;
      *route*|*api*|*handler*|*controller*|*endpoint*|*middleware*)
        dedupe "API-DESIGN"
        dedupe "SECURITY"
        dedupe "PERFORMANCE"
        ;;
      *auth*|*login*|*session*|*token*|*password*|*secret*)
        dedupe "SECURITY"
        dedupe "COMPLIANCE"
        ;;
      *.sql|*migration*|*database*|*db*|*query*|*model*|*schema*)
        dedupe "PERFORMANCE"
        dedupe "DATA-MANAGEMENT"
        ;;
      *test*|*.test.*|*.spec.*|*__tests__*)
        dedupe "TESTING"
        ;;
      *docker*|*deploy*|*.yml|*.yaml|Dockerfile|*terraform*|*kubernetes*)
        dedupe "DEPLOYMENT"
        dedupe "RELIABILITY"
        ;;
      *component*|*page*|*view*|*.css|*.scss|*.less|*style*|*.html|*.vue|*.svelte)
        dedupe "UX"
        dedupe "PERFORMANCE"
        ;;
      *i18n*|*locale*|*translation*|*lang*)
        dedupe "I18N"
        ;;
      *log*|*metric*|*monitor*|*alert*|*trace*|*observe*|*sentry*|*datadog*)
        dedupe "OBSERVABILITY"
        ;;
      *worker*|*queue*|*job*|*cron*|*scheduler*)
        dedupe "BACKGROUND-JOBS"
        ;;
      *search*|*elastic*|*algolia*|*meilisearch*|*typesense*)
        dedupe "SEARCH"
        ;;
      *notification*|*email*|*sms*|*push*|*webhook*)
        dedupe "NOTIFICATIONS"
        ;;
      *websocket*|*ws*|*socket*|*realtime*|*live*|*pubsub*)
        dedupe "REALTIME"
        ;;
      *analytics*|*tracking*|*event*|*telemetry*)
        dedupe "ANALYTICS"
        ;;
      *doc*|*README*|*.md)
        dedupe "DOCUMENTATION"
        ;;
      *billing*|*payment*|*pricing*|*subscription*|*stripe*)
        dedupe "MONETIZATION"
        ;;
      *incident*|*oncall*|*runbook*|*pager*)
        dedupe "INCIDENT-MANAGEMENT"
        ;;
      *rollout*|*feature-flag*|*launchdarkly*|*flagship*)
        dedupe "ROLLOUT"
        ;;
      *.env*|*.toml|Makefile|package.json|tsconfig*|eslint*|prettier*)
        dedupe "DX"
        dedupe "COST-MANAGEMENT"
        ;;
    esac
  done

  dedupe "CODE-QUALITY"
  dedupe "SECURITY"
}

# mechanical checks verifiable automatically
run_mechanical_checks() {
  echo "--- Mechanical Checks ---"

  # check: no console.log
  if echo "$STAGED_FILES $DIFF_FILES" | grep -qE '\.(ts|tsx|js|jsx|mjs|cjs)$'; then
    if echo "$CHANGED_CONTENT" | grep -qE '^\+[^+].*console\.(log|warn|error|debug|info)\('; then
      die "console.log/debug statements found in changes"
    else
      ok "No console.log/debug statements"
    fi
  else
    ok "No JS/TS files changed"
  fi

  # check: no TODO without ticket reference
  if echo "$CHANGED_CONTENT" | grep -qE '^\+[^+].*TODO\b'; then
    local bare_todos
    bare_todos=$(echo "$CHANGED_CONTENT" | grep -E '^\+[^+].*TODO\b' | grep -vE '(#[0-9]+|GH-[0-9]+|TICKET-[0-9]+)' || echo "")
    if [ -n "$bare_todos" ]; then
      die "TODO without ticket reference found (use TODO(#123) or TODO(GH-123))"
    else
      ok "All TODOs have ticket references"
    fi
  else
    ok "No TODOs in changes"
  fi

  # check: no hardcoded secrets (basic pattern scan)
  if echo "$CHANGED_CONTENT" | grep -qiE '^\+[^+].*(password|secret|api_key|apikey|token)\s*[:=]\s*['"'"'"][^$]'; then
    die "Possible hardcoded secret detected"
  else
    ok "No obvious hardcoded secrets"
  fi

  # check: no .only / .skip in tests
  if echo "$CHANGED_CONTENT" | grep -qE '^\+[^+].*\.(only|skip)\('; then
    die ".only() or .skip() found — remove before commit"
  else
    ok "No .only() / .skip() in tests"
  fi

  # check: no commented-out code (heuristic)
  if echo "$CHANGED_CONTENT" | grep -qE '^\+[^+][[:space:]]*//[[:space:]]*(function|const|let|var|if|for|while|return|import|export|class)\b'; then
    die "Commented-out code found — delete, git has history"
  else
    ok "No commented-out code"
  fi
}

# print the relevant checklists for manual verification
print_manual_checklists() {
  echo ""
  echo "--- Relevant Standards Checklists (verify manually) ---"

  for standard in "${!APPLIES[@]}"; do
    local std_file="$STANDARDS_DIR/$standard-STANDARDS.md"
    if [ -f "$std_file" ]; then
      echo ""
      echo ">>> $standard ($std_file)"
      grep '^\s*- \[ \]' "$std_file" 2>/dev/null || echo "  (no checklist items)"
    fi
  done
}

# main
determine_standards "$STAGED_FILES $DIFF_FILES"
run_mechanical_checks

echo ""
echo "=== APPLICABLE STANDARDS ==="
for standard in "${!APPLIES[@]}"; do
  echo "  - $standard"
done

if [ -d "$STANDARDS_DIR" ]; then
  print_manual_checklists
else
  echo ""
  echo "WARNING: Standards directory '$STANDARDS_DIR' not found."
  echo "  Pass the path containing *-STANDARDS.md files as argument:"
  echo "  $0 /path/to/standards"
fi

echo ""
echo "=== RESULT ==="
echo "Passed: $PASSED"
echo "Failed: $FAILED"
echo ""

if [ "$FAILED" -gt 0 ]; then
  echo "STANDARDS CHECK FAILED. Fix the issues above before committing."
  exit 1
else
  echo "STANDARDS CHECK PASSED."
  exit 0
fi
