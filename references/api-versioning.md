# API Versioning — Write Against Installed, Not Remembered

The agent's training data is frozen. The installed packages are not. A
deprecated API, a renamed method, a changed default — any of these can be
different from what the model "knows." This file defines the mandatory
workflow for verifying every library API call against the installed version
before writing code.

## Principle

> Never call a library API from memory. Always verify the signature, return
> type, and options against the version actually installed in this project.

This applies to every third-party import — no exceptions. The standard
library of the runtime is exempt unless the project uses a specific version
constraint.

## Workflow (per ecosystem)

Run these checks before writing any code that calls a library. If the check
fails or the docs are unavailable, halt and ask the user to install the
package or add doc generation.

### Node.js / TypeScript

```bash
# 1. Get installed version
jq -r '.version' node_modules/<package>/package.json

# 2. Read the installed README (covers API surface for most packages)
head -200 node_modules/<package>/README.md

# 3. Check types for signature (preferred — authoritative)
#    Read the .d.ts file for the specific export:
#    node_modules/<package>/dist/index.d.ts
#    node_modules/<package>/dist/<module>.d.ts

# 4. Check for a CHANGELOG to see if the API changed recently
head -100 node_modules/<package>/CHANGELOG.md 2>/dev/null
```

### Python

```bash
# 1. Get installed version
pip show <package> 2>/dev/null || python3 -c "import <package>; print(<package>.__version__)"

# 2. Read the installed README or docs
python3 -c "import <package>; print(<package>.__doc__)"  # module docstring

# 3. Check for deprecation warnings on the specific API
python3 -c "
import warnings
warnings.simplefilter('always', DeprecationWarning)
import <package>
# call the API you intend to use here to trigger any deprecation warning
"

# 4. Inspect the function signature
python3 -c "import inspect, <package>; print(inspect.signature(<package>.<function>))"
```

### Rust / Cargo

```bash
# 1. Get installed version from Cargo.lock
grep -A1 'name = "<crate>"' Cargo.lock

# 2. Build docs locally (slow, do once per session)
cargo doc --no-deps -p <crate> 2>/dev/null
# Then read: target/doc/<crate>/index.html

# 3. Check docs.rs for the installed version
# Fetch: https://docs.rs/<crate>/<version>/<crate>/
```

### Go

```bash
# 1. Get installed version from go.mod
grep '<module>' go.mod

# 2. Run go doc against the installed version
go doc <package>.<Symbol>

# 3. For full module docs
go doc <module>/<package>
```

### Other ecosystems

Adapt the pattern: (1) get installed version, (2) read installed docs or
type definitions, (3) verify the specific API signature before calling it.

## Installing: Always Use Latest Stable

Before adding any new dependency, the agent must check what the latest stable
(non-prerelease) version is and install that — not whatever version the model
"remembers" as current.

### Check latest stable (per ecosystem)

```bash
# Node.js — query the npm registry for the latest stable
npm view <package> version
npm view <package>@latest version    # explicit latest tag
npm view <package> versions --json | python3 -c "
import json,sys
vs = json.load(sys.stdin)
stable = [v for v in vs if 'alpha' not in v and 'beta' not in v and 'rc' not in v and 'pre' not in v and 'next' not in v and 'canary' not in v and 'nightly' not in v]
print(stable[-1])
"

# Python — query PyPI for the latest stable
pip index versions <package> 2>/dev/null || \
python3 -c "
import json,urllib.request as r
d = json.loads(r.urlopen('https://pypi.org/pypi/<package>/json').read())
vs = [v for v in d['releases'] if not any(t in v for t in ('a','b','rc','dev','pre','alpha','beta'))]
vs.sort(key=lambda v: [int(x) for x in v.replace('-','.').split('.') if x.isdigit()])
print(vs[-1] if vs else d['info']['version'])
"

# Rust — query crates.io for the latest stable
curl -s https://crates.io/api/v1/crates/<crate> | python3 -c "
import json,sys
d = json.load(sys.stdin)
vs = d['crate']['versions']
# Semver pre-release identifiers: anything after a hyphen is pre-release
# https://semver.org/#spec-item-9
stable = [v for v in vs if '-' not in v]
print(stable[0] if stable else vs[0])
"

# Go — query the module index for the latest stable
go list -m -versions <module>@latest 2>/dev/null || \
curl -s https://proxy.golang.org/<module>/@latest
```

### Rules for installing

1. **Never install from memory.** The agent must run the registry check above
   before running `npm install`, `pip install`, `cargo add`, `go get`, etc.
2. **Pin exact versions** in the manifest, not ranges. `"react": "19.2.1"` not
   `"^19.0.0"`. The agent must be explicit about which version it verified.
3. **Record the decision.** When adding a dependency, write the version and
   the registry check timestamp to a comment in the manifest:
   ```json
   // Installed 19.2.1 (latest stable as of 2026-07-05, verified via npm view)
   "react": "19.2.1"
   ```
   This lets future agents audit freshness against the registry.
4. **Check during scaffold.** Phase 0 must run the latest-stable check for
   any dependency added during project initialization.

## When to check

**Version freshness:**

- **Phase 0 — Scaffold.** Before running `install` commands that pull
  dependencies, check the latest stable version of every direct dependency.
- **Phase 3 / Feature Loop — Adding a dependency.** Before `install`, check
  latest stable. If an existing dependency is upgraded, run the same check.
- **Phase 7 — Dependency freshness audit.** Run the latest-stable check for
  every direct dependency. If the installed version is more than one major
  behind latest stable, file an upgrade issue with `risk: medium`. If more
  than two majors behind, flag as `risk: high`.

**API verification:**

- **Phase 3 / Feature Loop Implement:** Before writing any code that imports
  a third-party library, verify the API against the installed version.
  Check at minimum: the imports the agent intends to use, ordered by
  likelihood of staleness (newer packages first).
- **Phase 3 REFACTOR step:** During refactor, re-verify any library APIs
  that were added or changed in this issue.
- **Dependency changes:** If `package.json`, `requirements.txt`, `Cargo.toml`,
  or equivalent changed in the current branch, re-verify all imports from
  affected packages.

## Staleness risk ranking

Prioritize verification for these packages (highest risk of stale knowledge):

1. Packages released or major-version-bumped in the last 12 months
2. Packages with a v0.x version (unstable API)
3. Packages the agent hasn't verified in this session
4. Packages where the project's version constraint allows a newer range
   (e.g., `^2.0.0` — the agent may "know" v2.3 but v2.7 is installed)

## Anti-patterns

- **Installing from memory.** The agent must never assume it knows the latest
  version. Always query the registry. The model's training data may be months
  old — packages release weekly.
- **Guessing imports.** If the agent doesn't know the exact import path,
  read the package's index file, not guess from memory.
- **Using features from a newer major.** If the project installs v2 and the
  agent writes v3 API, the code will fail at runtime. Always check the
  major version.
- **Skipping because "it's popular."** React, Express, Flask, Axios — these
  are the worst offenders because the agent has strong (stale) priors.
- **Trusting LLM training data over installed types.** The `.d.ts` file in
  `node_modules` is the authority. The model is not.
- **Silent auto-updates.** The agent must get explicit user approval before
  upgrading a major version. Minor and patch upgrades within the same major
  are safe to apply automatically — the API surface is backward-compatible.
