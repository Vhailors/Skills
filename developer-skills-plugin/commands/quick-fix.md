# quick-fix

Memory-powered rapid problem solving - searches history for known fixes before debugging.

## Usage

```bash
/quick-fix [problem-description]
```

## Description

Smart fix command that:
1. **Searches memory** for similar past issues
2. **Known issue?** → Applies proven fix immediately
3. **Unknown issue?** → Triggers systematic-debugging workflow
4. **Reports outcome** with confidence level

**Core principle:** Don't debug from scratch if the problem was solved before.

## What It Does

### Phase 1: Memory Search (Always First)

Searches claude-mem for:
- Exact error messages
- Similar symptoms
- Past debugging sessions
- Root causes identified
- Solutions that worked vs. failed

### Phase 2: Decision Tree

```
Memory search results
    │
    ├─ Exact match found (100% confidence)
    │  → Apply known fix immediately
    │  → Verify it worked
    │  → Done
    │
    ├─ Similar issue found (70%+ confidence)
    │  → Explain similarity
    │  → Propose likely fix
    │  → Ask user to confirm
    │  → Apply fix
    │
    ├─ Pattern recognized (50-70% confidence)
    │  → Show pattern
    │  → Suggest investigation approach
    │  → Run systematic-debugging
    │
    └─ Unknown issue (< 50% confidence)
       → No memory found
       → Run systematic-debugging from scratch
```

## Execution Flow

```mermaid
graph TD
    A[/quick-fix description] --> B[Parse Problem]
    B --> C[🧠 Search Memory]
    C --> D{Match Found?}
    D -->|Exact| E[Apply Known Fix]
    D -->|Similar| F[Propose Likely Fix]
    D -->|Pattern| G[Suggest Approach]
    D -->|Unknown| H[Systematic Debug]
    E --> I[Verify Fix]
    F --> J{User Confirms?}
    J -->|Yes| E
    J -->|No| H
    G --> H
    H --> K[Complete]
    I --> L{Fixed?}
    L -->|Yes| K
    L -->|No| H
```

## Input Parsing

**Accepts flexible input:**

```bash
# Error messages
/quick-fix "TypeError: Cannot read property userId of undefined"

# Symptoms
/quick-fix "tests failing randomly"
/quick-fix "page loading slow"
/quick-fix "button not working"

# File-specific
/quick-fix "comments.js line 45 throwing error"

# Behavioral
/quick-fix "login redirects to wrong page"
/quick-fix "data not saving to database"
```

**Extracts:**
- Error type (TypeError, ENOENT, etc.)
- Component/file affected
- Symptom keywords (slow, failing, not working)
- Context (login, database, frontend, etc.)

## Memory Search Strategy

### Query 1: Exact Error Match
```
mcp__claude_mem__search_observations("[exact error message]")

Example: "Cannot read property userId of undefined"
```

**If match found:**
- Extract: Session number, root cause, solution
- Confidence: 100%
- Action: Apply known fix

### Query 2: Symptom Search
```
mcp__claude_mem__find_by_concept("[problem category]")

Examples:
- "authentication error"
- "slow query"
- "test failure"
- "undefined property"
```

**If matches found:**
- Extract: Similar issues, common root causes
- Confidence: 70-90%
- Action: Propose likely fix

### Query 3: Pattern Search
```
mcp__claude_mem__search_user_prompts("[symptom keywords]")

Examples:
- "not working"
- "failing"
- "slow"
```

**If patterns found:**
- Extract: Recurring patterns in this project
- Confidence: 50-70%
- Action: Suggest investigation approach

### Query 4: Recent Context
```
mcp__claude_mem__get_recent_context()

Check: Was something just changed that could cause this?
```

**If recent relevant work:**
- Extract: Recent changes
- Confidence: Varies
- Action: Check if recent change caused issue

## Output Format

### Scenario A: Exact Match Found

```markdown
# 🎯 Quick-Fix: Known Issue

## Memory Match
**Found:** Session #15 (2 weeks ago)
**Confidence:** 100% - Exact same error

## Problem
`TypeError: Cannot read property userId of undefined` in `/api/comments` POST endpoint

## Root Cause (from session #15)
Missing authentication middleware on the route.
The endpoint expected `req.user` to be set by middleware, but middleware wasn't attached.

## Solution (proven to work)
Add `auth.requireUser` middleware to the route:

```javascript
// Before (session #15):
router.post('/api/comments', commentsController.create);

// After (fix that worked):
router.post('/api/comments', auth.requireUser, commentsController.create);
```

## Applying Fix

Let me apply this known fix...

[Reads routes/comments.js]
[Edits to add middleware]

✅ **Fix applied!** Added auth middleware to comments route.

## Verification

Run server and test POST /api/comments
[If test command available, runs it]

✅ **Verified!** Error resolved.

## Summary
- **Time to fix:** 30 seconds (vs. 30 minutes debugging from scratch)
- **Confidence:** 100% - exact match from memory
- **Source:** Session #15 solution
```

### Scenario B: Similar Issue Found

```markdown
# 🔍 Quick-Fix: Similar Issue

## Memory Match
**Found:** 2 similar issues (sessions #8, #23)
**Confidence:** 85% - Same symptom, different context

## Your Problem
`Database query slow` in user profiles endpoint

## Similar Past Issues

**Session #8:** Slow query in posts endpoint
- Root cause: Missing index on `userId` column
- Fix: Added index → query 100x faster

**Session #23:** Slow query in comments endpoint
- Root cause: Missing index on `postId` column
- Fix: Added index → query 50x faster

## Pattern Recognized
**In this project:** Slow queries are ALWAYS missing indexes (3/3 cases)

## Likely Root Cause
Missing database index on frequently-queried column in profiles.

## Proposed Fix
Check for missing indexes on User table, likely on columns used in WHERE clause.

**Would you like me to:**
A) Check database schema for missing indexes (recommended)
B) Run EXPLAIN query to confirm
C) Apply index migration immediately
D) Full systematic debugging instead

[User chooses A]

[Checks schema, finds missing index on User.email]

✅ **Confirmed!** Missing index on `email` column (used in profile lookup).

Applying fix: Creating migration to add index...
```

### Scenario C: Pattern Suggested

```markdown
# 🧩 Quick-Fix: Pattern Detected

## Memory Search
**Found:** 5 past sessions with "test failing" symptoms
**Confidence:** 60% - Pattern exists, but varied root causes

## Your Problem
Tests failing randomly

## Past Root Causes (from 5 sessions)

1. **Session #12:** Database state pollution (40% of cases)
   - Tests not cleaning up data
   - Fix: Added `afterEach` cleanup

2. **Session #18:** Race conditions (40% of cases)
   - Async operations not awaited
   - Fix: Used condition-based waiting

3. **Session #25:** Parallel execution conflicts (20% of cases)
   - Tests conflicting on shared resources
   - Fix: Run tests serially

## Recommended Investigation Approach

Based on project history, check in this order:
1. Database cleanup (most common)
2. Async/await patterns
3. Test isolation

## Running Systematic Debugging

Since this could be any of these patterns, let me run systematic investigation...

**Using:** systematic-debugging skill
**Starting:** Root Cause Investigation phase

[Proceeds with systematic debugging, informed by likely causes]
```

### Scenario D: Unknown Issue

```markdown
# 🔬 Quick-Fix: No Memory Found

## Memory Search
**Found:** No similar issues in project history
**Confidence:** 0% - This appears to be a new issue

## Your Problem
"Websocket connection dropping after 30 seconds"

## No Past Context
- This is the first WebSocket-related issue in this project
- No similar timeout issues found
- No relevant debugging sessions

## Approach
Running systematic-debugging from first principles...

**Phase 1: Root Cause Investigation**
[Systematic debugging process begins]

**Note:** This debugging session will be saved to memory for future reference.
```

## Skills Integration

**Primary skill:** memory-assisted-debugging
- Provides memory search logic
- Enforces memory-first workflow

**Fallback skill:** systematic-debugging
- Used when no memory match
- Used when proposed fix doesn't work
- 4-phase debugging framework

**Verification:** verification-before-completion
- Always verify fix actually works
- Run tests if available
- Check for regressions

## Confidence Levels

| Confidence | Meaning | Action |
|-----------|---------|--------|
| **100%** | Exact match in memory | Apply known fix immediately |
| **80-99%** | Very similar issue | Propose fix, ask confirmation |
| **60-79%** | Pattern recognized | Suggest approach, run debugging |
| **40-59%** | Weak pattern | Inform user, run debugging |
| **0-39%** | Unknown | Full systematic debugging |

## Success Metrics

**Tracks and reports:**
- Time saved vs. debugging from scratch
- Memory hit rate (how often memory helps)
- Fix success rate (did proposed fix work?)

**Example:**
```markdown
✅ Fixed in 45 seconds (memory hit: session #15)
📊 Time saved: ~29 minutes vs. debugging from scratch
🎯 Project stats: Memory helps 73% of the time (8/11 issues)
```

## Common Use Cases

### Use Case 1: Exact Error Repeat
```bash
/quick-fix "ENOENT: no such file or directory, open 'config.json'"

→ Memory: Found 3 times before
→ Root cause: File path incorrect (relative vs absolute)
→ Fix: Use path.join(__dirname, 'config.json')
→ Applied in 20 seconds
```

### Use Case 2: Performance Issue
```bash
/quick-fix "API endpoint taking 5+ seconds to respond"

→ Memory: Similar in session #12 (slow products endpoint)
→ Root cause: N+1 query (loading relations in loop)
→ Fix: Use .include() to eager load
→ Proposed fix, user confirmed, applied
```

### Use Case 3: New Issue Type
```bash
/quick-fix "Emails not sending in production"

→ Memory: No email issues found in history
→ This is new territory for this project
→ Running systematic debugging...
→ [Full investigation process]
```

### Use Case 4: Recurring Pattern
```bash
/quick-fix "Form validation not showing errors"

→ Memory: 4 past form issues found
→ Pattern: 100% were state management (not clearing errors)
→ Check: Is error state being reset?
→ Found: Same issue, applied known pattern
```

## Error Handling

**If memory search fails:**
- Fallback to systematic-debugging
- Notify user: "Memory unavailable, debugging from scratch"

**If proposed fix doesn't work:**
- Report: "Proposed fix didn't resolve issue"
- Fallback to systematic-debugging
- Save: This solution FAILED (prevent suggesting again)

**If verification fails:**
- Don't claim fix complete
- Run more thorough investigation
- May need deeper debugging

## Examples with Full Flow

### Example 1: Complete Success

```bash
$ /quick-fix "Cannot read property userId of undefined in comments endpoint"

🧠 Searching memory for similar issues...

🎯 **Exact match found!** (Session #15)

**Root cause:** Missing auth middleware
**Solution:** Add auth.requireUser to route
**Confidence:** 100%

Applying known fix...
✅ Added middleware to routes/comments.js:45
✅ Running tests... 12/12 passing
✅ **Fixed!**

⏱️ Time: 35 seconds (vs ~30 min debugging from scratch)
📝 This was the 8th time memory saved debugging time in this project
```

### Example 2: Similar Issue, User Decision

```bash
$ /quick-fix "database query very slow"

🧠 Searching memory...

🔍 **Similar issues found** (3 matches, 90% confidence)

All 3 past "slow query" issues were missing database indexes.

**Likely fix:** Add index to queried column

**Should I:**
A) Check for missing indexes (quick)
B) Run EXPLAIN query first (thorough)
C) Full debugging instead

> A

Checking schema... Found: Missing index on User.email
Creating migration to add index...

✅ **Fix applied!** Query now 150x faster.
```

### Example 3: Unknown Issue

```bash
$ /quick-fix "app crashes when uploading images"

🧠 Searching memory...

🔬 **No similar issues found**

This appears to be new. Running systematic debugging...

**Systematic Debugging: Phase 1 - Root Cause Investigation**
Let me gather information about the crash...
[Full debugging workflow]
```

## Notes

- Requires claude-mem plugin installed
- Gets smarter over time (more memory = better fixes)
- Saves every debugging session for future reference
- First few uses may have low hit rate (building memory)
- After 10+ debugging sessions, hit rate typically 60-80%

## Quick Reference

**Best for:**
- Known error types (auth, database, validation)
- Recurring issues
- Common problems (slow queries, missing checks)

**Not ideal for:**
- New project (no memory yet)
- Truly novel bugs
- Complex multi-system issues (use systematic-debugging directly)

**Pro tip:** After fixing an issue with systematic-debugging, `/quick-fix` will know how to fix it next time!
