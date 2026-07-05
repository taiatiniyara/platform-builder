# UI/UX Design Heuristics

Prescriptive guidance the agent applies during implementation. All decisions
recorded in `docs/ARCHITECTURE.md#ui-ux`.

## 1. Design Tokens

Define these before writing any component. No ad-hoc values in components.

```css
:root {
  /* Spacing scale — 4px base, multiplicative */
  --space-1: 4px;   --space-2: 8px;   --space-3: 12px;
  --space-4: 16px;  --space-5: 20px;  --space-6: 24px;
  --space-8: 32px;  --space-10: 40px; --space-12: 48px;
  --space-16: 64px;

  /* Typography scale — one modular scale */
  --text-xs: 0.75rem;  --text-sm: 0.875rem; --text-base: 1rem;
  --text-lg: 1.125rem; --text-xl: 1.25rem;  --text-2xl: 1.5rem;
  --text-3xl: 1.875rem; --text-4xl: 2.25rem;

  /* Font weight — max 3 weights */
  --font-normal: 400; --font-medium: 500; --font-bold: 700;

  /* Line height */
  --leading-tight: 1.25; --leading-normal: 1.5; --leading-relaxed: 1.75;

  /* Color palette — semantic, not descriptive */
  --color-bg: #...;        --color-bg-secondary: #...;
  --color-text: #...;      --color-text-secondary: #...;
  --color-border: #...;    --color-border-hover: #...;
  --color-accent: #...;    --color-accent-hover: #...;
  --color-success: #...;   --color-warning: #...;   --color-error: #...;

  /* Radii — max 3 sizes */
  --radius-sm: 4px; --radius-md: 8px; --radius-lg: 12px;

  /* Shadows — max 3 elevations */
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
  --shadow-md: 0 4px 6px rgba(0,0,0,0.07);
  --shadow-lg: 0 10px 25px rgba(0,0,0,0.1);
}
```

Choose a real palette. Every color decision must pass WCAG AA contrast (4.5:1
for normal text, 3:1 for large text). Test with
https://webaim.org/resources/contrastchecker/.

## 2. State Coverage

Every interactive component must render all of these before it ships:

| State | Trigger | What to show |
|-------|---------|-------------|
| **Loading** | Data fetching, form submitting | Skeleton or spinner. Never blank. Never flash "No data" then populate. |
| **Empty** | Zero results, new account | Illustration + clear CTA. Never "No items found" alone. |
| **Error** | Network failure, server 500 | What went wrong + retry action. Never raw stack trace. |
| **Success** | Form saved, action completed | Confirmation inline (not just toast). Auto-dismiss or clear next action. |
| **Edge case** | Long text, zero value, null | Truncation, monospace for codes, `—` for null. |

For **every page/screen**: define how it looks when data hasn't loaded yet,
when there's nothing to show, and when something breaks. Ship the skeleton
with the component — not later.

## 3. Component Architecture

Prefer these patterns. Each has known UX properties.

### Data Display
- **Table:** sortable columns, sticky header, row hover, responsive collapse
  to card layout below 768px.
- **Card grid:** consistent card height within rows, consistent image aspect
  ratio (16:9 or 4:3), hover state on interactive cards.
- **List:** divider or alternating row color, avatar + title + subtitle
  pattern, swipe/context actions on mobile.

### Forms
- **Labels:** always visible (never placeholder-only). Above the input on
  mobile, left-aligned on desktop.
- **Validation:** validate on blur, not on keystroke. Show error below the
  field in red. Disable submit until valid + not submitting.
- **Buttons:** one primary action per form. Secondary as outline/ghost.
  Destructive actions confirmed with dialog.
- **Input sizing:** match expected content width. A 2-char field should not
  be full-width.

### Navigation
- **Top-level:** max 5 items. Current page highlighted. Logo links to home.
- **Mobile:** hamburger or bottom tab bar (max 5 tabs). Back button always
  available on sub-pages.
- **Breadcrumbs:** on any page deeper than 2 levels. Last item is current page
  (not a link).

### Feedback
- **Toasts:** top-right, auto-dismiss after 5s. For transient success/error.
  Not for confirmations that need acknowledgment.
- **Dialogs:** for destructive actions and decisions that block workflow.
  Focus trap. Escape closes. Click-outside closes.
- **Inline feedback:** preferred over toasts for form results. Stays visible
  until user dismisses or navigates.

## 4. Layout & Spacing

- **Vertical rhythm:** consistent spacing between sections (space-8 or
  space-12). Double the gap between unrelated sections vs related ones.
- **Max content width:** 72ch for prose, 1200px for app layouts. Center on
  viewport.
- **Visual hierarchy:** size → weight → color → spacing, in that priority
  order. A heading distinguished only by color is invisible.
- **Whitespace:** more than you think. Dense UIs read as complex. Generous
  padding around interactive targets (min 44x44px touch target).

## 5. Accessibility Baseline

WCAG 2.1 AA minimum. These are non-negotiable:

- **Color contrast:** 4.5:1 for text, 3:1 for large text and UI components.
- **Keyboard:** Tab through every interactive element in logical order.
  Visible focus ring on every element (never `outline: none` without
  replacement). Enter/Space activates. Escape dismisses.
- **Screen reader:** Every image has alt text (decorative: `alt=""`).
  Form inputs have associated labels (`<label for="...">` or `aria-label`).
  Dynamic content updates use `aria-live` regions. Page has a single `<h1>`.
- **Motion:** Respect `prefers-reduced-motion`. Animations must be optional.
- **Touch targets:** minimum 44x44px. Adequate spacing between targets.

## 6. Anti-Patterns

These produce ugly UI. The agent must never ship these:

- **Mystery meat navigation:** icons without labels, hidden menus, unlabeled
  buttons. Every interactive element declares its purpose.
- **Dead-end states:** empty states without a next action, error pages without
  a way out, modals without a close button.
- **Layout shift:** content that jumps as things load. Reserve space for async
  content with skeletons or fixed dimensions.
- **Inconsistent spacing:** different gaps between similar sections. Use
  design tokens, never ad-hoc padding.
- **Low-contrast text:** gray-on-gray, thin fonts at small sizes. Minimum
  4.5:1 contrast ratio.
- **Orphaned labels:** inputs where the label disappears on focus
  (placeholder-as-label pattern). Labels must persist.
- **Tiny click targets:** buttons < 44px, links packed too tight.
- **Missing hover/active states:** interactive elements that don't respond to
  pointer or keyboard. Every button, link, and card has `:hover`, `:focus-visible`,
  and `:active` states.

## 7. Internationalization (i18n)

If the platform may serve non-English users, make a conscious decision in
Phase 1 and record it in `docs/ARCHITECTURE.md`. The options are:

- **Not needed now** — document the decision so it is explicit, not an
  omission. Note the trigger for revisiting (e.g., "first request from
  non-English locale").
- **Included from day one** — define the i18n strategy:
  - Translation key format: `namespace.component.key` (e.g.,
    `checkout.payment.submitLabel`).
  - No hardcoded strings in components. Every user-visible string goes
    through the translation function.
  - RTL support: layout flips for Arabic, Hebrew, etc. Use logical
    properties (`start`/`end` not `left`/`right`).
  - Date, number, and currency formatting use `Intl` or equivalent
    locale-aware APIs.
  - Language detection: `Accept-Language` header with a user override.

---

## 8. Accessibility in CI

Beyond the Phase 7 manual audit, wire automated accessibility checks into
the CI pipeline during Phase 4:

- Run `axe-core`, `pa11y`, or equivalent on every PR against the preview
  deployment (or a local build).
- Block merge on critical violations (contrast failures, missing labels,
  missing alt text on non-decorative images).
- Monitor for regression: if the violation count increases, fail the check.

---

## 9. Phase 7 UX Audit Checklist

The agent must verify every one of these during the Upkeep phase UX audit.
Flag any failure as a finding.

- [ ] Every page/screen has a defined loading, empty, and error state.
- [ ] No raw stack traces or technical errors visible to users.
- [ ] All text passes 4.5:1 contrast ratio against its background.
- [ ] Full keyboard navigation works: Tab order is logical, focus ring is
  visible, Escape dismisses overlays.
- [ ] Every `<img>` has an alt attribute. Every form input has an associated
  label. Page has exactly one `<h1>`.
- [ ] Touch/click targets are ≥ 44x44px with adequate spacing.
- [ ] No layout shift on load — async content reserves its space.
- [ ] Consistent spacing: all gaps come from design tokens, not ad-hoc values.
- [ ] Forms validate on blur (not keystroke), errors appear below fields,
  submit is disabled while invalid or submitting.
- [ ] Navigation: current page highlighted, mobile menu functional, max 5
  top-level items.
- [ ] Animations respect `prefers-reduced-motion`.
- [ ] Toast/dialog behavior: toasts auto-dismiss, dialogs trap focus, Escape
  closes both.
- [ ] No mystery meat: every icon has a label or `aria-label`, every button
  has descriptive text.
