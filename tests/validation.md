# Skill Validation Checks

Run these checks to verify the skill is correctly structured.

## Structural

- [ ] `SKILL.md` exists and has valid YAML frontmatter (`name`, `description`)
- [ ] `name` matches the directory name (`platform-builder`)
- [ ] `description` lists triggers without enumerating all delegated skills inline
- [ ] All referenced files exist:
  - [ ] `references/delegated-skills.md`
  - [ ] `references/directives.md`
  - [ ] `references/phases.md`
  - [ ] `references/feature-loop.md`
  - [ ] `references/state-files.md`
  - [ ] `references/code-quality.md`
  - [ ] `references/api-design.md`
  - [ ] `references/testing-strategy.md`
  - [ ] `references/operations.md`
  - [ ] `references/compliance.md`
  - [ ] `references/ui-ux.md`
  - [ ] `references/ui-ux-grill.md`
  - [ ] `references/api-versioning.md`
  - [ ] `references/documentation.md`
  - [ ] `references/skill-prerequisites.md`
  - [ ] `templates/SESSION.md`
  - [ ] `templates/CONTEXT.md`
  - [ ] `templates/ARCHITECTURE.md`
  - [ ] `templates/ISSUES.md`
  - [ ] `templates/DEPLOYMENT.md`
  - [ ] `templates/CONTRIBUTING.md`
  - [ ] `templates/CHANGELOG.md`
  - [ ] `templates/runbook.md`
  - [ ] `scripts/session-status.sh`
  - [ ] `scripts/validate-gate.sh`
  - [ ] `tests/validation.md`

## Content

- [ ] Every phase (0-7) has a checkable gate criterion
- [ ] Every delegated skill is listed in `references/delegated-skills.md` with its phase
- [ ] Directives are factual and actionable (not aspirational)
- [ ] Templates are blank scaffolds, not filled-in examples
- [ ] Scripts are executable (`chmod +x`)

## Invocation

- [ ] Invocation section correctly branches on:
  - No `SESSION.md` → greenfield, Phase 0
  - No `SESSION.md` but source files exist → brownfield, jump to Phase 1
  - Phase < 7 → resume at recorded phase
  - Phase 7 complete → Feature Loop
- [ ] State files documented in `references/state-files.md` match SKILL.md references
- [ ] `last_compaction` semantics defined: update frequency, staleness threshold, yield trigger
- [ ] Feature Loop references only skills needed post-launch (not one-time setup skills)

## Progressive Disclosure

- [ ] SKILL.md is lean — steps reference disclosed files for detail
- [ ] No duplication between SKILL.md and reference files
- [ ] Every context pointer in SKILL.md leads to an existing file

## UI/UX Quality

- [ ] `references/ui-ux.md` defines design tokens with a real palette
- [ ] State coverage table specifies loading, empty, error, success, edge case for every component
- [ ] Anti-patterns list is specific and checkable (not vague "be consistent")
- [ ] Phase 7 UX audit checklist has 13+ concrete, verifiable items
- [ ] ARCHITECTURE.md template UI/UX section references `references/ui-ux.md`
- [ ] Phase 1 gate requires UI/UX template sections filled before advancing
- [ ] Phase 7 gate requires UX audit checklist pass
- [ ] `references/ui-ux-grill.md` exists and its 8 sections cover visual language, IA, mental model, state, screen-level, interaction, and live review
- [ ] Feature Loop grill step (§3) references `references/ui-ux-grill.md` §6‑§7

## Code Quality Gates

- [ ] Phase 3 REFACTOR step references `references/code-quality.md` § "Per-Issue Refactor"
- [ ] Phase 3 REFACTOR step references `references/api-design.md` for endpoint standards
- [ ] Phase 7 includes code quality audit (dead code, duplication, complexity, coupling)

## API Design

- [ ] `references/api-design.md` covers versioning, pagination, error shape, idempotency
- [ ] Phase 1 Blueprint references `references/api-design.md`
- [ ] Phase 5 gate includes idempotency verification

## API Versioning (Write Against Installed)

- [ ] `references/api-versioning.md` defines per-ecosystem verification workflows (Node, Python, Rust, Go)
- [ ] Defines anti-patterns: installing from memory, guessing imports, trusting training data over installed types
- [ ] Directives §7 ("Write Against Installed") references `references/api-versioning.md`
- [ ] Feature Loop Implement step references `references/api-versioning.md`
- [ ] Phase 3 Implement step references `references/api-versioning.md`

## Documentation

- [ ] `references/documentation.md` defines agent artifacts (graph, contracts, schemas, ADRs, glossary) and human artifacts (README, CONTRIBUTING, CHANGELOG, DEPLOYMENT, runbooks, ADRs)
- [ ] Doc audit checklist covers ADR cross-check, graph coverage, contract match, README walkthrough, changelog completeness, runbook coverage
- [ ] Directives §6 ("Documentation") references `references/documentation.md`
- [ ] Feature Loop Implement and Review steps reference `references/documentation.md`
- [ ] Phase 3 Implement step references `references/documentation.md`
- [ ] Phase 7 doc audit references `references/documentation.md` § "Doc Audit"

## Testing Strategy

- [ ] `references/testing-strategy.md` defines test pyramid, test data, flaky test policy
- [ ] Phase 3 applies testing strategy
- [ ] CI pipeline (Phase 4) runs unit → integration → e2e in order

## Operations

- [ ] `references/operations.md` covers environments, monitoring, alerting, DR, performance, cost
- [ ] Phase 4 sets up dev/staging/production environments and preview deployments
- [ ] Phase 6 includes metrics, SLOs, alerting, load testing, DR plan, cost review
- [ ] Phase 7 includes performance audit (no regressions)

## Compliance

- [ ] `references/compliance.md` covers GDPR, data privacy, audit logging, retention, encryption
- [ ] Phase 1 declares compliance posture as an architecture decision
- [ ] Phase 5 verifies compliance checklist items
- [ ] Phase 7 includes compliance audit

## Internationalization

- [ ] `references/ui-ux.md` includes i18n section with concrete strategy options
- [ ] Phase 1 requires explicit i18n decision (now/later/never)
- [ ] Phase 7 includes i18n audit if applicable

## Accessibility

- [ ] `references/ui-ux.md` includes automated accessibility in CI section (§8)
- [ ] Phase 4 wires accessibility checks into CI pipeline

## Circuit Breaker

- [ ] Directives §9 defines: issue depth limit (20), compaction frequency (40 tool calls / 5 issues), staleness threshold (2h), loop detection (3 repeats)
- [ ] `last_compaction` is written to `docs/SESSION.md` by the agent at prescribed intervals
- [ ] `session-status.sh` reads and reports `last_compaction`
- [ ] Stuck-loop rule: same bug across 3 compactions → BLOCKED, no retry
- [ ] Brownfield entry: source files exist → survey stack, build CONTEXT.md from code, skip Phase 0 scaffolding, jump to Phase 1
- [ ] Brownfield gate: ARCHITECTURE.md accurately describes what's already deployed

## Skill Prerequisites

- [ ] `references/skill-prerequisites.md` lists required delegated skills per phase
- [ ] Pre-flight checklist defined: verify availability before entering each phase
- [ ] Core skills (graphify, tdd, codebase-design, grill-with-docs) marked as non-negotiable
- [ ] Optional skills (prototype, design-an-interface, decision-mapping) permit degraded-mode progression
- [ ] `delegated-skills.md` includes `domain-modeling` for brownfield Phase 1
- [ ] `delegated-skills.md` includes `handoff` for circuit breaker yield

## Directives

- [ ] 9 directives defined, all referenced in SKILL.md summary
- [ ] §8 (Prerequisites) references `references/skill-prerequisites.md`
- [ ] §9 (Circuit Breaker) includes brownfield entry rules
