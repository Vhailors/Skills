---
name: performance-optimization
description: Use when application is slow, has high latency, or needs performance improvements - systematic profiling and optimization methodology for backend, frontend, and database performance
---

# Performance Optimization

## Overview

Slow applications lose users. Random performance fixes waste time. **Core principle:** Profile first, optimize bottlenecks systematically, measure impact.

## The Iron Law

```
NO OPTIMIZATION WITHOUT PROFILING FIRST
NO PREMATURE OPTIMIZATION
ALWAYS MEASURE BEFORE AND AFTER
```

## When to Use

- Application feels slow
- High API response times (>500ms)
- Large bundle sizes (>500KB)
- Poor Lighthouse scores (<70)
- Database queries slow (>100ms)
- Memory leaks suspected
- High CPU usage

## Performance Hierarchy (Optimize in Order)

1. **Algorithm** - O(n²) → O(n log n) gives 100x improvement
2. **Database** - N+1 queries, missing indexes
3. **Caching** - Redis, CDN, browser cache
4. **Network** - Payload size, compression
5. **Code** - Micro-optimizations (last resort)

## Backend Optimization

### Database Query Optimization

```typescript
// ❌ SLOW: N+1 query problem
const posts = await db.posts.findAll();
for (const post of posts) {
  post.author = await db.users.findOne(post.userId); // N queries!
}

// ✅ FAST: Single query with join
const posts = await db.posts.findAll({
  include: [{ model: db.users, as: 'author' }]
});
```

### Missing Index Detection

```sql
-- Check slow queries
EXPLAIN ANALYZE SELECT * FROM posts WHERE userId = 123;
-- If you see "Seq Scan", add index:
CREATE INDEX idx_posts_userId ON posts(userId);
```

### Caching Strategy

```typescript
// ✅ Cache expensive operations
import redis from 'redis';
const cache = redis.createClient();

app.get('/api/expensive-data', async (req, res) => {
  const cacheKey = 'expensive-data';
  const cached = await cache.get(cacheKey);

  if (cached) {
    return res.json(JSON.parse(cached));
  }

  const data = await expensiveComputation();
  await cache.set(cacheKey, JSON.stringify(data), { EX: 3600 }); // 1 hour
  res.json(data);
});
```

## Frontend Optimization

### Bundle Size Reduction

```javascript
// ❌ SLOW: Import entire library
import _ from 'lodash';

// ✅ FAST: Import only what you need
import debounce from 'lodash/debounce';

// ✅ FAST: Code splitting
const HeavyComponent = lazy(() => import('./HeavyComponent'));
```

### Image Optimization

```jsx
// ✅ Responsive images with WebP
<picture>
  <source srcSet="/image.webp" type="image/webp" />
  <img src="/image.jpg" alt="..." loading="lazy" />
</picture>
```

### Lazy Loading

```javascript
// ✅ Route-based code splitting
const Dashboard = lazy(() => import('./pages/Dashboard'));
const Profile = lazy(() => import('./pages/Profile'));

<Suspense fallback={<Loading />}>
  <Routes>
    <Route path="/dashboard" element={<Dashboard />} />
    <Route path="/profile" element={<Profile />} />
  </Routes>
</Suspense>
```

## React Performance

### Avoid Unnecessary Re-renders

```jsx
// ❌ SLOW: Re-renders on every parent update
function ExpensiveList({ items }) {
  return items.map(item => <ExpensiveItem key={item.id} item={item} />);
}

// ✅ FAST: Memoize component
const ExpensiveList = memo(function ExpensiveList({ items }) {
  return items.map(item => <ExpensiveItem key={item.id} item={item} />);
});

// ✅ FAST: Memoize expensive computations
const sortedItems = useMemo(() => {
  return items.sort((a, b) => a.value - b.value);
}, [items]);
```

### Virtual Lists

```jsx
// ✅ For long lists (1000+ items)
import { FixedSizeList } from 'react-window';

<FixedSizeList
  height={600}
  itemCount={items.length}
  itemSize={50}
>
  {({ index, style }) => (
    <div style={style}>{items[index].name}</div>
  )}
</FixedSizeList>
```

## Network Optimization

### Reduce Payload Size

```typescript
// ❌ SLOW: Return entire object
app.get('/api/users', async (req, res) => {
  const users = await db.users.findAll();
  res.json(users); // Includes password hashes, internal fields!
});

// ✅ FAST: Return only needed fields
app.get('/api/users', async (req, res) => {
  const users = await db.users.findAll({
    attributes: ['id', 'name', 'email', 'avatar']
  });
  res.json(users);
});
```

### Compression

```typescript
import compression from 'compression';
app.use(compression()); // gzip responses
```

### HTTP/2 Server Push

```typescript
// ✅ Push critical resources
app.get('/', (req, res) => {
  res.push('/css/main.css');
  res.push('/js/main.js');
  res.sendFile('index.html');
});
```

## Profiling Tools

### Backend Profiling

```bash
# Node.js profiling
node --prof app.js
# Generate report
node --prof-process isolate-*.log > processed.txt

# Python profiling
python -m cProfile -o profile.stats app.py
```

### Frontend Profiling

```javascript
// React DevTools Profiler
import { Profiler } from 'react';

<Profiler id="MyComponent" onRender={(id, phase, actualDuration) => {
  console.log(`${id} took ${actualDuration}ms`);
}}>
  <MyComponent />
</Profiler>
```

### Database Profiling

```sql
-- PostgreSQL: Enable query logging
ALTER SYSTEM SET log_min_duration_statement = 100; -- Log queries >100ms

-- MySQL: Enable slow query log
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 0.1; -- 100ms
```

## Performance Checklist

**Backend:**
- [ ] Database queries <100ms
- [ ] Indexes on filtered/joined columns
- [ ] No N+1 queries
- [ ] Caching for expensive operations
- [ ] API responses <200ms

**Frontend:**
- [ ] Bundle size <250KB gzipped
- [ ] Code splitting implemented
- [ ] Images optimized (WebP, lazy loading)
- [ ] Lighthouse score >90
- [ ] No unnecessary re-renders

**Network:**
- [ ] Compression enabled (gzip/brotli)
- [ ] HTTP/2 enabled
- [ ] Static assets cached (1 year)
- [ ] API responses cached appropriately
- [ ] Payload size minimized

## Performance Budgets

| Metric | Target | Max |
|--------|--------|-----|
| API Response | <200ms | <500ms |
| Bundle Size | <250KB | <500KB |
| Lighthouse | >90 | >70 |
| DB Query | <50ms | <100ms |
| Time to Interactive | <3s | <5s |

## Integration

**Works with:**
- `/perf-check` command for performance analysis
- `database-design` for query optimization
- `memory-assisted-debugging` for known performance issues
