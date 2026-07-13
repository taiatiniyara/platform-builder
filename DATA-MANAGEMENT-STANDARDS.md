# Data Management Standards

## Applies when

Designing DB schemas, writing migrations, handling data ops, or implementing backup strategies.

## Checklist

### Migrations & Integrity
- [ ] Zero-downtime migrations (backward-compatible, expand-contract); rollback script per migration
- [ ] Test on production-like data; sequential (001, 002, 003); batch backfilling
- [ ] Transactions for multi-step ops (ACID); DB constraints (NOT NULL, UNIQUE, FOREIGN KEY, CHECK)
- [ ] Validate at app AND DB layer; concurrency control (optimistic locking, SELECT FOR UPDATE)

### Audit & Deletion
- [ ] Audit trails: who, what, when, where; immutable (append-only); searchable
- [ ] Soft deletes (deleted_at); automatic timestamping (created_at, updated_at, created_by, updated_by)

### Backups & Retention
- [ ] Automated (daily full, hourly incremental); tested restore procedures; point-in-time recovery
- [ ] Defined retention period; off-site storage; encrypted at rest
- [ ] Retention rules per data type; automated cleanup/archive; legal holds support

### Privacy
- [ ] Data minimization; data classification (public, internal, confidential, restricted)
- [ ] Encrypt at rest + transit; role-based access (need-to-know); data masking in non-production
- [ ] GDPR: right to deletion, data portability (JSON, CSV); consent management
