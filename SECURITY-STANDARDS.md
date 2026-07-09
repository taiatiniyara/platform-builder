# Security Standards

## Applies when

Handling user input, authentication, authorization, data storage, API endpoints, file uploads, or any security-sensitive operation.

## Rules

### Design

- Document threat model in `docs/security-model.md`
- Minimize attack surface (fewer entry points)
- Defense in depth (multiple security layers)
- Least privilege (minimum necessary access)
- Zero trust (verify every request)

### Input/Output

- Validate all input: type, length, format, range (allowlists, not blocklists)
- Encode all output: context-aware (HTML, JS, URL, CSS) to prevent XSS
- Never trust user input, even from authenticated users
- Parameterized queries only (no string concatenation for SQL)

### Authentication/Authorization

- Secure password storage: bcrypt, argon2, or scrypt (never MD5, SHA1, plain text)
- Secure cookies: HttpOnly, Secure, SameSite, proper expiration
- MFA where appropriate
- Authorization checks on every request (not just login)
- No IDOR vulnerabilities (verify resource ownership)

### Data Protection

- Encrypt at rest (AES-256) and in transit (TLS 1.3)
- No sensitive data in logs, URLs, or error messages
- No hardcoded secrets (use environment variables or secret managers)
- Proper key management and rotation

### Cryptography

- Proven libraries only (libsodium, OpenSSL), never custom crypto
- Secure random (crypto.randomBytes, not Math.random)
- Proper algorithms (AES-GCM, not DES; RSA-2048+, not RSA-512)
- Secure defaults (no CBC without authentication, no ECB)

### Dependencies

- Regular audits (npm audit, dependabot, Snyk)
- No known CVEs in production
- Pin versions, use lockfiles
- Review before adding (maintenance status, download count)

### Tooling

- Secret scanning in CI/CD (gitleaks, trufflehog)
- SAST in CI/CD
- Dependency vulnerability scanning in CI/CD
- DAST for web apps
- Security headers (CSP, HSTS, X-Frame-Options, X-Content-Type-Options)

### Logging

- Log security events (auth failures, access denials, suspicious activity)
- No sensitive data in logs (passwords, tokens, PII)
- Centralized logging with alerting
- Documented incident response plan

### API Security

- Authentication on all endpoints (except public)
- Rate limiting (prevent brute force)
- Input validation on all parameters
- CORS restricted (no wildcard in production)
- API versioning for breaking changes

### File Uploads

- Validate file type (magic bytes, not just extension)
- Limit file size
- Store outside webroot
- Random filenames (prevent directory traversal)
- Malware scanning if appropriate

## Checklist

- [ ] Input validated (allowlists)
- [ ] Output encoded (context-aware)
- [ ] Parameterized queries (no SQL injection)
- [ ] Authentication verified
- [ ] Authorization checked (every request)
- [ ] No hardcoded secrets
- [ ] Sensitive data encrypted
- [ ] Security headers set
- [ ] Rate limiting configured
- [ ] CORS restricted
- [ ] File uploads validated
- [ ] Security tooling passes (secret scan, SAST, dependency audit)

## Anti-patterns

- Hardcoded secrets → environment variables or secret managers
- Plain text passwords → bcrypt/argon2/scrypt
- SQL string concatenation → parameterized queries
- Disabled SSL validation → always validate
- Verbose errors → generic errors to users, detailed in logs
- Client-side validation only → server-side validation required
- Math.random() for security → crypto.randomBytes()
- Sensitive data in localStorage → httpOnly cookies or server-side
- Logging passwords/tokens/PII → sanitize logs
- Wildcard CORS → explicit origin list
