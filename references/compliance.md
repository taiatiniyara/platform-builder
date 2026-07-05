# Compliance

Covers data privacy, audit logging, retention, and regulatory concerns.
Applied during Phase 1 (Blueprint — as architectural decisions) and
verified in Phase 5 (Data Integrity & Security). Not every platform needs
everything here — but every platform must make a conscious decision about
each section.

---

## Data Classification

Classify every data store and entity in `CONTEXT.md`:

| Classification | Examples | Storage rule |
|----------------|----------|--------------|
| Public | Display name, public profile | Any store |
| Internal | Email, preferences, usage stats | Encrypted at rest |
| Sensitive | Passwords (hashed), session tokens, PII | Encrypted at rest, masked in logs |
| Regulated | Payment data, health records, government IDs | Never store unless necessary; use processor tokens |

If classification is "Regulated", prefer a third-party processor that
provides a tokenized reference rather than storing the raw data.

---

## GDPR & Data Privacy

If the platform serves users in the EU (or may in the future), make these
decisions during Phase 1 and record them in `docs/ARCHITECTURE.md`:

### Data Minimization

- Only collect data needed to provide the service. Ask: "What happens if
  we never collect this field?"
- No pre-checked consent boxes. No bundling of consent.

### User Rights

- **Right to access:** user can export all their data in a machine-readable
  format (JSON/CSV). Document the export endpoint or manual process.
- **Right to erasure:** user can delete their account and all associated data.
  Hard-delete or irreversible anonymize within 30 days. If legal retention
  obligations exist (e.g., financial records), document the exception.
- **Right to rectification:** user can correct inaccurate data.

### Cookie Consent

If the platform sets non-essential cookies (analytics, tracking, ads):
- Block non-essential cookies before consent is given.
- Show a consent banner with "Accept", "Reject", and "Customize" options.
- Log consent decisions with timestamp and IP (anonymized).

If the platform uses no cookies beyond session/auth, no banner is needed
(but document this decision).

### Data Processing Records

Maintain a record of:
- What data is collected
- Why (purpose)
- Where it is stored (which data store, which region)
- How long it is retained
- Who has access (roles, not individuals)

This can be a single page in `docs/ARCHITECTURE.md`.

---

## Audit Logging

For every state-changing operation, log:

| Field | Example |
|-------|---------|
| Actor ID | `user:abc123` |
| Action | `order.create` |
| Target ID | `order:def456` |
| Timestamp | ISO 8601, UTC |
| IP address | Anonymized (last octet zeroed for GDPR) |
| Result | `success` / `failure: insufficient_balance` |

Audit logs are append-only, immutable, and stored separately from application
logs. They are never truncated — the retention policy applies to them as data.

At minimum, audit: login, logout, password change, account deletion, any
financial or billing operation, and any permission change.

---

## Data Retention

Declare retention periods in `docs/ARCHITECTURE.md`:

| Data type | Retention period | After expiry |
|-----------|-----------------|--------------|
| Audit logs | 1 year (or legal minimum) | Archive to cold storage, then delete |
| User data | Account lifetime + 30 days | Hard delete or irreversible anonymize |
| Backups | 30 days | Rotate and delete |
| Error logs | 90 days | Delete |
| Analytics events | 26 months (or less) | Delete or aggregate beyond recognition |

---

## Encryption

- **In transit:** TLS 1.2+ for all connections. Redirect HTTP → HTTPS.
  HSTS header with `max-age=31536000; includeSubDomains`.
- **At rest:** Encrypt database volumes, backups, and any file storage.
  Use the hosting provider's managed encryption where possible.

---

## Dependency & Supply Chain

Phase 7 dependency audit includes:
- **SBOM** (Software Bill of Materials): if tooling is available, generate
  and review a dependency tree.
- **License compliance:** flag dependencies with licenses incompatible with
  the project's license (e.g., GPL in an MIT project).
- **Known vulnerabilities:** run the project's package audit tool. File
  critical/high findings as blocking issues.

---

## Phase 5 Gate Integration

The Data Integrity & Security gate adds:
- [ ] Consent mechanism in place (if GDPR applies)
- [ ] Data export and deletion paths implemented and tested
- [ ] Audit log writing for auth and financial operations
- [ ] No PII in application logs or error messages
- [ ] HSTS header present on production
