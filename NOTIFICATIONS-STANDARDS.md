# Notifications Standards

## Applies when

Sending emails, push notifications, in-app notifications, webhooks, or SMS.

## Rules

### Email

- Transactional emails (verification, password reset, confirmation)
- Branded templates (HTML and plain text)
- Reliable service (SendGrid, Mailgun, AWS SES, Postmark)
- Delivery tracking (delivery, opens, clicks, bounces)
- Unsubscribe management (easy unsubscribe, respect preferences)
- Throttling (rate limit, batch non-urgent)

### Push

- Mobile push (iOS APNs, Android FCM)
- Web push (browser, with permission)
- User preferences (control which notifications)
- Rich notifications (images, action buttons, deep links)
- Scheduling (respect time zones, quiet hours)
- Delivery tracking (delivery, engagement)

### In-App

- Notification center (centralized place)
- Real-time updates (WebSockets, SSE)
- Notification types (info, warning, success, error)
- Read/unread status
- Actions (clickable, navigate to content)
- Preferences (mute, customize)

### Webhooks

- Reliable delivery with retries
- Security (signed payloads HMAC, HTTPS, IP whitelisting)
- Clear documentation
- Management UI (subscriptions)
- Debugging tools
- Versioning (avoid breaking changes)

### SMS & Voice

- Reliable service (Twilio, AWS SNS, Vonage)
- Pre-approved templates (compliance)
- SMS-based 2FA (TOTP preferred)
- Voice calls (verification, emergency if needed)
- Cost management (expensive, use judiciously)
- Compliance (TCPA, GDPR, opt-in required)

### Architecture

- Centralized service (not scattered)
- Channel abstraction (email, push, SMS, in-app)
- User preferences (choose channels, frequency)
- Queue (reliable delivery, handle failures)
- Template engine (dynamic variables)
- Localization (user's language)

## Checklist

- [ ] Notification service centralized
- [ ] Email templates branded
- [ ] Email delivery tracked
- [ ] Unsubscribe mechanism exists
- [ ] Push notifications configured
- [ ] User preferences respected
- [ ] In-app notification center exists
- [ ] Webhooks signed and secure
- [ ] Webhook documentation exists
- [ ] SMS compliance checked
- [ ] Notifications queued
- [ ] Templates support variables
- [ ] Notifications localized

## Anti-patterns

- Scattered notification code → centralize service
- No user preferences → add preference management
- No unsubscribe → add unsubscribe mechanism
- Hardcoded templates → use template engine
- No delivery tracking → add tracking
- Ignoring time zones → respect user time zones
- No queue → add notification queue
- PII in logs → sanitize logs
- English-only → localize
- Unsigned webhooks → add HMAC signatures
