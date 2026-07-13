# Security Standards

## Applies when

Handling user input, auth, data storage, API endpoints, file uploads, or any security-sensitive operation.

## Checklist

### Design
- [ ] Document threat model in `docs/security-model.md`; minimize attack surface
- [ ] Defense in depth; least privilege; zero trust (verify every request)

### Input/Output
- [ ] Validate all input: type, length, format, range (allowlists, not blocklists)
- [ ] Encode output context-aware (HTML, JS, URL, CSS); parameterized queries only (no SQL string concat)
- [ ] Never trust user input, even from authenticated users; server-side validation required

### Auth
- [ ] bcrypt/argon2/scrypt for passwords (never MD5/SHA1/plaintext)
- [ ] Cookies: HttpOnly, Secure, SameSite; MFA where appropriate
- [ ] Authorization on every request; no IDOR (verify resource ownership)

### Data Protection
- [ ] Encrypt at rest (AES-256) and in transit (TLS 1.3)
- [ ] No sensitive data in logs/URLs/errors; no hardcoded secrets (env vars or secret manager)
- [ ] Proper key management and rotation

### Cryptography
- [ ] Proven libraries only (libsodium, OpenSSL); crypto.randomBytes (not Math.random)
- [ ] Proper algorithms: AES-GCM, RSA-2048+; secure defaults (no CBC without auth, no ECB)

### Dependencies & Tooling
- [ ] Regular audits (npm audit, Dependabot, Snyk); no known CVEs in prod; pin versions
- [ ] CI/CD: secret scanning (gitleaks), SAST, dependency scanning, DAST
- [ ] Security headers: CSP, HSTS, X-Frame-Options, X-Content-Type-Options
- [ ] Log security events (auth failures, access denials); centralized logging with alerting

### File Uploads
- [ ] Validate file type (magic bytes, not extension); limit size; store outside webroot
- [ ] Random filenames; malware scanning if appropriate
