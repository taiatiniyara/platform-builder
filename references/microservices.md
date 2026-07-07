# Microservices Architecture

Design patterns for distributed service architectures. Apply when you have
multiple teams, independent deployment needs, or different scaling requirements.

## Tool Selection

This file describes **patterns**, not specific tools. Tools mentioned are
**examples** to illustrate the pattern — not recommendations. When selecting
tools for this project, the agent MUST:
1. Check `docs/ARCHITECTURE.md` for the declared stack
2. Research current options (never suggest from memory)
3. Present 2-3 options with trade-offs
4. Let the user decide

## When to Apply

- 5+ services with independent lifecycles
- Multiple teams need autonomous deployment
- Different parts of the system have different scaling requirements
- Technology diversity is needed (different languages/databases per service)
- Team size > 8 engineers (Conway's Law)

**Don't apply when:**
- Single team < 5 engineers
- Simple CRUD application
- Strong consistency requirements across all data
- Team lacks distributed systems experience

## Service Decomposition

### Decomposition Strategies

| Strategy | When to Use |
|----------|------------|
| **By Bounded Context** | DDD bounded contexts exist (see `ddd.md`) |
| **By Business Capability** | Map to business functions (e.g., Order, Payment, Inventory) |
| **By Subdomain** | Split by business subdomain (Core, Supporting, Generic) |
| **By Data** | Split by data ownership (each service owns its data) |

**Rules:**
- Each service owns its data (no shared databases)
- Each service has a single responsibility
- Services communicate via well-defined APIs
- Services can be deployed independently

### Service Boundaries

**Size guidelines:**
- Small: 1-3 engineers, 1-2 weeks to deploy
- Medium: 3-5 engineers, 2-4 weeks to deploy
- Large: 5-8 engineers, 1+ month to deploy (consider splitting)

**Boundary signals:**
- Different scaling requirements (CPU vs memory intensive)
- Different release cadences
- Different teams owning different parts
- Different data consistency requirements
- Different technology needs

## Communication Patterns

### Synchronous

| Pattern | Use When | Trade-offs |
|---------|----------|-----------|
| **REST/HTTP** | Simple CRUD, external APIs | Easy to understand, but tight coupling |
| **gRPC** | High-performance internal calls | Fast, typed, but requires protobuf |
| **GraphQL** | Flexible data fetching (frontend) | Powerful, but complex caching |

### Asynchronous

| Pattern | Use When | Trade-offs |
|---------|----------|-----------|
| **Message Queue** | Point-to-point, work distribution | Decoupled, but eventual consistency |
| **Event Bus** | Broadcast to multiple consumers | Highly decoupled, but harder to debug |
| **Event Streaming** | Long-lived event log, replay | Durable, replayable, but complex |

**Decision tree:**
1. Do you need immediate response? → Synchronous
2. Can the caller wait? → Asynchronous
3. Multiple consumers need the event? → Event Bus/Streaming
4. Single consumer, work queue? → Message Queue
5. Need replay/audit trail? → Event Streaming

### API Gateway

An API gateway is a single entry point for clients. It routes requests to
appropriate services.

**Responsibilities:**
- Request routing
- Authentication/authorization
- Rate limiting
- Request/response transformation
- Protocol translation (REST ↔ gRPC)
- Caching
- Circuit breaking

**When to use:**
- Multiple services with different APIs
- Need centralized auth/rate limiting
- Clients need simplified interface
- Mobile/web clients need different responses

**Don't use when:**
- Single service or monolith
- Services already have consistent APIs
- Gateway becomes a bottleneck

## Resilience Patterns

### Circuit Breaker

Prevents cascading failures by detecting when a service is failing and
failing fast.

**States:**
- **Closed:** requests flow normally
- **Open:** requests fail immediately (no call to downstream)
- **Half-Open:** limited requests test if service recovered

**Configuration:**
- Failure threshold: 5 failures in 60 seconds
- Open duration: 30 seconds
- Half-open requests: 3 test requests

**Libraries:**
- Node.js: `opossum`, `circuitbreaker`
- Python: `pybreaker`, `circuitbreaker`
- Go: `sony/gobreaker`, `rubyist/circuitbreaker`

### Retry with Backoff

Retry failed requests with exponential backoff to handle transient failures.

**Rules:**
- Only retry idempotent operations (GET, PUT, DELETE)
- Use exponential backoff with jitter
- Set max retries (3-5)
- Set timeout per attempt

**Example:**
```
Attempt 1: immediate
Attempt 2: wait 1s + jitter
Attempt 3: wait 2s + jitter
Attempt 4: wait 4s + jitter
Give up
```

### Timeout

Set timeouts on all external calls to prevent resource exhaustion.

**Guidelines:**
- HTTP calls: 5-30 seconds (depending on operation)
- Database queries: 1-5 seconds
- gRPC calls: 5-30 seconds
- Message publishing: 1-5 seconds

**Rules:**
- Always set timeouts (no infinite waits)
- Timeout should be > expected latency but < resource exhaustion
- Different timeouts for different operations (read vs write)

### Bulkhead

Isolate failures by partitioning resources (connection pools, thread pools).

**Example:**
- Separate connection pools for different services
- Separate thread pools for different operations
- Separate rate limits for different clients

### Fallback

Provide alternative behavior when a service is unavailable.

**Strategies:**
- Return cached data
- Return default value
- Return degraded response
- Queue request for later processing

## Data Management

### Database per Service

Each service owns its database. No shared databases.

**Benefits:**
- Loose coupling
- Independent scaling
- Technology choice per service
- Easier to understand data ownership

**Challenges:**
- Distributed transactions (use sagas)
- Data consistency (eventual consistency)
- Cross-service queries (CQRS, API composition)

### Distributed Transactions

**Two-Phase Commit (2PC):**
- Strong consistency
- Blocking protocol
- Poor performance at scale
- **Avoid for most cases**

**Saga Pattern:**
- Eventual consistency
- Non-blocking
- Each step has a compensating transaction
- **Preferred for most cases**

See `event-driven.md` for saga details.

### Cross-Service Queries

**API Composition:**
- API gateway calls multiple services
- Aggregates results
- Simple but can be slow

**CQRS (Command Query Responsibility Segregation):**
- Separate read model from write model
- Read model is denormalized for queries
- Event-driven updates to read model
- Better performance for complex queries

See `event-driven.md` for CQRS details.

## Deployment

### Independent Deployment

Each service can be deployed independently without affecting other services.

**Requirements:**
- No shared databases
- Backward-compatible API changes
- Feature flags for risky changes
- Automated testing per service
- Blue-green or canary deployments

### Service Discovery

Services need to find each other in dynamic environments.

**Patterns:**
- **Client-side discovery:** client queries registry, chooses instance
- **Server-side discovery:** load balancer queries registry
- **DNS-based:** use DNS for service names

**Tools:**
- Consul
- etcd
- Kubernetes Services
- AWS Cloud Map

### Configuration Management

Each service needs its own configuration.

**Strategies:**
- Environment variables (simple)
- Configuration service (centralized)
- Git-based configuration (version controlled)

**Rules:**
- Never store secrets in configuration files
- Use secrets manager (Vault, AWS Secrets Manager)
- Different configuration per environment
- Configuration changes should not require redeployment

## Observability

### Distributed Tracing

Track requests across service boundaries.

**Tools:**
- OpenTelemetry (standard)
- Jaeger
- Zipkin
- AWS X-Ray

**Implementation:**
- Instrument all services with OpenTelemetry
- Propagate trace context across service boundaries
- Sample traces (100% in dev, 1-10% in production)

### Service-Level Objectives (SLOs)

Define SLOs per service.

**Example SLOs:**
- Availability: 99.9% (43 minutes downtime/month)
- Latency: p95 < 200ms
- Error rate: < 0.1%

**Monitoring:**
- Track SLOs per service
- Alert on SLO burn rate
- Dashboard per service

## Integration with Platform Builder

### Phase 1 (Blueprint)

- Decide if microservices are appropriate (see "When to Apply")
- Decompose into services (by bounded context, capability, or subdomain)
- Define communication patterns (sync vs async)
- Choose API gateway strategy
- Document service boundaries in `docs/ARCHITECTURE.md`

### Phase 2 (Backlog)

- Issues should align with service boundaries
- Cross-service issues need integration tests
- Tag issues with service name

### Phase 3 (Implement)

- Implement resilience patterns (circuit breaker, retry, timeout)
- Implement distributed tracing (OpenTelemetry)
- Implement service discovery
- Test service boundaries with contract tests

### Phase 4 (Productionization)

- Set up independent deployment per service
- Configure service discovery
- Set up API gateway
- Configure per-service SLOs

### Phase 6 (Operations)

- Implement chaos engineering (see `chaos-engineering.md`)
- Monitor service-level metrics
- Track distributed traces
- Review service boundaries (are they still correct?)

## Anti-Patterns

- **Distributed Monolith:** services that can't be deployed independently
- **Shared Database:** multiple services accessing same database
- **Chatty Services:** too many small services, excessive network calls
- **Nano-services:** services too small to justify overhead
- **No Circuit Breakers:** cascading failures
- **No Distributed Tracing:** can't debug cross-service issues
- **Synchronous Chain:** long chain of synchronous calls (use async)
