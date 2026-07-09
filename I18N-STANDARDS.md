# Internationalization Standards

## Applies when

Writing user-facing strings, formatting dates/numbers/currency, or building multi-language support.

## Rules

### i18n Framework

- Use established libraries (i18next, react-intl, vue-i18n)
- Meaningful translation keys (not just strings)
- Translation files per language (JSON or YAML)
- Fallback language (default to English if missing)
- Pluralization (handle different language rules)
- Context for translators (where string is used)

### Localization

- Locale-specific date formats (MM/DD/YYYY vs DD/MM/YYYY)
- Locale-specific time formats (12-hour vs 24-hour)
- Locale-specific number formats (1,000.00 vs 1.000,00)
- Locale-specific currency symbols and formats
- Translated relative time ("2 hours ago")
- Store in UTC, display in user's timezone

### RTL Support

- Support Arabic, Hebrew, Persian, Urdu
- CSS logical properties (margin-inline-start, not margin-left)
- dir="rtl" on HTML element
- Mirror icons, images, layouts
- Right-align text in RTL
- Test all pages in RTL mode

### Translation Workflow

- Translation management system (Crowdin, Transifex, Lokalise)
- Process: extract → translate → review → import
- Provide context, screenshots, glossary
- Review by native speakers
- Track translation changes in version control
- Automated sync with code changes

### Content Strategy

- Extract all user-facing strings
- No hardcoded strings (all in translation files)
- String interpolation (parameters, not concatenation)
- Avoid HTML in translations (use components)
- Handle dynamic content
- Define fallback strategy

## Checklist

- [ ] i18n framework configured
- [ ] All strings in translation files
- [ ] No hardcoded strings
- [ ] String interpolation used
- [ ] Pluralization supported
- [ ] Date/time formatting uses locale
- [ ] Number formatting uses locale
- [ ] Currency formatting uses locale
- [ ] RTL support implemented
- [ ] Translation management system configured
- [ ] Fallback language defined

## Anti-patterns

- Hardcoded strings → extract to translation files
- String concatenation → use interpolation
- No pluralization → add pluralization support
- Date/time formatting in code → use locale
- No RTL support → test and implement RTL
- HTML in translations → use components
- No translation management → add TMS
- No fallback language → define fallback
- Assuming English is default → support all languages
- Testing only in English → test all languages
