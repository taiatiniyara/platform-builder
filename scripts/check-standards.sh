#!/usr/bin/env bash
set -euo pipefail

STANDARDS_DIR="${1:-$PWD/standards}"
STAGED_FILES=$(git diff --cached --name-only 2>/dev/null || echo "")
DIFF_FILES=$(git diff --name-only 2>/dev/null || echo "")
FAILED=0
PASSED=0
declare -A APPLIES

die() { echo "FAIL: $*"; FAILED=$((FAILED + 1)); }
ok()   { echo "PASS: $*"; PASSED=$((PASSED + 1)); }

echo "=== STANDARDS COMPLIANCE CHECK ==="
echo ""

# maps glob patterns to standards files
determine_standards() {
  local files="$1"

  APPLIES=()

  for f in $files; do
    case "$f" in
      *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs)
        APPLIES["CODE-QUALITY"]=1
        APPLIES["TESTING"]=1
        ;;
      *route*|*api*|*handler*|*controller*|*endpoint*|*middleware*)
        APPLIES["API-DESIGN"]=1
        APPLIES["SECURITY"]=1
        APPLIES["PERFORMANCE"]=1
        ;;
      *auth*|*login*|*session*|*token*|*password*|*secret*)
        APPLIES["SECURITY"]=1
        APPLIES["COMPLIANCE"]=1
        ;;
      *.sql|*migration*|*database*|*db*|*query*|*model*|*schema*)
        APPLIES["PERFORMANCE"]=1
        APPLIES["DATA-MANAGEMENT"]=1
        ;;
      *test*|*.test.*|*.spec.*|*__tests__*)
        APPLIES["TESTING"]=1
        ;;
      *docker*|*deploy*|*.yml|*.yaml|Dockerfile|*terraform*|*kubernetes*)
        APPLIES["DEPLOYMENT"]=1
        APPLIES["RELIABILITY"]=1
        ;;
      *component*|*page*|*view*|*.css|*.scss|*.less|*style*|*.html|*.vue|*.svelte)
        APPLIES["UX"]=1
        APPLIES["PERFORMANCE"]=1
        ;;
      *i18n*|*locale*|*translation*|*lang*)
        APPLIES["I18N"]=1
        ;;
      *log*|*metric*|*monitor*|*alert*|*trace*|*observe*|*sentry*|*datadog*)
        APPLIES["OBSERVABILITY"]=1
        ;;
      *worker*|*queue*|*job*|*cron*|*scheduler*)
        APPLIES["BACKGROUND-JOBS"]=1
        ;;
      *search*|*elastic*|*algolia*|*meilisearch*|*typesense*)
        APPLIES["SEARCH"]=1
        ;;
      *notification*|*email*|*sms*|*push*|*webhook*)
        APPLIES["NOTIFICATIONS"]=1
        ;;
      *websocket*|*ws*|*socket*|*realtime*|*live*|*pubsub*)
        APPLIES["REALTIME"]=1
        ;;
      *analytics*|*tracking*|*event*|*telemetry*)
        APPLIES["ANALYTICS"]=1
        ;;
      *doc*|*README*|*.md)
        APPLIES["DOCUMENTATION"]=1
        ;;
      *billing*|*payment*|*pricing*|*subscription*|*stripe*)
        APPLIES["MONETIZATION"]=1
        ;;
      *incident*|*oncall*|*runbook*|*pager*)
        APPLIES["INCIDENT-MANAGEMENT"]=1
        ;;
      *rollout*|*feature-flag*|*launchdarkly*|*flagship*)
        APPLIES["ROLLOUT"]=1
        ;;
      *.env*|*.toml|Makefile|package.json|tsconfig*|eslint*|prettier*)
        APPLIES["DX"]=1
        APPLIES["COST-MANAGEMENT"]=1
        ;;
    esac
  done

  APPLIES["CODE-QUALITY"]=1
  APPLIES["SECURITY"]=1
}

# mechanical checks that can be verified automatically
run_mechanical_checks() {
  echo "--- Mechanical Checks ---"

  # check: no console.log
  if echo "$STAGED_FILES $DIFF_FILES" | grep -qE '\.(ts|tsx|js|jsx|mjs|cjs)$'; then
    if git diff --cached -U0 2>/dev/null | grep -qE '^\+.*console\.(log|warn|error|debug|info)\('; then
      die "console.log/debug statements found in staged changes"
    elif git diff -U0 2>/dev/null | grep -qE '^\+.*console\.(log|warn|error|debug|info)\('; then
      die "console.log/debug statements found in changes"
    else
      ok "No console.log/debug statements"
    fi
  fi

  # check: no TODO without ticket reference
  if git diff -U0 2>/dev/null | grep -qE '^\+.*TODO(?!.*\#[0-9]+|.*GH-[0-9]+|.*TICKET-[0-9]+).*$' 2>/dev/null; then
    die "TODO without ticket reference found (use TODO(#123) or TODO(GH-123))"
  else
    ok "No bare TODOs"
  fi

  # check: no hardcoded secrets (basic pattern scan)
  if git diff -U0 2>/dev/null | grep -qiE '^\+.*(password|secret|api_key|apikey|token)\s*[:=]\s*['\''"][^$]'; then
    die "Possible hardcoded secret detected"
  else
    ok "No obvious hardcoded secrets"
  fi

  # check: no .only in tests
  if git diff -U0 2>/dev/null | grep -qE '^\+.*\.(only|skip)\(' ; then
    die ".only() or .skip() found in tests — remove before commit"
  else
    ok "No .only() / .skip() in tests"
  fi

  # check: no commented-out code (heuristic)
  if git diff -U0 2>/dev/null | grep -qE '^\+[[:space:]]*//[[:space:]]*(function|const|let|var|if|for|while|return|import|export|class)\b'; then
    die "Commented-out code found — delete, git has history"
  else
    ok "No commented-out code"
  fi
}

# print the relevant checklists for the user/agent to verify manually
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
run_mechanical_checks || true

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
  echo "  Pass the path to the platform-builder skill directory as argument:"
  echo "  $0 /path/to/platform-builder"
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
