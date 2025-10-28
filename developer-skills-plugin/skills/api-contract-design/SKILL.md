---
name: api-contract-design
description: Use when designing or modifying API endpoints - ensures RESTful patterns, consistent contracts, breaking change detection, schema validation, and backward compatibility for maintainable APIs
---

# API Contract Design

## Overview

**APIs are contracts. Breaking them breaks clients.**

This skill provides systematic patterns for designing consistent, maintainable REST APIs. It prevents breaking changes, ensures schema validation, and maintains backward compatibility.

**Core principle:** API design is a commitment to clients. Change carefully.

## When to Use

Use this skill when:
- **Designing new endpoints** - Before implementing
- **Modifying existing endpoints** - Breaking change check
- **API versioning** - When to version vs. evolve
- **Schema changes** - Adding/removing fields
- **Error responses** - Standardizing errors

**Triggers:**
- "Create API for...", "Add endpoint..."
- "Change API response to..."
- Before implementing backend routes
- Code review of API changes

## REST API Design Patterns

### URL Structure

```
✅ GOOD: Resource-oriented
GET    /api/users              # List users
GET    /api/users/:id          # Get specific user
POST   /api/users              # Create user
PUT    /api/users/:id          # Update user (full)
PATCH  /api/users/:id          # Update user (partial)
DELETE /api/users/:id          # Delete user

❌ BAD: Verb-oriented
GET    /api/getUsers
POST   /api/createUser
POST   /api/updateUser
POST   /api/deleteUser
```

### HTTP Methods (Use Correctly)

| Method | Purpose | Body | Idempotent | Safe |
|--------|---------|------|------------|------|
| GET | Read | No | Yes | Yes |
| POST | Create | Yes | No | No |
| PUT | Full update | Yes | Yes | No |
| PATCH | Partial update | Yes | No | No |
| DELETE | Remove | No | Yes | No |

### Response Format

**Standard success:**
```json
{
  "data": {
    "id": 123,
    "name": "John Doe",
    "email": "john@example.com"
  },
  "meta": {
    "timestamp": "2025-10-27T19:00:00Z"
  }
}
```

**Standard error:**
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email is required",
    "field": "email"
  }
}
```

## Breaking vs. Non-Breaking Changes

### ✅ NON-Breaking (Safe)

- **Adding new endpoints**
- **Adding optional fields** to request/response
- **Adding new error codes** (clients ignore unknown)
- **Making required → optional**
- **Relaxing validation** (accept more input)

### ❌ BREAKING (Dangerous)

- **Removing endpoints**
- **Removing fields** from response
- **Renaming fields**
- **Changing field types** (string → number)
- **Making optional → required**
- **Changing URL structure**
- **Changing HTTP method**

### Handling Breaking Changes

**Option 1: API Versioning**
```
/api/v1/users  # Old version
/api/v2/users  # New version

Keep v1 running until clients migrate
```

**Option 2: Feature Flags**
```javascript
if (req.headers['x-api-version'] === '2') {
  // New behavior
} else {
  // Old behavior
}
```

**Option 3: Deprecation Period**
```
1. Add new field, keep old field (both work)
2. Deprecation warning in response header
3. After 6 months, remove old field
```

## Request/Response Schemas

### Input Validation

```javascript
const userSchema = {
  email: {
    type: 'string',
    format: 'email',
    required: true
  },
  name: {
    type: 'string',
    minLength: 1,
    maxLength: 100,
    required: true
  },
  age: {
    type: 'integer',
    minimum: 0,
    maximum: 150,
    required: false
  }
};

// Validate before processing
const errors = validate(req.body, userSchema);
if (errors) {
  return res.status(400).json({ error: {
    code: 'VALIDATION_ERROR',
    fields: errors
  }});
}
```

### Output Consistency

**Always same shape:**
```javascript
// ✅ GOOD: Consistent field presence
{
  "id": 123,
  "name": "John",
  "avatar": null  // Present even if null
}

// ❌ BAD: Field sometimes missing
{
  "id": 123,
  "name": "John"
  // avatar field missing entirely
}
```

## Pagination Pattern

```
GET /api/users?page=2&limit=20

Response:
{
  "data": [...],
  "pagination": {
    "page": 2,
    "limit": 20,
    "total": 150,
    "pages": 8,
    "hasNext": true,
    "hasPrev": true
  }
}
```

## Filtering & Sorting

```
GET /api/users?filter[status]=active&sort=-createdAt

# Multiple filters
filter[status]=active&filter[role]=admin

# Sort ascending: sort=name
# Sort descending: sort=-name
```

## Authentication

```javascript
// Bearer token (recommended)
Authorization: Bearer <jwt-token>

// Check in middleware
function requireAuth(req, res, next) {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) {
    return res.status(401).json({
      error: { code: 'UNAUTHORIZED', message: 'Authentication required' }
    });
  }

  try {
    req.user = verifyToken(token);
    next();
  } catch (e) {
    res.status(401).json({
      error: { code: 'INVALID_TOKEN', message: 'Token is invalid or expired' }
    });
  }
}
```

## Status Codes Quick Reference

| Code | When to Use | Example |
|------|-------------|---------|
| 200 OK | Successful GET, PUT, PATCH | User fetched |
| 201 Created | Successful POST | User created |
| 204 No Content | Successful DELETE | User deleted |
| 400 Bad Request | Validation error | Missing required field |
| 401 Unauthorized | Missing/invalid auth | No token provided |
| 403 Forbidden | Insufficient permissions | User can't delete others' posts |
| 404 Not Found | Resource doesn't exist | User ID not found |
| 409 Conflict | Duplicate or conflict | Email already exists |
| 422 Unprocessable | Semantic error | Invalid state transition |
| 429 Too Many Requests | Rate limit hit | Try again later |
| 500 Server Error | Unexpected error | Database connection failed |

## API Design Checklist

**Before implementing new endpoint:**
- [ ] URL follows REST conventions (/resource/:id)
- [ ] HTTP method is semantically correct
- [ ] Request schema defined with validation
- [ ] Response schema defined (success + errors)
- [ ] Authentication/authorization planned
- [ ] Error cases identified
- [ ] Status codes chosen appropriately
- [ ] Breaking changes identified (if modifying existing)

**Before modifying existing endpoint:**
- [ ] Search memory: why was this designed this way?
- [ ] Identify all clients/consumers
- [ ] Check if change is breaking
- [ ] If breaking: plan versioning/deprecation
- [ ] Document migration path for clients
- [ ] Update API documentation

## Common Mistakes

### ❌ Inconsistent Naming
```
GET /api/users          # plural
GET /api/product/:id    # singular
```
**Fix:** Always plural for collections.

### ❌ Using POST for Everything
```
POST /api/getUser
POST /api/updateUser
```
**Fix:** Use correct HTTP methods (GET, PUT, etc.)

### ❌ No Validation
```javascript
app.post('/api/users', (req, res) => {
  User.create(req.body);  // No validation
});
```
**Fix:** Always validate input before processing.

### ❌ Exposing Internal IDs
```json
{
  "id": 123,
  "userId": 456,  // Database internal ID
  "internalRef": "abc123"  // Exposes internals
}
```
**Fix:** Only expose necessary IDs, use UUIDs for public IDs.

### ❌ No Pagination
```
GET /api/users  # Returns all 100,000 users
```
**Fix:** Always paginate large collections.

## Real-World Impact

**Without consistent API design:**
- Breaking changes ship unnoticed
- Clients break in production
- Inconsistent error handling
- Hard to maintain/version

**With this skill:**
- Predictable API contracts
- Safe evolution with backward compatibility
- Clear versioning strategy
- Professional, maintainable APIs
