# Event-Driven Architecture

Patterns for building systems with events as the primary communication
mechanism. Apply when you need loose coupling, audit trails, or complex
workflows.

## Tool Selection

This file describes **patterns**, not specific tools. Tools mentioned are
**examples** to illustrate the pattern — not recommendations. When selecting
tools for this project, the agent MUST:
1. Check `docs/ARCHITECTURE.md` for the declared stack
2. Research current options (never suggest from memory)
3. Present 2-3 options with trade-offs
4. Let the user decide

## When to Apply

- Multiple bounded contexts need to communicate
- Audit trail is required (every state change recorded)
- Complex workflows span multiple services
- Need temporal decoupling (producer/consumer independent)
- Event sourcing or CQRS patterns needed

**Don't apply when:**
- Simple request/response is sufficient
- Strong consistency required across all data
- Team lacks event-driven experience
- Low tolerance for eventual consistency

## Core Concepts

### Events

An event is an immutable record of something that happened in the domain.

**Naming:** past tense, business-meaningful
- Good: `OrderPlaced`, `PaymentProcessed`, `UserRegistered`
- Bad: `OrderCreated`, `UpdateOrder`, `UserChanged`

**Structure:**
```json
{
  "eventId": "uuid",
  "eventType": "OrderPlaced",
  "timestamp": "2024-01-15T10:30:00Z",
  "aggregateId": "order-123",
  "data": {
    "customerId": "cust-456",
    "total": 99.99,
    "items": [...]
  },
  "metadata": {
    "userId": "user-789",
    "correlationId": "corr-abc"
  }
}
```

**Rules:**
- Events are immutable facts (never modify past events)
- Events carry data needed by consumers (don't force lookups)
- Events are raised by aggregates (see `ddd.md`)
- Events are handled by event handlers

### Event Sourcing

Store state changes as a sequence of events rather than current state.

**Benefits:**
- Complete audit trail
- Temporal queries (state at any point in time)
- Event replay for debugging
- Easy to add new read models

**Challenges:**
- Event schema evolution
- Eventual consistency (not immediate)
- Querying current state requires projections
- Steeper learning curve

**When to use:**
- Financial systems (audit required)
- Complex workflows with many state changes
- Need to reconstruct historical state
- Regulatory requirements

**When NOT to use:**
- Simple CRUD applications
- No audit requirements
- Team unfamiliar with event sourcing

### CQRS (Command Query Responsibility Segregation)

Separate read model from write model.

**Write side (Commands):**
- Handles business logic
- Enforces invariants
- Produces events
- Optimized for writes

**Read side (Queries):**
- Denormalized for fast reads
- Updated via events
- Optimized for queries
- Can use different database

**Benefits:**
- Independent scaling of reads and writes
- Optimized read models (no joins, denormalized)
- Separation of concerns

**Challenges:**
- Eventual consistency (read model lags behind write model)
- More complexity (two models to maintain)
- Event handling failures

**When to use:**
- Read/write ratio is very different (e.g., 100:1)
- Complex queries that don't match write model
- Different scaling requirements for reads vs writes

### Sagas

Manage distributed transactions across multiple services.

**Choreography:**
- Each service publishes events
- Other services react to events
- No central coordinator
- Decentralized control

**Orchestration:**
- Central coordinator (saga orchestrator)
- Orchestrator tells services what to do
- Centralized control

**Choreography example:**
```
Order Service → publishes OrderPlaced
Inventory Service → listens, reserves stock, publishes StockReserved
Payment Service → listens, charges card, publishes PaymentProcessed
Notification Service → listens, sends confirmation
```

**Orchestration example:**
```
Saga Orchestrator → tells Order Service: create order
Order Service → done
Saga Orchestrator → tells Inventory Service: reserve stock
Inventory Service → done
Saga Orchestrator → tells Payment Service: charge card
Payment Service → done
Saga Orchestrator → tells Notification Service: send confirmation
```

**Compensating transactions:**
- Each step has a compensating action
- If a step fails, run compensating actions for previous steps
- Example: if payment fails, release reserved stock

**When to use:**
- Distributed transactions across services
- Long-running business processes
- Need eventual consistency

**When NOT to use:**
- Single service (use local transactions)
- Strong consistency required (use 2PC, but avoid if possible)

## Messaging Patterns

### Point-to-Point

One producer, one consumer. Message is consumed once.

**Use when:**
- Work distribution (task queues)
- Single consumer per message
- Need guaranteed delivery

**Tools:**
- RabbitMQ
- AWS SQS
- Azure Service Bus

### Publish-Subscribe

One producer, multiple consumers. Each consumer gets a copy.

**Use when:**
- Multiple services need the same event
- Broadcast to interested parties
- Fan-out processing

**Tools:**
- RabbitMQ (with fanout exchange)
- AWS SNS
- Google Pub/Sub

### Event Streaming

Long-lived log of events. Consumers can replay from any point.

**Use when:**
- Need durable event log
- Multiple consumers at different speeds
- Need to replay events (rebuild read models)
- Event sourcing

**Tools:**
- Apache Kafka
- AWS Kinesis
- Redpanda
- Pulsar

## Event Schema Evolution

Events are immutable, but schemas evolve.

**Rules:**
- Never delete a field (consumers may depend on it)
- Never change field semantics
- Add new fields as optional
- Use versioning when breaking changes needed

**Strategies:**
- **Schema Registry:** validate events against schema (Confluent Schema Registry)
- **Versioned events:** `OrderPlaced.v1`, `OrderPlaced.v2`
- **Upcasting:** convert old events to new format on read

## Implementation

### Event Bus

Central hub for publishing and subscribing to events.

**Setup:**
```
Producer → Event Bus → Consumer 1
                     → Consumer 2
                     → Consumer 3
```

**Libraries:**
- Node.js: `amqplib` (RabbitMQ), `kafkajs` (Kafka)
- Python: `pika` (RabbitMQ), `confluent-kafka` (Kafka)
- Go: `streadway/amqp` (RabbitMQ), `segmentio/kafka-go` (Kafka)

### Event Store

Database optimized for storing events.

**Tools:**
- EventStoreDB (dedicated event store)
- Kafka (event streaming platform)
- PostgreSQL (with event sourcing libraries)

### Projections

Build read models from events.

**Example:**
```
Events: OrderPlaced, OrderUpdated, OrderCancelled
Projection: OrderSummary (denormalized view)
```

**Rules:**
- Projections are eventually consistent
- Handle out-of-order events (use timestamps)
- Handle duplicate events (idempotent handlers)
- Rebuild projections from scratch when needed

## Testing

### Unit Tests

Test event handlers in isolation.

**Example:**
```javascript
test('handles OrderPlaced event', () => {
  const event = { type: 'OrderPlaced', data: { ... } };
  const result = handleOrderPlaced(event);
  expect(result).toEqual({ ... });
});
```

### Integration Tests

Test event flow across services.

**Example:**
```javascript
test('order placement workflow', async () => {
  // Place order
  await orderService.placeOrder(orderData);
  
  // Wait for events to propagate
  await waitForEvent('OrderPlaced');
  await waitForEvent('StockReserved');
  await waitForEvent('PaymentProcessed');
  
  // Verify final state
  const order = await orderService.getOrder(orderId);
  expect(order.status).toBe('confirmed');
});
```

### Contract Tests

Verify event contracts between services.

**Example:**
```javascript
test('OrderPlaced event has required fields', () => {
  const event = produceOrderPlacedEvent();
  expect(event).toHaveProperty('eventId');
  expect(event).toHaveProperty('timestamp');
  expect(event).toHaveProperty('data.customerId');
});
```

## Integration with Platform Builder

### Phase 1 (Blueprint)

- Decide if event-driven is appropriate (see "When to Apply")
- Identify events (domain events, integration events)
- Choose messaging pattern (point-to-point, pub-sub, streaming)
- Choose technology (Kafka, RabbitMQ, etc.)
- Document event contracts in `docs/agents/contracts/`

### Phase 2 (Backlog)

- Issues should align with event flows
- Cross-service event flows need integration tests
- Tag issues with event types

### Phase 3 (Implement)

- Implement event producers and consumers
- Implement idempotent event handlers
- Implement sagas for distributed transactions
- Test event flows with integration tests

### Phase 4 (Productionization)

- Set up message broker (Kafka, RabbitMQ, etc.)
- Configure event schema registry
- Set up dead letter queues
- Configure event retention policies

### Phase 6 (Operations)

- Monitor event processing lag
- Track event processing errors
- Set up alerts for failed events
- Implement event replay for debugging

## Anti-Patterns

- **Event Storm:** too many events, hard to follow flow
- **Missing Idempotency:** duplicate events cause duplicate processing
- **No Dead Letter Queue:** failed events are lost
- **Tight Coupling:** consumers depend on event structure (use schema evolution)
- **Synchronous Event Handling:** events should be asynchronous
- **No Correlation ID:** can't trace event flow across services
- **Event Chaining:** event triggers another event triggers another (use sagas)
