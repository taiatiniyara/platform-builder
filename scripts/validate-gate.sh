#!/usr/bin/env bash
# Validate phase gates by checking artifacts and running verification commands.
# Stack-agnostic: detects Node.js, Python, Go, Rust, and runs equivalent commands.
# Usage: ./scripts/validate-gate.sh <phase>
# Exit 0 if all checks pass, exit 1 if any check fails.

set -euo pipefail

PHASE="${1:-}"
ERRORS=0

if [[ -z "$PHASE" ]]; then
  echo "Usage: validate-gate.sh <phase>"
  exit 1
fi

error() {
  echo "FAIL: $1"
  ERRORS=$((ERRORS + 1))
}

check_file() {
  if [[ ! -f "$1" ]]; then
    error "Missing file: $1"
    return 1
  fi
  return 0
}

check_dir() {
  if [[ ! -d "$1" ]]; then
    error "Missing directory: $1"
    return 1
  fi
  return 0
}

check_nonempty() {
  if [[ ! -s "$1" ]]; then
    error "File is empty: $1"
    return 1
  fi
  return 0
}

# Detect stack
detect_stack() {
  if [[ -f "package.json" ]]; then
    echo "node"
  elif [[ -f "pyproject.toml" ]] || [[ -f "setup.py" ]] || [[ -f "requirements.txt" ]]; then
    echo "python"
  elif [[ -f "go.mod" ]]; then
    echo "go"
  elif [[ -f "Cargo.toml" ]]; then
    echo "rust"
  elif [[ -f "pom.xml" ]] || [[ -f "build.gradle" ]]; then
    echo "java"
  else
    echo "unknown"
  fi
}

STACK=$(detect_stack)
echo "Detected stack: $STACK"

# Run stack-specific command
run_stack_cmd() {
  local cmd_name="$1"
  local description="$2"
  
  case "$STACK" in
    node)
      if [[ -f "package.json" ]] && grep -q "\"$cmd_name\"" package.json; then
        echo "Running $description (npm run $cmd_name)..."
        if ! npm run "$cmd_name" --silent 2>/dev/null; then
          error "$description failed"
        else
          echo "  $description: OK"
        fi
      else
        echo "  $description: skipped (no '$cmd_name' script in package.json)"
      fi
      ;;
    python)
      case "$cmd_name" in
        lint)
          if command -v ruff &>/dev/null; then
            echo "Running $description (ruff check)..."
            if ! ruff check . 2>/dev/null; then
              error "$description failed"
            else
              echo "  $description: OK"
            fi
          elif command -v flake8 &>/dev/null; then
            echo "Running $description (flake8)..."
            if ! flake8 . 2>/dev/null; then
              error "$description failed"
            else
              echo "  $description: OK"
            fi
          else
            echo "  $description: skipped (no linter found)"
          fi
          ;;
        typecheck)
          if command -v mypy &>/dev/null; then
            echo "Running $description (mypy)..."
            if ! mypy . 2>/dev/null; then
              error "$description failed"
            else
              echo "  $description: OK"
            fi
          elif command -v pyright &>/dev/null; then
            echo "Running $description (pyright)..."
            if ! pyright . 2>/dev/null; then
              error "$description failed"
            else
              echo "  $description: OK"
            fi
          else
            echo "  $description: skipped (no typechecker found)"
          fi
          ;;
        test)
          if command -v pytest &>/dev/null; then
            echo "Running $description (pytest)..."
            if ! pytest 2>/dev/null; then
              error "$description failed"
            else
              echo "  $description: OK"
            fi
          else
            echo "  $description: skipped (pytest not found)"
          fi
          ;;
        audit)
          if command -v pip-audit &>/dev/null; then
            echo "Running $description (pip-audit)..."
            if ! pip-audit 2>/dev/null; then
              error "$description found vulnerabilities"
            else
              echo "  $description: OK"
            fi
          else
            echo "  $description: skipped (pip-audit not found)"
          fi
          ;;
      esac
      ;;
    go)
      case "$cmd_name" in
        lint)
          if command -v golangci-lint &>/dev/null; then
            echo "Running $description (golangci-lint)..."
            if ! golangci-lint run 2>/dev/null; then
              error "$description failed"
            else
              echo "  $description: OK"
            fi
          else
            echo "  $description: skipped (golangci-lint not found)"
          fi
          ;;
        typecheck)
          echo "Running $description (go build)..."
          if ! go build ./... 2>/dev/null; then
            error "$description failed"
          else
            echo "  $description: OK"
          fi
          ;;
        test)
          echo "Running $description (go test)..."
          if ! go test ./... 2>/dev/null; then
            error "$description failed"
          else
            echo "  $description: OK"
          fi
          ;;
        audit)
          if command -v govulncheck &>/dev/null; then
            echo "Running $description (govulncheck)..."
            if ! govulncheck ./... 2>/dev/null; then
              error "$description found vulnerabilities"
            else
              echo "  $description: OK"
            fi
          else
            echo "  $description: skipped (govulncheck not found)"
          fi
          ;;
      esac
      ;;
    rust)
      case "$cmd_name" in
        lint)
          echo "Running $description (cargo clippy)..."
          if ! cargo clippy -- -D warnings 2>/dev/null; then
            error "$description failed"
          else
            echo "  $description: OK"
          fi
          ;;
        typecheck)
          echo "Running $description (cargo check)..."
          if ! cargo check 2>/dev/null; then
            error "$description failed"
          else
            echo "  $description: OK"
          fi
          ;;
        test)
          echo "Running $description (cargo test)..."
          if ! cargo test 2>/dev/null; then
            error "$description failed"
          else
            echo "  $description: OK"
          fi
          ;;
        audit)
          if command -v cargo-audit &>/dev/null; then
            echo "Running $description (cargo audit)..."
            if ! cargo audit 2>/dev/null; then
              error "$description found vulnerabilities"
            else
              echo "  $description: OK"
            fi
          else
            echo "  $description: skipped (cargo-audit not found)"
          fi
          ;;
      esac
      ;;
    java)
      case "$cmd_name" in
        lint|typecheck)
          if [[ -f "pom.xml" ]] && command -v mvn &>/dev/null; then
            echo "Running $description (mvn compile)..."
            if ! mvn compile 2>/dev/null; then
              error "$description failed"
            else
              echo "  $description: OK"
            fi
          elif [[ -f "build.gradle" ]] && command -v gradle &>/dev/null; then
            echo "Running $description (gradle build)..."
            if ! gradle build 2>/dev/null; then
              error "$description failed"
            else
              echo "  $description: OK"
            fi
          else
            echo "  $description: skipped (no build tool found)"
          fi
          ;;
        test)
          if [[ -f "pom.xml" ]] && command -v mvn &>/dev/null; then
            echo "Running $description (mvn test)..."
            if ! mvn test 2>/dev/null; then
              error "$description failed"
            else
              echo "  $description: OK"
            fi
          elif [[ -f "build.gradle" ]] && command -v gradle &>/dev/null; then
            echo "Running $description (gradle test)..."
            if ! gradle test 2>/dev/null; then
              error "$description failed"
            else
              echo "  $description: OK"
            fi
          else
            echo "  $description: skipped (no build tool found)"
          fi
          ;;
      esac
      ;;
    *)
      echo "  $description: skipped (unknown stack)"
      ;;
  esac
}

echo "=== Phase $PHASE Gate Validation ==="
echo ""

case "$PHASE" in
  0)
    echo "Checking Phase 0 artifacts..."
    
    # Git
    check_dir ".git" || true
    check_file ".gitignore" || true
    
    # Core files
    check_file "README.md" || true
    check_nonempty "README.md" || true
    check_file "CONTRIBUTING.md" || true
    check_nonempty "CONTRIBUTING.md" || true
    check_file "CHANGELOG.md" || true
    
    # CHANGELOG format
    if check_file "CHANGELOG.md"; then
      if ! grep -q "## \[Unreleased\]" CHANGELOG.md; then
        error "CHANGELOG.md missing [Unreleased] section"
      fi
      if ! grep -q "keepachangelog" CHANGELOG.md; then
        error "CHANGELOG.md doesn't reference keepachangelog.com"
      fi
    fi
    
    # Directory structure
    check_dir "docs" || true
    check_dir "docs/adr" || true
    check_dir "docs/agents" || true
    check_dir "docs/agents/contracts" || true
    check_dir "docs/agents/schemas" || true
    check_dir ".scratch" || true
    
    # Git hooks (check for any pre-commit hook framework)
    if [[ -d ".husky" ]] || [[ -d ".git/hooks" ]]; then
      if [[ -f ".husky/pre-commit" ]] || [[ -f ".git/hooks/pre-commit" ]]; then
        echo "  Pre-commit hook: found"
      else
        error "No pre-commit hook found"
      fi
      if [[ -f ".husky/commit-msg" ]] || [[ -f ".git/hooks/commit-msg" ]]; then
        echo "  Commit-msg hook: found"
      else
        error "No commit-msg hook found"
      fi
      if [[ -f ".husky/pre-push" ]] || [[ -f ".git/hooks/pre-push" ]]; then
        echo "  Pre-push hook: found"
      else
        error "No pre-push hook found"
      fi
    else
      error "No git hook framework found (Husky, lefthook, pre-commit, etc.)"
    fi
    
    # Commitlint (check for any commit message validation)
    if [[ -f "commitlint.config.js" ]] || [[ -f ".commitlintrc.json" ]] || [[ -f ".commitlintrc.yml" ]]; then
      echo "  Commitlint: found"
    else
      echo "  Commitlint: not found (recommended for conventional commits)"
    fi
    
    # State files
    check_file "CONTEXT.md" || true
    check_file "docs/ARCHITECTURE.md" || true
    
    # Run linter
    run_stack_cmd "lint" "Linter"
    
    # Run typechecker
    run_stack_cmd "typecheck" "Typechecker"
    ;;
    
  1)
    echo "Checking Phase 1 artifacts..."
    
    # CONTEXT.md populated
    check_file "CONTEXT.md" || true
    if check_file "CONTEXT.md"; then
      if ! grep -q "## Terms" CONTEXT.md; then
        error "CONTEXT.md missing Terms section"
      fi
      # Check it has more than just the template
      if [[ $(wc -l < CONTEXT.md) -lt 10 ]]; then
        error "CONTEXT.md appears to be just the template"
      fi
    fi
    
    # ARCHITECTURE.md has required sections
    check_file "docs/ARCHITECTURE.md" || true
    if check_file "docs/ARCHITECTURE.md"; then
      for section in "Stack" "Topology" "API" "UI/UX" "Compliance" "Cost" "Documentation"; do
        if ! grep -qi "$section" docs/ARCHITECTURE.md; then
          error "docs/ARCHITECTURE.md missing $section section"
        fi
      done
    fi
    
    # ADRs exist
    check_dir "docs/adr" || true
    if check_dir "docs/adr"; then
      if [[ -z "$(ls -A docs/adr 2>/dev/null)" ]]; then
        error "docs/adr/ is empty (no ADRs)"
      fi
    fi
    ;;
    
  2)
    echo "Checking Phase 2 artifacts..."
    
    # ISSUES.md exists
    check_file "docs/ISSUES.md" || true
    check_nonempty "docs/ISSUES.md" || true
    
    # Issues in .scratch/
    check_dir ".scratch" || true
    if check_dir ".scratch"; then
      if [[ -z "$(find .scratch -name 'issue.md' 2>/dev/null)" ]]; then
        error "No issue.md files found in .scratch/"
      fi
    fi
    
    # Graphify (if source files exist)
    if [[ -d "src" ]] || [[ -d "lib" ]] || [[ -f "package.json" ]] || [[ -f "pyproject.toml" ]] || [[ -f "go.mod" ]] || [[ -f "Cargo.toml" ]]; then
      check_dir "graphify-out" || true
      check_file "graphify-out/graph.json" || true
      check_file "graphify-out/GRAPH_REPORT.md" || true
    fi
    ;;
    
  3)
    echo "Checking Phase 3 artifacts..."
    
    # All tests pass
    run_stack_cmd "test" "Full test suite"
    
    # Linter + typechecker
    run_stack_cmd "lint" "Linter"
    run_stack_cmd "typecheck" "Typechecker"
    
    # CHANGELOG updated
    check_file "CHANGELOG.md" || true
    if check_file "CHANGELOG.md"; then
      # Check for entries beyond [Unreleased]
      if ! grep -q "### Added\|### Changed\|### Fixed" CHANGELOG.md; then
        error "CHANGELOG.md has no entries"
      fi
    fi
    
    # Agent contracts
    check_dir "docs/agents/contracts" || true
    if check_dir "docs/agents/contracts"; then
      if [[ -z "$(ls -A docs/agents/contracts 2>/dev/null)" ]]; then
        error "docs/agents/contracts/ is empty"
      fi
    fi
    
    # Git log check (all issues merged)
    if git rev-parse --git-dir &>/dev/null; then
      echo "Checking git log for merged issues..."
      if ! git log --oneline | grep -q "issue-"; then
        error "No issue branches found in git log"
      fi
    fi
    ;;
    
  4)
    echo "Checking Phase 4 artifacts..."
    
    # CI config (check for any CI system)
    if [[ ! -d ".github/workflows" ]] && [[ ! -f ".gitlab-ci.yml" ]] && [[ ! -f "azure-pipelines.yml" ]] && [[ ! -f "bitbucket-pipelines.yml" ]] && [[ ! -f ".circleci/config.yml" ]] && [[ ! -f "Jenkinsfile" ]]; then
      error "No CI configuration found"
    fi
    
    # Deployment artifacts (check for any deployment config)
    if [[ ! -f "Dockerfile" ]] && [[ ! -f "docker-compose.yml" ]] && [[ ! -f "serverless.yml" ]] && [[ ! -f "serverless.yaml" ]] && [[ ! -f "wrangler.toml" ]] && [[ ! -f "wrangler.json" ]] && [[ ! -f "vercel.json" ]] && [[ ! -f "netlify.toml" ]] && [[ ! -f "fly.toml" ]] && [[ ! -f "railway.json" ]] && [[ ! -f "Procfile" ]] && [[ ! -f "app.yaml" ]]; then
      error "No deployment artifacts found"
    fi
    
    # DEPLOYMENT.md
    check_file "docs/DEPLOYMENT.md" || true
    check_nonempty "docs/DEPLOYMENT.md" || true
    ;;
    
  5)
    echo "Checking Phase 5 artifacts..."
    
    # Schemas documented
    check_dir "docs/agents/schemas" || true
    if check_dir "docs/agents/schemas"; then
      if [[ -z "$(ls -A docs/agents/schemas 2>/dev/null)" ]]; then
        error "docs/agents/schemas/ is empty"
      fi
    fi
    
    # Auth flow documented
    if check_file "docs/ARCHITECTURE.md"; then
      if ! grep -qi "auth" docs/ARCHITECTURE.md; then
        error "docs/ARCHITECTURE.md doesn't mention auth flow"
      fi
    fi
    ;;
    
  6)
    echo "Checking Phase 6 artifacts..."
    
    # Runbooks
    check_dir "docs/runbooks" || true
    if check_dir "docs/runbooks"; then
      if [[ -z "$(ls -A docs/runbooks 2>/dev/null)" ]]; then
        error "docs/runbooks/ is empty"
      fi
    fi
    
    # DEPLOYMENT.md finalized
    check_file "docs/DEPLOYMENT.md" || true
    if check_file "docs/DEPLOYMENT.md"; then
      if ! grep -qi "runbook" docs/DEPLOYMENT.md; then
        error "docs/DEPLOYMENT.md doesn't reference runbooks"
      fi
    fi
    ;;
    
  7)
    echo "Checking Phase 7 artifacts..."
    
    # Graphify rebuilt
    check_dir "graphify-out" || true
    check_file "graphify-out/graph.json" || true
    check_file "graphify-out/GRAPH_REPORT.md" || true
    
    # SESSION.md complete
    check_file "docs/SESSION.md" || true
    if check_file "docs/SESSION.md"; then
      if ! grep -q "status: complete" docs/SESSION.md; then
        error "docs/SESSION.md doesn't have status: complete"
      fi
    fi
    
    # Dependency audit
    run_stack_cmd "audit" "Dependency audit"
    ;;
    
  *)
    echo "Gate validation not automated for phase $PHASE."
    echo "Check the gate criteria in references/phase-checklists.md."
    exit 0
    ;;
esac

echo ""
if [[ $ERRORS -gt 0 ]]; then
  echo "=== VALIDATION FAILED: $ERRORS error(s) ==="
  exit 1
else
  echo "=== Phase $PHASE gate passed ==="
  exit 0
fi
