# Background Jobs Standards

## Applies when

Implementing asynchronous processing, email sending, file processing, or scheduled tasks.

## Rules

### Queue Infrastructure

- Reliable queue (Bull, BullMQ, Sidekiq, Celery, AWS SQS, Redis Queue)
- Prioritization (critical jobs first: password reset > email digest)
- Scheduling (future execution, cron-like)
- Deduplication (idempotency keys)
- Timeouts (for long-running jobs)
- Concurrency control (parallel job limit)

### Processing Patterns

- Retry strategy (exponential backoff with jitter)
- Dead letter queue (permanently failed jobs for inspection)
- Cancellation (cancel pending/running jobs)
- Progress tracking (0-100% for long jobs)
- Dependencies (chain jobs: B after A)
- Batching (multiple items in one job)

### Common Types

- Email sending (transactional, marketing, notifications)
- File processing (image resizing, video transcoding, PDF generation)
- Data processing (ETL, aggregation, reports)
- Webhook delivery (reliable, with retries)
- Scheduled tasks (daily/weekly/monthly: cleanup, backups, reports)
- Third-party integrations (Stripe, Slack sync)

### Reliability

- Idempotency (safe retries without side effects)
- Transactional processing (complete or rollback)
- Error handling (catch, log, don't crash silently)
- Monitoring (success/failure rates, processing times)
- Alerting (high failure rates, long queues, stuck jobs)
- Replay (retry failed jobs after fix)

### Performance

- Batching (multiple items, reduce overhead)
- Chunking (split large jobs, parallel processing)
- Optimization (slow jobs: database queries, API calls)
- Resource management (memory/CPU control)
- Scheduling (off-peak hours, reduce load)
- Caching (avoid reprocessing)

### Monitoring

- Metrics (queue depth, processing time, success/failure rates)
- Logging (structured: job ID, type, status, duration)
- Tracing (distributed tracing for jobs calling services)
- Dashboards (real-time visibility)
- Alerting (anomalies: high failure, long queue, stuck jobs)
- Debugging (inspect state, retry, cancel)

### Security

- Authentication (authenticate job sources)
- Validation (validate payloads, prevent injection)
- Secrets (environment variables, secret managers)
- Isolation (no shared state between jobs)
- Rate limiting (prevent abuse)
- Audit trail (who created jobs, when, what they did)

## Checklist

- [ ] Queue system configured
- [ ] Job prioritization implemented
- [ ] Retry strategy configured
- [ ] Dead letter queue configured
- [ ] Job timeouts set
- [ ] Idempotency implemented
- [ ] Error handling implemented
- [ ] Monitoring configured
- [ ] Alerting configured
- [ ] Job replay capability exists
- [ ] Job authentication implemented
- [ ] Job validation implemented
- [ ] Job metrics collected
- [ ] Job dashboards available

## Anti-patterns

- No queue (blocking on long operations) → add job queue
- No retry strategy → add exponential backoff
- No dead letter queue → add dead letter queue
- No idempotency → implement idempotency
- No monitoring → add monitoring
- No timeouts → set timeouts
- No error handling → add error handling
- No prioritization → add prioritization
- No deduplication → add deduplication
- No cancellation → add cancellation capability
