# Architecture

## Stack

| Concern | Choice | Rationale |
|---------|--------|-----------|
| Language |        |           |
| Framework |      |           |
| Data Store |      |           |
| Auth |             |           |
| Hosting |          |           |

## System Topology

<!-- What talks to what, across which boundaries. Diagram or prose. -->

## API / IPC Contracts

<!-- Route shapes and payloads (web), module interfaces, event contracts, or CLI signatures. -->

## UI / UX

Design decisions driven by `references/ui-ux.md` heuristics. Fill every
section before implementation begins.

### Design Tokens

<!-- Colors, spacing scale, typography, radii, shadows. Each with contrast ratio verified. -->
<!-- Use the token structure from references/ui-ux.md §1. -->

### Component Library

| Component | States Covered | Accessibility Notes |
|-----------|---------------|---------------------|
|           |               |                     |

<!-- Every component must cover: loading, empty, error, success, edge cases. -->

### Layout

- **Max content width:** <!-- 72ch prose / 1200px app default -->
- **Breakpoints:** <!-- mobile-first: sm, md, lg, xl -->
- **Navigation pattern:** <!-- top-nav / sidebar / bottom-tab -->
- **Responsive strategy:** <!-- collapse / stack / hide / drawer -->

### UX Patterns

- **Forms:** <!-- label position, validation trigger, error placement -->
- **Data display:** <!-- table/card/list, pagination/infinite-scroll -->
- **Feedback:** <!-- toast/dialog/inline, auto-dismiss timing -->
- **Empty states:** <!-- illustration + CTA pattern per entity type -->
- **Error states:** <!-- retry pattern, error boundary strategy -->

### Accessibility Baseline

- **Standard:** WCAG 2.1 AA
- **Color contrast:** 4.5:1 minimum verified
- **Keyboard:** full navigation, visible focus ring
- **Screen reader:** semantic HTML, alt text, aria labels
- **Motion:** `prefers-reduced-motion` respected
- **Touch targets:** ≥ 44x44px
