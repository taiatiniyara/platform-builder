# Advanced Security

Security patterns for large-scale platforms. Apply when you need enterprise-grade
security, compliance, or have sensitive data.

## Tool Selection

This file describes **patterns**, not specific tools. Tools mentioned are
**examples** to illustrate the pattern — not recommendations. When selecting
tools for this project, the agent MUST:
1. Check `docs/ARCHITECTURE.md` for the declared stack
2. Research current options (never suggest from memory)
3. Present 2-3 options with trade-offs
4. Let the user decide

## When to Apply

- Handling sensitive data (PII, financial, health)
- Compliance requirements (SOC2, HIPAA, PCI)
- Multiple services with complex trust boundaries
- Regulatory requirements (GDPR, CCPA)
- Team >10 engineers (need formal security practices)

## Zero Trust Architecture

### Principles

1. **Never trust, always verify** — no implicit trust based on network location
2. **Least privilege** — minimum access needed for each request
3. **Assume breach** — design for compromise, limit blast radius

### Implementation

**Identity-based access:**
- Every request authenticated (user or service)
- Every request authorized (permissions checked)
- No implicit trust based on IP/network

**Microsegmentation:**
- Network segmentation between services
- Each service can only access what it needs
- Use service mesh for fine-grained control

**Continuous verification:**
- Re-authenticate periodically (not just at login)
- Monitor for anomalous behavior
- Revoke access immediately on compromise

## Service-to-Service Authentication

### mTLS (Mutual TLS)

Both client and server authenticate each other with certificates.

**Setup:**
```
Service A → presents certificate → Service B
Service B → presents certificate → Service A
Both verify certificates → trusted connection
```

**Tools:**
- Istio (service mesh, automatic mTLS)
- Linkerd (service mesh, automatic mTLS)
- Consul Connect (service mesh)
- Custom (manual certificate management)

**Benefits:**
- Strong authentication (cryptographic)
- Encrypted traffic (no eavesdropping)
- Zero trust (no implicit trust)

**Challenges:**
- Certificate management (rotation, expiration)
- Performance overhead (TLS handshake)
- Complexity (need service mesh or custom solution)

### JWT (JSON Web Tokens)

Tokens signed by identity provider, verified by services.

**Setup:**
```
Client → authenticates → Identity Provider
Identity Provider → issues JWT → Client
Client → presents JWT → Service A
Service A → verifies JWT → grants access
```

**Tools:**
- Auth0 (commercial)
- Okta (commercial)
- Keycloak (open source)
- AWS Cognito (cloud-native)

**Benefits:**
- Stateless (no session storage)
- Scalable (no central verification)
- Flexible (custom claims)

**Challenges:**
- Token revocation (hard to revoke before expiration)
- Token size (can be large with many claims)
- Key management (need to distribute public keys)

### API Keys

Simple authentication for service-to-service calls.

**Setup:**
```
Service A → presents API key → Service B
Service B → verifies API key → grants access
```

**Benefits:**
- Simple to implement
- Easy to rotate

**Challenges:**
- No expiration (need manual rotation)
- No fine-grained permissions (all-or-nothing)
- Security risk (if leaked, full access)

**Recommendation:** use for internal services only, prefer mTLS or JWT.

## Secrets Management

### Secrets Manager

Centralized storage for secrets (API keys, database passwords, certificates).

**Tools:**
- HashiCorp Vault (open source, self-hosted)
- AWS Secrets Manager (cloud-native)
- GCP Secret Manager (cloud-native)
- Azure Key Vault (cloud-native)

**Features:**
- Encryption at rest (secrets encrypted)
- Access control (who can read which secrets)
- Audit logging (who accessed what)
- Automatic rotation (rotate secrets periodically)

**Integration:**
```
Service → requests secret → Secrets Manager
Secrets Manager → verifies permissions → returns secret
Service → uses secret → connects to database/API
```

**Best practices:**
- Never store secrets in code (use environment variables)
- Never log secrets (mask in logs)
- Rotate secrets regularly (every 90 days)
- Use short-lived credentials when possible

### Dynamic Secrets

Generate secrets on-demand, short-lived.

**Example:**
```
Service → requests database access → Vault
Vault → creates temporary database user → returns credentials
Service → uses credentials → connects to database
Credentials expire after 1 hour
```

**Benefits:**
- No long-lived credentials (reduced risk)
- Automatic rotation (no manual management)
- Audit trail (who accessed what, when)

## Network Security

### Web Application Firewall (WAF)

Protect against web exploits (SQL injection, XSS, etc.).

**Tools:**
- AWS WAF (cloud-native)
- Cloudflare WAF (commercial)
- ModSecurity (open source)

**Rules:**
- Block SQL injection
- Block XSS (cross-site scripting)
- Block CSRF (cross-site request forgery)
- Rate limiting (prevent DDoS)

### DDoS Protection

Protect against distributed denial-of-service attacks.

**Tools:**
- Cloudflare (commercial)
- AWS Shield (cloud-native)
- Google Cloud Armor (cloud-native)

**Layers:**
- Layer 3/4 (network): SYN floods, UDP floods
- Layer 7 (application): HTTP floods, slow loris

### API Gateway Security

Centralized security at API gateway.

**Features:**
- Authentication (JWT, API keys)
- Rate limiting (per user, per IP)
- Request validation (schema validation)
- CORS (cross-origin resource sharing)
- IP whitelisting/blacklisting

## Data Security

### Encryption at Rest

Encrypt data stored in databases, object storage.

**Tools:**
- AWS KMS (key management)
- GCP KMS (key management)
- Azure Key Vault (key management)
- HashiCorp Vault (key management)

**Encryption levels:**
- Database-level (entire database encrypted)
- Table-level (specific tables encrypted)
- Column-level (specific columns encrypted, e.g., PII)

### Encryption in Transit

Encrypt data in motion between services.

**Tools:**
- TLS 1.3 (minimum TLS 1.2)
- mTLS for service-to-service (see above)
- HTTPS for client-to-server

**Certificate management:**
- Use Let's Encrypt (free, automated)
- Use cloud provider certificates (AWS ACM, GCP Certificate Manager)
- Automate rotation (certificates expire)

### Data Masking

Hide sensitive data in non-production environments.

**Strategies:**
- Static masking (replace PII with fake data)
- Dynamic masking (mask on read, based on permissions)
- Tokenization (replace with token, reversible)

**Tools:**
- AWS Macie (discover sensitive data)
- Google DLP (data loss prevention)
- Immuta (data masking)

## Compliance

### SOC2 (Service Organization Control 2)

Security, availability, processing integrity, confidentiality, privacy.

**Requirements:**
- Access control (authentication, authorization)
- Audit logging (who did what, when)
- Encryption (at rest, in transit)
- Incident response (detect, respond, recover)
- Vulnerability management (scan, patch)

**Tools:**
- Vanta (automated compliance)
- Drata (automated compliance)
- Secureframe (automated compliance)

### HIPAA (Health Insurance Portability and Accountability Act)

Protect health information (PHI).

**Requirements:**
- Access control (minimum necessary)
- Audit logging (access to PHI)
- Encryption (at rest, in transit)
- Business associate agreements (BAAs)
- Breach notification (within 60 days)

### PCI DSS (Payment Card Industry Data Security Standard)

Protect cardholder data.

**Requirements:**
- Firewall configuration (restrict access)
- Encryption (cardholder data)
- Access control (need-to-know)
- Network scanning (quarterly)
- Vulnerability management (patch within 30 days)

### GDPR (General Data Protection Regulation)

Protect personal data of EU citizens.

**Requirements:**
- Consent (explicit consent for data collection)
- Data minimization (collect only what's needed)
- Right to access (provide data to users)
- Right to deletion (delete user data on request)
- Data breach notification (within 72 hours)

## Security Testing

### Static Application Security Testing (SAST)

Analyze source code for vulnerabilities.

**Tools:**
- SonarQube (open source)
- Snyk (commercial)
- GitHub CodeQL (built-in)
- Semgrep (open source)

**Integration:**
- Run in CI/CD pipeline
- Block merge on critical vulnerabilities
- Track vulnerabilities in dashboard

### Dynamic Application Security Testing (DAST)

Test running application for vulnerabilities.

**Tools:**
- OWASP ZAP (open source)
- Burp Suite (commercial)
- Netsparker (commercial)

**Integration:**
- Run against staging environment
- Test for SQL injection, XSS, CSRF
- Generate vulnerability report

### Dependency Scanning

Check dependencies for known vulnerabilities.

**Tools:**
- npm audit (Node.js)
- pip audit (Python)
- cargo audit (Rust)
- Snyk (multi-language)

**Integration:**
- Run in CI/CD pipeline
- Block merge on critical vulnerabilities
- Update dependencies regularly

### Penetration Testing

Hire ethical hackers to find vulnerabilities.

**When:**
- Before major release
- Annually (for compliance)
- After major architecture changes

**Types:**
- Black box (no knowledge of internals)
- White box (full knowledge of internals)
- Gray box (partial knowledge)

## Incident Response

### Incident Response Plan

Documented process for handling security incidents.

**Phases:**
1. **Preparation:** tools, training, documentation
2. **Detection:** monitor, alert, triage
3. **Containment:** isolate affected systems
4. **Eradication:** remove threat
5. **Recovery:** restore systems
6. **Lessons learned:** post-mortem, improve

**Roles:**
- Incident commander (leads response)
- Technical lead (investigates threat)
- Communications lead (notifies stakeholders)
- Legal lead (handles compliance)

### Security Monitoring

Monitor for security incidents.

**Tools:**
- SIEM (Security Information and Event Management): Splunk, Elastic SIEM
- IDS/IPS (Intrusion Detection/Prevention): Snort, Suricata
- Log analysis: ELK stack, Datadog

**Alerts:**
- Failed login attempts (brute force)
- Unusual access patterns (data exfiltration)
- Vulnerability exploitation (CVE in logs)
- Anomalous behavior (machine learning)

## Integration with Platform Builder

### Phase 1 (Blueprint)

- Assess security requirements (compliance, sensitive data)
- Choose authentication strategy (mTLS, JWT, API keys)
- Choose secrets management (Vault, AWS Secrets Manager)
- Define network security (WAF, DDoS, API gateway)
- Document in `docs/ARCHITECTURE.md`

### Phase 5 (Security)

- Implement authentication/authorization
- Implement secrets management
- Implement encryption (at rest, in transit)
- Implement network security (WAF, DDoS)
- Run security testing (SAST, DAST, dependency scanning)

### Phase 6 (Operations)

- Set up security monitoring (SIEM, IDS)
- Set up incident response plan
- Run penetration testing (annually)
- Review compliance (SOC2, HIPAA, PCI, GDPR)

## Anti-Patterns

- **Security Through Obscurity:** hiding vulnerabilities instead of fixing
- **No Secrets Management:** secrets in code or environment variables
- **No Encryption:** data stored or transmitted in plaintext
- **No Audit Logging:** can't trace security incidents
- **No Incident Response:** unprepared for breaches
- **Ignoring Compliance:** fines, legal liability
- **Over-Privileged Services:** services have more access than needed
