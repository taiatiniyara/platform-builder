# UX Standards

## Applies when

Building any user-facing feature, interaction, or UI string.

## Checklist

### Time-to-Wow
- [ ] First-run value in <30s (no signup wall, no tutorial) — demo visible before commitment
- [ ] Value proposition clear in <5 words at first glance
- [ ] "Mom test": would your mom understand this in one sentence?

### Simplicity
- [ ] Every feature answers: "what does this remove from the user's life?"
- [ ] Defaults are right for 80% of users; advanced settings never in critical path
- [ ] Feature count is a cost — prefer depth over breadth

### Accessibility
- [ ] WCAG 2.1 AA minimum: keyboard nav, screen reader, color contrast ≥4.5:1
- [ ] Touch targets ≥44x44px; respect prefers-reduced-motion/color-scheme
- [ ] Joyful states accessible to all (keyboard, screen reader, reduced motion)
- [ ] Color-blind users get cues through shape/icon/pattern, not color alone

### Responsiveness
- [ ] Mobile-first, works 320px+; no horizontal scroll
- [ ] Interactions <100ms (optimistic UI); page transitions <50ms perceived
- [ ] No layout shift; images optimized (WebP/AVIF, lazy loading)
- [ ] Network failures degrade gracefully (cached content, offline, queued actions)
- [ ] Core actions work offline (read, draft, queue writes)

### Emotion & Delight
- [ ] Product has distinct, human voice (not sterile, not try-hard)
- [ ] Empty states educate or entertain; loading states show progress/intent
- [ ] Error states are gentle, blame-free, with immediate recovery path
- [ ] Success states celebrate the user's action
- [ ] Transitions feel physical (acceleration/deceleration); animations <300ms, purposeful
- [ ] No generic spinners, no lorem ipsum, no "contact support" as primary CTA

### Consistency & Polish
- [ ] Design system components used; 8px grid, consistent spacing/typography/colors
- [ ] All states handled: loading, error, empty, success, disabled
- [ ] Edge cases covered: long text, missing data, network errors
- [ ] Natural micro-interactions (button press, hover); clear visual hierarchy

### Virality & Sharing
- [ ] Natural reason to invite/tell someone (collaboration, sharing results, novelty)
- [ ] Shareable outputs built in (link, image, embed); invite flow <3 taps
- [ ] Sharing message written for recipient, not sharer

### Error Forgiveness
- [ ] Undo on destructive actions (≥5s); confirmation only for irreversible
- [ ] Autosave/draft persistence — no data loss through normal use
- [ ] Every error has clear next step; no dead ends; plain-language explanations

### Feedback Flywheel
- [ ] Users can give feedback from anywhere (<2 taps)
- [ ] Public changelog; feature requests have public status (considering → building → shipped)
- [ ] Bug reports get human response within 48h; product visibly improves between visits

### i18n
- [ ] i18n framework configured (i18next, react-intl); all strings in translation files
- [ ] String interpolation used (not concatenation); pluralization supported
- [ ] Dates/numbers/currency use locale; stored UTC, displayed in user's timezone
- [ ] RTL supported (Arabic, Hebrew): CSS logical props, dir="rtl", mirrored layout
- [ ] Translation management system (Crowdin, Transifex); native speaker review
