# Real-Time Standards

## Applies when

Implementing WebSockets, real-time updates, live collaboration, or live features.

## Checklist

### Infrastructure
- [ ] Reliable server (Socket.io, ws, uWebSockets); SSL/TLS (wss://)
- [ ] Connection management (connect, disconnect, reconnect); heartbeat/ping-pong
- [ ] Scaling (sticky sessions or Redis pub/sub); load balancing

### Communication Patterns
- [ ] Pub/Sub, broadcast, room/channel, direct message, request/response (RPC over WS)

### Live Collaboration
- [ ] Presence (who's online/viewing); typing indicators; cursor tracking
- [ ] Real-time editing; conflict resolution (CRDTs, operational transforms); collaborative undo/redo

### Live Updates
- [ ] Live dashboards, feeds, chat, notifications, tracking, auctions

### Fallbacks & Offline
- [ ] Long polling → SSE → polling; graceful degradation (works without real-time)
- [ ] Connection status shown to user (connected, reconnecting, offline); offline queue + sync

### Performance & Security
- [ ] Message compression + batching; backpressure; message ordering; delivery guarantees
- [ ] Authentication (JWT, session); authorization; message validation; rate limiting; connection limits
