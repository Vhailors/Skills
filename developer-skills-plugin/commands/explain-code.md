# explain-code

Comprehensive code explanation with historical context, design rationale, and architecture decisions.

## Usage

```bash
/explain-code [file-or-function]

# Examples:
/explain-code auth/middleware.js
/explain-code calculateDiscount
/explain-code src/components/UserProfile.jsx
```

## Description

Memory-enhanced code explanation that provides:
1. **What the code does** - Line-by-line breakdown
2. **Why it was written this way** - Design rationale from memory
3. **How it fits in** - Architecture context
4. **Edge cases handled** - Special logic explained
5. **History** - Past changes and decisions

**Use this command:**
- Understanding unfamiliar code
- Before refactoring (understand context)
- Code review (deep dive)
- Onboarding to codebase
- Debugging complex logic

## Explanation Layers

### Layer 1: Code Structure

```markdown
## Code Overview

**File:** `auth/middleware.js`
**Purpose:** Authentication middleware for protecting routes
**Lines:** 45
**Dependencies:** jsonwebtoken, User model
```

### Layer 2: Functionality

```markdown
## What It Does

**Main function:** `requireAuth(req, res, next)`

1. Extracts JWT token from Authorization header
2. Verifies token signature and expiration
3. Loads user from database using token payload
4. Attaches user to req.user for downstream handlers
5. Returns 401 if token invalid/missing
6. Returns 403 if user not found/inactive
```

### Layer 3: Memory Context

```markdown
## Design Rationale (from memory)

**Session #23** (2 weeks ago):
- Originally used req.body.userId
- Security audit found this was insecure (client could impersonate)
- Changed to extract userId from verified JWT token

**Session #45** (1 week ago):
- Added user.status check
- Prevents deactivated users from accessing API
- Addresses incident where banned user still had valid token

**Session #67** (3 days ago):
- Added req.user caching to avoid duplicate DB queries
- Performance optimization (reduced API latency 30%)
```

### Layer 4: Architecture Context

```markdown
## How It Fits

**Used in:** 15 routes across the application
- All `/api/users/:id` endpoints (ownership checks)
- All `/api/posts` write operations
- All `/api/comments` endpoints

**Pattern:** Middleware composition
```javascript
router.post('/api/posts',
  requireAuth,       // This middleware
  validate.post,     // Then validation
  postsController.create  // Then handler
);
```

**Alternatives considered:**
- Session-based auth (rejected: doesn't scale horizontally)
- OAuth only (rejected: need email/password option)
```

### Layer 5: Edge Cases

```markdown
## Special Cases Handled

1. **Expired tokens** (line 15-18)
   - JWT throws TokenExpiredError
   - Returns 401 with "Token expired" message
   - Client should refresh token

2. **Malformed tokens** (line 20-23)
   - JWT throws JsonWebTokenError
   - Returns 401 with "Invalid token"
   - Prevents server crashes from bad input

3. **User deleted after token issued** (line 30-33)
   - Token is valid but user no longer exists
   - Returns 403 (not 401 - token is valid, user is gone)
   - Prevents zombie access

4. **User deactivated** (line 35-38)
   - User exists but status='inactive'
   - Returns 403 with "Account deactivated"
   - Admins can ban users without invalidating all tokens
```

## Output Format

```markdown
# Code Explanation: auth/middleware.js

## 📄 File Overview
- **Purpose:** JWT authentication middleware
- **Created:** 3 months ago (commit abc123)
- **Last modified:** 3 days ago (commit def456)
- **Modified by:** Performance optimization
- **Lines:** 45 LOC
- **Tests:** tests/middleware/auth.test.js (12 tests)

---

## 🔍 What It Does

### Main Export: `requireAuth`

```javascript
function requireAuth(req, res, next) {
  // 1. Extract token from header
  const token = req.headers.authorization?.split(' ')[1];

  // 2. Verify and decode
  const decoded = jwt.verify(token, process.env.JWT_SECRET);

  // 3. Load user
  const user = await User.findById(decoded.userId);

  // 4. Attach to request
  req.user = user;
  next();
}
```

**Step-by-step:**
1. **Line 5-7:** Extract Bearer token from Authorization header
   - Format: "Bearer eyJhbGc..."
   - Split by space, take second part

2. **Line 9-11:** Verify JWT signature
   - Throws if expired or tampered
   - Decoded payload contains userId, email, issued timestamp

3. **Line 13-15:** Load user from database
   - Uses decoded.userId from token payload
   - **Never trusts client-provided userId** (security)

4. **Line 17-18:** Attach user to request object
   - Downstream handlers can access req.user
   - Avoids duplicate database queries

---

## 🧠 Memory Context (Why This Way)

### Session #23: Security Fix
**Problem:** Original implementation trusted req.body.userId
**Issue:** Client could impersonate any user by sending different userId
**Fix:** Extract userId from verified JWT token (can't be tampered)

### Session #45: Deactivated Users
**Problem:** Banned users with valid tokens could still access API
**Issue:** Tokens don't expire when user is banned
**Fix:** Added user.status check (line 35-38)

### Session #67: Performance
**Problem:** Multiple auth checks caused N duplicate DB queries
**Issue:** Same route uses requireAuth + ownership check → 2x User.findById
**Fix:** Cache user on req.user, check cache before querying

---

## 🏗️ Architecture Context

### Where It's Used

**15 protected routes:**
- `/api/users/:id` (PATCH, DELETE) - User can only modify own profile
- `/api/posts` (POST, PUT, DELETE) - Auth required for mutations
- `/api/comments` (POST, DELETE) - Auth + ownership checks

### Pattern: Middleware Chain

```javascript
// Standard pattern in this codebase
router.method('/path',
  requireAuth,        // 1st: Authenticate
  requireOwnership,   // 2nd: Authorize
  validate.schema,    // 3rd: Validate
  controller.action   // 4th: Handle
);
```

### Alternative Approaches (Rejected)

1. **Session-based auth** - Doesn't scale horizontally (requires sticky sessions)
2. **API keys** - Less secure (no expiration, hard to revoke)
3. **OAuth-only** - Too complex for simple email/password use case

**Decision:** JWT with short expiration (7 days) + refresh token strategy

---

## ⚠️ Edge Cases

### 1. Expired Token
**Code:** Line 15-18
**Happens:** Token older than 7 days
**Handling:** Returns 401 with "Token expired"
**Client action:** Request new token from /auth/refresh

### 2. Malformed Token
**Code:** Line 20-23
**Happens:** Client sends garbage in Authorization header
**Handling:** Catches JsonWebTokenError, returns 401
**Why:** Prevents server crash from malformed input

### 3. Deleted User
**Code:** Line 30-33
**Happens:** User deleted after token was issued
**Handling:** Returns 403 (not 404 - don't leak existence)
**Why:** Token is technically valid, but user is gone

### 4. Deactivated User
**Code:** Line 35-38
**Happens:** Admin bans user while they have active token
**Handling:** Returns 403 "Account deactivated"
**Why:** Tokens don't expire on ban, so check status

---

## 🔗 Related Files

**Dependencies:**
- `models/User.js` - User model (findById method)
- `config/jwt.js` - JWT secret and config
- `.env` - JWT_SECRET environment variable

**Used by:**
- `routes/users.js` - User endpoints
- `routes/posts.js` - Post endpoints
- `routes/comments.js` - Comment endpoints
- `middleware/ownership.js` - Depends on req.user

**Tests:**
- `tests/middleware/auth.test.js` - 12 tests covering all cases

---

## 🎯 Key Takeaways

1. **Security first:** Never trust client-provided identifiers
2. **Token-based:** User identity comes from verified JWT
3. **Stateless:** No server-side session storage needed
4. **Edge cases:** Handles expired, malformed, deleted users gracefully
5. **Performance:** Caches user on req.user to avoid duplicate queries
6. **Pattern:** First middleware in chain for protected routes

---

## 💡 If You're Modifying This

**Before refactoring:**
- Check tests (tests/middleware/auth.test.js)
- Search memory for past issues (Session #23, #45, #67)
- Understand security implications (userId from JWT, not client)
- Verify all 15 usage sites won't break

**Common mistakes to avoid:**
- Don't trust req.body.userId (security hole)
- Don't remove user.status check (allows banned users)
- Don't skip caching (performance regression)
- Don't change error codes (breaks client error handling)
```

## Integration

**Works with:**
- **memory-assisted-debugging** - References past bugs/fixes
- **refactoring-safety-protocol** - Understand before refactoring
- **claude-mem** - Loads historical context

**Provides context for:**
- `/quick-fix` - Understand code before debugging
- Refactoring - Know why before changing
- Code review - Deep understanding

## Benefits

**Without /explain-code:**
- Read code line by line
- Guess at rationale
- Miss historical context
- Don't understand edge cases

**With /explain-code:**
- Comprehensive understanding
- Historical context from memory
- Architecture fit
- Edge cases explained
- Refactoring-ready

## Quick Reference

| Code Type | Explanation Includes |
|-----------|---------------------|
| Function | Purpose, parameters, return, algorithm |
| Class | Responsibilities, methods, inheritance |
| Module | Exports, dependencies, patterns |
| Component | Props, state, lifecycle, render logic |
| Middleware | Request flow, transformations, error handling |
| Utility | Use cases, edge cases, examples |

## Notes

- Uses claude-mem for historical context
- Searches git history for file changes
- Identifies all usages across codebase
- Explains WHY not just WHAT
- Perfect before refactoring
