# Testing Strategy

Defines the test mix, data management, and quality gates applied during
Phase 3 (Implement) and enforced by CI in Phase 4. Stack-agnostic — the
agent picks the right tools for the project's language and framework.

---

## Test Pyramid

Every issue ships with tests at the appropriate level. The tracer bullet
(Phase 2) defines the e2e path; everything else follows the pyramid.

| Level | Target proportion | Scope | Speed target |
|-------|-------------------|-------|--------------|
| Unit | ~70% of tests | Pure logic — no I/O, no network, no filesystem. Test behavior, not implementation. | <1ms per test |
| Integration | ~20% of tests | Real boundaries — database queries, API handlers, auth flows, file I/O, IPC. | <100ms per test |
| End-to-end | ~10% of tests | Critical user journeys only — signup, login, core transaction, billing. | <5s per test |

### Unit Tests

- One `describe`/`test` per function or method.
- No mocking frameworks unless the boundary is non-deterministic (clock, random,
  network). Prefer fakes over mocks.
- Test the public interface, not internal helpers. If a helper is hard to test
  through the public API, the interface is wrong — refactor the module.
- Every branch of business logic covered. Skip branches that only handle
  framework plumbing (e.g., try/catch that just re-throws).

### Integration Tests

- Test against real infrastructure — a local database, an ephemeral test
  instance, or an in-memory equivalent that matches the production interface.
- Each test sets up its own data and tears it down. No shared mutable state
  between tests.
- Cover: database read/write, API request/response, auth token lifecycle,
  file upload/download, event publish/consume.

### End-to-End Tests

- Cover the tracer bullet path and the top 3-5 critical user journeys only.
- Run against a full deployed environment (or equivalent local compose).
- Assert at the user-visible level: "user sees confirmation page" not
  "div.data-confirmation exists".
- These are slow. Run them in CI on merge to main, not on every push.

---

## Test Data

- **Factories over fixtures.** Every test creates the data it needs through
  a factory function. Fixture files rot — factories encode the invariants.
- **No shared mutable state.** Tests run in any order. Each test seeds and
  cleans up its own data.
- **Deterministic.** No `Date.now()`, `Math.random()`, or `UUID.randomUUID()`
  in test assertions. Inject or freeze time and randomness.

---

## Flaky Tests

- A test that fails without a code change is flaky. Quarantine it immediately
  (skip it, file an issue, and reference the issue number in the skip).
- Fix within 3 working days or delete the test. A flaky test is worse than no
  test — it trains the team to ignore red builds.

---

## Coverage

- No hard percentage gate — coverage tools measure what code was touched, not
  what behavior was verified.
- The standard: every branch of business logic has a test. Every integration
  boundary has a test. Every critical user journey has an e2e test.
- If a coverage tool is available, run it and flag files below 80% as review
  candidates — but never require a number to pass the gate.

---

## Contract Testing

If the platform has service-to-service boundaries (microservices, Workers
calling Workers, backend-to-SDK), add contract tests:
- Provider tests confirm the service honors its published contract.
- Consumer tests confirm callers only depend on the published contract.
- Run both sides in CI; a provider change that breaks a consumer contract
  must fail the build.

---

## Property-Based Testing

Use for parsers, validators, serializers, and any function with this shape:
`(input: A) => B` where you can define invariants that hold for all inputs.

- "Encoding then decoding returns the original" (round-trip)
- "Sorting twice gives the same result as sorting once" (idempotence)
- "No valid input causes a crash" (no exceptions for valid domain)

---

## CI Integration (Phase 4)

The CI pipeline runs:
1. Linter
2. Typechecker
3. Unit tests (parallel where possible)
4. Integration tests
5. E2e tests (on main branch only, or on PRs that touch critical paths)

Block merge on any failure. Fast-fail: lint fails → skip the rest.
