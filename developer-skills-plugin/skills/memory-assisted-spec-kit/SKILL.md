---
name: memory-assisted-spec-kit
description: Enhanced spec-kit workflow that queries project memory for similar features, past clarifications, and implementation patterns before creating specifications - prevents reinventing solutions and learns from past work
---

# Memory-Assisted Spec-Kit

## Overview

**Learn from your past. Don't reinvent what you've already solved.**

This skill enhances the spec-kit-orchestrator workflow by querying claude-mem's persistent memory BEFORE creating specifications. It searches your project history for similar features, successful patterns, and past clarifications to inform new feature development.

**Core principle:** Every feature you build teaches lessons. This skill ensures those lessons are applied to future work.

## When to Use

Use this skill when:
- **Starting spec-kit workflow** - Before creating any specification
- **Creating feature specifications** - Query memory for similar past features
- **Clarification phase** - Reference past clarification questions that revealed gaps
- **Planning phase** - Find implementation patterns that worked well
- **Avoiding past mistakes** - Learn from features that had issues

**Triggers:**
- About to run `/speckit.specify`
- User says "build a feature similar to..."
- You recognize a feature type you've built before
- During spec-kit clarification phase

**Integration:**
- Use BEFORE spec-kit-orchestrator's Step 2 (Specification)
- Enhances systematic-debugging with past bug patterns
- Works with full-stack-integration-checker to reference past integration approaches

## Prerequisites

**Required:**
- `claude-mem` plugin installed and running
- At least one previous session captured (otherwise no memory to query)

**Check if claude-mem is available:**
- Look for MCP tools starting with `mcp__claude_mem__*`
- SessionStart hook should inject "[Skills] recent context"

## Memory-Assisted Workflow

### Phase 1: Memory Search (Before Specification)

**When user requests a feature, BEFORE creating spec, query memory:**

#### Query 1: Find Similar Features

```
Use MCP tool: mcp__claude_mem__find_by_concept

Concept to search: [feature category]
Examples:
- "authentication" (if building login/signup)
- "CRUD operations" (if building create/read/update/delete)
- "real-time updates" (if building WebSocket features)
- "user profiles" (if building profile management)
- "comments system" (if building commenting)
- "notifications" (if building alerts/notifications)
```

**What to look for in results:**
- Past feature specifications
- Clarification questions that revealed hidden requirements
- Implementation approaches (what worked, what didn't)
- Integration patterns used
- Common pitfalls encountered

#### Query 2: Search Past User Prompts

```
Use MCP tool: mcp__claude_mem__search_user_prompts

Query: [feature keywords]
Examples:
- "implement comments"
- "build authentication"
- "add notifications"
```

**What to extract:**
- How user described similar features before
- What requirements were initially vague
- What details emerged during clarification
- What scope creep occurred (features that grew beyond initial ask)

#### Query 3: Search Implementation Observations

```
Use MCP tool: mcp__claude_mem__search_observations

Query: [technical terms]
Examples:
- "database schema migration"
- "API endpoint authentication"
- "frontend state management"
- "WebSocket connection"
```

**What to identify:**
- Technical decisions made (libraries, patterns, approaches)
- Problems encountered (errors, bugs, integration issues)
- Solutions that worked
- Code patterns to reuse

### Phase 2: Memory-Informed Specification

**Create spec using lessons from memory:**

#### Section 1: Context (Enhanced with Memory)

```markdown
## Context

### Why We're Building This
[Standard context about the problem]

### Lessons from Past Similar Features
Based on project memory:

**Similar feature:** [Name from memory search]
- **What worked:** [Successful patterns]
- **What didn't:** [Issues encountered]
- **Key learnings:** [Insights to apply]

**Avoided pitfalls:**
- [Issue 1 from past] → [How we'll prevent it]
- [Issue 2 from past] → [Mitigation strategy]
```

#### Section 2: Requirements (Informed by Past Clarifications)

```markdown
## Requirements

### Functional Requirements
[Standard requirements]

### Requirements Often Forgotten (From Memory)
Based on past features, these were commonly missed:
- [ ] [Requirement discovered late in past feature 1]
- [ ] [Requirement discovered late in past feature 2]
- [ ] [Edge case revealed during past implementation]

**Clarification questions to answer upfront:**
(These revealed gaps in past similar features)
1. [Question that caught gaps before]
2. [Question that prevented rework]
3. [Question that improved quality]
```

#### Section 3: Technical Constraints (Pattern-Aware)

```markdown
## Technical Constraints

### Patterns to Follow
(These worked well in similar past features)
- **Authentication:** [Pattern used successfully]
- **Data validation:** [Approach that prevented bugs]
- **Error handling:** [Strategy that improved UX]

### Patterns to Avoid
(These caused issues before)
- ❌ [Anti-pattern 1] → Use [better approach] instead
- ❌ [Anti-pattern 2] → Use [better approach] instead
```

### Phase 3: Memory-Assisted Clarification

**During spec-kit clarification phase, use memory to ask better questions:**

#### Standard Clarification PLUS Memory Insights

**Ask questions that revealed gaps in past similar features:**

```
Query memory for: "clarification questions [feature-type]"

Example insights:
- Past "comments feature" needed clarification on: ownership model, edit permissions, soft delete
- Past "authentication feature" needed clarification on: session duration, password reset flow, OAuth providers
- Past "notifications feature" needed clarification on: delivery mechanism, read/unread state, notification preferences
```

**Enhanced clarification template:**

```markdown
## Clarification Questions

### Standard Questions
[Normal CRUD, security, error handling questions]

### Questions That Caught Past Gaps
Based on similar feature: [name]

**Data Model:**
- [Question that revealed missing field in past]
- [Question that prevented N+1 query issue]

**Security:**
- [Question that caught authorization hole]
- [Question that revealed rate limit need]

**UX:**
- [Question that improved error messaging]
- [Question that prevented loading state bug]
```

### Phase 4: Memory-Informed Planning

**When creating implementation plan, reference past approaches:**

#### Query Past Implementation Patterns

```
Use MCP tool: mcp__claude_mem__find_by_file

File patterns to search:
- "schema.prisma" or "migrations/*" → Database patterns
- "api/routes/*" or "controllers/*" → API patterns
- "components/*" or "pages/*" → Frontend patterns
```

**Extract:**
- Migration strategies that worked smoothly
- API endpoint structures that scaled well
- Component architectures that stayed maintainable
- Testing approaches that caught bugs early

#### Enhanced Implementation Plan

```markdown
## Implementation Plan

### Approach
[Standard high-level approach]

**Reference implementation:** [Similar past feature]
**What we'll reuse:**
- [Pattern 1]: [Why it worked]
- [Pattern 2]: [Why it worked]

**What we'll improve:**
- [Past approach]: [Why we're changing it]
- [New approach]: [Expected benefit]

### Phase 1: Database Schema
**Pattern to follow:** [Past schema that worked]
**Lesson from past:** [Issue we'll avoid]

### Phase 2: Backend API
**Pattern to follow:** [Past API structure that worked]
**Lesson from past:** [Error handling improvement]

### Phase 3: Frontend UI
**Pattern to follow:** [Past component structure that worked]
**Lesson from past:** [State management improvement]
```

### Phase 5: Memory-Driven Validation

**During completion checklist, compare against past feature quality:**

```
Query memory for: "completed feature [similar-feature-name]"

Compare new feature against past feature:
- [ ] Has all CRUD operations past feature had
- [ ] Has better error handling than past feature
- [ ] Includes authentication checks that were missing before
- [ ] Includes edge cases that caused past bugs
- [ ] Has tests that past feature lacked
```

## Integration with Spec-Kit-Orchestrator

**How to use both skills together:**

### Standard Spec-Kit Flow (7 Steps):
1. Constitution Check
2. Feature Specification ← **ADD MEMORY SEARCH HERE**
3. Clarification ← **ADD MEMORY-ASSISTED QUESTIONS HERE**
4. Implementation Planning ← **ADD PATTERN REFERENCE HERE**
5. Task Breakdown
6. Implementation
7. Completion Validation ← **ADD MEMORY COMPARISON HERE**

### Enhanced Flow with Memory:

```
┌─────────────────────┐
│   Constitution      │
└──────────┬──────────┘
           │
           ↓
┌─────────────────────┐
│  🧠 MEMORY SEARCH   │ ← NEW STEP
│  Query similar      │
│  features & patterns│
└──────────┬──────────┘
           │
           ↓
┌─────────────────────┐
│  Specification      │ ← Enhanced with memory insights
│  (with lessons)     │
└──────────┬──────────┘
           │
           ↓
┌─────────────────────┐
│  🧠 MEMORY-ASSISTED │ ← NEW ENHANCEMENT
│     Clarification   │
│  (better questions) │
└──────────┬──────────┘
           │
           ↓
┌─────────────────────┐
│  Planning           │ ← Enhanced with past patterns
│  (with patterns)    │
└──────────┬──────────┘
           │
           ↓
     [Continue standard flow...]
```

## MCP Tools Reference

**Claude-mem provides these search tools:**

| Tool | Purpose | When to Use |
|------|---------|-------------|
| `mcp__claude_mem__search_observations` | Search all captured tool usage | Finding technical patterns, errors, solutions |
| `mcp__claude_mem__search_sessions` | Search session summaries | Finding similar feature work sessions |
| `mcp__claude_mem__search_user_prompts` | Search user requests | Finding how user described similar features |
| `mcp__claude_mem__find_by_concept` | Search by high-level concept | Finding features by category (auth, CRUD, etc) |
| `mcp__claude_mem__find_by_file` | Search by file path patterns | Finding implementation patterns in specific files |
| `mcp__claude_mem__find_by_type` | Search by observation type | Finding specific tool usage (Read, Write, Edit, etc) |
| `mcp__claude_mem__get_recent_context` | Get recent session context | Understanding what was just worked on |

## Example: Memory-Assisted Comments Feature

**User request:** "Build a comments system for blog posts"

### Step 1: Memory Search

```
mcp__claude_mem__find_by_concept("comments")
mcp__claude_mem__find_by_concept("CRUD operations")
mcp__claude_mem__search_user_prompts("comments feature")
```

**Findings from memory:**
- Past feature: "Product reviews system" (similar comment-like feature)
- Lessons learned:
  - ✅ Used soft delete (status field) instead of hard delete
  - ✅ Added `isEdited` flag for transparency
  - ❌ Forgot rate limiting → spam issue
  - ❌ No pagination → slow page load with many comments
  - ✅ Included user info in comment fetch → avoided N+1 queries

### Step 2: Memory-Informed Spec

```markdown
# Feature Spec: Blog Comments System

## Context
Users need to engage with blog posts through comments.

### Lessons from Past Similar Feature
**Reference:** Product reviews system (Session #42)

**What worked:**
- Soft delete with `status` field (allows content moderation)
- Including `isEdited` flag (user transparency)
- Fetching user data with comments in one query (performance)

**What didn't work:**
- No rate limiting led to spam (5 spam comments in one session)
- Missing pagination caused slow loads (20+ reviews on page)

**Applied to this feature:**
- Include rate limiting from the start (max 10 comments/hour/user)
- Implement pagination (20 comments per page)
- Use soft delete pattern
- Include edit tracking

## Requirements

### Functional Requirements
- Users can create comments on blog posts
- Users can edit their own comments (within 15 minutes)
- Users can delete their own comments (soft delete)
- Comments display with author info
- Comments are paginated (20 per page)

### Requirements Often Forgotten
(Lessons from product reviews feature)
- [ ] Rate limiting (prevent spam)
- [ ] Edit time window (prevent abuse)
- [ ] Pagination (performance)
- [ ] User info prefetch (avoid N+1 queries)
- [ ] Soft delete (enable moderation)
```

### Step 3: Memory-Assisted Clarification

**Questions informed by past reviews feature:**

1. **Ownership model** (revealed gap before): Can users edit/delete any comment or only their own? → Only their own
2. **Edit audit** (missed before): Should we show "edited" label? → Yes, with edit timestamp
3. **Moderation** (caused rework before): Will there be admin moderation? → Yes, soft delete enables this
4. **Spam prevention** (issue in past): What rate limits? → 10 comments/hour per user
5. **Nested comments** (scope creep before): Are replies/threads needed? → No, out of scope

---

## Red Flags - When Memory Search Fails

**If memory search returns no results:**
- Project is new (no history yet)
- Feature is truly novel (never built anything similar)
- Search terms don't match past work

**In these cases:**
- Fall back to standard spec-kit-orchestrator workflow
- This feature will become the reference for future similar work
- Memory will be valuable for next similar feature

**Don't force memory usage if it's not helpful.**

## Benefits

**With memory-assisted spec-kit:**
- ✅ Avoid repeating past mistakes
- ✅ Reuse successful patterns
- ✅ Better clarification questions upfront
- ✅ Faster specification (reference past work)
- ✅ Higher quality features (learn from history)
- ✅ Consistent patterns across features

**Without memory:**
- ❌ Rediscover requirements during implementation
- ❌ Repeat past mistakes
- ❌ Inconsistent patterns across features
- ❌ Miss edge cases you've encountered before
- ❌ Rework that could be avoided

**Time investment:** +5-10 minutes for memory search
**Time saved:** Hours of rework avoiding past mistakes

## Quick Reference

**Before spec-kit Step 2 (Specification):**
1. Query memory: `find_by_concept([feature-category])`
2. Extract: What worked, what didn't, lessons learned
3. Enhance spec with memory insights
4. Ask clarification questions that caught past gaps
5. Reference successful implementation patterns
6. Compare validation against past feature quality

**Remember:** Memory is only useful if you apply its lessons. Don't just read past work—integrate its insights into new work.
