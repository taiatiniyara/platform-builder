# API Design Standards

## Applies when

Designing or implementing any API endpoint (REST, GraphQL, etc.).

## Checklist

### Conventions
- [ ] RESTful: resources (nouns), not actions (verbs); plural nouns; HTTP methods for operations
- [ ] Consistent naming (kebab-case or camelCase); correct HTTP status codes (200, 201, 204, 400, 401, 403, 404, 500)
- [ ] Content negotiation (Accept, Content-Type); API versioning (URL, header, or query param)

### Errors
- [ ] Standard error format: machine-readable code, human-readable message, field-level validation
- [ ] Generic errors to users; detailed in logs

### Pagination/Filtering/Sorting
- [ ] Cursor-based pagination for large datasets (not OFFSET/LIMIT); next/previous cursors in response
- [ ] Query params: ?status=active&role=admin for filters; ?sort=created_at:desc; ?fields=id,name,email for sparse fieldsets

### Rate Limiting
- [ ] Headers: X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset
- [ ] 429 Too Many Requests with Retry-After; tiered limits; burst handling

### Documentation
- [ ] OpenAPI/Swagger spec; request/response examples for every endpoint
- [ ] Authentication docs; error code reference; changelog; interactive docs (Swagger UI, Redoc)

### Security
- [ ] Authentication on all endpoints (except public); authorization on every request
- [ ] Input validation (type, length, format, range); CORS restricted (no wildcard in prod)
- [ ] HTTPS only (redirect HTTP → HTTPS)
