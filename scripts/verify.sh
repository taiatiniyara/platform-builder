#!/usr/bin/env bash
set -euo pipefail

if [ "${BASH_VERSINFO[0]:-0}" -lt 4 ]; then
  echo "ERROR: bash 4.0+ required (found ${BASH_VERSION:-unknown})"
  exit 2
fi

PROJECT_ROOT="${1:-$PWD}"
STANDARDS_DIR="$PROJECT_ROOT/standards"
SESSION_FILE="$PROJECT_ROOT/docs/SESSION.md"
CONTEXT_FILE="$PROJECT_ROOT/docs/CONTEXT.md"
ADR_DIR="$PROJECT_ROOT/docs/adr"
STAGED_FILES=$(git diff --cached --name-only 2>/dev/null || echo "")
DIFF_FILES=$(git diff --name-only 2>/dev/null || echo "")
CHANGED_CONTENT=$( (git diff --cached -U0 2>/dev/null && git diff -U0 2>/dev/null) || echo "")
FAILED=0
PASSED=0
declare -A APPLIES

die() { echo "FAIL: $*"; FAILED=$((FAILED + 1)); }
ok()   { echo "PASS: $*"; PASSED=$((PASSED + 1)); }
warn() { echo "WARN: $*"; }

echo "=== VERIFY ==="
echo ""

# ═══════════════════════════════════════════════════════════════
# PART 1: CODE STANDARDS
# ═══════════════════════════════════════════════════════════════

echo "--- Code Standards ---"

dedupe() { APPLIES["$1"]=1; }

determine_standards() {
  local files="$1" f
  APPLIES=()
  declare -A APPLIES

  for f in $files; do
    case "$f" in
      *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs)
        dedupe "CODE-QUALITY"; dedupe "TESTING" ;;
      *route*|*api*|*handler*|*controller*|*endpoint*|*middleware*)
        dedupe "API-DESIGN"; dedupe "SECURITY"; dedupe "PERFORMANCE" ;;
      *auth*|*login*|*session*|*token*|*password*|*secret*)
        dedupe "SECURITY"; dedupe "COMPLIANCE" ;;
      *.sql|*migration*|*database*|*db*|*query*|*model*|*schema*)
        dedupe "PERFORMANCE"; dedupe "DATA-MANAGEMENT" ;;
      *test*|*.test.*|*.spec.*|*__tests__*)
        dedupe "TESTING" ;;
      *docker*|*deploy*|*.yml|*.yaml|Dockerfile|*terraform*|*kubernetes*)
        dedupe "DEPLOYMENT"; dedupe "RELIABILITY" ;;
      *component*|*page*|*view*|*.css|*.scss|*.less|*style*|*.html|*.vue|*.svelte)
        dedupe "UX"; dedupe "PERFORMANCE" ;;
      *i18n*|*locale*|*translation*|*lang*)
        dedupe "I18N" ;;
      *log*|*metric*|*monitor*|*alert*|*trace*|*observe*|*sentry*|*datadog*)
        dedupe "OBSERVABILITY" ;;
      *worker*|*queue*|*job*|*cron*|*scheduler*)
        dedupe "BACKGROUND-JOBS" ;;
      *search*|*elastic*|*algolia*|*meilisearch*|*typesense*)
        dedupe "SEARCH" ;;
      *notification*|*email*|*sms*|*push*|*webhook*)
        dedupe "NOTIFICATIONS" ;;
      *websocket*|*ws*|*socket*|*realtime*|*live*|*pubsub*)
        dedupe "REALTIME" ;;
      *analytics*|*tracking*|*event*|*telemetry*)
        dedupe "ANALYTICS" ;;
      *doc*|*README*|*.md)
        dedupe "DOCUMENTATION" ;;
      *billing*|*payment*|*pricing*|*subscription*|*stripe*)
        dedupe "MONETIZATION" ;;
      *incident*|*oncall*|*runbook*|*pager*)
        dedupe "INCIDENT-MANAGEMENT" ;;
      *rollout*|*feature-flag*|*launchdarkly*|*flagship*)
        dedupe "ROLLOUT" ;;
      *.env*|*.toml|Makefile|package.json|tsconfig*|eslint*|prettier*)
        dedupe "DX"; dedupe "COST-MANAGEMENT" ;;
    esac
  done
  dedupe "CODE-QUALITY"
  dedupe "SECURITY"
}

mechanical_code_checks() {
  if echo "$STAGED_FILES $DIFF_FILES" | grep -qE '\.(ts|tsx|js|jsx|mjs|cjs)$'; then
    if echo "$CHANGED_CONTENT" | grep -qE '^\+[^+].*console\.(log|warn|error|debug|info)\('; then
      die "console statements found in changes"
    else
      ok "No console statements"
    fi
  fi

  if echo "$CHANGED_CONTENT" | grep -qE '^\+[^+].*TODO\b'; then
    bare_todos=$(echo "$CHANGED_CONTENT" | grep -E '^\+[^+].*TODO\b' | grep -vE '(#[0-9]+|GH-[0-9]+|TICKET-[0-9]+)' || echo "")
    [ -n "$bare_todos" ] && die "TODO without ticket ref" || ok "TODOs have ticket refs"
  fi

  if echo "$CHANGED_CONTENT" | grep -qiE '^\+[^+].*(password|secret|api_key|apikey|token)\s*[:=]\s*['"'"'"][^$]'; then
    die "Possible hardcoded secret"
  else
    ok "No hardcoded secrets"
  fi

  if echo "$CHANGED_CONTENT" | grep -qE '^\+[^+].*\.(only|skip)\('; then
    die ".only()/.skip() found — remove before commit"
  else
    ok "No .only()/.skip() in tests"
  fi

  if echo "$CHANGED_CONTENT" | grep -qE '^\+[^+][[:space:]]*//[[:space:]]*(function|const|let|var|if|for|while|return|import|export|class)\b'; then
    die "Commented-out code — delete, git has history"
  else
    ok "No commented-out code"
  fi
}

print_applicable_standards() {
  echo ""
  for standard in "${!APPLIES[@]}"; do
    echo "  - $standard"
  done
  if [ -d "$STANDARDS_DIR" ]; then
    echo ""
    echo "--- Relevant Checklist Items (verify manually) ---"
    for standard in "${!APPLIES[@]}"; do
      local std_file="$STANDARDS_DIR/$standard-STANDARDS.md"
      if [ -f "$std_file" ]; then
        echo ""
        echo ">>> $standard"
        grep '^\s*- \[ \]' "$std_file" 2>/dev/null || echo "  (no checklist items)"
      fi
    done
  fi
}

determine_standards "$STAGED_FILES $DIFF_FILES"
mechanical_code_checks

echo ""
echo "--- Applicable Standards ---"
print_applicable_standards

# ═══════════════════════════════════════════════════════════════
# PART 2: DOC UNIFICATION
# ═══════════════════════════════════════════════════════════════

echo ""
echo "--- Doc Unification ---"

# SESSION.md validity
if [ -f "$SESSION_FILE" ]; then
  PHASE=$(grep -E '^Phase:' "$SESSION_FILE" | sed 's/Phase: *//' | tr -d '[:space:]')
  STATUS=$(grep -E '^Status:' "$SESSION_FILE" | sed 's/Status: *//' | tr -d '[:space:]')
  LAST_ACTIVE=$(grep -E '^Last active:' "$SESSION_FILE" | sed 's/Last active: *//' | tr -d '[:space:]')

  [ -z "$PHASE" ] && die "SESSION.md missing Phase" || ok "SESSION.md Phase=$PHASE"
  [ -z "$STATUS" ] && die "SESSION.md missing Status" || ok "SESSION.md Status=$STATUS"
  [ -z "$LAST_ACTIVE" ] && die "SESSION.md missing Last active" || ok "SESSION.md Last active=$LAST_ACTIVE"

  echo "1 2 3 4 5 feature" | grep -qw "$PHASE" && ok "Phase '$PHASE' valid" || die "Phase '$PHASE' invalid"
  echo "in_progress blocked complete" | grep -qw "$STATUS" && ok "Status '$STATUS' valid" || die "Status '$STATUS' invalid"

  if ! grep -q '^## Doc consistency' "$SESSION_FILE" 2>/dev/null; then
    die "SESSION.md missing ## Doc consistency section"
  else
    ok "SESSION.md has Doc consistency section"
  fi
else
  die "SESSION.md not found at $SESSION_FILE"
fi

# Phase vs filesystem
if [ -f "$SESSION_FILE" ]; then
  case "$PHASE" in
    1)
      [ ! -f "$CONTEXT_FILE" ] && warn "Phase 1: CONTEXT.md not yet created"
      ;;
    2)
      [ ! -f "$CONTEXT_FILE" ] && die "Phase $PHASE but no CONTEXT.md" || ok "CONTEXT.md exists"
      [ ! -d "$ADR_DIR" ] || [ -z "$(ls -A "$ADR_DIR" 2>/dev/null)" ] && die "Phase $PHASE but no ADRs" || ok "ADRs exist"
      ;;
    3|4|5|feature)
      [ ! -f "$CONTEXT_FILE" ] && die "Phase $PHASE but no CONTEXT.md" || ok "CONTEXT.md exists"
      [ -d "$STANDARDS_DIR" ] && [ -n "$(ls -A "$STANDARDS_DIR" 2>/dev/null)" ] && ok "Standards dir exists" || warn "No standards dir (expected Phase 3+)"
      ;;
  esac
fi

# CONTEXT.md term count
if [ -f "$CONTEXT_FILE" ]; then
  TERM_COUNT=$(grep -cE '^\*\*' "$CONTEXT_FILE" 2>/dev/null || echo "0")
  [ "$TERM_COUNT" -lt 3 ] && warn "CONTEXT.md has <3 terms (expect ≥5)" || ok "CONTEXT.md: $TERM_COUNT terms"
fi

# ADR integrity
if [ -d "$ADR_DIR" ] && [ -n "$(ls -A "$ADR_DIR" 2>/dev/null)" ]; then
  ADR_INDEX="$ADR_DIR/README.md"
  [ ! -f "$ADR_INDEX" ] && die "ADR index missing ($ADR_INDEX)" || ok "ADR index exists"

  for adr in "$ADR_DIR"/*.md; do
    [ "$adr" = "$ADR_INDEX" ] && continue
    adr_name=$(basename "$adr")
    if [ -f "$ADR_INDEX" ] && ! grep -q "$adr_name" "$ADR_INDEX" 2>/dev/null; then
      die "ADR $adr_name not in index"
    else
      ok "ADR $adr_name indexed"
    fi
  done
fi

# Cross-doc links
ALL_DOCS=$(find "$PROJECT_ROOT/docs" -name "*.md" -not -path "*/.git/*" 2>/dev/null || echo "")
ALL_DOCS="$ALL_DOCS $(find "$PROJECT_ROOT" -maxdepth 1 -name "README.md" 2>/dev/null || echo "")"
for doc in $ALL_DOCS; do
  [ -z "$doc" ] && continue
  STALE_LINKS=$(grep -oE '\[([^]]*)\]\(([^)]*\.md)\)' "$doc" 2>/dev/null | grep -oE '\([^)]+\)' | tr -d '()' || echo "")
  for link in $STALE_LINKS; do
    link="$PROJECT_ROOT/$link"
    link="$(echo "$link" | sed 's|/\./|/|g')"
    [ ! -f "$link" ] && die "Broken link in $(basename "$doc"): $link"
  done
done

# Orphan docs
for doc in $ALL_DOCS; do
  [ -z "$doc" ] && continue
  doc_name=$(basename "$doc")
  case "$doc_name" in
    SESSION.md|CONTEXT.md|README.md|adr/*) continue ;;
  esac
  REFERENCED=false
  for other in $ALL_DOCS; do
    [ -z "$other" ] || [ "$doc" = "$other" ] && continue
    if grep -qF "$doc_name" "$other" 2>/dev/null; then REFERENCED=true; break; fi
  done
  [ "$REFERENCED" = false ] && warn "Orphan doc: $doc_name"
done

# ═══════════════════════════════════════════════════════════════
# RESULT
# ═══════════════════════════════════════════════════════════════

echo ""
echo "=== RESULT ==="
echo "Passed: $PASSED  Failed: $FAILED"
echo ""

if [ "$FAILED" -gt 0 ]; then
  echo "VERIFY FAILED. Fix all issues above before proceeding."
  exit 1
fi

echo "VERIFY PASSED."
exit 0
