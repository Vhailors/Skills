# Test Scenarios: Memory-Assisted Debugging

## Purpose
Establish baseline behavior of agents WITHOUT memory-assisted-debugging skill to identify gaps.

## Test Scenario 1: Repeated Bug Pattern

**User Request:** "I'm getting 'TypeError: Cannot read property userId of undefined' in the comments endpoint"

**Expected Baseline Behavior (WITHOUT skill):**
- Agent analyzes the error message
- Proposes checking if req.user exists
- Suggests adding null checks
- Implements fix
- Doesn't check if this exact error occurred before
- Doesn't query memory for past similar authentication errors

**Gap Identified:**
- Agent doesn't search memory for identical/similar errors
- May propose solutions that failed before
- Doesn't learn from past debugging sessions
- Misses patterns across similar bugs

**What the skill should do:**
- Before proposing solutions, search memory: `mcp__claude_mem__search_observations("Cannot read property userId")`
- Find past occurrences of this error
- Check what solutions were tried (failed vs. succeeded)
- Apply successful solution from past
- Avoid repeating failed debugging approaches

---

## Test Scenario 2: Known Failed Solution

**User Request:** "The WebSocket connection keeps disconnecting after 30 seconds"

**Context (from memory):** In session #15, agent tried using `keepAlive: true` option but it didn't work. Real fix was server-side timeout configuration.

**Expected Baseline Behavior (WITHOUT skill):**
- Agent suggests adding `keepAlive: true` client option
- User tries it, doesn't work
- Agent then suggests server-side timeout
- Wasted time on known-failed solution

**Gap Identified:**
- Agent doesn't check memory for past failed solutions
- Repeats debugging approaches that already failed
- Wastes time on dead ends
- Doesn't prioritize solutions that worked before

**What the skill should do:**
- Search memory for "WebSocket disconnecting" or "WebSocket timeout"
- Find session #15 with failed approach
- Note: "`keepAlive: true` was tried and failed"
- Immediately suggest server-side timeout (known working solution)
- Skip failed approaches from history

---

## Test Scenario 3: Missing Root Cause Pattern

**User Request:** "Database query is really slow on production"

**Context (from memory):** Sessions #8, #12, #19 all had "slow query" issues. Root cause was always missing database indexes, never query optimization.

**Expected Baseline Behavior (WITHOUT skill):**
- Agent starts with query optimization suggestions
- Checks query structure, suggests rewrites
- Eventually discovers missing index
- Doesn't recognize this is a repeated pattern

**Gap Identified:**
- Agent doesn't identify recurring root causes
- Starts debugging from scratch each time
- Misses patterns: "slow query = missing index"
- Doesn't jump to likely root cause based on history

**What the skill should do:**
- Search memory for "slow query" or "database performance"
- Identify pattern: 3/3 past cases were missing indexes
- Immediately check indexes first (highest probability)
- Say: "Based on 3 past similar issues, this is usually a missing index. Let me check that first."
- Only try query optimization if index check fails

---

## Test Scenario 4: Incomplete Debugging Investigation

**User Request:** "Tests are failing randomly"

**Context (from memory):** Session #22 had "random test failures" that seemed like timing issues. Agent applied systematic-debugging skill and found it was actually database state pollution from parallel tests.

**Expected Baseline Behavior (WITHOUT skill):**
- Agent assumes timing/race condition issue
- Suggests adding waits/delays
- Doesn't apply systematic root cause investigation
- Doesn't check memory for similar "random failures"

**Gap Identified:**
- Agent jumps to conclusions without systematic investigation
- Doesn't learn from past debugging methodology
- Misses that "random failures" have specific patterns
- Doesn't apply lessons from past debugging sessions

**What the skill should do:**
- Search memory for "random test failures" or "flaky tests"
- Find session #22 with similar symptoms
- Note: "Past agent used systematic-debugging, found database pollution"
- Apply systematic-debugging skill (learned from history)
- Check for database state issues first (known cause)
- Reference past debugging methodology

---

## Test Scenario 5: Error Message Without Context

**User Request:** "Getting error: ENOENT: no such file or directory"

**Context (from memory):** Sessions #5, #11, #17 all had ENOENT errors. Root causes were:
- Session #5: Working directory incorrect
- Session #11: File path using forward slashes on Windows
- Session #17: File created in wrong directory

**Expected Baseline Behavior (WITHOUT skill):**
- Agent asks "what file is missing?"
- Checks if file exists
- Generic debugging without pattern recognition
- Doesn't query for past ENOENT errors

**Gap Identified:**
- Agent doesn't recognize error patterns
- Doesn't learn from past root causes
- Treats each ENOENT as unique
- Misses common causes

**What the skill should do:**
- Search memory for "ENOENT"
- Find 3 past sessions with root causes
- List known causes: "Working directory, path format, wrong output location"
- Check each known cause systematically
- Reference past solutions
- Pattern: "ENOENT usually means X, Y, or Z based on 3 past cases"

---

## Test Scenario 6: Integration Error Repeat

**User Request:** "API endpoint returns 500 error"

**Context (from memory):** Session #9 had similar 500 error. Root cause was missing error handling in database query causing uncaught exception.

**Expected Baseline Behavior (WITHOUT skill):**
- Agent checks server logs
- Looks at endpoint code
- Debugs from scratch
- Eventually finds missing try-catch

**Gap Identified:**
- Doesn't check memory for similar 500 errors
- Doesn't apply past lessons about error handling
- Repeats investigation that was done before

**What the skill should do:**
- Search memory for "500 error" or "API endpoint error"
- Find session #9 with missing error handling
- Immediately check: "Are database queries wrapped in try-catch?"
- Known pattern: "500 errors often from uncaught exceptions"
- Apply full-stack-integration-checker (learned from past)

---

## Test Scenario 7: Performance Issue Without Memory

**User Request:** "Page is loading slowly"

**Context (from memory):** Sessions #4, #13, #20 all had performance issues:
- Session #4: N+1 query problem (missing includes)
- Session #13: Large payload (missing pagination)
- Session #20: No caching headers

**Expected Baseline Behavior (WITHOUT skill):**
- Agent profiles performance
- Checks network waterfall
- Investigates from first principles
- Doesn't query for past performance issues

**Gap Identified:**
- Doesn't learn from past performance debugging
- Doesn't recognize common performance anti-patterns
- Each performance issue treated as unique

**What the skill should do:**
- Search memory for "slow" or "performance" or "loading"
- Find 3 past sessions with root causes
- Check known causes first: "N+1 queries, missing pagination, no caching"
- Pattern recognition: "Performance issues in this project are usually X, Y, or Z"
- Prioritize investigation based on past frequency

---

## Summary of Baseline Gaps

| Gap Category | Impact | Skill Solution |
|-------------|--------|---------------|
| No memory search | Repeat failed solutions | Query memory before proposing fixes |
| Missing pattern recognition | Debug from scratch each time | Identify recurring root causes |
| Ignoring past methodology | Inconsistent debugging approach | Reference successful debugging strategies |
| Not learning from failures | Waste time on dead ends | Skip solutions that failed before |
| No root cause patterns | Long investigation time | Check common causes first (based on history) |
| Generic error handling | Miss project-specific patterns | Apply project-specific lessons |

---

## Next Step: RED Phase Testing

Run these scenarios with subagents WITHOUT the skill to document actual baseline behavior and confirm these gaps exist.
