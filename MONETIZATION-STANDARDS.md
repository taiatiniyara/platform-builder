# Monetization Standards

## Applies when

Implementing payment processing, subscription management, billing, or pricing.

## Rules

### Payment Processing

- Reliable provider (Stripe, Braintree, PayPal, Paddle)
- Multiple methods (credit card, debit card, PayPal, ACH)
- PCI-DSS compliance (never store raw card data)
- Validate payment details before processing
- Confirm success before granting access
- Send receipts via email

### Subscriptions

- Flexible plans (monthly, annual, usage-based)
- Lifecycle management (creation, updates, cancellations, renewals)
- Proration (upgrade/downgrade mid-cycle)
- Trial periods (free trials, auto-convert to paid)
- Grace periods (failed payments before cancellation)
- Analytics (MRR, ARR, churn, LTV, conversion)

### Billing & Invoicing

- Automated billing (on renewal)
- Invoice generation (each cycle)
- Tax calculation (location-based: VAT, GST, sales tax)
- Currency support (multiple currencies, conversion)
- Invoice delivery (email, user dashboard)
- Payment reminders (before due date)

### Dunning

- Failed payment handling (retry with exponential backoff)
- Dunning emails (for failed payments)
- Payment method updates (user can update)
- Graceful degradation (maintain access during grace period)
- Cancellation handling (access until end of period)
- Debt recovery (process for outstanding debts)

### Pricing & Plans

- Clear pricing page (plan comparison)
- Defined plan features
- Usage-based pricing (per API call, per GB, per user)
- Discounts & coupons (promo codes, promotional pricing)
- Enterprise plans (custom pricing)
- Pricing experiments (A/B test pages and plans)

### Revenue Analytics

- Metrics (MRR, ARR, ARPU, LTV, CAC, churn)
- Dashboards (real-time)
- Forecasting (based on trends)
- Attribution (marketing channels, campaigns)
- Recognition (GAAP compliance if needed)
- Alerts (anomalies: sudden drop, unusual spike)

### Security

- Webhook security (signature verification)
- Fraud detection (prevent fraudulent transactions)
- Chargeback handling (respond to disputes)
- Refund management (full, partial)
- Access control (only paying users access paid features)
- Audit trail (track all payment actions)

## Checklist

- [ ] Payment provider configured
- [ ] Multiple payment methods supported
- [ ] PCI-DSS compliant
- [ ] Payment validation implemented
- [ ] Payment confirmation before access
- [ ] Receipts sent
- [ ] Subscription lifecycle managed
- [ ] Proration implemented
- [ ] Trial periods supported
- [ ] Grace periods implemented
- [ ] Automated billing configured
- [ ] Invoices generated
- [ ] Tax calculation implemented
- [ ] Currency support configured
- [ ] Dunning management implemented
- [ ] Pricing page clear
- [ ] Revenue metrics tracked
- [ ] Webhook security configured
- [ ] Fraud detection implemented
- [ ] Audit trail exists

## Anti-patterns

- Storing raw card data → use payment provider
- No webhook security → add signature verification
- No dunning → implement dunning management
- No proration → implement proration
- No tax calculation → add tax calculation
- No subscription analytics → track metrics
- No fraud detection → add fraud detection
- No audit trail → add audit logging
- Blocking access immediately on failed payment → add grace period
- No receipts → send receipts
