# Search Standards

## Applies when

Implementing search functionality, building search UI, or configuring search infrastructure.

## Rules

### UX

- Prominent search bar (header, sidebar)
- Autocomplete (suggest as user types, with debouncing)
- Suggestions (popular, recent, related)
- Filters (faceted: category, date, price)
- Sorting (relevance, date, price, popularity)
- Highlighting (matching terms in results)
- Empty state (helpful message, suggestions)
- Analytics (queries, zero-result searches, click-through)

### Infrastructure

- Dedicated engine (Elasticsearch, Algolia, Meilisearch, Typesense)
- Indexing strategy (full-text, partial, fuzzy)
- Index management (reindexing, versioning, zero-downtime)
- Relevance tuning (boosting, weighting, ranking)
- Performance (<100ms autocomplete, <500ms full search)
- Scalability (millions of documents)

### Features

- Full-text search (across multiple fields)
- Fuzzy matching (typos, misspellings)
- Phrase search (exact phrases, quoted terms)
- Boolean operators (AND, OR, NOT)
- Wildcards (partial matching: *, ?)
- Synonyms (laptop = notebook)
- Stop words (filter common words)
- Stemming (running = run = ran)

### Indexing

- Real-time (index on create/update/delete)
- Batch (bulk for large datasets)
- Incremental (only changed data)
- Scheduling (during low-traffic)
- Monitoring (size, speed, errors)
- Optimization (sharding, replication)

### Advanced

- Geospatial (location: radius, bounding box)
- Aggregations (facets, histograms, statistics)
- Highlighting (matching text in results)
- Suggestions ("did you mean?")
- Search as you type (instant results)
- Semantic search (vector-based, embeddings)

### Security & Performance

- Rate limiting (prevent abuse)
- Query validation (prevent injection)
- Result filtering (user permissions)
- Caching (frequent queries: Redis, CDN)
- Analytics (performance, slow queries)
- Monitoring (errors, slow queries, index issues)

## Checklist

- [ ] Search bar prominent
- [ ] Autocomplete implemented
- [ ] Filters available
- [ ] Sorting available
- [ ] Results highlighted
- [ ] Empty state handled
- [ ] Dedicated search engine configured
- [ ] Full-text search enabled
- [ ] Fuzzy matching enabled
- [ ] Real-time indexing configured
- [ ] Search performance <500ms
- [ ] Rate limiting configured
- [ ] Query validation implemented
- [ ] Search analytics configured

## Anti-patterns

- No search → implement search
- Database-only search (LIKE) → use dedicated engine
- No autocomplete → add autocomplete
- No filters → add faceted search
- Slow search (>1 second) → optimize
- No analytics → add search analytics
- No empty state → add helpful message
- No typo tolerance → enable fuzzy matching
- No highlighting → add highlighting
- No rate limiting → add rate limits
