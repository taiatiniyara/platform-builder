# Background Jobs & Notifications Standards

## Applies when

Implementing async processing, job queues, email, push/SMS notifications, or webhooks.

## Checklist

### Queue Infrastructure
- [ ] Reliable queue (BullMQ, Sidekiq, Celery, SQS); prioritization (critical first)
- [ ] Retry with exponential backoff + jitter; dead letter queue for failed jobs
- [ ] Job timeouts; idempotency keys; concurrency control; cancellation support
- [ ] Progress tracking for long jobs; job chaining (B after A); batching

### Reliability & Monitoring
- [ ] Transactional processing; error handling (catch, log, don't crash silently)
- [ ] Metrics: queue depth, processing time, success/failure rates; dashboards + alerting
- [ ] Replay capability (retry failed after fix); structured logging per job

### Email
- [ ] Transactional emails (verification, password reset); branded HTML + plain text templates
- [ ] Delivery tracking (delivery, opens, clicks, bounces); throttling; unsubscribe management

### Push & In-App
- [ ] Mobile (APNs, FCM) + web push with permissions; user preferences per channel
- [ ] Rich notifications (images, actions, deep links); scheduling (time zones, quiet hours)
- [ ] In-app notification center: types (info/warning/success/error), read/unread, actions

### Webhooks
- [ ] Reliable delivery with retries; HMAC-signed payloads; HTTPS only
- [ ] Management UI for subscriptions; clear docs; versioning

### SMS & Voice
- [ ] Reliable provider (Twilio, AWS SNS); pre-approved templates; compliance (TCPA, GDPR)
- [ ] SMS-based 2FA (TOTP preferred); cost management (SMS is expensive)

### Architecture
- [ ] Centralized notification service; channel abstraction (email, push, SMS, in-app)
- [ ] User preferences (choose channels, frequency); template engine with variables; i18n
- [ ] Job authentication; payload validation; no shared state; rate limiting; audit trail
