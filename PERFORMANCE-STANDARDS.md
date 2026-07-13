# Performance Standards

## Applies when

Writing DB queries, API endpoints, caching logic, or any performance-sensitive code.

## Checklist

### Database
- [ ] Index all frequently queried columns; composite indexes for multi-column
- [ ] No N+1 queries (eager loading, batch, JOINs); no SELECT *; EXPLAIN ANALYZE on slow queries
- [ ] Connection pooling; read replicas for read-heavy; cursor pagination (not OFFSET/LIMIT)

### Caching
- [ ] Multi-layer: app (Redis) → CDN → browser; explicit invalidation on data change
- [ ] Cache-aside pattern (check first, populate on miss); HTTP headers (Cache-Control, ETag)

### API
- [ ] Response targets: <200ms reads, <500ms writes (p95)
- [ ] Async processing for long operations (queues, not blocking); batch endpoints for multiple items
- [ ] Compression (gzip/brotli) for >1KB responses; HTTP/2, keep-alive, connection pooling

### Scalability
- [ ] Stateless services (session in Redis); load balancing with health checks
- [ ] Queue-based processing; auto-scaling (CPU/memory/requests); event-driven architecture

### Resources
- [ ] No memory leaks (monitor heap, streams for large data); no blocking event loop
- [ ] Async file ops, batch writes; minimize network round trips; lazy loading (images, modules, routes)
