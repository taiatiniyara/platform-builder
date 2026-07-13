# Code Quality Standards

## Applies when

Writing, reviewing, or refactoring any code.

## Checklist

### Code Standards
- [ ] No dead code, unused variables, commented-out code, or speculative features (YAGNI)
- [ ] No console.log/debug statements; no TODO without ticket reference
- [ ] Max 3 levels nesting; max 3 parameters per function; no magic numbers (named constants)
- [ ] No duplication (DRY); single responsibility per function/class
- [ ] Clear, descriptive names; intent obvious from reading; follows codebase patterns
- [ ] No O(n²) where O(n) possible; no blocking ops where async is appropriate

### Testing
- [ ] TDD: tests written first, then implementation
- [ ] Critical paths 100% covered; overall >80%
- [ ] Tests isolated (no shared state); arrange-act-assert pattern
- [ ] Edge cases covered (boundaries, null/undefined, empty, errors)
- [ ] No flaky tests; test suite runs <10 min; parallelized
- [ ] Integration tests for service boundaries; E2E for critical flows
- [ ] Load tests for critical paths; chaos engineering for resilience
- [ ] Test data: factories/fixtures; isolated per test; cleaned up between runs

### Developer Experience
- [ ] One-command setup (make setup, npm run dev); .env.example exists
- [ ] Hot reload enabled; local startup <30s; time to first commit <1h
- [ ] Docker Compose for dependencies; local build parity with CI
- [ ] Incremental builds; CI <10min; caching for deps/artifacts/tests
- [ ] Linting + type checking + pre-commit hooks configured; editor integration (.editorconfig)
- [ ] Source maps (dev + prod); debug configs provided (VS Code/JetBrains)
- [ ] Code generation for common patterns; dependency auto-updates (Dependabot)
- [ ] Onboarding guide: architecture overview, code walkthrough, common task recipes
