# Data Management Standards

## Applies when

Designing database schemas, writing migrations, handling data operations, or implementing backup strategies.

## Rules

### Migrations

- Zero-downtime (backward-compatible, expand-contract pattern)
- Test on production-like data before deploying
- Rollback script for every migration
- Sequential, numbered (001, 002, 003)
- Batch data backfilling (not all at once)
- Schema versioning (track version, support multiple during migration)

### Integrity

- Transactions for multi-step operations (ACID)
- Database constraints (NOT NULL, UNIQUE, FOREIGN KEY, CHECK)
- Validate at application AND database layer
- Concurrency control (optimistic locking with version fields, or SELECT FOR UPDATE)
- Audit trails (created_at, updated_at, created_by, updated_by)
- Soft deletes (deleted_at instead of hard delete)

### Backups

- Automated (daily full, hourly incremental)
- Tested restore procedures
- Defined retention period (30 days, 90 days, 1 year)
- Off-site storage (different region/cloud)
- Point-in-time recovery
- Encrypted at rest

### Retention

- Defined retention rules per data type
- Automated cleanup (delete/archive past retention)
- GDPR compliance (right to deletion)
- Data portability (export as JSON, CSV)
- Legal holds (prevent deletion for legal reasons)
- Archive strategy (move old data to cheap storage)

### Audit Trails

- Audit create, update, delete on sensitive data
- Structure: who, what, when, where (user ID, action, timestamp, IP)
- Immutable (append-only, no updates/deletes)
- Retained for required period
- Searchable (for compliance investigations)
- Cryptographically signed (prevent tampering)

### Privacy

- Data minimization (collect only what's needed)
- Data classification (public, internal, confidential, restricted)
- Encryption at rest and in transit
- Access control (role-based, need-to-know)
- Data masking in non-production
- Consent management (track user consent)

## Checklist

- [ ] Migrations are zero-downtime
- [ ] Migrations have rollback scripts
- [ ] Database constraints enforced
- [ ] Transactions used for multi-step operations
- [ ] Audit trails implemented
- [ ] Soft deletes used (not hard deletes)
- [ ] Backups automated and tested
- [ ] Retention policies defined
- [ ] Data export functionality exists
- [ ] Data deletion functionality exists
- [ ] Sensitive data encrypted
- [ ] Data masked in non-production

## Anti-patterns

- Manual schema changes → use migrations
- No rollback plan → add rollback scripts
- No database constraints → add constraints
- No transactions → wrap multi-step operations
- No audit trails → add audit logging
- Hard deletes → use soft deletes
- No backup strategy → automate backups
- Untested backups → test restore procedures
- No retention policy → define retention rules
- Sensitive data in plain text → encrypt
- No data classification → classify by sensitivity
