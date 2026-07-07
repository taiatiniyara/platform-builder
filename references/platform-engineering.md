# Platform Engineering

Building an internal developer platform (IDP) that enables stream-aligned
teams to self-serve infrastructure and reduce cognitive load.

## Tool Selection

This file describes **patterns**, not specific tools. Tools mentioned are
**examples** to illustrate the pattern — not recommendations. When selecting
tools for this project, the agent MUST:
1. Check `docs/ARCHITECTURE.md` for the declared stack
2. Research current options (never suggest from memory)
3. Present 2-3 options with trade-offs
4. Let the user decide

## When to Apply

- 3+ stream-aligned teams (see `multi-team.md`)
- Teams spend >20% of time on infrastructure
- Inconsistent environments across teams
- Slow onboarding for new engineers
- Need standardized deployment patterns

## Internal Developer Platform (IDP)

### What is an IDP?

An IDP is a layer of abstraction over infrastructure that enables developers
to self-serve without deep infrastructure knowledge.

**Components:**
- **Golden Paths:** standardized templates for common patterns
- **Self-Service Portal:** UI for provisioning resources
- **CLI Tools:** command-line interface for common operations
- **Backstage/Port:** developer portal for service catalog

**Benefits:**
- Reduce cognitive load (developers focus on business logic)
- Standardize patterns (golden paths)
- Faster onboarding (self-service)
- Consistent environments (templates)

### Golden Paths

Standardized templates for common patterns.

**Examples:**
- **Service template:** new microservice with CI/CD, monitoring, logging
- **Database template:** provisioned database with backups, monitoring
- **Frontend template:** React app with build, deploy, CDN
- **Worker template:** background job with queue, monitoring

**Template structure:**
```
templates/
  service/
    cookiecutter.json      ← parameters
    {{cookiecutter.name}}/
      src/
      tests/
      Dockerfile
      .github/workflows/
      README.md
```

**Tools:**
- Cookiecutter (Python)
- Yeoman (Node.js)
- Backstage Software Templates
- Port

### Self-Service Portal

UI for provisioning resources without infrastructure knowledge.

**Capabilities:**
- Provision new service (from template)
- Provision database (with standard config)
- Provision environment (dev, staging, production)
- View service catalog (all services, owners, status)
- View documentation (APIs, runbooks, ADRs)

**Tools:**
- Backstage (open source)
- Port (commercial)
- Cortex (commercial)

### CLI Tools

Command-line interface for common operations.

**Examples:**
```bash
# Create new service
platform create service --name my-service --template service

# Provision database
platform create database --name my-db --type postgres

# Deploy to environment
platform deploy --service my-service --env staging

# View service status
platform status --service my-service
```

**Tools:**
- Custom CLI (wrap infrastructure tools)
- Backstage CLI
- Port CLI

## Service Catalog

Central registry of all services.

**Information per service:**
- Name, owner, team
- API documentation (link to OpenAPI spec)
- Runbooks (link to `docs/runbooks/`)
- Monitoring dashboard (link)
- On-call rotation
- Dependencies (upstream/downstream)
- Deployment status

**Tools:**
- Backstage Service Catalog
- Port Service Catalog
- Cortex Catalog

**Integration:**
- Auto-discover services from CI/CD
- Auto-discover APIs from OpenAPI specs
- Auto-discover runbooks from `docs/runbooks/`

## Environment Management

### Environment Types

| Environment | Purpose | Who uses it |
|------------|---------|------------|
| **Local** | Development on laptop | Individual developers |
| **Dev** | Integration testing | Team |
| **Staging** | Pre-production testing | Team + QA |
| **Production** | Live traffic | Users |

### Environment Parity

Environments should be as similar as possible.

**Rules:**
- Same infrastructure as code (IaC) per environment
- Same container images (different tags)
- Same configuration (different values)
- Same monitoring (different alert thresholds)

**Differences:**
- Scale (production has more replicas)
- Resources (production has more CPU/memory)
- Data (production has real data, others have test data)
- Secrets (different per environment)

### Infrastructure as Code (IaC)

Define infrastructure in code.

**Tools:**
- Terraform (multi-cloud)
- Pulumi (multi-cloud, programming languages)
- AWS CDK (AWS-specific)
- CloudFormation (AWS-specific)

**Structure:**
```
infrastructure/
  modules/
    service/          ← reusable module
    database/
    queue/
  environments/
    dev/
    staging/
    production/
  global/
    dns.tf
    iam.tf
```

**Rules:**
- All infrastructure changes via IaC (no manual changes)
- IaC changes go through code review
- IaC changes go through CI/CD
- State files stored in remote backend (S3, Terraform Cloud)

## CI/CD Standardization

### Pipeline Templates

Standardized CI/CD pipelines.

**Example:**
```yaml
# .github/workflows/service.yml
name: Service CI/CD

on:
  push:
    branches: [main]

jobs:
  test:
    uses: platform/.github/workflows/test.yml@main
  
  build:
    uses: platform/.github/workflows/build.yml@main
  
  deploy:
    uses: platform/.github/workflows/deploy.yml@main
    with:
      environment: production
```

**Benefits:**
- Consistent pipelines across services
- Centralized updates (update template, all services get update)
- Reduced duplication

### Deployment Strategies

Standardized deployment strategies.

**Strategies:**
- **Rolling update:** replace instances gradually (zero downtime)
- **Blue-green:** two identical environments, switch traffic (instant rollback)
- **Canary:** deploy to small % of traffic, monitor, roll out (safe)

**Recommendation:** canary for production, rolling update for dev/staging.

## Observability Standardization

### Logging Standard

Standardized logging format.

**Format:**
```json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "level": "info",
  "service": "order-service",
  "traceId": "abc123",
  "message": "Order placed",
  "data": {
    "orderId": "order-123",
    "customerId": "cust-456"
  }
}
```

**Rules:**
- Structured logging (JSON)
- Include trace ID (for distributed tracing)
- Include service name
- Standard log levels (debug, info, warn, error)

### Metrics Standard

Standardized metrics.

**Metrics per service:**
- Request rate (requests/second)
- Error rate (errors/requests)
- Latency (p50, p95, p99)
- Saturation (CPU, memory, disk)

**Tools:**
- Prometheus (metrics collection)
- Grafana (dashboards)
- Datadog (commercial)

### Dashboard Templates

Standardized dashboards.

**Template includes:**
- Service overview (request rate, error rate, latency)
- Infrastructure (CPU, memory, disk)
- Dependencies (upstream/downstream health)
- Business metrics (orders/second, revenue)

**Tools:**
- Grafana dashboard templates
- Datadog dashboard templates

## Integration with Platform Builder

### Phase 1 (Blueprint)

- Decide if platform team is needed (see "When to Apply")
- Define golden paths (service, database, frontend, worker)
- Choose IDP tools (Backstage, Port, etc.)
- Define environment strategy (dev, staging, production)
- Document in `docs/ARCHITECTURE.md`

### Phase 4 (Productionization)

- Set up platform team (if applicable)
- Build golden paths
- Set up self-service portal
- Set up service catalog
- Standardize CI/CD pipelines

### Phase 6 (Operations)

- Monitor platform usage (adoption rate)
- Collect feedback from stream-aligned teams
- Iterate on golden paths
- Update service catalog

## Anti-Patterns

- **Platform Team as Gatekeeper:** platform team blocks deployments (should enable)
- **No Golden Paths:** every team builds their own infrastructure
- **Over-Abstraction:** platform hides too much (can't debug)
- **Under-Abstraction:** platform requires deep infrastructure knowledge
- **No Service Catalog:** can't find who owns what
- **Inconsistent Environments:** dev works, production fails
- **Manual Infrastructure:** infrastructure changes not in IaC
