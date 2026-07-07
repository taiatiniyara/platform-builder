# API Design Standards

Applied during Phase 1 (Blueprint — as architecture decisions) and enforced
during Phase 3 (Implement — every endpoint must follow these). Covers REST,
GraphQL, RPC, and event contracts. Stack-agnostic — specifics filled in from
`docs/ARCHITECTURE.md`.

## Tool Selection

This file describes **patterns**, not specific tools. Tools mentioned are
**examples** to illustrate the pattern — not recommendations. When selecting
tools for this project, the agent MUST:
1. Check `docs/ARCHITECTURE.md` for the declared stack
2. Research current options (never suggest from memory)
3. Present 2-3 options with trade-offs
4. Let the user decide

---

## Versioning

Choose one strategy and apply it consistently:

| Strategy | When to use | Example |
|----------|-------------|---------|
| URL path prefix | Public APIs with long-lived clients | `/v1/users` |
| Header-based | Internal APIs, service-to-service | `Accept: application/vnd.api+json;version=1` |
| Query parameter | Avoid — easy to forget, clutters URLs | `/users?version=1` |

**For new platforms:** URL path prefix. It is visible, cacheable, and
trivially routable.

Deprecation: add a `Sunset` header to deprecated versions. Minimum 90-day
window between deprecation announcement and removal.

---

## Error Response Shape

Every error response follows the same envelope:

```
{
  "error": {
    "code": "validation_failed",
    "message": "Human-readable single sentence",
    "requestId": "req_abc123",
    "details": [
      { "field": "email", "reason": "invalid_format" }
    ]
  }
}
```

Rules:
- `code` is a snake_case machine-readable identifier. No spaces.
- `message` is for developers, not end users. Don't expose stack traces.
- `requestId` ties the error to the request log entry (correlation ID).
- `details` is optional — include for validation errors, omit for 500s.
- Never return a 500 with a raw stack trace. 500s get a generic message
  and are logged with full details server-side.

---

## Pagination

Use cursor-based pagination for datasets that can grow:

```
GET /v1/users?cursor=eyJpZCI6MTIzfQ&limit=50

Response:
{
  "data": [...],
  "pagination": {
    "cursor": "eyJpZCI6MTczfQ",
    "hasMore": true
  }
}
```

For small, bounded datasets (e.g., list of countries), offset-based is
acceptable: `?offset=0&limit=50`. Max `limit` is 100 unless the use case
demands it.

---

## Idempotency

Every mutation endpoint (POST, PUT, PATCH, DELETE) that has side effects
MUST support idempotency:

- Client sends an `Idempotency-Key` header with a unique value per operation.
- The server stores the key + response for at least 24 hours.
- If the same key is received again, return the stored response (not reprocess).
- Implement via a unique constraint on (key, operation_type) or a dedicated
  idempotency store.

Apply to: payment endpoints, order creation, account mutations, any operation
a client might retry on network timeout.

---

## Rate Limiting

Apply rate limiting to all endpoints, not just auth:

- Per-IP for unauthenticated requests (e.g., 60 req/min).
- Per-user or per-token for authenticated requests (e.g., 1000 req/min).
- Rate limit headers on every response:
  ```
  RateLimit-Limit: 1000
  RateLimit-Remaining: 987
  RateLimit-Reset: 1620000000
  ```
- 429 response body uses the standard error shape with `code: "rate_limited"`.

---

## Input Validation

- Reject unknown fields (strict mode). Don't silently ignore extra JSON keys.
- Validate types, ranges, and formats before business logic.
- Return 400 with `details` array listing every validation failure (not just
  the first one).
- Sanitize string inputs: trim whitespace, reject null bytes, enforce max
  length.
- Guard against prototype pollution (JSON parse with `__proto__` blocked).

---

## Authentication

- Every endpoint declares its auth requirement in `docs/ARCHITECTURE.md`.
- Three tiers: `public` (no auth), `authenticated` (any valid session/token),
  `authorized:<scope>` (specific permission).
- Unauthenticated → 401. Unauthorized → 403 (even if the resource doesn't
  exist — don't leak existence information).

---

## Pagination, Filtering & Sorting

- **Filtering:** `?status=active&role=admin` — query params match field names.
- **Sorting:** `?sort=createdAt:desc` — field name + `:asc` or `:desc`.
- **Search:** `?q=term` for full-text search queries.
- **Sparse fieldsets:** `?fields=id,name,email` to reduce payload size.

---

## Async Operations

For long-running operations (report generation, bulk exports, video processing):

1. POST creates the operation → returns `202 Accepted` with a status URL:
   ```
   { "status": "processing", "statusUrl": "/v1/jobs/job_abc123" }
   ```
2. GET `/v1/jobs/job_abc123` returns current status:
   ```
   { "status": "complete", "resultUrl": "/v1/exports/export_xyz" }
   ```
3. Webhook (optional): if a webhook URL was provided, POST the completion
   payload to it.

---

## Event Contracts

If the platform emits or consumes events:

- Event schemas are versioned and stored alongside code.
- Events include: `eventId` (UUID), `eventType` (reverse-DNS), `timestamp`
  (ISO 8601), `data` (payload).
- Consumers are idempotent — they can receive the same event more than once.
- Events are never deleted from the schema — only deprecated with a
  `supersededBy` field.
