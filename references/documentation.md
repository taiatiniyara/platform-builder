# Documentation Standards

Documentation serves two audiences with different needs. Both are required.

## Agent Documentation

Machine-readable, queryable, structured. The agent's source of truth.

| Artifact | Location | Format | Updated |
|----------|----------|--------|---------|
| Knowledge graph | `graphify-out/` | `graph.json` | Every session (--update) / per phase (full rebuild) |
| API contracts | `docs/agents/contracts/` | OpenAPI, GraphQL SDL, gRPC proto, or typed IDL | Every Phase 3 issue + Feature Loop implement |
| Data model | `docs/agents/schemas/` | JSON Schema, DDL, Prisma, or equivalent | Phase 5 (initial) + every schema change |
| Architecture decisions | `docs/adr/` | Markdown, numbered | Phase 1 + whenever superseded |
| Domain glossary | `CONTEXT.md` | Markdown, terms + aliases + relationships | Whenever domain model changes |

Agent-facing rule: if a concept, interface, or schema exists in code but not
in the graph or agent docs, it is undocumented. The graph is the structural
index — every public module must appear as a graph node.

## Human Documentation

Narrative, tutorial, reference. The human onboarding path.

| Artifact | Location | Updated |
|----------|----------|---------|
| README | `README.md` | Phase 0 (bare), Phase 4 (setup + deploy), every feature |
| Contributing guide | `CONTRIBUTING.md` | Phase 0, Phase 4 (CI instructions) |
| Changelog | `docs/CHANGELOG.md` | Every PR, keepachangelog.com format |
| Deployment guide | `docs/DEPLOYMENT.md` | Phase 4 (initial), Phase 6 (finalized) |
| Runbooks | `docs/runbooks/` | Phase 6 — one per alert (template: `templates/runbook.md`) |
| ADRs | `docs/adr/` | Human-readable rationale for architectural choices |

## Doc Audit (Phase 7 + periodic)

1. **ADR cross-check.** For every ADR in `docs/adr/`, verify the decision
   is reflected in code and ARCHITECTURE.md. File an issue for superseded
   or violated decisions.
2. **Graph coverage.** Query the graph: "Which public modules have no
   corresponding graph node?" File an issue for each gap.
3. **Contract match.** Compare `docs/agents/contracts/` against actual
   endpoint behavior. Run a contract test if the stack supports it.
4. **README walkthrough.** Clone the repo fresh and follow README setup
   instructions. They must succeed without prior knowledge.
5. **Changelog completeness.** Every merged PR since the last release must
   have a CHANGELOG entry.
6. **Runbook coverage.** Every configured alert must have a runbook in
   `docs/runbooks/`. Runbooks must include: symptom description, severity,
   diagnostic steps, remediation steps, escalation path.
