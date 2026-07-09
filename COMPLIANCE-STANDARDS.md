# Compliance Standards

## Applies when

Collecting user data, processing payments, building algorithms, or designing user interfaces.

## Rules

### Privacy by Design

- Data minimization (collect only what's needed)
- Purpose limitation (use data only for stated purposes)
- Consent management (track consent, allow withdrawal)
- Data retention (delete when no longer needed)
- Privacy settings (default to most private)
- Clear, accessible privacy policy

### GDPR

- Right to access (users can request their data)
- Right to rectification (users can correct data)
- Right to erasure (users can request deletion)
- Right to data portability (export as JSON, CSV)
- Right to restrict processing (limit how data is used)
- Data breach notification (notify authorities within 72 hours)
- DPIA for high-risk processing
- Legal basis for processing (consent, contract, legal obligation, legitimate interest)

### CCPA

- Right to know (users can request what data is collected)
- Right to delete (users can request deletion)
- Right to opt-out (users can opt out of data sale)
- "Do Not Sell My Personal Information" link
- Non-discrimination (can't penalize for exercising rights)
- Service provider agreements (contracts with processors)

### Accessibility Beyond WCAG

- Cognitive accessibility (clear language, consistent navigation, error prevention)
- Neurodiversity support (ADHD, autism, dyslexia)
- Motion sensitivity (respect prefers-reduced-motion)
- Color blindness (don't rely on color alone)
- Screen reader testing (VoiceOver, NVDA, JAWS)
- Keyboard-only testing (navigate without mouse)

### Algorithmic Fairness

- Bias detection (test for biased outcomes by race, gender, age)
- Fairness metrics (equal opportunity, demographic parity)
- Explainability (users understand why algorithm made decision)
- Human oversight (humans review algorithmic decisions)
- Appeals process (users can contest decisions)
- Regular audits (audit for fairness over time)

### Ethical Design

- No dark patterns (no manipulative design)
- Transparent pricing (no hidden fees)
- Easy cancellation (as easy to cancel as subscribe)
- No notification spam (respect attention)
- Addiction prevention (no infinite scroll unless justified)
- User wellbeing (design for benefit, not engagement)

### Legal

- Clear, accessible terms of service
- GDPR-compliant cookie banner
- COPPA compliance for users under 13
- Industry regulations (HIPAA, PCI-DSS, SOX, FERPA)
- Export controls compliance
- Accessibility laws (ADA, Section 508, EN 301 549)

## Checklist

- [ ] Data minimization implemented
- [ ] Consent management configured
- [ ] Data export functionality exists
- [ ] Data deletion functionality exists
- [ ] Privacy policy accessible
- [ ] Cookie consent banner compliant
- [ ] No dark patterns
- [ ] Transparent pricing
- [ ] Easy cancellation
- [ ] Accessibility beyond WCAG
- [ ] Algorithmic fairness tested (if applicable)
- [ ] Industry regulations complied with

## Anti-patterns

- Collecting too much data → minimize data collection
- No consent management → add consent tracking
- No data export → add export functionality
- No data deletion → add deletion functionality
- Dark patterns → remove manipulative design
- Hidden fees → transparent pricing
- Hard to cancel → easy cancellation
- Notification spam → respect user attention
- Addictive design → justify or remove
- Biased algorithms → test for fairness
- No accessibility beyond WCAG → add cognitive accessibility
- Ignoring privacy regulations → comply with GDPR/CCPA
