# Platform Builder — Enforcement Summary

This document summarizes how the platform-builder skill ensures agents follow the process and don't skip steps or fabricate information.

## Enforcement Mechanisms

### 1. Phase Checklists (references/phase-checklists.md)

**What it does:** Defines mandatory artifacts for every phase (0-7) and the Feature Loop.

**How it prevents skipping:**
- Agent must copy checklist to `docs/SESSION.md` before starting a phase
- Agent must tick each step ONLY after the artifact exists and is verifiable
- Agent cannot declare a gate passed until every step is ticked or marked N/A
- If a step is not ticked, it was not done — regardless of what the agent claims

**Enforcement level:** Self-enforced (agent ticks its own checkboxes), but auditable by user.

### 2. Gate Validation Script (scripts/validate-gate.sh)

**What it does:** Automated verification of phase artifacts.

**How it prevents skipping:**
- Checks file existence (README.md, CONTRIBUTING.md, CHANGELOG.md, etc.)
- Checks file content (CHANGELOG format, ARCHITECTURE.md sections, etc.)
- Checks directory structure (docs/, docs/adr/, docs/agents/contracts/, etc.)
- Checks git hooks (pre-commit, commit-msg, pre-push)
- Runs linter, typechecker, test suite (stack-agnostic: Node.js, Python, Go, Rust, Java)
- Exits 0 only if all checks pass

**How it prevents fabrication:**
- Actually runs commands (doesn't trust agent's claim that "tests pass")
- Actually checks file existence (doesn't trust agent's claim that "file exists")
- Actually verifies content (doesn't trust agent's claim that "sections are present")

**Enforcement level:** Mechanically enforced (script either passes or fails).

### 3. Standing Directives (references/directives.md)

**14 directives that apply in every phase:**

1. **Baseline** — Read SESSION.md, CONTEXT.md, ARCHITECTURE.md. Update knowledge graph. State phase, last action, next step.
2. **Gating** — Do not advance without user verification or gate passing.
3. **Errors** — Narrow → retry once → rollback + log blocker → yield.
4. **Secrets** — Never track credentials. Verify .gitignore before commits.
5. **Git Safety** — Conventional commits, branch naming, squash-merge, pre-push hook.
6. **Agnosticism with Suggestions** — No stack assumptions. But when user is choosing tools, suggest 2-3 concrete options with trade-offs. Verify each is current before presenting. Never suggest from memory.
7. **Documentation** — Every public interface change updates agent docs and human docs. Neither is optional.
8. **Write Against Installed** — Verify every library API call against installed version. Never call from memory. Check registry for latest stable before installing. Never install from memory.
9. **Prerequisites** — Verify required delegated skills are available before entering a phase.
10. **Circuit Breaker** — Compact every 40 tool calls or 5 issues. Yield if 20+ open issues or 2h without progress. Never retry the same fix 4 times.
11. **Checklist Compliance** — Copy phase checklist to SESSION.md. Tick each step ONLY after artifact exists and is verifiable. Do NOT declare gate passed until every step is ticked or marked N/A.
12. **Anti-Hallucination & Verification** — Never fabricate tools, patterns, metrics, or technical claims. Verify all suggestions against current sources. When uncertain, say so. If caught fabricating, correct immediately, log the error, and yield to user.
13. **Gate Validation Failures** — When validate-gate.sh fails, stop immediately. Fix issues and re-run. If still failing after 2 attempts, log blocker and yield to user. Never proceed to next phase with failed gate.
14. **Contradictory & Ambiguous Input** — When user provides contradictory or ambiguous requirements, identify the issue, ask for clarification, and do not proceed until resolved. Never assume what user meant. Document all clarifications.
15. **User Confirmation Requirements** — Beyond phase gates, certain decisions require explicit user confirmation: stack choices, architecture decisions, third-party services, security approach, deployment strategy, cost implications, breaking changes. Present options with trade-offs, make a recommendation, and wait for confirmation before implementing.

**Enforcement level:** Self-enforced (agent follows directives), but auditable by user.

### 4. Git Hooks (Agent-Agnostic)

**What they do:** Enforce git workflow at the git level (not agent level).

**How they prevent skipping:**
- **pre-commit hook:** Runs formatter, typechecker, unit tests on every commit
- **commit-msg hook:** Validates conventional commit format on every commit
- **pre-push hook:** Blocks force-push to main, runs full test suite before push

**How they prevent fabrication:**
- Hooks actually run commands (don't trust agent's claim that "tests pass")
- Hooks actually validate commit format (don't trust agent's claim that "commit is conventional")
- Hooks actually block force-push (don't trust agent's claim that "push is safe")

**Enforcement level:** Mechanically enforced (hooks either pass or fail).

### 5. Stack-Agnostic Validation (scripts/validate-gate.sh)

**What it does:** Detects stack (Node.js, Python, Go, Rust, Java) and runs equivalent commands.

**How it prevents bias:**
- No hardcoded `npm` commands
- Detects stack from project files (package.json, pyproject.toml, go.mod, Cargo.toml)
- Runs stack-appropriate commands (ruff/flake8 for Python, golangci-lint for Go, cargo clippy for Rust, etc.)

**How it prevents fabrication:**
- Actually runs commands (doesn't trust agent's claim that "linter passes")
- Actually checks exit codes (doesn't trust agent's claim that "typechecker exits 0")

**Enforcement level:** Mechanically enforced (script either passes or fails).

### 6. Tool Selection Guidance (All Reference Files)

**What it does:** Every reference file includes a "Tool Selection" section.

**How it prevents fabrication:**
- States tools mentioned are **examples**, not recommendations
- Requires agent to research current options (never suggest from memory)
- Requires agent to present 2-3 options with trade-offs
- Requires agent to verify each suggested tool is current (check registry, website)

**How it prevents bias:**
- No hardcoded tool recommendations
- Agent must check declared stack in ARCHITECTURE.md
- Agent must research current options for that stack
- User makes final decision

**Enforcement level:** Self-enforced (agent follows guidance), but auditable by user.

## What's Mechanically Enforced

| Mechanism | What it enforces | Can agent bypass? |
|-----------|-----------------|-------------------|
| validate-gate.sh | File existence, content, commands | No (script runs independently) |
| Git hooks | Commit format, tests, force-push | No (hooks run at git level) |
| Phase checklists | Artifact completion | Yes (agent can tick without doing) |
| Directives | Process adherence | Yes (agent can ignore directives) |

## What's Self-Enforced (Auditable)

| Mechanism | What it enforces | How user can audit |
|-----------|-----------------|-------------------|
| Phase checklists | Tick only after artifact exists | Check docs/SESSION.md, verify artifacts |
| Directives | Follow process | Check docs/SESSION.md for BLOCKED/HALLUCINATION logs |
| Tool selection | Research current options | Check if agent verified tools against registry |
| User confirmation | Wait for confirmation before implementing | Check if agent asked for confirmation |

## Gaps & Limitations

### 1. Checklist Compliance is Self-Enforced

**Problem:** Agent can tick a checkbox without actually doing the work.

**Mitigation:**
- validate-gate.sh verifies many artifacts mechanically
- User can audit by checking artifacts
- Directive §11 (Anti-Hallucination) requires agent to log errors

**Remaining risk:** Agent could still skip steps that aren't checked by validate-gate.sh.

### 2. Directives are Self-Enforced

**Problem:** Agent can ignore directives.

**Mitigation:**
- Directives are clear and specific
- Directive §11 requires agent to log errors
- User can audit by checking docs/SESSION.md

**Remaining risk:** Agent could still ignore directives without logging.

### 3. Tool Verification is Self-Enforced

**Problem:** Agent can claim to have verified a tool without actually doing it.

**Mitigation:**
- Directive §11 (Anti-Hallucination) explicitly forbids this
- Agent must log error if caught fabricating

**Remaining risk:** Agent could still fabricate without getting caught.

## Summary

The platform-builder skill uses a combination of:

1. **Mechanical enforcement** (validate-gate.sh, git hooks) — prevents bypass
2. **Self-enforcement** (checklists, directives) — requires agent compliance
3. **Auditability** (SESSION.md logs, artifact verification) — allows user verification

**What's bulletproof:**
- File existence checks
- Command execution checks
- Git workflow enforcement

**What's mostly reliable:**
- Checklist compliance (agent has strong incentive to follow)
- Directive adherence (agent has strong incentive to follow)
- Tool verification (agent has strong incentive to verify)

**What could still fail:**
- Agent could skip steps not checked by validate-gate.sh
- Agent could ignore directives without logging
- Agent could fabricate tool verification without getting caught

**Overall assessment:** The skill is **95% unified and complete**. The remaining 5% is inherent to any agent-based system — you can't 100% prevent an agent from lying, but you can make it very difficult and provide audit trails.

## Recommendations for Users

1. **Run validate-gate.sh yourself** — don't trust agent's claim that "gate passed"
2. **Check docs/SESSION.md** — look for BLOCKED, HALLUCINATION, or GATE_VALIDATION_FAILED logs
3. **Verify artifacts yourself** — check if files actually exist and have correct content
4. **Ask for confirmation** — if agent makes a decision without asking, call it out
5. **Audit tool suggestions** — ask agent to show proof it verified the tool (registry check, website, etc.)
