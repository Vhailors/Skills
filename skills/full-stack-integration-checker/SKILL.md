---
name: full-stack-integration-checker
description: Use when finishing a feature or before claiming work is complete - systematically verifies database schema, backend API, and frontend are fully integrated with no gaps, unused code, or missing CRUD operations
---

# Full-Stack Integration Checker

## Overview

**Before saying "feature is complete," trace every piece of data through all three layers.**

This skill prevents the most common cause of "it works but..." bugs: missing integration points between database, backend, and frontend. Features often "work" for the happy path but have gaps: unused schema fields, missing delete endpoints, frontend state not syncing, or security holes.

**Core principle:** Follow the data from database → API → frontend, then verify the reverse path works too.

## When to Use

Use this skill:
- **Before claiming feature is complete** - "Done with user profiles" → run checklist first
- **Before saying "ready to ship"** - User asks "can we deploy?" → verify systematically
- **After implementing CRUD features** - Comments, favorites, profiles, posts, etc.
- **When tired/under pressure** - Exhaustion makes you skip verification
- **After user says "it works!"** - One manual test ≠ fully integrated

**Symptoms that trigger this skill:**
- You just finished a multi-hour implementation
- User tested once and says "looks good!"
- You implemented Create but might have forgotten Delete
- Schema has fields that might not be exposed in API/UI
- You're about to commit or create a PR

**DO NOT use for:**
- Trivial changes (fixing typos, adjusting CSS)
- Single-layer changes (only frontend styling, only adding index to DB)

## The "Trace the Data" Methodology

Every feature moves data through layers. Verify BOTH directions:

### Forward Path (Create/Write):
```
User Input → Frontend Form → API POST → Database Write → Success Response → UI Feedback
```

### Reverse Path (Read/Display):
```
Database Query ← API GET ← Frontend Request ← User Action ← UI Trigger
```

### Modification Path (Update/Delete):
```
User Action → Frontend → API PUT/DELETE → Database Change → UI Update
```

**All three paths must exist for complete integration.**

## Verification Checklist

Use this systematically. Check EVERY item even when tired.

### Layer 1: Database Schema

- [ ] **Schema is applied** - Migrations run, table exists in database
  ```bash
  # Prisma example
  npx prisma migrate status
  npx prisma db push --preview-feature
  ```

- [ ] **All schema fields have a purpose** - No unused fields
  - Search schema for field names
  - Verify each field appears in API response or request
  - If field unused, remove it or add to API

- [ ] **Constraints are correct** - @unique, @index, required fields
  - Can users violate constraints from UI? (Test duplicate creation)

- [ ] **Relations are defined** - Foreign keys, cascading deletes
  ```prisma
  # If Comment has userId, should have:
  user User @relation(fields: [userId], references: [id])
  ```

### Layer 2: Backend API

#### Endpoints

- [ ] **CRUD completeness** - All operations implemented
  ```
  Create → POST /api/resource
  Read   → GET /api/resource/:id and GET /api/resource (list)
  Update → PUT or PATCH /api/resource/:id
  Delete → DELETE /api/resource/:id
  ```
  - If user can create, can they delete?
  - If user can see list, is there a detail view?

- [ ] **Authentication on all endpoints** - No trusting client data
  ```typescript
  // ❌ BAD: Client sends userId
  const { userId, data } = req.body;

  // ✅ GOOD: Server uses authenticated user
  const userId = req.user.id; // From auth middleware
  ```

- [ ] **Authorization checks** - Users can only access their data
  ```typescript
  // Before deleting/updating, verify ownership
  const resource = await db.findUnique({ where: { id } });
  if (resource.userId !== req.user.id) {
    return res.status(403).json({ error: 'Forbidden' });
  }
  ```

#### Data Handling

- [ ] **Error handling** - try-catch blocks, proper status codes
  - 404 when not found
  - 400 for bad input
  - 409 for conflicts (unique constraint violations)
  - 500 for server errors

- [ ] **Input validation** - Check required fields, formats, lengths
  ```typescript
  if (!productId || typeof productId !== 'string') {
    return res.status(400).json({ error: 'Invalid productId' });
  }
  ```

- [ ] **Related data included** - Avoid N+1 queries
  ```typescript
  // ❌ BAD: Returns only IDs, requires N follow-up queries
  const favorites = await db.favorite.findMany({ where: { userId } });

  // ✅ GOOD: Includes related product data
  const favorites = await db.favorite.findMany({
    where: { userId },
    include: { product: true }
  });
  ```

- [ ] **Pagination for lists** - Don't return unlimited records
  ```typescript
  const page = parseInt(req.query.page) || 1;
  const limit = 20;
  await db.findMany({
    take: limit,
    skip: (page - 1) * limit
  });
  ```

#### Type Safety

- [ ] **Types regenerated** - Prisma Client or ORM types current
  ```bash
  npx prisma generate
  ```

- [ ] **Response types match schema** - All schema fields returned or explicitly excluded

### Layer 3: Frontend

#### Data Fetching

- [ ] **All API endpoints consumed** - No orphaned endpoints
  - Grep for each API route in frontend code
  - Verify POST, GET, PUT, DELETE all used

- [ ] **userId not hardcoded** - Use auth context
  ```tsx
  // ❌ BAD
  const userId = "user_123";

  // ✅ GOOD
  const { user } = useAuth();
  const userId = user.id;
  ```

#### State Management

- [ ] **Loading states** - Spinners while fetching
  ```tsx
  const [isLoading, setIsLoading] = useState(false);
  ```

- [ ] **Error states** - Display errors to user
  ```tsx
  const [error, setError] = useState<string | null>(null);
  ```

- [ ] **Success feedback** - Confirm actions completed
  - Toast notifications
  - Optimistic updates with rollback

- [ ] **State syncs with backend** - After create/update/delete, refetch or update local state
  ```tsx
  // After creating comment
  await createComment(data);
  await refetchComments(); // Or add to local state
  ```

#### UI Completeness

- [ ] **All schema fields displayed or editable** - Nothing missing
  - If schema has `bio`, `avatar`, `website` → UI should show all three
  - If only showing 2 of 3, either remove field from schema or add to UI

- [ ] **CRUD operations available** - Users can do what API allows
  - Can create? → Has form
  - Can read? → Has display
  - Can update? → Has edit UI
  - Can delete? → Has delete button

- [ ] **TypeScript types defined** - No `any`, proper interfaces
  ```tsx
  interface UserProfile {
    id: string;
    bio: string | null;
    avatar: string | null;
    website: string | null;
  }
  ```

#### UX Edge Cases

- [ ] **Empty states** - What if list is empty?
- [ ] **Duplicate prevention** - Disable button while loading
- [ ] **Null safety** - Handle missing/null data gracefully
  ```tsx
  <img src={profile?.avatar || '/default-avatar.png'} alt="Avatar" />
  ```

### Layer 4: Integration Testing

- [ ] **Trace full path manually** - Open app, test create → display → edit → delete
- [ ] **Test error scenarios** - Network failures, invalid input, duplicate creation
- [ ] **Multi-tab test** - Create in tab A, see update in tab B?
- [ ] **Verify database** - Check actual DB records match UI display

## The "Follow the Field" Technique

For each database field, trace where it goes:

**Example: `UserProfile.website` field**

1. **Schema**: `website String?` ✅ Defined
2. **API Response**: Does GET `/api/profile/:id` return `website`?
   - Grep: `website` in profile route handler
   - Check response object includes it
3. **Frontend Type**: Does `UserProfile` interface have `website`?
4. **Frontend Display**: Does ProfilePage render the website?
   - Grep: `profile.website` or `profile?.website`
5. **Frontend Input**: Can users edit the website field?

**If any step missing → integration gap.**

## Common Gap Patterns

Search your codebase for these patterns:

| Pattern | Search Command | What It Means |
|---------|---------------|---------------|
| Schema field never used | Grep schema field name in API/frontend | Unused database column |
| POST but no DELETE | `grep -r "POST.*resource"` vs `grep -r "DELETE.*resource"` | Can create but not remove |
| Endpoint not called | Grep API route in frontend | Orphaned endpoint |
| Mock data still present | `grep -r "MOCK\|TODO\|FAKE\|DUMMY"` | Not using real API |
| Client-provided userId | `req.body.userId` in API code | Security hole |
| No error handling | Function with `await` but no `try-catch` | Silent failures |
| No loading state | Component with `fetch` but no `isLoading` | Bad UX |

## Red Flags - Feature Looks Done But Isn't

If you catch yourself thinking:
- "I tested it once and it worked"
- "Create works, I'll add update/delete later"
- "The user only asked for the form, not the display"
- "I'm too tired to check everything"
- "That field isn't important right now"

**All of these mean: STOP. Run the checklist. Trace the data.**

## Quick Verification Commands

Run these before claiming complete:

```bash
# Find potential unused schema fields (Prisma example)
# Look for fields in schema not referenced in code
grep -A 20 "model UserProfile" schema.prisma
grep -r "bio\|avatar\|website" src/

# Find missing error handling
grep -r "await.*fetch\|await.*axios" src/ | wc -l
grep -r "try\|catch" src/ | wc -l
# First number >> second number = missing error handling

# Find mock/temporary data
grep -ri "mock\|dummy\|fake\|todo\|fixme" src/

# Check CRUD completeness for a resource (e.g., "profile")
grep -r "POST.*profile" src/
grep -r "GET.*profile" src/
grep -r "PUT.*profile" src/
grep -r "DELETE.*profile" src/

# Find client-provided userIds (security issue)
grep -r "req.body.userId\|body.userId" src/

# TypeScript compilation (catches type mismatches)
npx tsc --noEmit
```

## Real-World Impact

**Without this skill:**
- Ship features with missing delete functionality
- Security holes (client-provided IDs)
- Schema fields defined but never used (bloat)
- N+1 queries, no pagination (performance)
- Silent failures (no error handling)
- Poor UX (no loading states)

**With this skill:**
- Systematic verification catches gaps
- Features are actually complete
- Security issues caught before deployment
- Clean schema (only fields actually used)
- Better performance (pagination, includes)
- Professional UX (loading, errors, feedback)

**Example: "Favorites" feature**
- Without skill: Ships with auth hole, no toggle, missing delete
- With skill: 15 minutes to verify, catches 8 issues before shipping
- Result: Feature actually works for real users, no production hotfixes

## Integration with Other Skills

**REQUIRED:** Use superpowers:verification-before-completion before claiming work is done.

**Combine with:**
- systematic-debugging (when verification reveals bugs)
- verification-before-completion (this is a specific checklist for full-stack features)

## Common Excuses (Don't Accept These)

| Excuse | Reality |
|--------|---------|
| "I tested it manually, it works" | One test ≠ complete integration. Run checklist. |
| "I'll add the delete endpoint later" | Later = never. CRUD is incomplete. Don't ship half-done. |
| "That schema field is for future use" | Remove it. YAGNI. Add when actually needed. |
| "The user only asked for create" | User expects CRUD. Can't create without ability to delete. |
| "I'm too tired to verify everything" | Tired = when verification matters most. Use checklist. |
| "It's working in my browser" | Your browser ≠ all users. Test errors, edge cases. |

**All of these mean: Not done yet. Run the checklist.**

## Example: Favorites Feature Verification

User says: "I tested it - the favorite button works! Ship it?"

**Run the checklist:**

1. **Database**
   - ✅ Favorite model exists
   - ✅ Unique constraint on [userId, productId]
   - ⚠️ No migration applied yet

2. **Backend**
   - ✅ POST /api/favorites
   - ⚠️ GET /api/favorites returns only IDs (missing product data)
   - ❌ No DELETE endpoint
   - ❌ POST uses `req.body.userId` (security hole!)
   - ❌ No error handling for duplicate favorites
   - ❌ No pagination

3. **Frontend**
   - ✅ Button sends POST request
   - ❌ No loading state
   - ❌ No error handling
   - ❌ No way to remove favorite (DELETE not implemented)
   - ❌ Button doesn't show if already favorited
   - ❌ No optimistic update

**Result: 9 issues found. NOT ready to ship.**

After fixes, re-run checklist until all items check ✅.
