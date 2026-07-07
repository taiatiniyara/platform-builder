# Domain-Driven Design

Strategic design patterns for complex domains. Apply when the domain has
multiple sub-domains, complex business rules, or when services need clear
boundaries.

## When to Apply

- Domain has 3+ distinct sub-domains
- Business rules are complex and evolving
- Multiple teams work on different parts of the domain
- Services need clear ownership boundaries
- Data consistency requirements span multiple aggregates

## Strategic Design

### Sub-Domain Classification

Classify every part of your domain:

| Sub-Domain | Characteristic | Investment |
|-----------|---------------|-----------|
| **Core** | Competitive advantage | Heavy — custom code, best engineers |
| **Supporting** | Necessary but not differentiating | Moderate — configurable or simple custom |
| **Generic** | Commodity | Light — buy or use SaaS |

Document classification in `docs/ARCHITECTURE.md` with rationale.

### Bounded Contexts

A bounded context is a boundary within which a domain model is consistent.
Inside: terms have one meaning. At boundaries: terms may differ.

**Identify bounded contexts by:**
1. Terms that mean different things in different parts of the domain
2. Teams that own different parts of the domain
3. Data that has different consistency requirements
4. Business capabilities that are loosely coupled

**Document each bounded context:**
- Name
- Core concept (one sentence)
- Key entities and value objects
- Business rules (invariants)
- Upstream/downstream relationships
- Owning team

Save to `docs/agents/schemas/contexts/` (one file per context).

### Context Mapping

Define relationships between bounded contexts:

| Pattern | When to Use |
|---------|------------|
| **Partnership** | Two contexts must coordinate; teams agree on interface |
| **Shared Kernel** | Small shared subset; both teams manage it |
| **Customer-Supplier** | Upstream provides, downstream consumes; upstream prioritizes downstream needs |
| **Conformist** | Downstream has no influence; conforms to upstream as-is |
| **Anti-Corruption Layer (ACL)** | Downstream translates upstream model to own model |
| **Open Host Service** | Upstream provides protocol for all downstreams |
| **Published Language** | Upstream publishes schema; downstreams interpret |
| **Separate Ways** | No integration needed; contexts are independent |

Document context map in `docs/ARCHITECTURE.md` with diagram.

## Tactical Design

### Aggregates

An aggregate is a cluster of entities and value objects treated as a unit
for data changes. One aggregate root is the entry point.

**Rules:**
- External objects hold references to the aggregate root only
- Changes within an aggregate must be consistent (single transaction)
- Changes across aggregates are eventually consistent
- Aggregates should be small — prefer many small aggregates over few large ones

**Identify aggregates by:**
1. Business invariants that must be enforced in a single transaction
2. Entities that are created/deleted together
3. True ownership (not just usage) of other entities

Document aggregates per bounded context in `docs/agents/schemas/contexts/`.

### Domain Events

A domain event represents something that happened in the domain. It's a
fact, not a command.

**Naming:** past tense, business-meaningful (e.g., `OrderPlaced`, not
`OrderCreated`).

**Rules:**
- Events are immutable facts
- Events carry data needed by consumers (don't force lookups)
- Events are raised by aggregates
- Events are handled by event handlers (which may call other aggregates)

**When to use:**
- Communicating between aggregates (eventual consistency)
- Communicating between bounded contexts
- Triggering side effects (notifications, analytics)

### Value Objects

A value object has no identity; it's defined by its attributes. Immutable.

**Examples:** `Money`, `Address`, `DateRange`, `Email`.

**Rules:**
- Compare by value, not reference
- Immutable — create new instances instead of mutating
- Self-validating — reject invalid state at construction

### Entities

An entity has identity that persists across state changes.

**Rules:**
- Identity is separate from attributes
- Lifecycle management (creation, modification, deletion)
- Business invariants enforced within the entity

## Integration with Platform Builder

### Phase 1 (Blueprint)

- Classify sub-domains (Core, Supporting, Generic)
- Identify bounded contexts
- Map context relationships
- Document in `docs/ARCHITECTURE.md` with diagram
- Create context files in `docs/agents/schemas/contexts/`

### Phase 2 (Backlog)

- Issues should align with bounded contexts
- Cross-context issues need integration tests
- Tag issues with bounded context for ownership clarity

### Phase 3 (Implement)

- One aggregate per bounded context per issue (avoid cross-aggregate changes)
- Domain events for cross-aggregate communication
- ACLs at context boundaries
- Test invariants at aggregate level

### Phase 7 (Upkeep)

- Audit bounded context boundaries (are they still correct?)
- Check for context drift (terms used inconsistently)
- Review context map (relationships still valid?)

## Anti-Patterns

- **Big Ball of Mud:** no bounded contexts, everything coupled
- **Anemic Domain Model:** entities with no behavior, just getters/setters
- **Transaction Script:** business logic in services, not in domain objects
- **Shared Database:** multiple contexts accessing same tables
- **Distributed Monolith:** microservices that can't be deployed independently
