# Standing Directives

Rules the agent follows in every phase.

## 1. Baseline

On every entry, read `docs/SESSION.md`, `CONTEXT.md`, and
`docs/ARCHITECTURE.md`. If the project has source files, run
`/graphify . --update` to refresh the knowledge graph, then scan
`graphify-out/GRAPH_REPORT.md` for god nodes and surprising connections.
State phase, last action, next step before doing anything else.

When navigating the codebase to understand architecture or dependencies,
query the graph (`/graphify query "<question>" --budget 2000`) instead of
reading source files directory-by-directory. The graph is the structural
index — use it first, fall back to raw file reads only when the graph
answers are insufficient.

## 2. Gating

Do not advance to the next phase without explicit user verification or the
phase gate passing. A gate is satisfied when its stated checkable condition
evaluates to true — not when the agent thinks it should be true.

## 3. Errors

Narrow the failing scope and retry once. If still failing:
- If in a git repo: roll back to the last stable commit.
- Log the blocker to `docs/SESSION.md` with the format:
  `BLOCKED: <phase> — <what failed> — <remediation prompt>`.
- Yield to the user with the remediation prompt.

## 4. Secrets

Never track credentials, keys, tokens, or secrets in any file. Verify
`.gitignore` covers all sensitive paths before every commit. If a
`.gitignore` entry is missing, add it before committing.

## 4b. Git Safety

All git enforcement is agent-agnostic — applied via git hooks (Husky),
not agent-specific config. Follow `references/git-strategy.md`:

- **Commits:** conventional commit format enforced by `commit-msg` hook
- **Branches:** `issue-<n>-<slug>` from `main`, squash-merge back, delete
- **Push:** `pre-push` hook blocks force-push to `main`, runs full test suite
- **No direct to main:** all changes via branch + merge
- **Signing:** commits should be GPG/SSH signed (documented in CONTRIBUTING.md)

Never bypass hooks (`--no-verify`). Never force-push to protected branches.
Never commit directly to `main`. If a hook fails, fix the issue — do not
work around it.

## 5. Agnosticism with Suggestions

No assumptions about Docker, databases, HTTP, Unix, or any specific stack.
Every action is driven by declarations in `docs/ARCHITECTURE.md`. If a
needed declaration is missing (e.g., "which data store?"), halt and ask the
user rather than guessing.

**However:** when the user is deciding on tools, technologies, or patterns,
the agent MUST provide concrete suggestions based on the declared stack and
requirements. Do not say "choose whatever works" — research and present
2-3 options with trade-offs. Examples:

- "For your Node.js API, consider: Express (mature, flexible), Fastify
  (high performance), or Hono (lightweight, edge-ready)"
- "For your PostgreSQL database, consider: Supabase (managed, realtime),
  Neon (serverless, branching), or Railway (simple, predictable pricing)"
- "For authentication, consider: Auth0 (enterprise, expensive), Clerk
  (developer-friendly), or Lucia (open source, self-hosted)"

Always verify suggested tools are current (check registry, website) before
presenting. Never suggest from memory — training data may be outdated.

## 6. Documentation

Every code change that introduces or modifies a public interface must update
the corresponding documentation. Agent docs (`docs/agents/`, `graphify-out/`)
and human docs (README, CHANGELOG, ADRs) are equally required — neither is
optional. A public interface without docstrings, contract, or graph node is
a gate failure. During Phase 7, run the full doc audit from
`references/documentation.md` § "Doc Audit".

## 7. Write Against Installed, Not Remembered

Never call a library API from memory. Before writing any code that imports
a third-party package, verify the API signature, options, and return type
against the version actually installed in the project. Read the installed
types, docs, or README from `node_modules/`, `pip show`, `go doc`, etc. See
`references/api-versioning.md` for per-ecosystem workflows. The installed
`.d.ts` file is the authority — the model's training data is not.

When adding or upgrading a dependency, never install from memory either.
Check the latest stable version against the package registry first
(`npm view`, `pip index versions`, `go list -m -versions`, etc.) and pin
exact versions with a registry-check timestamp comment in the manifest.

## 8. Prerequisites

On first entry (greenfield) and at the start of every phase transition,
verify that every delegated skill required by the current phase is
available. Cross-reference the phase against `references/delegated-skills.md`
and `references/skill-prerequisites.md`. If a required skill is missing,
install it or halt and ask the user. Do not enter a phase without its tools.

## 9. Circuit Breaker

Sessions are not infinite. Track three signals to avoid drift:

- **Issue depth:** if more than 20 issues are open in Phase 3, pause.
  Compact completed work to `docs/SESSION.md`, run `/handoff`, and yield
  to the user with a summary of what's done and what's next. Do not
  silently accumulate unfinished issues.

- **Session length:** update `last_compaction` in `docs/SESSION.md` every
  40 tool calls or after completing every 5th issue, whichever comes
  first. Record the ISO timestamp. If `last_compaction` is more than 2
  hours old with no phase progress, compact and yield.

- **Stuck loop:** if the same bug reoccurs across 3 or more compactions,
  stop. Write `BLOCKED: <phase> — loop detected on <bug> — investigate
  root cause before continuing` to `docs/SESSION.md`. Do not retry the
  same fix a fourth time.

- **Brownfield entry:** if the project already has source files when
  Phase 0 begins, treat it as a brownfield. Do not scaffold from scratch.
  Instead: (a) survey existing stack and record it in
  `docs/ARCHITECTURE.md`, (b) build `CONTEXT.md` from existing code
  (run `/domain-modeling`), (c) run `/graphify .` to index what's there,
  (d) skip Phase 0 scaffolding — jump to Phase 1 (Blueprint) with the
  existing codebase as working material. Gate: ARCHITECTURE.md accurately
  describes what's already deployed.

## 10. Checklist Compliance

Phase checklists are the primary enforcement mechanism. Before starting
any phase, copy its checklist from `references/phase-checklists.md` into
`docs/SESSION.md` under the `## Phase Checklist` section.

**Rules:**
- Tick a step ONLY after its artifact exists and is verifiable. Do not
  tick based on intent or partial completion.
- If a step is not applicable, write `N/A — <reason>` instead of ticking.
- Do NOT declare a gate passed until every step is ticked or marked N/A.
- If a required skill is unavailable, write `BLOCKED — <skill> missing`
  and yield to the user. Do not skip the step silently.
- The checklist is the proof of work. If a step is not ticked, it was
  not done — regardless of what the agent claims.

**Verification:** before declaring a gate passed, the agent MUST:
1. Re-read the checklist in `docs/SESSION.md`.
2. Verify every ticked step has a corresponding artifact that exists.
3. Confirm every artifact is valid (e.g., file is non-empty, command
   actually exited 0, not just "should have" exited 0).
4. If any artifact is missing or invalid, un-tick the step and complete
   it before advancing.

This directive is non-negotiable. Checklist compliance is what prevents
agents from skipping mandatory steps like grilling, graphify, UI/UX
reviews, and other critical quality gates.

## 11. Anti-Hallucination & Verification

The agent MUST NOT fabricate or invent information. All recommendations,
tool suggestions, architecture decisions, and technical claims must be
verifiable against current sources.

**Rules:**
- **Never suggest tools from memory.** Always check the registry, website,
  or documentation to verify the tool exists, is current, and matches the
  declared stack.
- **Never invent patterns or practices.** If a pattern is not in the
  reference files, do not claim it exists. Research it or ask the user.
- **Never fabricate metrics, statistics, or benchmarks.** If you don't
  have real data, say "I don't have data on this" or research it.
- **Never claim to have verified something you haven't.** If you say
  "I checked the registry" or "I verified the tool exists," you must
  have actually done it in this session.
- **When uncertain, say so.** Use phrases like "I'm not certain about
  this, let me verify" or "I don't have information on this."

**Verification workflow:**
1. Before suggesting any tool, check its registry/website for:
   - Current version
   - Last update date
   - Compatibility with declared stack
   - License and maintenance status
2. Before recommending any pattern, verify it exists in the reference
   files or research it from authoritative sources.
3. Before making any technical claim, verify it against installed
   versions, documentation, or authoritative references.

**Consequences:** If the agent is caught fabricating information, it must:
1. Immediately correct the false information
2. Log the error to `docs/SESSION.md` with format:
   `HALLUCINATION: <what was fabricated> — <correct information>`
3. Re-verify all other claims made in the session
4. Yield to the user with an apology and corrected information

This directive is non-negotiable. Hallucination destroys trust and leads
to broken systems.

## 12. Gate Validation Failures

When `scripts/validate-gate.sh <phase>` fails, the agent MUST NOT proceed
to the next phase. Gate validation is a hard requirement.

**On validate-gate.sh failure:**
1. **Stop immediately.** Do not attempt to advance to the next phase.
2. **Read the error output.** Identify which artifacts are missing or invalid.
3. **Fix the issues.** Complete the missing artifacts or fix invalid ones.
4. **Re-run validate-gate.sh.** Verify all issues are resolved.
5. **If still failing after 2 attempts:**
   - Log the blocker to `docs/SESSION.md` with format:
     `GATE_VALIDATION_FAILED: <phase> — <what failed> — <remediation needed>`
   - Yield to the user with the specific failures and ask for guidance.
   - Do NOT proceed to the next phase.

**Common failures and fixes:**
- **Missing files:** Create the required files from templates
- **Empty files:** Populate the files with required content
- **Command failures:** Fix the underlying issue (lint errors, test failures, etc.)
- **Missing sections:** Add the required sections to documentation

**Never:**
- Skip validate-gate.sh and proceed anyway
- Manually verify artifacts instead of running the script
- Claim the gate passed when the script failed
- Modify the script to make it pass without fixing the underlying issues

This directive is non-negotiable. Gate validation ensures quality and
prevents incomplete work from advancing.

## 13. Contradictory & Ambiguous Input

When the user provides contradictory or ambiguous requirements, the agent
MUST NOT proceed with assumptions. Clarification is required.

**On contradictory input:**
1. **Identify the contradiction.** Clearly state what conflicts.
   Example: "You mentioned PostgreSQL for the database, but also said
   you need a document database. These are different database types."
2. **Ask for clarification.** Present the contradiction and ask the user
   to choose or clarify.
3. **Do NOT proceed** until the contradiction is resolved.
4. **Document the resolution** in `docs/SESSION.md` or an ADR.

**On ambiguous input:**
1. **Identify the ambiguity.** Clearly state what is unclear.
   Example: "You said 'make it fast,' but I need specific performance
   targets. What response time do you consider 'fast'?"
2. **Ask for specifics.** Request concrete, measurable requirements.
3. **Provide examples** of what specific requirements look like.
   Example: "For performance, I need: p95 response time < 200ms,
   throughput > 1000 req/s, etc."
4. **Do NOT proceed** until the ambiguity is resolved.
5. **Document the clarification** in `docs/SESSION.md` or an ADR.

**Never:**
- Assume what the user meant when input is contradictory or ambiguous
- Proceed with one interpretation without confirming with the user
- Make decisions on behalf of the user for ambiguous requirements
- Silently pick one option when multiple interpretations exist

**Always:**
- Ask clarifying questions before proceeding
- Document all clarifications and decisions
- Confirm understanding with the user before implementing

This directive is non-negotiable. Proceeding with unclear requirements
leads to wasted work and user frustration.

## 14. User Confirmation Requirements

Beyond phase gates, certain decisions require explicit user confirmation
before implementation. The agent MUST NOT make these decisions unilaterally.

**Decisions requiring user confirmation:**
1. **Stack choices** — language, framework, database, hosting provider
2. **Architecture decisions** — microservices vs monolith, sync vs async,
   event-driven vs request-response
3. **Third-party services** — payment providers, email services, CDNs, etc.
4. **Security approach** — authentication method, encryption strategy,
   compliance requirements
5. **Deployment strategy** — cloud provider, region, scaling approach
6. **Cost implications** — any decision with significant cost impact
7. **Breaking changes** — API changes, data migrations, deprecations

**Confirmation workflow:**
1. **Present the decision.** Clearly state what needs to be decided.
2. **Provide options.** Present 2-3 options with trade-offs (per §5).
3. **Recommend an option.** State which option you recommend and why.
4. **Ask for confirmation.** Explicitly ask: "Do you approve this decision?"
5. **Wait for response.** Do NOT proceed until the user confirms.
6. **Document the decision.** Record in `docs/SESSION.md` or an ADR.

**Example confirmation:**
```
I need your confirmation on the database choice.

Options:
1. PostgreSQL (managed: Supabase) — relational, strong consistency, $25/mo
2. MongoDB (managed: Atlas) — document, flexible schema, $30/mo
3. DynamoDB (AWS) — key-value, serverless, pay-per-request

Recommendation: PostgreSQL (Supabase) because your domain has strong
relational requirements and you need ACID transactions for orders.

Do you approve using PostgreSQL with Supabase?
```

**Never:**
- Implement a decision without user confirmation
- Assume silence means approval
- Make cost-impacting decisions without explicit approval
- Choose third-party services without user input
- Proceed with breaking changes without confirmation

**Always:**
- Present options with trade-offs
- Make a clear recommendation
- Ask for explicit confirmation
- Document the decision and rationale

This directive is non-negotiable. User confirmation prevents misalignment
and ensures the user is in control of key decisions.
