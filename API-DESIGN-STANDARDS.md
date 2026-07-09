# API Design Standards

## Applies when

Designing or implementing any API endpoint (REST, GraphQL, etc.).

## Rules

### Conventions

- RESTful: resources (nouns), not actions (verbs)
- HTTP methods for operations (GET, POST, PUT, DELETE)
- Plural nouns for resources (users, orders)
- Consistent naming (kebab-case or camelCase throughout)
- Correct HTTP status codes (200, 201, 204, 400, 401, 403, 404, 500)
- Content negotiation (Accept, Content-Type headers)
- API versioning (URL, header, or query param)

### Errors

- Standard format across all endpoints
- Machine-readable error codes
- Human-readable, actionable messages
- Field-level validation errors
- Example:
  ```json
  {
    "error": {
      "code": "VALIDATION_ERROR",
      "message": "Invalid input",
      "details": [
        {"field": "email", "message": "Invalid email format"}
      ]
    }
  }
  ```

### Pagination/Filtering/Sorting

- Cursor-based pagination for large datasets
- Include next/previous cursors in response
- Query parameters for filters (?status=active&role=admin)
- Query parameter for sort (?sort=created_at:desc)
- Sparse fieldsets (?fields=id,name,email)
- Example:
  ```json
  {
    "data": [...],
    "pagination": {
      "cursor": "eyJpZCI6MTAwfQ==",
      "has_more": true
    }
  }
  ```

### Rate Limiting

- Headers: X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset
- 429 Too Many Requests with Retry-After header
- Tiered limits for different user tiers
- Burst handling (allow short bursts, enforce average)
- Document limits in API docs

### Documentation

- OpenAPI/Swagger specification
- Request/response examples for every endpoint
- Authentication documentation
- Error code reference
- Changelog (changes, deprecations)
- Interactive docs (Swagger UI, Redoc)

### Security

- Authentication on all endpoints (except public)
- Authorization checks on every request
- Input validation (type, length, format, range)
- Rate limiting (prevent abuse)
- CORS restricted (no wildcard in production)
- HTTPS only (redirect HTTP to HTTPS)

## Checklist

- [ ] RESTful conventions followed
- [ ] Consistent naming
- [ ] Correct HTTP status codes
- [ ] Standard error format
- [ ] Pagination implemented
- [ ] Filtering/sorting supported
- [ ] Rate limiting configured
- [ ] Rate limit headers present
- [ ] OpenAPI spec exists
- [ ] Examples provided
- [ ] Authentication required
- [ ] Authorization checked
- [ ] Input validated
- [ ] CORS restricted
- [ ] HTTPS only

## Anti-patterns

- RPC-style APIs → use RESTful resources
- Inconsistent naming → standardize (plural nouns, consistent case)
- No error handling → standard error format
- No pagination → add cursor-based pagination
- No rate limiting → add rate limits
- No documentation → add OpenAPI spec
- No versioning → add versioning strategy
- Verbose errors → generic errors to users
- No input validation → validate all input
- Wildcard CORS → explicit origin list
