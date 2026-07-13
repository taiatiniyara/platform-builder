# Lovable Software Standards

## Applies when

Building any user-facing feature, designing any interaction, writing any copy, or deciding what to build next. This file gates loveability — does the software make people happy, does it feel effortless, and would they tell a friend about it?

## Rules

### Time-to-Wow

- First-run value in <30 seconds (no signup wall, no setup wizard, no tutorial)
- Demo/sandbox/gallery mode visible before any commitment
- Benefit is obvious before effort is asked
- Core value proposition is clear in <5 words at first glance
- Onboarding is skip-everything-by-default, show-don't-tell

### Simplicity

- Do one thing exceptionally well; remove, don't add
- Every feature proposed must answer: "what does this remove from the user's life?"
- Defaults are always the right choice for 80% of users
- Advanced settings exist but are never in the critical path
- Feature count is a cost, not a metric — prefer depth over breadth

### Emotion & Personality

- The product has a distinct voice (not sterile corporate, not try-hard quirky)
- Copy shows personality in empty states, errors, loading, and success
- Brand feels human — a specific person could have written every line
- Micro-copy in buttons/labels uses verbs the user would actually say
- No lorem ipsum, no placeholder text, no "TODO" in shipped copy

### Delight Details

- Empty states educate or entertain (not blank pages)
- Loading states communicate progress and intent (not generic spinners)
- Success states celebrate the user's action (not silent completion)
- Error states are gentle and blame-free, with immediate recovery path
- Transitions feel physical: acceleration/deceleration, not linear
- Hover, press, focus states all feel responsive and intentional

### Virality & Sharing

- There is a natural reason to invite someone (collaboration, comparison, sharing results)
- Shareable outputs are built in (link, image, embed) — not an afterthought
- The sharing message is written for the recipient, not the sharer
- Invite flow is <3 taps/clicks and previews what the recipient will see
- Word-of-mouth triggers exist: something remarkably fast, beautiful, clever, or personality-driven that people will describe unprompted

### Error Forgiveness

- Undo is available on every destructive action for ≥5 seconds
- Confirmation is required for irreversible actions only; else just undo
- No data loss is possible through normal use — autosave, draft persistence
- "Are you sure?" dialogs are replaced with "We'll keep this for 30 days"
- Every error has a clear next step; no dead ends, no "contact support" as primary CTA

### Speed = Respect

- Interactions respond in <100ms (optimistic UI, not spinners, for known outcomes)
- Page/route transitions are instant (<50ms perceived)
- Typing never lags; scroll never janks; click always responds
- Network failures degrade gracefully — cached content, offline mode, queued actions
- Slow operations show progress, not indeterminacy

### It Just Works

- Zero configuration path exists and is tested (the "curl and go" experience)
- Works on the device the user has right now (browser, OS, screen size)
- Offline capability for core actions (read, draft, queue writes)
- No mysterious errors — every message explains what happened in plain language
- If something can fail silently, it fails loudly with a fix-it path

### Feedback Flywheel

- Users can give feedback from anywhere in the product (<2 taps)
- Public changelog shows what shipped and what's coming
- Feature requests get a public status (under consideration → building → shipped)
- Bug reports get a human response within 48 hours
- The product visibly improves between visits — return visits feel rewarded

### Accessibility of Joy

- Delight is not gated behind animation preference — reduced-motion users still get personality
- Keyboard-only users experience the same delightful states (not just functional)
- Screen readers hear the same personality in copy, not just ARIA labels
- Color-blind users get the same emotional cues through shape/icon/pattern
- Low-bandwidth users get the core experience, then progressive enhancement

## Checklist

- [ ] First-run value in <30 seconds
- [ ] Demo/sandbox visible before signup
- [ ] Value proposition clear in <5 words at first glance
- [ ] Product has a distinct, human voice
- [ ] Empty states educate or entertain
- [ ] Loading states communicate progress and intent
- [ ] Error messages are gentle, blame-free, with recovery path
- [ ] Undo on destructive actions
- [ ] Autosave/draft persistence (no data loss through normal use)
- [ ] Interactions respond in <100ms
- [ ] Page/route transitions instant (<50ms perceived)
- [ ] Network failures degrade gracefully (cached content, offline mode, queued actions)
- [ ] Natural sharing/invite reason built in
- [ ] Shareable outputs (link, image, embed)
- [ ] Invite flow <3 taps
- [ ] Feedback accessible from anywhere (<2 taps)
- [ ] Public changelog exists
- [ ] Core actions work offline
- [ ] Zero-config path tested
- [ ] Works on the device the user has right now (browser, OS, screen size)
- [ ] No mysterious errors — plain-language explanations
- [ ] Feature requests have public status (considering → building → shipped)
- [ ] Bug reports get human response within 48 hours
- [ ] Product visibly improves between visits
- [ ] Joyful states accessible to all users (keyboard, screen reader, reduced motion)
- [ ] Color-blind users get emotional cues through shape/icon/pattern
- [ ] Mom test: would your mom understand what this does in one sentence?
- [ ] No generic spinners, no lorem ipsum, no "contact support" as primary CTA

## Anti-patterns

- Signup wall before value → show value first, signup optional
- Tutorials/wizards before use → let users play, offer help contextually
- Generic empty states → educate or entertain
- Indeterminate spinners for known durations → show progress or optimistic UI
- "Something went wrong" → specific, actionable, blame-free message
- "Are you sure?" → undo instead of confirm
- Sterile corporate copy → human voice
- Feature creep → ask "what does this remove?"
- Hidden settings → sensible defaults, progressive disclosure
- No way to give feedback → feedback path from every page
- Silent failures → fail loudly with fix-it path
- Sharing as afterthought → built into the core loop
- "Contact support" as primary error CTA → self-serve recovery path
- No personality → distinct voice in every state
