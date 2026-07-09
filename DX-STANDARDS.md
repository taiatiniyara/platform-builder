# Developer Experience Standards

## Applies when

Setting up local development, configuring build tools, or creating developer workflows.

## Rules

### Local Setup

- One-command setup (make setup, npm run dev)
- Docker Compose (all dependencies: database, cache, services)
- Environment templates (.env.example with documented variables)
- Hot reload (changes reflect immediately)
- Fast startup (<30 seconds)
- Clear documentation (README with setup, troubleshooting)

### Build Performance

- Incremental builds (only rebuild what changed)
- Caching (dependencies, artifacts, test results)
- Parallel execution (tests, linting, type checking in parallel)
- Build monitoring (track times, alert on regressions)
- Fast CI (<10 minutes for full build)
- Local build parity (local matches CI)

### Debugging

- Source maps (development and production for error tracking)
- Debug configurations (VS Code/JetBrains pre-configured)
- Logging controls (adjustable levels without restart)
- Request inspection (Postman, Insomnia)
- Database inspection (TablePlus, DBeaver)
- Structured errors (stack traces, context, reproduction steps)

### Onboarding

- Time to first commit <1 hour
- Step-by-step onboarding guide
- Architecture overview (diagram with explanations)
- Code walkthrough (guided tour of key paths)
- Common tasks (recipes: add endpoint, add migration)
- Mentorship plan (assigned mentor, regular check-ins)

### Code Quality Tools

- Linting (ESLint, Prettier, Black)
- Type checking (TypeScript, mypy, Flow)
- Pre-commit hooks (linters, formatters, type checkers)
- Editor integration (.editorconfig)
- Code generation (scaffolding for common patterns)
- Dependency management (Dependabot, Renovate)

### Testing Infrastructure

- Fast, reliable test runners
- Coverage reports with clear visibility
- Test data (factories, fixtures, seed data)
- Mock services (isolated testing)
- Watch mode (run tests on file changes)
- Test parallelization (run tests in parallel)

## Checklist

- [ ] One-command setup works
- [ ] Docker Compose configured
- [ ] .env.example exists
- [ ] Hot reload enabled
- [ ] Local startup <30 seconds
- [ ] Incremental builds configured
- [ ] CI <10 minutes
- [ ] Source maps configured
- [ ] Debug configurations provided
- [ ] Time to first commit <1 hour
- [ ] Onboarding guide exists
- [ ] Linting configured
- [ ] Type checking configured
- [ ] Pre-commit hooks configured
- [ ] Code generation tools available
- [ ] Test watch mode enabled

## Anti-patterns

- Manual setup → automate with scripts
- Slow builds (>10 minutes) → optimize with caching, parallelization
- No hot reload → enable hot reload
- Poor error messages → improve error messages
- No debugging tools → add debug configurations
- Inconsistent code style → configure linting/formatting
- No documentation → write documentation
- Flaky tests → fix or remove
- Long onboarding (>1 day) → streamline onboarding
- No code generation → add generators
