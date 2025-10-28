---
name: memory-assisted-debugging
description: Use when encountering bugs, errors, performance issues, or test failures - searches project memory for similar past issues, failed solutions, and successful debugging approaches before proposing fixes, preventing repeated dead ends
---

# Memory-Assisted Debugging

## Overview

**Your project has memory. Use it before debugging from scratch.**

This skill queries claude-mem's persistent memory BEFORE proposing debugging solutions. It searches for similar past errors, checks which solutions failed, identifies recurring root causes, and applies successful debugging methodologies from history.

**Core principle:** Every bug you debug teaches lessons. Most bugs follow patterns. Memory prevents repeating failed debugging approaches.

## When to Use

Use this skill when:
- **Any error occurs** - TypeError, ENOENT, 500 errors, database errors
- **Performance issues** - Slow queries, page load times, memory leaks
- **Test failures** - Random failures, flaky tests, integration errors
- **Before proposing solutions** - Check if solution failed before
- **Pattern recognition needed** - Similar errors across sessions

**Triggers:**
- User reports error message or stack trace
- Performance problem described ("slow", "hanging", "timeout")
- Test failure with symptoms ("random", "flaky", "sometimes passes")
- Before suggesting debugging approach

**DO NOT use for:**
- First session on new project (no memory yet)
- Single-character typos with no context suggesting systematic issues (e.g., `cosnt` → `const`, `improt` → `import`)
- When memory search returns no results (fallback to systematic-debugging)

**CAUTION:** Even "obvious" errors may reveal patterns in memory. Recurring "simple" errors suggest deeper issues (wrong templates, faulty generators, copy-paste problems). When in doubt, search memory first.

## Prerequisites

**Required:**
- `claude-mem` plugin installed and running
- At least one previous debugging session captured

**Integration:**
- Use WITH systematic-debugging (memory informs investigation approach)
- Enhances full-stack-integration-checker (reference past integration issues)
- Works with spec-kit-orchestrator (memory-assisted problem prevention)

## Memory-First Debugging Workflow

### Step 1: ALWAYS Search Memory First

**BEFORE proposing any solution or debugging approach:**

#### For Error Messages

```
Use MCP tool: mcp__claude_mem__search_observations

Query: [exact error message or key phrase]

Examples:
- "Cannot read property userId of undefined"
- "ENOENT no such file or directory"
- "500 Internal Server Error"
- "TypeError: X is not a function"
- "Database connection timeout"
```

**Extract from results:**
- When did this error occur before? (session numbers, dates)
- What was the root cause? (not just symptoms)
- What solutions were tried? (successful vs. failed)
- What debugging methodology worked?

#### For Performance Issues

```
Use MCP tool: mcp__claude_mem__find_by_concept

Concepts to search:
- "slow query" / "database performance"
- "page load" / "frontend performance"
- "memory leak" / "memory usage"
- "N+1 query" / "missing index"
```

**Extract from results:**
- Common root causes in this project
- Performance anti-patterns encountered
- Solutions that improved performance
- Profiling approaches that worked

#### For Test Failures

```
Use MCP tool: mcp__claude_mem__search_user_prompts

Query phrases:
- "test failing" / "flaky test"
- "random failure" / "intermittent"
- "test hangs" / "test timeout"
```

**Extract from results:**
- Past test failure patterns
- Root causes (isolation, timing, state pollution)
- What fixed them (systematic-debugging approach?)
- Known testing anti-patterns in project

### Step 2: Pattern Recognition

**After memory search, identify patterns:**

#### Single Error Pattern

**If same error occurred 1+ times before:**

```markdown
## Memory Search Results

**Past occurrences:** [N] times (sessions #X, #Y, #Z)

**Root causes identified:**
- Session #X: [root cause 1]
- Session #Y: [root cause 2]
- Session #Z: [root cause 3]

**Pattern detected:** [Most common root cause]

**Recommendation:** Check [most likely cause] first based on history.
```

#### Recurring Root Cause

**If multiple similar errors share common root cause:**

```markdown
## Pattern Recognition

This is the [N]th time we've seen errors related to [category].

**Past instances:**
1. [Error A] → Root cause: [X]
2. [Error B] → Root cause: [X]
3. [Error C] → Root cause: [X]

**Project-specific pattern:** [Error category] = [Root cause] in 100% of cases

**Action:** Jump to [root cause check] immediately.
```

### Step 3: Solution Filtering

**Check memory for attempted solutions:**

#### Failed Solutions (Skip These)

```
Query: mcp__claude_mem__search_observations
       with context around error + "tried" or "didn't work"

Look for:
- "Tried adding [X] but didn't work"
- "Attempted [Y] without success"
- "Still failing after [Z]"
```

**Flag failed approaches:**

```markdown
## Solutions to AVOID (Failed in Past)

Based on project memory:
- ❌ [Solution A] - Tried in session #X, didn't work
- ❌ [Solution B] - Tried in session #Y, made it worse
- ❌ [Solution C] - Session #Z notes: "This seemed to help but underlying issue remained"

## Solutions to TRY (Worked in Past)

- ✅ [Solution D] - Fixed similar issue in session #X
- ✅ [Solution E] - Root cause solution from session #Y
```

#### Successful Solutions (Apply These First)

**Prioritize solutions that worked before:**

1. **Known fix for this exact error** → Apply immediately
2. **Known fix for similar error** → Try first
3. **Successful debugging methodology** → Follow same approach
4. **Project-specific patterns** → Check those first

### Step 4: Methodology Reference

**Apply debugging approach that worked before:**

#### Query Past Debugging Success

```
Use MCP tool: mcp__claude_mem__find_by_type

Type: "skill usage" or "systematic debugging"

Look for:
- What debugging skills were used?
- What investigation steps were followed?
- What worked vs. wasted time?
```

**Reference successful methodology:**

```markdown
## Debugging Approach (From Memory)

Session #X successfully debugged similar issue using:
1. [Step 1 from past session]
2. [Step 2 from past session]
3. [Root cause tracing method]

**Apply same methodology to current issue.**

**Use systematic-debugging skill** (referenced in session #X)
```

### Step 5: Memory-Informed Proposal

**Present findings to user:**

```markdown
## Memory-Assisted Debugging Plan

### 1. Memory Search Results
[What you found in past sessions]

### 2. Pattern Recognition
[Is this a known pattern? Recurring root cause?]

### 3. Most Likely Cause
Based on [N] similar past issues: [hypothesis]

### 4. Investigation Plan
**Priority 1:** Check [most common root cause from history]
**Priority 2:** If #1 clear, check [second most common]
**Priority 3:** If both clear, apply [debugging methodology from past]

### 5. Solutions to Avoid
[List failed attempts from memory]

### 6. Next Steps
[Specific debugging actions based on memory]
```

## MCP Tools Quick Reference

| Tool | When to Use | What to Search |
|------|-------------|----------------|
| `search_observations` | Error messages, stack traces | Exact error text or key phrase |
| `find_by_concept` | Broad patterns | "performance", "authentication", "testing" |
| `search_user_prompts` | User-reported symptoms | How user described similar issues |
| `find_by_file` | File-specific errors | File paths where errors occurred |
| `get_recent_context` | Recent work context | What was just being worked on |
| `search_sessions` | Debugging session summaries | "debugging", "fixed", "root cause" |

## Integration with Systematic-Debugging

**How these skills work together:**

```
User reports bug
    │
    ↓
[🧠 MEMORY SEARCH] ← memory-assisted-debugging
    │
    ├─ Known error? → Apply known solution
    │
    ├─ Pattern found? → Check likely root cause first
    │
    └─ Unknown error → Use systematic-debugging
                       │
                       └─ Follow 4-phase framework
                            (Root Cause Investigation →
                             Pattern Analysis →
                             Hypothesis Testing →
                             Implementation)
```

**Memory INFORMS systematic debugging:**
- Start investigation at most likely cause (from history)
- Skip failed debugging approaches
- Apply methodology that worked before
- Reference similar past investigations

## Common Mistakes

### ❌ Skipping Memory Search
**Symptom:** Immediately proposing solutions without checking history

**Fix:** ALWAYS search memory first. Takes 30 seconds, saves hours.

### ❌ Ignoring Failed Solutions
**Symptom:** Suggesting solution that failed in past session

**Fix:** Explicitly check for "tried but didn't work" in memory. Skip failed approaches.

### ❌ Not Recognizing Patterns
**Symptom:** Treating 5th occurrence of same root cause as unique

**Fix:** Count pattern frequency. If N>2 with same root cause, that's the pattern.

### ❌ Generic Debugging Without Context
**Symptom:** Debugging from first principles when project has specific patterns

**Fix:** Let memory inform where to start. This project's "slow query" might always mean "missing index."

## Red Flags - When You're Skipping Memory

**STOP if you think:**
- "This error is straightforward, don't need history"
- "I know what this is, seen it before" (in general, but not in THIS project)
- "Memory search will take too long"
- "Let me just check the code first"
- "The fix is obvious, just a typo/import" (unless single-character typo)
- "User gave me the code, can skip memory"

**All of these mean:** Search memory first, THEN check code.

**Even if the fix seems obvious:** Past sessions might reveal this "obvious" error is a symptom of a deeper systematic issue (wrong templates, faulty generators, recurring copy-paste mistakes).

## Real-World Impact

**Without memory-assisted debugging:**
- Repeat failed solutions (waste 30+ minutes)
- Debug from scratch every time (no learning)
- Miss project-specific patterns
- Don't apply successful past methodologies

**With memory-assisted debugging:**
- Skip known dead ends immediately
- Jump to likely root cause (based on history)
- Apply debugging approach that worked before
- Continuous learning across sessions

**Time investment:** 1-2 minutes for memory search
**Time saved:** 15-60 minutes avoiding failed approaches

## Example: TypeError with Memory

**User:** "Getting TypeError: Cannot read property userId of undefined in comments endpoint"

**Without memory:**
- Check if req.user exists
- Add null checks
- Test fix
- (This specific solution failed in session #15 - wrong root cause)

**With memory:**

```
1. Search: mcp__claude_mem__search_observations("Cannot read property userId")

2. Results: Session #15 had identical error
   - Tried adding null checks → didn't work
   - Root cause: Authentication middleware not attached to route
   - Fix: Added auth middleware to router

3. Proposal:
   "I found this exact error in session #15. Adding null checks didn't fix it.

   Root cause was missing authentication middleware on the route.

   Let me check if /api/comments POST has auth middleware attached..."

4. Apply known solution immediately (skip failed approach)
```

**Result:** Fix in 2 minutes vs. 30 minutes of trial-and-error.

## Quick Checklist

**Before proposing ANY debugging solution:**
- [ ] Searched memory for error message / symptom
- [ ] Identified past occurrences (if any)
- [ ] Listed root causes from history
- [ ] Checked for failed solution attempts
- [ ] Identified successful approaches
- [ ] Recognized any patterns (N>2 same root cause)
- [ ] Prioritized investigation based on history
- [ ] Referenced debugging methodology if available

**Then proceed with debugging, informed by memory.**
