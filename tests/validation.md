# Skill Validation Checks

Run these checks to verify the skill is correctly structured.

## Structural

- [ ] `SKILL.md` exists and has valid YAML frontmatter (`name`, `description`)
- [ ] `name` matches the directory name (`platform-builder`)
- [ ] `description` lists triggers without enumerating all delegated skills inline
- [ ] All referenced files exist:
  - [ ] `references/delegated-skills.md`
  - [ ] `references/directives.md`
  - [ ] `references/phases.md`
  - [ ] `references/feature-loop.md`
  - [ ] `references/state-files.md`
  - [ ] `references/ui-ux.md`
  - [ ] `templates/SESSION.md`
  - [ ] `templates/CONTEXT.md`
  - [ ] `templates/ARCHITECTURE.md`
  - [ ] `templates/ISSUES.md`
  - [ ] `templates/DEPLOYMENT.md`
  - [ ] `scripts/session-status.sh`
  - [ ] `scripts/validate-gate.sh`
  - [ ] `tests/validation.md`

## Content

- [ ] Every phase (0-7) has a checkable gate criterion
- [ ] Every delegated skill is listed in `references/delegated-skills.md` with its phase
- [ ] Directives are factual and actionable (not aspirational)
- [ ] Templates are blank scaffolds, not filled-in examples
- [ ] Scripts are executable (`chmod +x`)

## Invocation

- [ ] Invocation section correctly branches on:
  - No `SESSION.md` → greenfield, Phase 0
  - Phase < 7 → resume at recorded phase
  - Phase 7 complete → Feature Loop
- [ ] State files documented in `references/state-files.md` match SKILL.md references
- [ ] Feature Loop references only skills needed post-launch (not one-time setup skills)

## Progressive Disclosure

- [ ] SKILL.md is lean — steps reference disclosed files for detail
- [ ] No duplication between SKILL.md and reference files
- [ ] Every context pointer in SKILL.md leads to an existing file

## UI/UX Quality

- [ ] `references/ui-ux.md` defines design tokens with a real palette
- [ ] State coverage table specifies loading, empty, error, success, edge case for every component
- [ ] Anti-patterns list is specific and checkable (not vague "be consistent")
- [ ] Phase 7 UX audit checklist has 13+ concrete, verifiable items
- [ ] ARCHITECTURE.md template UI/UX section references `references/ui-ux.md`
- [ ] Phase 1 gate requires UI/UX template sections filled before advancing
- [ ] Phase 7 gate requires UX audit checklist pass
