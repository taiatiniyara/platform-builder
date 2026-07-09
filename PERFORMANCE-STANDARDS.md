# Performance Standards

## Applies when

Writing database queries, API endpoints, caching logic, or any performance-sensitive code.

## Rules

### Database

- Index all frequently queried columns
- Composite indexes for multi-column queries
- No N+1 queries (use eager loading, batch queries, JOINs)
- Connection pooling configured
- No SELECT * (specify columns)
- Use EXPLAIN ANALYZE for slow queries
- Read replicas for read-heavy workloads
- Cursor-based pagination for large datasets (not OFFSET/LIMIT)

### Caching

- Multi-layer: app cache (Redis) → CDN → browser cache
- Explicit invalidation on data change
- TTL-based fallback
- Cache-aside pattern (check cache first, populate on miss)
- CDN for static assets and public API responses
- HTTP caching headers (Cache-Control, ETag, Last-Modified)

### API

- Response time targets: <200ms reads, <500ms writes (p95)
- Async processing for long operations (queues, not blocking)
- Batch endpoints for multiple items
- Compression (gzip/brotli) for responses >1KB
- HTTP/2, keep-alive, connection pooling
- Rate limiting with 429 + Retry-After header

### Scalability

- Stateless services (session storage externalized to Redis)
- Load balancing with health checks
- Queue-based processing (decouple producers/consumers)
- Auto-scaling based on CPU/memory/request metrics
- Database sharding for very large datasets
- Event-driven architecture for async communication

### Resources

- No memory leaks (monitor heap, use streams for large data)
- No blocking event loop (async I/O, worker threads for CPU-intensive)
- Async file operations, batch writes
- Minimize network round trips
- Lazy loading (images, modules, routes on demand)

## Checklist

- [ ] Queries use indexes (check with EXPLAIN)
- [ ] No N+1 queries
- [ ] Connection pooling configured
- [ ] Caching implemented (with invalidation)
- [ ] API response times <200ms reads, <500ms writes
- [ ] Long operations use queues
- [ ] Compression enabled
- [ ] Rate limiting configured
- [ ] Services stateless
- [ ] Auto-scaling configured
- [ ] No memory leaks
- [ ] No blocking operations in async code
- [ ] Pagination implemented (cursor-based)

## Anti-patterns

- N+1 queries → eager loading or batch queries
- SELECT * → specify columns
- Blocking event loop → async I/O
- No indexes → add indexes on queried columns
- Caching without invalidation → add explicit invalidation
- No connection pooling → configure pool
- Loading entire datasets → use pagination/streams
- No pagination → implement cursor-based pagination
- Synchronous API calls in request path → use queues
- No rate limiting → add rate limits
