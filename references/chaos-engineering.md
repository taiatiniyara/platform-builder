# Chaos Engineering

Practices for building confidence in system resilience through controlled
experiments. Apply when you need to verify fault tolerance and recovery.

## Tool Selection

This file describes **patterns**, not specific tools. Tools mentioned are
**examples** to illustrate the pattern — not recommendations. When selecting
tools for this project, the agent MUST:
1. Check `docs/ARCHITECTURE.md` for the declared stack
2. Research current options (never suggest from memory)
3. Present 2-3 options with trade-offs
4. Let the user decide

## When to Apply

- System has multiple services (microservices)
- High availability requirements (99.9%+)
- History of outages or incidents
- Want to proactively find weaknesses
- Team has experience with distributed systems

**Don't apply when:**
- Monolith with single point of failure
- Team lacks distributed systems experience
- No monitoring or observability
- No incident response process

## Chaos Engineering Principles

### 1. Build a Hypothesis

Define what you expect to happen.

**Example:**
```
Hypothesis: If the payment service fails, the order service should:
- Return error to user (not hang)
- Log the failure
- Alert on-call
- Recover when payment service recovers
```

### 2. Vary Real-World Events

Simulate real failures.

**Examples:**
- Kill a service instance
- Add latency to network
- Block network traffic
- Consume CPU/memory
- Corrupt data
- Expire certificates

### 3. Run Experiments in Production

Test in real environment (with safeguards).

**Progression:**
1. **Dev environment:** safe to break things
2. **Staging environment:** similar to production
3. **Production (canary):** small % of traffic
4. **Production (full):** all traffic (with rollback)

### 4. Automate Experiments

Run experiments continuously.

**Benefits:**
- Continuous verification (not one-time)
- Catch regressions (new code breaks resilience)
- Build confidence (system handles failures)

## Chaos Experiment Types

### Infrastructure Failures

**Instance termination:**
- Kill EC2 instance / Pod / Container
- Verify system recovers (auto-scaling, failover)
- Measure recovery time (RTO)

**Example:**
```bash
# Terminate random instance in auto-scaling group
aws autoscaling terminate-instance-in-auto-scaling-group \
  --instance-id i-1234567890abcdef0 \
  --no-should-decrement-desired-capacity
```

**Network failures:**
- Block traffic between services
- Add latency to network
- Drop packets

**Example:**
```bash
# Add 500ms latency to traffic from service A to service B
tc qdisc add dev eth0 root netem delay 500ms
```

### Application Failures

**Service crashes:**
- Kill service process
- Inject exceptions
- Corrupt responses

**Example:**
```python
# Inject failure in 10% of requests
if random.random() < 0.1:
    raise Exception("Simulated failure")
```

**Dependency failures:**
- Database connection timeout
- API call timeout
- Message queue failure

### Data Failures

**Data corruption:**
- Corrupt database records
- Return invalid data from API
- Inject malformed messages

**Example:**
```python
# Corrupt 5% of database reads
if random.random() < 0.05:
    return {"id": -1, "name": None}  # Invalid data
```

**Data loss:**
- Delete database records
- Lose messages in queue
- Corrupt files in storage

## Chaos Engineering Tools

### Chaos Monkey

Randomly terminate instances in production.

**Tools:**
- Chaos Monkey (Netflix, open source)
- Chaos Monkey for Spring Boot (Java)
- kube-monkey (Kubernetes)

**Setup:**
```yaml
# kube-monkey configuration
kind: ConfigMap
apiVersion: v1
metadata:
  name: kube-monkey-config
data:
  config.toml: |
    [chaosmonkey]
    enabled = true
    run_hour = 8
    run_minute = 0
    terminator_enabled = true
```

### Litmus

Chaos engineering platform for Kubernetes.

**Features:**
- Pre-built chaos experiments
- ChaosHub (experiment library)
- Dashboard for experiment results
- GitOps-based experiment management

**Example experiment:**
```yaml
apiVersion: litmuschaos.io/v1alpha1
kind: ChaosEngine
metadata:
  name: pod-delete
spec:
  appinfo:
    appns: default
    applabel: app=order-service
  chaosServiceAccount: pod-delete-sa
  experiments:
    - name: pod-delete
      spec:
        components:
          env:
            - name: TOTAL_CHAOS_DURATION
              value: "30"
            - name: CHAOS_INTERVAL
              value: "10"
            - name: FORCE
              value: "false"
```

### Gremlin

Commercial chaos engineering platform.

**Features:**
- SaaS platform (no installation)
- Pre-built experiments (CPU, memory, network, process)
- Dashboard for experiment results
- Automated experiments (continuous chaos)

**Example:**
```bash
# Kill process on host
gremlin attack kill -p order-service

# Add latency to network
gremlin attack network latency -d eth0 -l 500

# Consume CPU
gremlin attack cpu -c 4
```

### Chaos Toolkit

Open source chaos engineering framework.

**Features:**
- Python-based (extensible)
- JSON/YAML experiment definitions
- Extensions for various platforms
- Reporting and analytics

**Example experiment:**
```json
{
  "version": "1.0.0",
  "title": "What is the impact of order service failure?",
  "description": "Verify order service resilience",
  "method": [
    {
      "type": "action",
      "name": "terminate-order-service-pod",
      "provider": {
        "type": "python",
        "module": "chaosk8s.pod.actions",
        "func": "terminate_pods",
        "arguments": {
          "label_selector": "app=order-service",
          "ns": "default"
        }
      }
    },
    {
      "type": "probe",
      "name": "checkout-still-works",
      "steady-state-hypothesis": "checkout should work",
      "provider": {
        "type": "http",
        "url": "http://checkout-service/health",
        "timeout": 5
      },
      "tolerance": 200
    }
  ]
}
```

## Game Days

Structured chaos engineering exercises.

### Planning

**Define scope:**
- Which services to test
- Which failure scenarios
- Who participates (teams)
- When to run (maintenance window)

**Define success criteria:**
- System recovers within RTO
- No data loss
- Users unaffected (or minimal impact)
- On-call notified correctly

**Prepare rollback:**
- How to stop experiment
- How to restore system
- Who has authority to stop

### Execution

**During game day:**
1. **Brief participants:** explain experiment, roles
2. **Start experiment:** inject failure
3. **Monitor system:** observe behavior
4. **Record observations:** what worked, what didn't
5. **Stop experiment:** restore system
6. **Debrief:** discuss findings, action items

### Post-Mortem

**Document findings:**
- What happened (timeline)
- What worked well
- What didn't work
- Action items (improvements)

**Share learnings:**
- Post-mortem document
- Team meeting
- Update runbooks
- Update architecture

## Continuous Chaos

Automate chaos experiments in CI/CD.

### Pre-Deployment

Run chaos experiments before deployment.

**Pipeline:**
```
Code → Build → Test → Chaos Experiment → Deploy
                              ↓
                        Inject failure
                        Verify resilience
                        Pass/Fail
```

**Example:**
```yaml
# GitHub Actions workflow
- name: Run chaos experiment
  run: |
    chaos run experiment.json
    
- name: Check resilience
  run: |
    if [ $? -ne 0 ]; then
      echo "Chaos experiment failed"
      exit 1
    fi
```

### Post-Deployment

Run chaos experiments after deployment.

**Schedule:**
- Daily: basic experiments (instance termination)
- Weekly: complex experiments (network failures)
- Monthly: full game day

**Tools:**
- Kubernetes CronJobs (schedule experiments)
- AWS EventBridge (schedule experiments)
- Gremlin (automated experiments)

## Resilience Patterns to Test

### Circuit Breaker

**Test:**
- Inject failure in downstream service
- Verify circuit breaker opens
- Verify fallback response
- Verify circuit breaker closes when service recovers

### Retry with Backoff

**Test:**
- Inject transient failure (timeout, 503)
- Verify retry with backoff
- Verify max retries respected
- Verify eventual success or failure

### Timeout

**Test:**
- Inject latency in downstream service
- Verify timeout triggers
- Verify timeout value appropriate
- Verify error handled gracefully

### Bulkhead

**Test:**
- Overload one service
- Verify other services unaffected
- Verify resource isolation (connection pools, thread pools)

### Fallback

**Test:**
- Inject failure in service
- Verify fallback response
- Verify fallback data acceptable
- Verify fallback performance acceptable

## Integration with Platform Builder

### Phase 4 (Productionization)

- Define resilience requirements (RTO, RPO)
- Implement resilience patterns (circuit breaker, retry, timeout)
- Set up monitoring and alerting

### Phase 6 (Operations)

- Start chaos experiments in dev/staging
- Run game days (quarterly)
- Automate chaos experiments in CI/CD
- Review resilience patterns (are they working?)

## Anti-Patterns

- **No Hypothesis:** random chaos without learning goal
- **Testing in Production Only:** no practice in dev/staging
- **No Monitoring:** can't observe system behavior
- **No Rollback Plan:** can't stop experiment
- **Blame Culture:** use chaos to blame teams (should be learning)
- **One-Time Event:** chaos once, then forget (should be continuous)
- **Ignoring Results:** run experiments but don't act on findings
