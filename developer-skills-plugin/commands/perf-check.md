# perf-check

Performance analysis and optimization workflow - identifies bottlenecks and suggests improvements.

## Usage

```bash
/perf-check [scope]
```

If no scope provided, analyzes entire application for performance issues.

## Description

Multi-layered performance validation:
1. **Profiling analysis** - CPU, memory, database queries
2. **Bundle size check** - Frontend asset optimization
3. **Query optimization** - Database performance
4. **Caching strategy** - Redis, CDN, browser caching
5. **Network performance** - API response times, payload size
6. **Frontend metrics** - Lighthouse scores, Core Web Vitals

Returns clear verdict: ✅ **Performant** or ⚠️ **Bottlenecks found with optimization plan**

## What It Checks

### Layer 1: Backend Performance
- [ ] API response times (<200ms for simple queries)
- [ ] Database query efficiency (N+1 queries, missing indexes)
- [ ] Memory usage patterns (leaks, excessive allocation)
- [ ] CPU utilization (hot paths, inefficient algorithms)

### Layer 2: Database Optimization
- [ ] Slow queries identified (>100ms)
- [ ] Missing indexes on filtered/joined columns
- [ ] Query plan analysis (sequential scans vs index scans)
- [ ] Connection pooling configured

### Layer 3: Frontend Performance
- [ ] Bundle size (<250KB gzipped for main bundle)
- [ ] Code splitting implemented
- [ ] Lazy loading for routes/components
- [ ] Image optimization (WebP, responsive images)
- [ ] Lighthouse score (>90 for performance)

### Layer 4: Caching Strategy
- [ ] Static assets cached (1 year max-age)
- [ ] API responses cached where appropriate
- [ ] CDN usage for static content
- [ ] Browser caching headers set
- [ ] Redis/memcached for session data

### Layer 5: Network Optimization
- [ ] API payload size optimized (<50KB per request)
- [ ] gzip/brotli compression enabled
- [ ] HTTP/2 or HTTP/3 enabled
- [ ] DNS prefetch for external resources
- [ ] Reduced number of requests (<50 per page)

## Skills Used

This command orchestrates:
1. **performance-optimization** - Main performance analysis engine
2. **database-design** (optional) - Query and index optimization
3. **memory-assisted-debugging** (optional) - Check for known perf issues

## Quick Reference

| Metric | Good | Warning | Critical |
|--------|------|---------|----------|
| API Response | <200ms | 200-500ms | >500ms |
| Bundle Size | <250KB | 250-500KB | >500KB |
| Lighthouse | >90 | 70-90 | <70 |
| DB Query | <100ms | 100-500ms | >500ms |
| Memory Usage | Stable | Slow growth | Leak detected |
