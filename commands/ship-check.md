# ship-check

Comprehensive pre-ship validation - verifies feature is complete and ready to deploy.

## Usage

```bash
/ship-check [feature-name]
```

If no feature name provided, checks current working branch/directory.

## Description

Runs complete validation checklist before shipping:
1. **Full-stack integration** - Database → API → Frontend connected
2. **Spec acceptance criteria** - All requirements met
3. **CRUD completeness** - All operations implemented
4. **Tests passing** - No failing tests
5. **Security checks** - Authentication, authorization, validation
6. **Code quality** - No obvious issues

Returns clear verdict: ✅ **Ready to ship** or ❌ **Gaps found with checklist**

## What It Checks

### Layer 1: Database Schema
- [ ] Schema applied (migrations run, tables exist)
- [ ] All fields have purpose (no unused fields)
- [ ] Constraints correct (@unique, @index, required)
- [ ] Relations configured (foreign keys, cascades)

### Layer 2: Backend API
- [ ] CRUD completeness (all operations present)
- [ ] Authentication on all endpoints (no trusting client)
- [ ] Authorization checks (ownership, permissions)
- [ ] Error handling (try-catch, status codes)
- [ ] Input validation (prevent injection, malformed data)
- [ ] No orphaned endpoints (all are consumed)

### Layer 3: Frontend
- [ ] All API endpoints consumed (no missing integration)
- [ ] Loading states (spinners, skeletons)
- [ ] Error states (user-friendly messages)
- [ ] State syncs with backend (after CRUD operations)
- [ ] Form validation (client-side + server-side)

### Cross-Cutting Concerns
- [ ] Tests exist and pass (unit, integration, e2e)
- [ ] No hardcoded secrets (API keys, passwords)
- [ ] No console.log/debugger statements
- [ ] Constitution principles followed

## Execution Flow

```mermaid
graph TD
    A[/ship-check feature-name] --> B[Load Feature Context]
    B --> C{Spec exists?}
    C -->|No| D[Ask user for feature scope]
    C -->|Yes| E[Load spec.md, plan.md, tasks.md]
    E --> F[Run Full-Stack Integration Check]
    F --> G[Verify Spec Acceptance Criteria]
    G --> H[Check Tests]
    H --> I[Security Scan]
    I --> J[Generate Report]
    J --> K{All checks pass?}
    K -->|Yes| L[✅ READY TO SHIP]
    K -->|No| M[❌ GAPS FOUND - Show Checklist]
```

## Skills Used

This command orchestrates multiple skills:
1. **full-stack-integration-checker** - Main validation engine
2. **verification-before-completion** - Evidence-based checks
3. **spec-kit-orchestrator** (validation phase) - Spec criteria check
4. **memory-assisted-debugging** (optional) - Check for known issues

## Step-by-Step Execution

### Step 1: Identify Feature Scope

**If feature name provided:**
```bash
/ship-check "comments"
→ Looks for: features/comments/spec.md
```

**If no feature name:**
```bash
/ship-check
→ Asks: "What feature are you shipping?"
→ Or detects from git branch name
```

### Step 2: Load Feature Context

**Load spec-kit files if they exist:**
- `features/{name}/spec.md` - Acceptance criteria
- `features/{name}/plan.md` - Implementation phases
- `features/{name}/tasks.md` - Task completion status

**If spec-kit files don't exist:**
- Ask user to describe feature scope
- Use conversation context to infer scope

### Step 3: Run Full-Stack Integration Check

**Use full-stack-integration-checker skill:**

```markdown
## Integration Validation

Checking: Database → API → Frontend

### Database Layer
[Checks schema for feature tables/fields]
✅ Comment model defined
✅ Migrations applied
✅ Relations configured (User → Comment)
⚠️ Missing index on postId (slow queries likely)

### Backend API Layer
[Checks API endpoints]
✅ POST /api/comments (authenticated)
✅ GET /api/comments?postId=X (public read)
❌ Missing DELETE /api/comments/:id (no delete operation)
⚠️ PUT endpoint exists but not in spec (orphaned?)

### Frontend Layer
[Checks UI components]
✅ CommentList displays comments
✅ CommentForm creates comments
❌ No delete button (matches missing DELETE endpoint)
⚠️ No loading state during POST (poor UX)
```

### Step 4: Verify Spec Acceptance Criteria

**If spec.md exists, check each criterion:**

```markdown
## Spec Acceptance Criteria

From: features/comments/spec.md

- [x] Users can create comments on posts
- [x] Users can view comments on posts
- [ ] Users can edit their own comments (NOT IMPLEMENTED)
- [ ] Users can delete their own comments (NOT IMPLEMENTED)
- [x] Comments display author information
- [ ] Rate limiting prevents spam (NOT IMPLEMENTED)

**Result:** 3/6 criteria met
```

**If no spec, ask targeted questions:**
- "Should users be able to delete comments?"
- "Is there edit functionality?"
- "What about rate limiting?"

### Step 5: Check Tests

**Run test validation:**

```bash
# Check if tests exist
find . -name "*comment*test*" -o -name "*comment*spec*"

# Check test status (if test command available)
npm test -- comments
# or
pytest tests/test_comments.py
```

**Report:**
```markdown
## Test Validation

✅ Unit tests exist: tests/comments.test.js
✅ Tests passing: 12/12
⚠️ No integration tests found
❌ No e2e tests for comments feature
```

### Step 6: Security Scan

**Check common security issues:**

```markdown
## Security Validation

✅ Authentication: POST endpoint requires auth
✅ Authorization: User can only delete own comments (code check)
❌ Input validation: No length limit on comment content (DoS risk)
⚠️ Rate limiting: Not implemented (spam risk)
✅ No hardcoded secrets found
```

### Step 7: Generate Ship-Check Report

**Final comprehensive report:**

```markdown
# Ship-Check Report: Comments Feature

Generated: 2025-10-27 19:45:00

## Summary

⚠️ **NOT READY TO SHIP** - 4 blocking issues, 3 warnings

---

## Critical Issues (Must Fix)

❌ **Missing DELETE endpoint**
   Location: Backend API
   Impact: Users cannot delete comments (spec requirement)
   Fix: Implement DELETE /api/comments/:id with ownership check

❌ **Incomplete spec acceptance criteria**
   Met: 3/6 criteria
   Missing: Edit, delete, rate limiting
   Fix: Implement missing features or update spec to mark as out-of-scope

❌ **No integration tests**
   Impact: Can't verify database → API → frontend flow
   Fix: Add integration test for create → display → delete flow

❌ **No input validation on comment content**
   Security risk: DoS via large comments
   Fix: Add max length validation (e.g., 5000 characters)

---

## Warnings (Should Fix)

⚠️ **Missing index on Comment.postId**
   Performance: Queries by postId will be slow
   Fix: Add migration for index

⚠️ **No loading state during comment creation**
   UX: User doesn't know submission is processing
   Fix: Add loading spinner to CommentForm

⚠️ **No rate limiting**
   Risk: Spam comments possible
   Fix: Add rate limit (e.g., 10 comments/hour/user)

---

## What's Working ✅

✅ Database schema defined and applied
✅ POST /api/comments with authentication
✅ GET /api/comments with user data
✅ CommentList component displays comments
✅ CommentForm component creates comments
✅ Unit tests passing (12/12)
✅ No hardcoded secrets

---

## Constitution Alignment

✅ User privacy: Auth required for posting
✅ Mobile-first: Components are responsive
⚠️ Zero security vulnerabilities: Input validation missing

---

## Next Steps

**To ship this feature:**

1. Implement DELETE /api/comments/:id endpoint
2. Add delete button to Comment component
3. Add input validation (max 5000 chars)
4. Write integration test
5. Re-run /ship-check

**Or update spec to mark edit/delete as v2:**
- Move edit/delete/rate-limiting to "Future Enhancements"
- Document in spec.md out-of-scope section
- Re-run /ship-check

---

## Estimated Time to Ship-Ready

- If implementing missing features: 2-3 hours
- If reducing scope: 30 minutes (validation + tests)

**Recommendation:** Reduce scope for v1, ship with create/read only, plan v2 with edit/delete.
```

### Step 8: User Decision

**Present options:**

```markdown
## Ship-Check Complete

⚠️ Not ready to ship (4 critical issues found)

**What would you like to do?**

A) Fix the critical issues (implement delete, tests, validation)
B) Reduce scope (mark delete/edit as v2, ship create/read only)
C) Show me the integration gaps in detail
D) Run specific check (tests only, security only, etc.)

[User chooses...]
```

## Exit Codes

**For CI/CD integration:**
- Exit 0: ✅ Ready to ship
- Exit 1: ❌ Critical issues found
- Exit 2: ⚠️ Warnings only (can ship with caution)

## Examples

### Example 1: Feature Ready

```bash
/ship-check "authentication"

# Output:
✅ READY TO SHIP - Authentication Feature

All checks passed:
✅ Database schema complete
✅ All CRUD operations implemented
✅ Frontend integrated
✅ Tests passing (45/45)
✅ Security validated
✅ Spec criteria met (8/8)

This feature is production-ready!
```

### Example 2: Feature Incomplete

```bash
/ship-check "notifications"

# Output:
❌ NOT READY TO SHIP - Notifications Feature

Critical issues found:
❌ Missing WebSocket implementation (real-time delivery)
❌ No notification preferences UI
❌ Tests failing (3/15)

Fix these issues before shipping.
```

### Example 3: Feature Needs Scope Reduction

```bash
/ship-check "user-profiles"

# Output:
⚠️ SHIP-READY WITH SCOPE REDUCTION

Current state:
✅ View profile: Complete
✅ Edit profile: Complete
❌ Profile pictures: Not implemented
❌ Social links: Not implemented

Recommendation: Ship view + edit, mark pictures/social as v2
```

## Integration with Other Tools

**Works with:**
- `full-stack-integration-checker` skill (main engine)
- `verification-before-completion` skill (evidence checks)
- `spec-kit-orchestrator` checklist phase
- Git hooks (can run on pre-push)
- CI/CD pipelines (exit codes)

**Complements:**
- `/recall-feature` - Check how similar features were shipped
- `/check-integration` - More detailed integration analysis
- Hooks: Add PostToolUse hook to auto-run after implementation

## Configuration

**Optional: Create `.shipcheck.json` in repo root:**

```json
{
  "requireTests": true,
  "requireIntegrationTests": false,
  "requireE2ETests": false,
  "testCommand": "npm test",
  "coverageThreshold": 80,
  "securityChecks": {
    "noSecrets": true,
    "authRequired": true,
    "inputValidation": true
  },
  "customChecks": [
    {
      "name": "TypeScript types",
      "command": "tsc --noEmit"
    }
  ]
}
```

## Notes

- This is a comprehensive check, takes 2-5 minutes to run
- Designed to be run BEFORE creating PR
- Can be automated with git hooks (pre-push)
- Generates markdown report that can be copied to PR description
- Replaces manual checklist review

## Quick Reference

| Status | Meaning | Action |
|--------|---------|--------|
| ✅ Ready to ship | All checks pass | Create PR, deploy |
| ⚠️ Ship with caution | Warnings only | Review warnings, decide if acceptable |
| ❌ Not ready | Critical issues | Fix issues, re-run check |
