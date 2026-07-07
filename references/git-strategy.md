# Git Strategy

Agent-agnostic git enforcement. Every rule is applied at the git level
(hooks, git config, branch protection) so it applies equally to
humans and any AI agent.

## Tool Selection

This file describes **patterns**, not specific tools. Tools mentioned are
**examples** to illustrate the pattern — not recommendations. When selecting
tools for this project, the agent MUST:
1. Check `docs/ARCHITECTURE.md` for the declared stack
2. Research current options (never suggest from memory)
3. Present 2-3 options with trade-offs
4. Let the user decide

**Hook framework examples by stack:**
- Node.js: Husky, lefthook, simple-git-hooks
- Python: pre-commit, pre-commit-hooks
- Go: lefthook, husky (via npm)
- Rust: lefthook, husky (via npm)
- Any: native `.git/hooks/` (no framework needed)

**Commit linting examples by stack:**
- Node.js: commitlint, commitizen
- Python: commitizen (py), gitlint
- Go: commitlint (via npm), gitlint
- Any: native commit-msg hook script

## 1. Commit Convention

Enforced via `commit-msg` hook. No exceptions.

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`,
`build`, `ci`, `chore`, `revert`.

**Rules:**
- Description: imperative mood, lowercase, no period, max 72 chars
- Scope: module or area affected (optional but encouraged)
- Body: wrap at 80 chars, explain what and why (not how)
- Footer: `BREAKING CHANGE:`, `Refs #123`, `Closes #456`

**Why:** automated CHANGELOG generation, searchable history, clear intent.

## 2. Branching

```
main                          ← always deployable
  └── issue-<n>-<slug>        ← one branch per issue, from main
```

**Rules:**
- Branch from `main`, squash-merge back to `main`
- Branch name: `issue-<n>-<slug>` (e.g., `issue-42-auth-flow`)
- One issue per branch — no multi-issue branches
- Delete branch after merge
- No direct commits to `main` — all changes via branch + merge

## 3. Pre-Commit Hook

Runs on every `git commit`. The agent should suggest the appropriate hook
framework based on the project's stack (see Tool Selection above).

**What it should do:**
1. Format staged files (linter/formatter)
2. Typechecker — exit 0
3. Test runner — exit 0 (unit tests only, fast)

## 4. Commit-Msg Hook

Runs on every `git commit` after the message is written:
- Validates conventional commit format
- Rejects non-conforming messages with actionable error

The agent should suggest the appropriate commit linting tool based on the
project's stack (see Tool Selection above).

## 5. Pre-Push Hook

Runs on every `git push`. This is the last line of defense.

**Script:** `scripts/pre-push.sh` (install to appropriate hook location)

Blocks:
- Force-push to `main` or `master`
- Push if full test suite fails
- Push if linter or typechecker fails

**Script content:** see `scripts/pre-push.sh` in this skill.

## 6. Signing

**Policy:** all commits should be signed (GPG or SSH).

**Git config (per-developer, documented in CONTRIBUTING.md):**
```bash
git config commit.gpgsign true
```

**Enforcement:** branch protection rule "Require signed commits" (GitHub)
or equivalent. This is a server-side setting, documented but not
enforced locally (since key setup is per-developer).

## 7. Semver Tagging

**Strategy:** tag every release with `vMAJOR.MINOR.PATCH`.

- `MAJOR`: breaking changes
- `MINOR`: new features (backwards-compatible)
- `PATCH`: bug fixes

**Tooling:** use a versioning tool appropriate to the stack to:
1. Bump version based on conventional commits since last tag
2. Generate CHANGELOG entry from commit history
3. Create git tag

The agent should suggest the appropriate versioning tool based on the
project's stack (see Tool Selection above).

**Release process:**
1. Run release tool
2. Push branch + tag
3. CI builds and deploys from tag

## 8. Branch Protection (documented policy)

These are server-side settings. Document in CONTRIBUTING.md, enforce
via platform settings (GitHub, GitLab, etc.).

- `main` requires PR/merge request (no direct push)
- `main` requires CI pass before merge
- `main` requires up-to-date branch before merge
- Force-push to `main` blocked
- Branch deletion of `main` blocked

## 9. What Gets Blocked (summary)

| Operation | Where blocked | Mechanism |
|-----------|--------------|-----------|
| Non-conventional commit | Local | `commit-msg` hook |
| Failing tests on commit | Local | `pre-commit` hook |
| Force-push to main | Local | `pre-push` hook |
| Push with failing tests | Local | `pre-push` hook |
| Direct push to main | Server | Branch protection rule |
| Unsigned commit (policy) | Server | Branch protection rule |

## 10. Setup Checklist (Phase 0)

- [ ] Git hook framework initialized (agent suggests based on stack)
- [ ] `pre-commit` hook: formatter + typecheck + unit test
- [ ] `commit-msg` hook: conventional commit validation
- [ ] `pre-push` hook: block force-push to main, run full test suite
- [ ] Commit linting configured (agent suggests based on stack)
- [ ] `.gitignore` verified (no secrets, no build artifacts)
- [ ] CONTRIBUTING.md documents branching, commit convention, signing
- [ ] Branch protection rules documented (apply when repo is on a host)
