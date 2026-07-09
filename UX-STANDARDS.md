# UX Standards

## Applies when

Building any user interface, form, or interactive component.

## Rules

### Accessibility

- WCAG 2.1 AA minimum
- Keyboard navigable (all interactions work without mouse)
- Screen reader compatible (semantic HTML, ARIA labels, logical tab order)
- Color contrast ≥4.5:1 for text, ≥3:1 for UI components
- Touch targets ≥44x44px on mobile
- Respect `prefers-reduced-motion`, `prefers-color-scheme`

### Responsiveness

- Mobile-first design, works on 320px+ screens
- No horizontal scroll at any breakpoint
- Interactions respond in <100ms
- No layout shift (fixed dimensions, font loading strategy)
- Optimized images (WebP/AVIF, lazy loading, proper sizing)

### Consistency

- Use design system components, not raw HTML/CSS
- Consistent spacing (8px grid), typography, colors
- Handle all states: loading, error, empty, success, disabled
- Purposeful animations (<300ms, easing, not decorative)
- Cover edge cases: long text, missing data, network errors

### User-centered

- Solve real user problems (refer to `docs/ux-principles.md`)
- Clear visual hierarchy (important stands out)
- Reduce cognitive load (progressive disclosure, sensible defaults)
- Clear feedback (every action has visible result)
- No dark patterns, no modal spam, no confusing navigation

### Polish

- Natural micro-interactions (button press, hover states)
- Attention-guiding transitions (not jarring jumps)
- Educational/entertaining empty states
- Helpful error messages (not blame)
- Attention to detail (icon alignment, spacing, typography)

## Checklist

- [ ] Design system components used (not raw HTML/CSS)
- [ ] Keyboard navigable
- [ ] ARIA labels present
- [ ] Color contrast ≥4.5:1
- [ ] Touch targets ≥44x44px
- [ ] Responsive (320px+)
- [ ] All states handled (loading, error, empty, success)
- [ ] Animations <300ms, purposeful
- [ ] Follows `docs/ux-principles.md`

## Anti-patterns

- Generic Bootstrap/Tailwind templates → customize to brand
- Decorative animations → remove or make purposeful
- Unnecessary modals → use inline content
- Hidden navigation on desktop → show full nav
- Validation only on submit → validate on blur
- Generic loading spinners → show context/progress
- "Something went wrong" errors → specific, actionable messages
