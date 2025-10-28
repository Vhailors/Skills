---
name: test-driven-development
description: Use when implementing any feature or fixing bugs - write failing tests first, then minimal code to pass, then refactor; ensures correct behavior and prevents regressions
---

# Test-Driven Development

## Overview

Code without tests breaks silently. Tests written after the fact test what code does, not what it should do. **Core principle:** Red-Green-Refactor cycle ensures correctness by design.

## The Iron Law

```
NO CODE WITHOUT A FAILING TEST FIRST
NO EXCEPTIONS
```

## When to Use

Use for EVERY code change:
- New features
- Bug fixes
- Refactoring
- Performance improvements
- Any production code

## The Red-Green-Refactor Cycle

### 🔴 RED: Write Failing Test

```typescript
// Step 1: Write test for desired behavior
test('adds two numbers', () => {
  expect(add(2, 3)).toBe(5);
});

// Run test → FAILS (add() doesn't exist yet)
// ✅ This failure is REQUIRED - proves test works
```

### 🟢 GREEN: Write Minimal Code

```typescript
// Step 2: Write simplest code that passes
function add(a, b) {
  return a + b;
}

// Run test → PASSES
// ✅ Behavior is now correct
```

### 🔵 REFACTOR: Improve Code

```typescript
// Step 3: Improve without changing behavior
function add(a: number, b: number): number {
  return a + b;
}

// Run test → STILL PASSES
// ✅ Refactoring is safe
```

## Why This Order Matters

| Approach | What It Tests | Risk |
|----------|---------------|------|
| **Test First** | What code SHOULD do | Low - caught by test |
| **Test After** | What code DOES do | High - test passes incorrectly |
| **No Test** | Nothing | Critical - breaks silently |

## Test Structure: AAA Pattern

```typescript
test('user can delete their own post', async () => {
  // ARRANGE: Set up test data
  const user = await createUser({ id: 1, name: 'Alice' });
  const post = await createPost({ id: 10, userId: 1, title: 'Test' });

  // ACT: Execute the behavior
  const result = await deletePost(post.id, user.id);

  // ASSERT: Verify the outcome
  expect(result.success).toBe(true);
  expect(await findPost(post.id)).toBeNull();
});
```

## Test Types

### Unit Tests (Fastest, Most Isolated)

```typescript
// Test single function in isolation
test('formatCurrency formats number as USD', () => {
  expect(formatCurrency(1234.56)).toBe('$1,234.56');
});
```

### Integration Tests (Multiple Components)

```typescript
// Test components working together
test('API endpoint creates post in database', async () => {
  const response = await request(app)
    .post('/api/posts')
    .send({ title: 'Test', content: 'Content' });

  expect(response.status).toBe(201);

  const post = await db.posts.findOne(response.body.id);
  expect(post.title).toBe('Test');
});
```

### End-to-End Tests (Full User Flow)

```typescript
// Test complete user journey
test('user can sign up and create first post', async () => {
  await page.goto('/signup');
  await page.fill('[name=email]', 'test@example.com');
  await page.fill('[name=password]', 'password123');
  await page.click('button[type=submit]');

  await page.goto('/posts/new');
  await page.fill('[name=title]', 'My First Post');
  await page.click('button[type=submit]');

  await expect(page.locator('text=My First Post')).toBeVisible();
});
```

## Test Coverage Targets

| Test Type | Quantity | Coverage |
|-----------|----------|----------|
| Unit | Most (80%) | Every function, edge case |
| Integration | Some (15%) | Critical paths, API endpoints |
| E2E | Few (5%) | Key user journeys only |

## Mocking External Dependencies

```typescript
// Mock database calls
jest.mock('./database');
const mockDb = require('./database');

test('getUserById returns user from database', async () => {
  // ARRANGE: Mock returns specific data
  mockDb.users.findOne.mockResolvedValue({
    id: 1,
    name: 'Alice'
  });

  // ACT
  const user = await getUserById(1);

  // ASSERT
  expect(user.name).toBe('Alice');
  expect(mockDb.users.findOne).toHaveBeenCalledWith(1);
});
```

## Test Edge Cases

```typescript
// Test boundary conditions
test('validates username length', () => {
  expect(validateUsername('')).toBe(false);           // Empty
  expect(validateUsername('ab')).toBe(false);         // Too short (min 3)
  expect(validateUsername('abc')).toBe(true);         // Min valid
  expect(validateUsername('a'.repeat(30))).toBe(true); // Max valid
  expect(validateUsername('a'.repeat(31))).toBe(false); // Too long
});

// Test null/undefined
test('handles missing input', () => {
  expect(formatUsername(null)).toBe('Guest');
  expect(formatUsername(undefined)).toBe('Guest');
  expect(formatUsername('')).toBe('Guest');
});

// Test error conditions
test('throws on invalid input', () => {
  expect(() => divide(10, 0)).toThrow('Division by zero');
});
```

## TDD for Bug Fixes

```typescript
// 1. RED: Write test that reproduces bug
test('bug: negative numbers break calculation', () => {
  expect(calculate(-5, 10)).toBe(5); // Currently fails
});

// 2. GREEN: Fix the bug
function calculate(a, b) {
  return Math.abs(a) + Math.abs(b); // Add Math.abs fix
}

// 3. Test now passes → Bug fixed with regression test
```

## Common Testing Patterns

### Test Setup/Teardown

```typescript
// Run before each test
beforeEach(async () => {
  await db.clear();
  await db.seed();
});

// Run after each test
afterEach(async () => {
  await db.clear();
});

// Run once before all tests
beforeAll(async () => {
  await db.connect();
});

// Run once after all tests
afterAll(async () => {
  await db.disconnect();
});
```

### Test Fixtures

```typescript
// Reusable test data
const fixtures = {
  users: {
    alice: { id: 1, name: 'Alice', email: 'alice@example.com' },
    bob: { id: 2, name: 'Bob', email: 'bob@example.com' }
  },
  posts: {
    published: { id: 10, title: 'Published Post', status: 'published' },
    draft: { id: 11, title: 'Draft Post', status: 'draft' }
  }
};

test('user can see published posts', async () => {
  await db.seed([fixtures.users.alice, fixtures.posts.published]);
  // ... test using fixture data
});
```

### Async Testing

```typescript
// ✅ Use async/await
test('fetches user data', async () => {
  const user = await fetchUser(1);
  expect(user.name).toBe('Alice');
});

// ✅ Or return promise
test('fetches user data', () => {
  return fetchUser(1).then(user => {
    expect(user.name).toBe('Alice');
  });
});

// ❌ DON'T forget async/await
test('fetches user data', () => {
  const user = fetchUser(1); // Promise, not user!
  expect(user.name).toBe('Alice'); // Test passes incorrectly!
});
```

## Red Flags - STOP and Follow TDD

If you catch yourself:
- "Let me just write the code first"
- "I'll write tests after I'm done"
- "This is too simple to test first"
- "I'll manually verify it works"
- "Tests after achieve the same purpose"

**ALL mean: STOP. Write test first. No exceptions.**

## TDD Benefits

| Benefit | How TDD Provides It |
|---------|-------------------|
| Correct behavior | Test defines requirements before code |
| No regressions | Tests catch broken changes immediately |
| Better design | Testable code = well-designed code |
| Refactor safely | Tests verify behavior unchanged |
| Living documentation | Tests show how code should be used |
| Faster debugging | Failing test pinpoints exact issue |

## Test Naming Convention

```typescript
// ✅ GOOD: Describes behavior, not implementation
test('returns empty array when no users exist', () => {...});
test('throws error when email is invalid', () => {...});
test('user can delete their own post', () => {...});

// ❌ BAD: Implementation details
test('getUsersFromDatabase', () => {...});
test('testValidateEmail', () => {...});
test('deletePost', () => {...});
```

## Integration with Other Skills

**TDD is REQUIRED for:**
- `systematic-debugging` (Phase 4: Create failing test for bug)
- `refactoring-safety-protocol` (Tests before refactoring)
- `verification-before-completion` (Tests prove it works)

**TDD works with:**
- `/test-assist` command (generates test cases)
- `memory-assisted-debugging` (learn from past test patterns)

## Quick Reference

```bash
# Run tests
npm test                    # All tests
npm test -- --watch        # Watch mode
npm test -- filename       # Specific file
npm test -- --coverage     # Coverage report

# Debug tests
npm test -- --verbose      # Detailed output
npm test -- --detectOpenHandles  # Find hanging tests
```

## The Bottom Line

**TDD is not optional. It's how professional software is built.**

Write test → Watch it fail → Write code → Watch it pass → Refactor → Repeat.

No code without failing test first. No exceptions.
