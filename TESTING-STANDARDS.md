# Testing Standards

## Applies when

Writing any code, creating new features, or fixing bugs.

## Rules

### Unit Testing

- Test-driven development (failing tests first, then implement)
- Coverage: critical paths 100%, overall >80%
- Test isolation (independent tests, no shared state)
- Readable tests (clear names, arrange-act-assert pattern)
- Mock external dependencies (not the unit under test)
- Test edge cases (boundaries, null/undefined, empty collections, errors)

### Integration Testing

- API contract tests (verify request/response schemas)
- Service boundary tests (interactions between services)
- Database tests (queries, transactions, migrations)
- External service tests (third-party integrations with mocks)
- Isolated test environment (reset between tests)
- Test data management (seed data, fixtures, factories)

### End-to-End Testing

- Critical user flows (happy paths and error paths)
- Browser automation (Playwright, Cypress, Selenium)
- Mobile testing (iOS, Android if applicable)
- Cross-browser (Chrome, Firefox, Safari, Edge)
- Test stability (flaky tests are bugs, fix or remove)
- Test speed (parallelize, optimize wait strategies)

### Load Testing

- Test before production (identify bottlenecks)
- Realistic scenarios (real user behavior, not just max load)
- Tools: k6, Locust, JMeter, Artillery
- Metrics: response times, error rates, throughput, resource usage
- Establish baseline, detect regressions
- Stress testing (find breaking point, test recovery)

### Chaos Engineering

- Failure injection (test handling of network, disk, process failures)
- Tools: Chaos Monkey, Gremlin, Litmus
- Game days (scheduled experiments with team)
- Hypothesis-driven (predict behavior, then test)
- Start small, increase blast radius gradually
- Automated rollback (stop if metrics degrade)

### Test Data

- Seed data (consistent across environments)
- Factories (generate programmatically: Faker.js, Factory Bot)
- Fixtures (static data for specific scenarios)
- Data isolation (each test has own data)
- Data cleanup (reset between tests: transactions, truncation)
- Production-like data (anonymized for realistic testing)

## Checklist

- [ ] Tests written first (TDD)
- [ ] Critical paths 100% covered
- [ ] Overall coverage >80%
- [ ] Tests isolated (no shared state)
- [ ] Edge cases tested
- [ ] Integration tests for service boundaries
- [ ] E2E tests for critical flows
- [ ] No flaky tests
- [ ] Tests parallelized
- [ ] Test data managed (factories, fixtures)
- [ ] Load tests for critical paths
- [ ] Test suite runs in <10 minutes

## Anti-patterns

- No tests → write tests first (TDD)
- Only happy path tests → add error path tests
- Tests depend on each other → isolate tests
- Flaky tests → fix or remove
- Testing implementation details → test behavior
- No test data management → use factories/fixtures
- Slow test suite → parallelize, optimize
- No integration tests → add service boundary tests
- No E2E tests → add critical flow tests
- Testing third-party code → mock instead
- Ignoring test failures → fix immediately
