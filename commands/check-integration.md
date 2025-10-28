---
description: Verify full-stack integration for a feature (database → API → frontend)
allowed-tools: Read, Grep, Bash
argument-hint: [feature-name]
---

# Full-Stack Integration Verification

You are running the `/check-integration` command to systematically verify that a feature is fully integrated across all three layers: database, API, and frontend.

## Your Task

Use the **full-stack-integration-checker** skill to verify the feature is complete:

@developer-skills-plugin/skills/full-stack-integration-checker/SKILL.md

## Feature to Verify

$ARGUMENTS

## Systematic Verification Process

Follow these steps exactly:

### Step 1: Identify the Feature Scope

Ask the user (if not clear from $ARGUMENTS):
- What model/table does this feature use? (e.g., `Comment`, `Favorite`, `UserProfile`)
- What operations should users be able to do? (Create, Read, Update, Delete)
- What files were modified?

### Step 2: Layer 1 - Database Schema

Verify:
- [ ] Find the schema definition (search for `model FeatureName` in schema files)
- [ ] List all fields in the model
- [ ] Check if migrations were applied (`npx prisma migrate status` or equivalent)
- [ ] Verify relations are defined (foreign keys, cascading)

**Report findings to user.**

### Step 3: Layer 2 - Backend API

For each CRUD operation the feature should support:

- [ ] **Create**: Search for `POST.*feature` endpoints
- [ ] **Read**: Search for `GET.*feature` endpoints (both list and detail)
- [ ] **Update**: Search for `PUT.*feature` or `PATCH.*feature` endpoints
- [ ] **Delete**: Search for `DELETE.*feature` endpoints

For each endpoint found, verify:
- [ ] Uses authenticated user (not `req.body.userId`)
- [ ] Has authorization checks (ownership verification)
- [ ] Has error handling (try-catch blocks)
- [ ] Returns proper status codes (404, 400, 403, 500)
- [ ] Includes related data (no N+1 queries)
- [ ] Has pagination for list endpoints

**Report findings to user with specific file:line references.**

### Step 4: Layer 3 - Frontend

Search for components that use this feature:

- [ ] Find API calls (grep for the API endpoints)
- [ ] Verify all endpoints are consumed
- [ ] Check for loading states (`useState.*Loading`)
- [ ] Check for error states (`useState.*Error`)
- [ ] Verify TypeScript types are defined
- [ ] Check CRUD operations available in UI:
  - Can create? → Has form
  - Can read? → Has display
  - Can update? → Has edit UI
  - Can delete? → Has delete button

**Report findings to user with specific file:line references.**

### Step 5: Follow the Field

For each database field, trace it through all layers:

1. Schema defines field ✓
2. API response includes field?
3. Frontend type includes field?
4. UI displays or edits field?

**Report any unused fields or missing integrations.**

### Step 6: Integration Gaps Summary

Create a checklist of all issues found:

```markdown
## Integration Verification Results

### ✅ Complete
- [List what's working correctly]

### ⚠️ Issues Found
- [List each issue with severity: 🔴 Critical, 🟠 Major, 🟡 Minor]

### 📋 Action Items
- [ ] Fix issue 1
- [ ] Fix issue 2
- [ ] Re-run verification after fixes
```

## Example Output

```markdown
## Integration Check: Comments Feature

### Database Layer ✅
- Comment model found in schema.prisma:45
- Fields: id, postId, userId, content, createdAt
- Migration applied ✓
- Relations defined: userId → User, postId → Post ✓

### Backend Layer ⚠️
- ✅ POST /api/comments (routes/comments.ts:12)
- ❌ GET /api/comments - NOT FOUND
- ❌ DELETE /api/comments/:id - NOT FOUND
- 🔴 **Security Issue**: POST uses req.body.userId (routes/comments.ts:15)

### Frontend Layer ⚠️
- ✅ CommentForm component (components/CommentForm.tsx:8)
- ❌ CommentList shows mock data (components/CommentList.tsx:22)
- ❌ No delete button in UI
- ❌ No loading state in CommentForm

### Issues Found: 6
🔴 Critical: Security hole (client-provided userId)
🔴 Critical: No GET endpoint (can't display real comments)
🟠 Major: Missing DELETE functionality
🟠 Major: Mock data not replaced with API call
🟡 Minor: No loading/error states

**Verdict: NOT ready to ship. Critical issues must be fixed.**
```

## Output Guidelines

- Be specific with file paths and line numbers
- Use the checklist format from the skill
- Categorize issues by severity
- Provide clear next steps
- Don't say "looks good" unless ALL items are verified
