# UI/UX Grill

World-class UI doesn't come from checklists — it comes from relentless
questioning. This grill is mandatory. Do not skip questions. Do not accept
"it's fine" as an answer. Push until the user either has a sharp answer or
admits the gap and files an issue.

Apply this grill at three points:
- **Phase 1:** after ARCHITECTURE.md is drafted — grill the entire product
  vision. Use §2 (Visual Language) and §4 (Mental Model).
- **Phase 3 / Feature Loop:** before implementing any UI issue — grill that
  specific screen or flow. Use §6 (Screen-Level) and §7 (Interaction).
- **Phase 7:** during the UX audit — re-ask the hardest questions from §7
  against the live product. Use §8 (Live Review).

---

## 1. Pre-Grill: Context Gathering

Before grilling, establish these facts. If the user cannot answer them,
stop and resolve before continuing.

> Who is the primary user? What is their technical ability, age range,
> device, connection speed, and emotional state when using this product?

> What is the one thing they must accomplish in their first session? If
> they accomplish nothing else, what single outcome makes them come back?

> Name three competing products. What do they do better than you? What do
> they do worse? How does your UI signal "this is different" in the first
> 5 seconds?

> What is the personality of this product? Pick three adjectives. Every
> design decision must reinforce at least one of them.

---

## 2. Visual Language

World-class products have an unmistakable visual identity. Grill until
the user can describe theirs without referencing CSS variables.

### Distinctiveness

> Close your eyes. Picture Stripe, Linear, Vercel, Apple. Each has an
> immediate visual signature. What is yours? If I showed you 10 SaaS
> apps side by side with logos removed, could you pick out yours? Why?

> What makes your UI unmistakably yours — not "modern SaaS with a blue
> accent"? If the answer involves the color blue, a rounded corner, or
> a sans-serif font, it's not distinctive. Try again.

> Shadcn/ui, Tailwind UI, Radix — they all ship the same visual language
> out of the box. What have you changed? If the answer is "we use a
> custom primary color," you haven't changed enough.

### Typography

> Typography is 95% of web design. What is your typeface? Why that one?
> What does it communicate? (If you don't know what your typeface
> communicates, you picked wrong.)

> What's your type scale? Show me the ratio. Is it a modular scale
> (1.25, 1.333, 1.5) or custom? Why?

> How many font weights do you actually use? More than three is a smell.

> What's your measure (line length) for body text? Is it between 45–75
> characters? If not, reading comprehension drops.

### Color

> Name the emotion your palette evokes. "Professional" is not an
> emotion. "Calm," "energetic," "trustworthy," "playful" — pick one.

> How many grays are in your palette? Most products need 8–12. Fewer
> than 6 and you can't build hierarchy. More than 14 and you have
> duplication.

> What's your accent color's job? Does it mark primary actions only? Or
> does it also decorate? An accent that means everything means nothing.

> Dark mode: designed or auto-generated? Auto-inverted colors create
> washed-out UIs. A proper dark palette is not the inverse of light.

### Spacing & Layout

> Show me the spacing rhythm. Is every gap a multiple of your base unit
> (4px, 8px, etc.)? If any component uses a value not in the token
> scale, that's a bug.

> What's your maximum content width? 1200px? 960px? Full-bleed? Why
> that number — is it driven by user needs or by "this is what
> Tailwind's container does"?

> Density: is your UI spacious (consumer) or dense (pro tool)? Does
> every screen match that density, or are some screens 2x denser than
> others?

---

## 3. Information Architecture

Bad IA is the root cause of most "confusing" UIs. Users don't complain
about IA — they just leave.

### Navigation

> List every top-level navigation item. Now delete one. If the user
> genuinely loses a core capability, keep it. If not, delete it. What
> survived?

> Group your navigation items. Are they grouped by user task or by
> engineering team? If the latter, restructure. Users navigate by goal,
> not by codebase module.

> What's at the bottom of every long page? Is it a dead end or does it
> guide the user to the logical next step?

> Breadcrumbs: where do they appear? Where don't they? Is the rule
> consistent or ad-hoc?

### Search & Discovery

> Can a user find anything on this platform in under 3 clicks? If not,
> you need search. Is it global, scoped, or both?

> What does the empty search state show? "No results" is a dead end.
> Show recent searches, popular items, or a guided fallback.

> If the user types "delete account" into search, does the search box
> find it? Does it surface the right action or just a help article?

### Hierarchy

> Draw the sitemap. What's the deepest page? Is anything buried more
> than 3 levels deep? Every additional level loses ~50% of users.

> What's on the homepage/dashboard? Is it what the user needs first or
> what the team built first? Dashboard widgets should be ranked by user
> priority, not development order.

---

## 4. Mental Model Alignment

The user has a mental model of your domain. Your UI either matches it
or fights it. Fighting it loses users.

### Core Loop

> Describe the user's core loop in their language, not yours. Not "user
> creates a project entity and assigns team members." But "I need to get
> my team working on something by end of day." Does the UI speak in user
> words or database words?

> What's the user's goal in session one? Session ten? Does the UI adapt
> or stay identical?

### Cognitive Load

> On your most complex screen, how many things can the user click? Count
> them. Hick's Law: decision time grows logarithmically with choices.
> Above ~7 interactive elements in immediate view, users freeze. How do
> you reduce it?

> Progressive disclosure: what's hidden until the user needs it? What's
> visible that shouldn't be? Every visible element should earn its place.

> Does any screen require the user to remember information from a
> previous screen? If yes, that's a cognitive leak. Show it, don't make
> them remember it.

### Language

> Audit every label on the primary screen. Are there any company-internal
> terms? "Workspace," "Organization," "Collection," "Space" — these mean
> nothing until you teach them. Use verbs and user language.

> What's the most jargon-heavy label in your UI? Replace it with words a
> 12-year-old would understand. If you can't, the concept is too complex.

> Error messages: do they blame the user, the system, or no one? "Invalid
> input" blames the user. "We couldn't process that — the server is
> having trouble" is honest and blameless.

---

## 5. State Design

Every screen exists in multiple states. A screen without designed states
is a prototype, not a product.

### Loading

> What does the user see in the first 100ms? 500ms? 2s? 5s? Each has a
> different answer. <100ms: nothing. 100–500ms: skeleton. 500ms–2s:
> skeleton with progress indication. >2s: progress bar + estimated time.
> >5s: cancel option + background processing offer.

> Does your skeleton match your layout? A generic shimmer that doesn't
> match the final layout causes more cognitive dissonance than a spinner.

> Optimistic UI: what actions complete instantly in the UI before the
> server confirms? Like button, checkbox toggle, drag-and-drop reorder.
> Every one of these is an opportunity to feel instant. How many of your
> mutations are optimistic?

### Empty

> New user, zero data. What do they see? "No items yet" is a failure.
> Show them what could be there. Give them a one-click way to create it.

> What's the blank-slate CTA? Is it a button, a template gallery, an
> import wizard, a guided tour? The answer depends on the product. What's
> yours?

> After the user deletes their last item — what do they see? The same
> empty state as a new user? If so, it missed the chance to suggest
> what's next.

### Error

> What happens when the API is down? Does the UI degrade gracefully or
> crash? Every data-dependent component needs an error boundary.

> Show me your worst error message. If it contains a status code, a
> stack trace, or the word "undefined," fix it. Error messages are
> microcopy — they should be helpful, not technical.

> Retry: is it automatic (exponential backoff), manual (button), or
> absent? The answer should differ by context. A dashboard widget should
> auto-retry. A form submission should show a retry button.

### Edge Cases

> Longest possible username: 64 characters. Does it break the layout?
> Shortest: 1 character. Does it look wrong?

> User with no profile picture. User with a profile picture that's
> 4000x4000px. User with an animated GIF as their profile picture. All
> handled?

> What happens at 320px viewport width? (Galaxy Fold.) At 2560px?
> (iMac.) Is the experience good at both? Or merely functional?

---

## 6. Screen-Level Grill

For the specific screen or flow being implemented, push deeper.

> Walk me through this screen at 2x speed. The user opens it, scans it,
> and clicks. What did they click first? If what they clicked isn't the
> primary action, your hierarchy is wrong.

> What's the most important number/word on this screen? Is it the
> largest? The boldest? The most colorful? If size, weight, and color
> don't all point to the same element, the hierarchy is competing.

> What happens if the user presses Enter on this screen? Submit? Next
> field? Nothing? Enter should always do the most likely action.

> What's the undo strategy? Every destructive or mutating action should
> be undoable for at least 5 seconds. Which actions on this screen
> support undo?

> Mobile: is this screen usable one-handed (thumb zone, bottom 2/3 of
> screen)? If the primary action is at the top, it's unreachable.

---

## 7. Interaction Design

### Micro-Interactions

> Count the animated transitions on this screen. Zero is sterile. More
> than ~3 per interaction is distracting. What's the count?

> What animates on hover? On click? On appear? On disappear? Every
> interactive element should respond in under 100ms to feel instant.

> Are your animations purpose-driven or decorative? A button that
> scales down 2% on press communicates "I received your click." A logo
> that spins on hover communicates nothing. Audit every animation.

### Feedback

> After clicking the primary action, what confirms success? If the
> answer is a toast notification, you've failed. The UI should confirm
> inline — the button changes state, the item appears in the list, the
> form shows a success summary integration. Toasts are for background
> operations, not foreground interactions.

> What's the slowest interaction? Find it. Profile it. Can you cache
> the result? Prefetch on hover? Warm the connection? A 500ms delay
> feels broken. A 100ms delay feels instant.

### Keyboard & Power Users

> What's the keyboard shortcut for the primary action? If none, power
> users are slower than they could be. Every core action gets a shortcut.

> Can a user complete the entire core loop without touching a mouse?
> If not, you've excluded keyboard-only users and slowed down power users.

> What's the ⌘K / Ctrl+K command palette? If none, how does a power
> user jump between sections without clicking through navigation?

---

## 8. Live Review (Phase 7)

After the product is live, grill the real thing — not the mockups.

> Open the product on an actual phone with 3G throttling. Time to
> interactive? If >3 seconds, what's loading that doesn't need to?

> Hand the product to someone who has never seen it. Say nothing. Watch
> where they click first. Where they hesitate. Where they give up. What
> surprised you?

> Turn on a screen reader. Navigate the core flow blind. Does every
> element have a name, role, and state? Can you complete the task without
> seeing the screen?

> Zoom to 200%. Does the layout break? Do elements overlap? Is text
> truncated? Low-vision users zoom. Your UI must survive it.

> Open your worst-performing page in the performance tab. What's
> blocking the first paint? What's the Largest Contentful Paint? Is it
> below 2.5s? If not, what's the plan?

---

## Grill Conduct

- **Never skip.** Every question in the relevant section must be asked.
  Mark skipped questions as `DEFERRED: <reason>` in `docs/SESSION.md`.
- **Don't settle.** If the answer starts with "I think" or "probably,"
  treat it as unresolved. File a documentation gap.
- **Every "no" is a finding.** Flag it in the Phase 7 UX audit or in the
  issue's `Docs:` field.
- **No design-by-committee.** If the user defers to "the team will
  decide," ask who on the team owns the decision. If no one does, the
  user owns it.
- **Record decisions.** Every answer that shapes the UI gets recorded in
  `docs/ARCHITECTURE.md` under the UI/UX section. Undecided questions
  become issues.
