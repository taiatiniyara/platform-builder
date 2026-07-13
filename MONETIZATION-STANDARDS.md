# Monetization Standards

## Applies when

Implementing payment processing, subscription management, billing, or pricing.

## Checklist

### Payment Processing
- [ ] Reliable provider (Stripe, Braintree, PayPal, Paddle); multiple payment methods
- [ ] PCI-DSS compliant (never store raw card data); validate before processing; confirm before access
- [ ] Send receipts via email; webhook signature verification

### Subscriptions
- [ ] Flexible plans (monthly, annual, usage-based); lifecycle management (create, update, cancel, renew)
- [ ] Proration (upgrade/downgrade mid-cycle); trials (auto-convert to paid); grace periods
- [ ] Dunning: failed payment retry with exponential backoff; dunning emails; payment method updates

### Billing & Invoicing
- [ ] Automated billing on renewal; invoice generation per cycle
- [ ] Tax calculation (VAT, GST, sales tax); currency support; payment reminders

### Pricing & Plans
- [ ] Clear pricing page with plan comparison; defined plan features
- [ ] Usage-based pricing (per API call, per GB, per user); discounts + coupons; enterprise plans
- [ ] Pricing experiments (A/B test pages and plans)

### Revenue Analytics
- [ ] Track MRR, ARR, ARPU, LTV, CAC, churn; real-time dashboards; forecasting
- [ ] Attribution (marketing channels); alerts on anomalies (sudden drop, unusual spike)

### Security
- [ ] Fraud detection; chargeback handling; refund management (full, partial)
- [ ] Access control (only paying users); audit trail (all payment actions)
