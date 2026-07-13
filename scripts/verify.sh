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

die() { echo "FAIL: $*"; FAILED=$((FAILED + 1)); }
ok()   { echo "PASS: $*"; PASSED=$((PASSED + 1)); }
warn() { echo "WARN: $*"; }

echo "=== VERIFY ==="
echo ""

# ═══════════════════════════════════════════════════════════════
# PART 1: CODE STANDARDS
# ═══════════════════════════════════════════════════════════════

echo "--- Code Standards ---"

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
mechanical_code_checks

# ═══════════════════════════════════════════════════════════════
# PART 2: DOC UNIFICATION
# ═══════════════════════════════════════════════════════════════

echo ""
echo "--- Doc Unification ---"

# SESSION.md validity
if [ -f "$SESSION_FILE" ]; then
  PHASE=$(grep -E '^Phase:' "$SESSION_FILE" | sed 's/Phase: *//' | xargs)
  STATUS=$(grep -E '^Status:' "$SESSION_FILE" | sed 's/Status: *//' | xargs)
  LAST_ACTIVE=$(grep -E '^Last active:' "$SESSION_FILE" | sed 's/Last active: *//' | xargs)

  [ -z "$PHASE" ] && die "SESSION.md missing Phase" || ok "SESSION.md Phase=$PHASE"
  [ -z "$STATUS" ] && die "SESSION.md missing Status" || ok "SESSION.md Status=$STATUS"
  [ -z "$LAST_ACTIVE" ] && die "SESSION.md missing Last active" || ok "SESSION.md Last active=$LAST_ACTIVE"

  case "$PHASE" in
    1|2|3|4|5|feature) ok "Phase '$PHASE' valid" ;;
    *) die "Phase '$PHASE' invalid (expected 1-5 or feature)" ;;
  esac
  case "$STATUS" in
    in_progress|blocked|complete) ok "Status '$STATUS' valid" ;;
    *) die "Status '$STATUS' invalid" ;;
  esac

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
    case "$link" in
      http://*|https://*) continue ;;
    esac
    link="$(dirname "$doc")/$link"
    link="$(echo "$link" | sed 's|/\./|/|g; s|//\+|/|g')"
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

# UX principles doc
UX_PRINCIPLES="$PROJECT_ROOT/docs/ux-principles.md"
if [ -f "$UX_PRINCIPLES" ]; then
  ok "ux-principles.md exists"
else
  warn "ux-principles.md not found (should exist in Phase 1+)"
fi

# Key standards existence (Phase 3+)
if [ -d "$STANDARDS_DIR" ]; then
  for key_std in UX-STANDARDS.md CODE-QUALITY-STANDARDS.md SECURITY-STANDARDS.md; do
    if [ -f "$STANDARDS_DIR/$key_std" ]; then
      ok "$key_std present in standards/"
    else
      warn "$key_std missing from standards/ — copy from platform-builder skill"
    fi
  done
fi

# ═══════════════════════════════════════════════════════════════
# PART 2.5: GRAPHIFY ENFORCEMENT
# ═══════════════════════════════════════════════════════════════

echo ""
echo "--- Graphify ---"

GRAPHFILE="$PROJECT_ROOT/graphify-out/graph.json"

if [ -n "${PHASE:-}" ] && [ "$PHASE" -ge 3 ] 2>/dev/null; then
  if python3 -c "import graphify" 2>/dev/null; then
    ok "Graphify installed"

    if [ -f "$GRAPHFILE" ]; then
      ok "graph.json exists"

      LAST_GRAPH=$(stat -c %Y "$GRAPHFILE" 2>/dev/null || stat -f %m "$GRAPHFILE" 2>/dev/null)
      NOW=$(date +%s)
      AGE_HOURS=$(( (NOW - LAST_GRAPH) / 3600 ))

      if [ "$AGE_HOURS" -gt 24 ]; then
        die "graph.json is $AGE_HOURS hours stale — run '/graphify . --update'"
      elif [ "$AGE_HOURS" -gt 4 ]; then
        warn "graph.json is $AGE_HOURS hours old — consider running '/graphify . --update'"
      else
        ok "graph.json is fresh ($AGE_HOURS hours old)"
      fi
    else
      die "graph.json not found — run '/graphify .' to build initial graph"
    fi
  else
    die "graphifyy not installed — run: uv tool install graphifyy"
  fi
else
  skip "Graphify not required (Phase ${PHASE:-0})"
fi

# ═══════════════════════════════════════════════════════════════
# PART 3: UX STANDARDS (DESIGN SYSTEM + ACCESSIBILITY)
# ═══════════════════════════════════════════════════════════════

echo ""
echo "--- UX Standards ---"

DESIGN_SYSTEM_DOC="$PROJECT_ROOT/docs/design-system.md"
UX_STANDARDS_FILE="$STANDARDS_DIR/UX-STANDARDS.md"

# UX doc existence
if [ -f "$DESIGN_SYSTEM_DOC" ]; then
  ok "docs/design-system.md exists"
else
  die "docs/design-system.md missing — define design tokens and components before writing UI code"
fi

if [ -f "$UX_STANDARDS_FILE" ]; then
  ok "UX-STANDARDS.md present in standards/"
else
  die "UX-STANDARDS.md missing from standards/"
fi

# Raw hex colors in source (exclude theme/config/design-system files)
RAW_HEX=$(echo "$CHANGED_CONTENT" | grep -E '^\+[^+].*#[0-9a-fA-F]{3,6}' | grep -vE '(theme|config|design-system|tokens|variables|\.json|\.css\.d\.ts)' || echo "")
if [ -n "$RAW_HEX" ]; then
  die "Raw hex colors found — use design system tokens instead. Found: $(echo "$RAW_HEX" | head -3 | tr '\n' ' ')"
else
  ok "No raw hex colors in component code"
fi

# Hardcoded px values in margin/padding/gap (exclude theme files)
RAW_PX=$(echo "$CHANGED_CONTENT" | grep -E '^\+[^+].*(margin|padding|gap|spacing|height|width)\s*[:=]\s*[0-9]+px' | grep -vE '(theme|config|design-system|tokens|variables)' || echo "")
if [ -n "$RAW_PX" ]; then
  warn "Hardcoded px values for spacing found — use design system spacing scale"
else
  ok "No hardcoded px spacing values"
fi

# Hardcoded font sizes (exclude theme files)
RAW_FONT=$(echo "$CHANGED_CONTENT" | grep -E '^\+[^+].*font-size\s*[:=]\s*[0-9.]+(px|rem|em)' | grep -vE '(theme|config|design-system|tokens|variables)' || echo "")
if [ -n "$RAW_FONT" ]; then
  warn "Hardcoded font-size found — use design system typography scale"
else
  ok "No hardcoded font sizes"
fi

# Lorem ipsum in UI code
LOREM=$(echo "$CHANGED_CONTENT" | grep -iE '^\+[^+].*lorem\s+ipsum' || echo "")
if [ -n "$LOREM" ]; then
  die "Lorem ipsum found in changes — replace with real content"
else
  ok "No lorem ipsum"
fi

# Generic loading text (no "Loading..." plain text)
GENERIC_LOADING=$(echo "$CHANGED_CONTENT" | grep -iE '^\+[^+].*["\x27](Loading\.\.\.|loading\.\.\.)["\x27]' || echo "")
if [ -n "$GENERIC_LOADING" ]; then
  warn "Generic 'Loading...' text found — use skeleton, spinner with intent, or progress bar"
else
  ok "No generic loading text"
fi

# Blame/technical error messages
BLAME_ERRORS=$(echo "$CHANGED_CONTENT" | grep -iE '^\+[^+].*(error occurred|something went wrong|an error has occurred|contact support)' || echo "")
if [ -n "$BLAME_ERRORS" ]; then
  warn "Generic error messages found — errors should be gentle, blame-free, with recovery path"
else
  ok "No generic error messages"
fi

# Inline styles in JSX/TSX
INLINE_STYLES=$(echo "$CHANGED_CONTENT" | grep -E '^\+[^+].*style=\{\{' || echo "")
if [ -n "$INLINE_STYLES" ]; then
  warn "Inline style={{}} found — use design system components or CSS modules instead"
else
  ok "No inline styles"
fi

# Unoptimized img tags (missing loading=lazy, srcSet, or next/image equivalent)
UNOPT_IMG=$(echo "$CHANGED_CONTENT" | grep -E '^\+[^+].*<img\s' | grep -vE '(loading="lazy"|srcSet|srcset|Image)' || echo "")
if [ -n "$UNOPT_IMG" ]; then
  warn "Unoptimized <img> tags found — add loading='lazy', srcSet, or use framework image component"
else
  ok "No unoptimized images"
fi

# Touch targets: very small buttons/links (width/height < 44px)
SMALL_TARGETS=$(echo "$CHANGED_CONTENT" | grep -E '^\+[^+].*(width|height|size|minWidth|minHeight|w-|h-)\s*[:=]\s*([0-9]|[1-3][0-9]|40|41|42|43)(px)?' | grep -vE '(font-size|icon|border|stroke|line|badge|dot|indicator)' || echo "")
if [ -n "$SMALL_TARGETS" ]; then
  warn "Possible small touch targets (<44px) — interactive elements need ≥44x44px"
else
  ok "No suspiciously small touch targets"
fi

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
