# Multi-Team Coordination

Patterns for organizing teams, ownership, and communication in large
platforms. Apply when 3+ teams work on the same platform.

## When to Apply

- 3+ teams working on the same platform
- Teams need autonomous deployment
- Different teams own different parts of the domain
- Cross-team dependencies exist
- Need to scale beyond Dunbar's number (~150 people)

## Team Topologies

### Team Types

| Team Type | Purpose | Size |
|-----------|---------|------|
| **Stream-Aligned** | Aligned to a business domain; delivers end-to-end | 5-8 engineers |
| **Platform** | Provides internal developer platform; enables stream-aligned teams | 3-5 engineers |
| **Enabling** | Bridges gap between platform and stream-aligned; coaching, mentoring | 2-3 engineers |
| **Complicated-Subsystem** | Builds specialized component (ML, payments, etc.) | 3-5 engineers |

**Stream-Aligned Teams:**
- Own a bounded context (see `ddd.md`)
- Deliver end-to-end value
- Autonomous deployment
- Cross-functional (frontend, backend, QA, etc.)

**Platform Teams:**
- Build internal developer platform (IDP)
- Provide self-service infrastructure
- Reduce cognitive load for stream-aligned teams
- See `platform-engineering.md`

**Enabling Teams:**
- Coach stream-aligned teams
- Share best practices
- Bridge platform and stream-aligned teams
- Temporary (dissolve when teams are self-sufficient)

**Complicated-Subsystem Teams:**
- Build specialized components
- Deep expertise in specific area
- Serve multiple stream-aligned teams

### Team Sizing

**Two-pizza team:** 5-8 engineers (small enough to feed with two pizzas)

**Cognitive load:** team should understand their entire domain

**Span of control:** 1 lead per 5-8 engineers

## Ownership Models

### Code Ownership

| Model | Description | When to Use |
|-------|------------|------------|
| **Strong Ownership** | Only owning team can modify code | Strict boundaries, high expertise needed |
| **Weak Ownership** | Owning team maintains, others can contribute | Collaborative, shared knowledge |
| **Collective Ownership** | Any team can modify any code | Small teams, high trust |

**Recommended:** strong ownership for bounded contexts, weak ownership for shared libraries.

### Data Ownership

Each team owns its data. No shared databases.

**Rules:**
- One team owns each data entity
- Other teams access via APIs (not direct database access)
- Data contracts defined in `docs/agents/schemas/`
- Schema changes require owning team approval

### API Ownership

Each team owns its APIs.

**Rules:**
- API changes are backward-compatible
- Breaking changes require version bump
- API documentation in `docs/agents/contracts/`
- API consumers notified of changes

## Communication Patterns

### Synchronous

| Pattern | When to Use |
|---------|------------|
| **Standup** | Daily sync within team (15 min) |
| **Scrum of Scrums** | Weekly sync between team leads (30 min) |
| **Architecture Review** | Monthly cross-team architecture review (2 hr) |

### Asynchronous

| Pattern | When to Use |
|---------|------------|
| **RFC Process** | Propose major changes (see below) |
| **Design Docs** | Document design decisions |
| **Code Review** | Cross-team code review for shared components |
| **Chat Channels** | Real-time questions, announcements |

### RFC Process

Request for Comments (RFC) for major changes.

**When to write RFC:**
- Breaking API changes
- New bounded context
- Major architectural change
- Cross-team impact

**RFC template:**
```markdown
# RFC: <Title>

## Status
Draft / Under Review / Accepted / Rejected

## Summary
One paragraph summary

## Motivation
Why is this change needed?

## Proposal
Detailed proposal

## Alternatives Considered
What else did you consider?

## Impact
Which teams/services are affected?

## Rollout Plan
How will this be rolled out?

## Open Questions
What needs to be decided?
```

**Process:**
1. Author writes RFC
2. Share with affected teams
3. Collect feedback (1-2 weeks)
4. Revise based on feedback
5. Final decision by architecture review board
6. Document decision in ADR

## Dependency Management

### Cross-Team Dependencies

**Identify dependencies:**
- API dependencies (service A calls service B)
- Data dependencies (service A reads data owned by service B)
- Team dependencies (team A needs team B to do something)

**Manage dependencies:**
- Document in `docs/ISSUES.md` with `Blocked by` field
- Prioritize in team backlogs
- Use RFC process for major dependencies
- Set SLAs for dependency resolution

### Interface Contracts

Define contracts between teams.

**API contracts:**
- OpenAPI spec in `docs/agents/contracts/`
- Versioned (v1, v2, etc.)
- Backward-compatible changes
- Breaking changes require version bump

**Data contracts:**
- JSON Schema in `docs/agents/schemas/`
- Owned by one team
- Changes require owning team approval

**Event contracts:**
- Event schema in `docs/agents/contracts/`
- Immutable (never change past events)
- Add new fields as optional

## Governance

### Architecture Review Board

Cross-team group that reviews major architectural decisions.

**Composition:**
- One representative from each team
- Platform team lead
- CTO/VP Engineering (optional)

**Responsibilities:**
- Review RFCs
- Approve major architectural changes
- Resolve cross-team disputes
- Set architectural standards

**Cadence:** monthly (or as needed)

### Code Review Standards

**Within team:**
- All code reviewed by team member
- Focus on correctness, maintainability

**Cross-team:**
- Required for shared components
- Focus on API compatibility, performance
- Reviewer from owning team

### Documentation Standards

**Required documentation:**
- API documentation (OpenAPI spec)
- Architecture decision records (ADRs)
- Runbooks for critical services
- Onboarding guide for new team members

**Documentation ownership:**
- Each team owns documentation for their services
- Platform team owns platform documentation
- Cross-team documentation owned by architecture review board

## Scaling Patterns

### When to Split a Team

**Signals:**
- Team > 8 engineers
- Team owns multiple bounded contexts
- Team can't deliver end-to-end in 2 weeks
- Communication overhead is high

**How to split:**
- Split by bounded context
- Each new team owns one bounded context
- Platform team supports transition
- Document ownership in `docs/ARCHITECTURE.md`

### When to Merge Teams

**Signals:**
- Team < 3 engineers
- Teams own tightly coupled services
- Communication overhead between teams is high
- Teams have similar domain expertise

**How to merge:**
- Merge by domain (combine related bounded contexts)
- New team owns combined domain
- Platform team supports transition
- Update ownership documentation

## Integration with Platform Builder

### Phase 1 (Blueprint)

- Define team topology (stream-aligned, platform, enabling, subsystem)
- Map teams to bounded contexts
- Define ownership model (code, data, API)
- Document communication patterns
- Set up RFC process

### Phase 2 (Backlog)

- Tag issues with team ownership
- Identify cross-team dependencies
- Prioritize cross-team dependencies

### Phase 3 (Implement)

- Follow ownership model (only modify code you own)
- Use RFC process for cross-team changes
- Cross-team code review for shared components

### Phase 4 (Productionization)

- Set up team-specific CI/CD pipelines
- Configure team-specific monitoring
- Set up team-specific on-call rotation

### Phase 6 (Operations)

- Monitor team velocity
- Track cross-team dependencies
- Review team topology (is it still effective?)

## Anti-Patterns

- **Team Silos:** no communication between teams
- **Shared Ownership:** no one owns the code (tragedy of the commons)
- **Hero Culture:** one person knows everything
- **Too Many Meetings:** communication overhead kills productivity
- **No Platform Team:** stream-aligned teams build infrastructure
- **Weak RFC Process:** major changes happen without review
- **No Documentation:** tribal knowledge only
