# continue-work

Resume from where you left off - loads recent context, in-progress features, and pending tasks.

## Usage

```bash
/continue-work
```

No arguments needed - automatically detects recent work.

## Description

Session continuity command that:
1. **Loads recent context** from claude-mem
2. **Identifies in-progress work** (features, tasks, bugs)
3. **Shows pending items** (what's not done)
4. **Resumes automatically** from last stopping point

**Use this command:**
- At session start
- After `/clear`
- When unsure what to work on next
- After break/interruption

## What It Does

### Step 1: Query Recent Context

Uses claude-mem to find recent work:

```
mcp__claude_mem__get_recent_context()
mcp__claude_mem__search_sessions(recent=true, limit=3)
```

**Extracts:**
- Last feature worked on
- In-progress tasks
- Open bugs/issues
- Recent decisions made

### Step 2: Check Project State

**Loads project files:**
- `features/*/tasks.md` - Task lists
- `features/*/spec.md` - Feature specs
- Git branch name - Current work context
- Recent commits - What was last done

**Identifies:**
- Features with incomplete tasks
- Pending pull requests
- Uncommitted changes
- Test failures

### Step 3: Present Summary

```markdown
## Session Resume

**Last worked on:** Comments feature (2 hours ago)

**Current status:**
- Branch: `feature/comments`
- Spec: Complete ✅
- Plan: Complete ✅
- Tasks: 5/8 complete (3 pending)

**Incomplete tasks:**
- [ ] Implement DELETE /api/comments/:id endpoint
- [ ] Add delete button to Comment component
- [ ] Write integration tests

**Recent decisions:**
- Using soft delete (status field)
- Rate limiting: 10 comments/hour/user
- Pagination: 20 per page

**Next step:** Continue implementing DELETE endpoint
```

### Step 4: Resume Action

**Automatically:**
- Loads relevant files into context
- Shows code to be modified
- Proposes next action
- Ready to continue immediately

## Output Format

```markdown
# Continue Work

## 🔄 Recent Context (from memory)

**Session #127** (2 hours ago)
- Worked on: Comments feature implementation
- Completed: POST /api/comments, GET /api/comments, CommentList component
- In progress: Delete functionality

**Session #126** (yesterday)
- Worked on: Comments feature specification
- Decisions: Soft delete, rate limiting, pagination

## 📋 Current Project State

**Git Status:**
- Branch: `feature/comments`
- Uncommitted changes: 3 files (routes/comments.js, components/CommentList.jsx, tests/comments.test.js)
- Behind main: 2 commits

**Feature Progress:**
- Spec: ✅ Complete
- Plan: ✅ Complete
- Tasks: 5/8 complete

## ✅ Completed Tasks
- [x] Create Comment model in schema
- [x] Write and apply migration
- [x] Implement POST /api/comments endpoint
- [x] Implement GET /api/comments endpoint
- [x] Create CommentList component

## ⏳ Pending Tasks
- [ ] Implement DELETE /api/comments/:id endpoint
- [ ] Add delete button to Comment component
- [ ] Write integration tests

## 🎯 Next Action

**Resume:** DELETE endpoint implementation

**Files to modify:**
- `routes/comments.js` - Add DELETE route
- `controllers/comments.js` - Add delete logic
- `components/Comment.jsx` - Add delete button

**Approach:**
1. Add DELETE route with auth middleware
2. Implement ownership check (user can only delete own comments)
3. Soft delete (set status='deleted')
4. Return 204 No Content
5. Add delete button to UI
6. Test manually
7. Run /ship-check before declaring complete

**Ready to continue? I can start with the DELETE endpoint implementation.**
```

## Use Cases

### Use Case 1: Morning Start

```bash
$ /continue-work

Resume: Comments feature (from yesterday)
Status: 5/8 tasks complete
Next: Implement DELETE endpoint

Ready to continue!
```

### Use Case 2: After Interruption

```bash
$ /continue-work

Resume: Bug fix for authentication (from 3 hours ago)
Status: Investigation complete, fix identified
Next: Implement fix and verify

Let me apply the fix we identified...
```

### Use Case 3: Multiple Features

```bash
$ /continue-work

Found 2 in-progress features:
1. Comments feature (5/8 tasks) - Last worked 2 hours ago
2. Notifications feature (2/6 tasks) - Last worked yesterday

Which should I continue?
> 1

Continuing comments feature...
```

### Use Case 4: Nothing In Progress

```bash
$ /continue-work

No in-progress work found.

Recent completed work:
- Comments feature (completed yesterday)
- Authentication refactor (completed 2 days ago)

Ready for new work! What should we build next?
```

## Integration

**Works with:**
- **claude-mem** - Loads recent session context
- **spec-kit-orchestrator** - Resumes feature workflow
- **memory-assisted-debugging** - Resumes bug investigations
- Git - Checks branch, commits, status

**Complements:**
- `/ship-check` - Check if ready to ship before continuing
- `/recall-feature` - Search similar past features
- Memory skills - Automatic context loading

## Smart Detection

**Detects context from:**
- claude-mem recent sessions
- Git branch names (`feature/X` → working on X)
- Open files in editor
- Uncommitted changes
- Task list files (tasks.md)
- Recent commits

**Prioritizes:**
1. Most recent work (< 24 hours)
2. In-progress tasks (incomplete)
3. Uncommitted changes
4. Current git branch

## Configuration

**Optional: Create `.continue.json` in repo root:**

```json
{
  "featureDir": "features",
  "taskFiles": ["tasks.md", "TODO.md"],
  "contextDepth": 3,
  "autoLoad": ["spec.md", "plan.md", "tasks.md"]
}
```

## Benefits

**Without /continue-work:**
- Ask "what was I doing?"
- Search memory manually
- Read tasks file
- Reconstruct context
- 5-10 minutes lost at session start

**With /continue-work:**
- Instant context resume
- Clear next action
- Ready to code immediately
- < 30 seconds to full context

**Time saved:** 5-10 minutes per session

## Quick Reference

| Situation | Command Output |
|-----------|----------------|
| In-progress feature | Resumes where you left off |
| Multiple features | Asks which to continue |
| Nothing pending | Suggests new work |
| Uncommitted changes | Shows what's modified |
| Test failures | Resumes debugging |

## Notes

- Requires claude-mem plugin for best results
- Works with or without spec-kit files
- Detects git state automatically
- Smart about multiple in-progress items
- Helps maintain focus and momentum
