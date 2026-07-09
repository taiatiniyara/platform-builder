# Real-Time Standards

## Applies when

Implementing WebSockets, real-time updates, live collaboration, or live features.

## Rules

### WebSocket Infrastructure

- Reliable server (Socket.io, ws, uWebSockets)
- Connection management (handle connections, disconnections, reconnections)
- Heartbeat/ping-pong (detect dead connections, keep alive)
- Scaling (thousands/millions of connections)
- Load balancing (sticky sessions or Redis pub/sub)
- SSL/TLS (wss://)

### Communication Patterns

- Pub/Sub (publish/subscribe for event distribution)
- Broadcast (message to all clients)
- Room/Channel (message to specific group)
- Direct message (message to specific client)
- Request/Response (RPC over WebSocket)
- Event sourcing (stream of events)

### Live Collaboration

- Presence (who's online, who's viewing)
- Typing indicators
- Cursor tracking (collaborative editing)
- Real-time editing (Google Docs-style)
- Conflict resolution (CRDTs, operational transforms)
- Undo/redo (collaborative)

### Live Updates

- Live dashboards (stock prices, metrics)
- Live feeds (activity, notifications)
- Live chat (support, team)
- Live notifications (new message, new order)
- Live tracking (location, delivery)
- Live auctions (bidding updates)

### Fallbacks

- Long polling (when WebSockets unavailable)
- Server-Sent Events (one-way, simpler)
- Polling (last resort, least efficient)
- Graceful degradation (works without real-time)
- Connection status (connected, reconnecting, offline)
- Offline support (queue messages, sync when online)

### Performance & Scaling

- Message compression (reduce bandwidth)
- Message batching (reduce overhead)
- Backpressure (handle slow clients)
- Rate limiting (prevent abuse)
- Message ordering (ensure order)
- Delivery guarantees (at-least-once, exactly-once)

### Security

- Authentication (JWT, session tokens)
- Authorization (check permissions)
- Message validation (prevent injection)
- Rate limiting (prevent spam)
- Connection limits (per user/IP)
- Secure protocols (wss:// only)

## Checklist

- [ ] WebSocket server configured
- [ ] Connection management implemented
- [ ] Heartbeat configured
- [ ] Load balancing configured
- [ ] SSL/TLS enabled (wss://)
- [ ] Authentication implemented
- [ ] Authorization checked
- [ ] Message validation implemented
- [ ] Rate limiting configured
- [ ] Fallback strategies implemented
- [ ] Connection status shown to user
- [ ] Offline support implemented
- [ ] Message ordering ensured
- [ ] Backpressure handled

## Anti-patterns

- Polling instead of WebSockets → use WebSockets
- No fallback → implement fallbacks
- No authentication → authenticate connections
- No connection management → manage connections
- No message validation → validate messages
- No rate limiting → add rate limits
- No presence → add presence indicators
- No conflict resolution → implement conflict resolution
- No offline support → add offline support
- No connection status → show connection status
