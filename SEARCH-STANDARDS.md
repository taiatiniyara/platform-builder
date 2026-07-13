# Search Standards

## Applies when

Implementing search functionality, building search UI, or configuring search infrastructure.

## Checklist

### UX
- [ ] Prominent search bar; autocomplete with debouncing; suggestions (popular, recent, related)
- [ ] Faceted filters (category, date, price); sorting (relevance, date, price, popularity)
- [ ] Result highlighting; helpful empty state; search analytics (queries, zero-results, click-through)

### Infrastructure
- [ ] Dedicated engine (Elasticsearch, Algolia, Meilisearch, Typesense)
- [ ] Index management (reindexing, versioning, zero-downtime); relevance tuning (boosting, ranking)
- [ ] Performance: <100ms autocomplete, <500ms full search

### Features
- [ ] Full-text across multiple fields; fuzzy matching (typos); phrase search (quoted terms)
- [ ] Boolean operators (AND/OR/NOT); wildcards; synonyms; stemming; stop words

### Indexing
- [ ] Real-time (on create/update/delete); batch for large datasets; incremental (only changed)
- [ ] Monitoring (size, speed, errors); optimization (sharding, replication)

### Security & Performance
- [ ] Rate limiting; query validation (prevent injection); result filtering (user permissions)
- [ ] Caching (frequent queries: Redis, CDN); performance analytics (slow queries)
