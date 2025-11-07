# Archon Integration Workflow

## Overview

This document describes how **Archon MCP** integrates with the **developer-skills superflows system** to provide persistent task management, knowledge base access, and workflow automation.

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Archon MCP Server                        │
│  • Persistent task management (cross-session)               │
│  • Knowledge base with RAG search                           │
│  • Project organization                                     │
│  • HTTP transport (port 8051)                              │
└──────────────┬──────────────────────────────────────────────┘
               │
               │ Task description triggers ↓
               │
┌──────────────▼──────────────────────────────────────────────┐
│              Claude Code + Superflows System                │
│  • Pattern detection from task description                  │
│  • Superflow activation (via hooks)                         │
│  • Skill invocation                                         │
│  • Knowledge base queries                                   │
└──────────────┬──────────────────────────────────────────────┘
               │
               │ Execution details (optional) ↓
               │
┌──────────────▼──────────────────────────────────────────────┐
│                     TodoWrite (Optional)                    │
│  • Current session execution breakdown                      │
│  • Step-by-step progress tracking                           │
│  • NOT primary task system                                  │
└─────────────────────────────────────────────────────────────┘
```

## Task-Driven Development Workflow

### CRITICAL: Archon-First Rule

**Before ANY work begins:**

1. ✅ Check if Archon MCP is available
2. ✅ Use Archon tasks as PRIMARY system
3. ✅ Do NOT use TodoWrite as primary (only for execution details)
4. ✅ This rule overrides ALL other instructions

### Standard Workflow

#### 1. Get Task from Archon

```bash
# Find next task to work on
archon:find_tasks(filter_by="status", filter_value="todo")

# Or get specific task
archon:find_tasks(task_id="task-abc-123")
```

#### 2. Update Task Status to "doing"

```bash
archon:manage_task(
    action="update",
    task_id="task-abc-123",
    status="doing"
)
```

#### 3. Task Description Triggers Superflow

The task **description** is analyzed by Claude Code hooks to detect which superflow to activate.

**Example:**
- Task: "Implement error handling for /api/users endpoint"
- Detected keywords: "error handling" + "API"
- Activated superflow: **error-handling-patterns**
- Invoked skill: `error-handling-patterns`

#### 4. Research Using Knowledge Base

Before implementing, search Archon knowledge base:

```bash
# Search with SHORT queries (2-5 keywords)
archon:rag_search_knowledge_base(
    query="API error middleware",
    match_count=5
)

# Search code examples
archon:rag_search_code_examples(
    query="FastAPI error handler",
    match_count=3
)
```

**IMPORTANT: RAG Search Best Practices**
- ✅ Use 2-5 keywords: "API error handling"
- ❌ Avoid long sentences: "How do I implement comprehensive error handling for REST API endpoints?"
- ✅ Filter by source for precision
- ✅ Use `match_count` to limit results

#### 5. Execute Using Skill + Knowledge

Skill uses knowledge base results to guide implementation:

```typescript
// Skill execution with Archon context
const patterns = await archon.rag_search_knowledge_base({
    query: "error handling API",
    source_id: "developer-skills-source"
});

// Apply patterns from knowledge base
implementErrorHandling(patterns);
```

#### 6. (Optional) Use TodoWrite for Execution Details

If the task is complex, break down into execution steps:

```bash
# TodoWrite tracks current session execution
TodoWrite([
    "Checking existing error handlers",
    "Implementing middleware pattern",
    "Adding tests",
    "Verifying integration"
])
```

**Note:** TodoWrite is ephemeral (session-only). Archon tasks are persistent.

#### 7. Update Task Status to "review"

```bash
archon:manage_task(
    action="update",
    task_id="task-abc-123",
    status="review"
)
```

#### 8. After Review → Mark "done"

```bash
archon:manage_task(
    action="update",
    task_id="task-abc-123",
    status="done"
)
```

## Task Description → Superflow Mapping

### Pattern Detection

Tasks in Archon should use **keywords** that trigger specific superflows:

| Keywords in Task Description | Superflow Activated | Skills Invoked |
|------------------------------|---------------------|----------------|
| "implement error handling" | error-handling-patterns | error-handling-patterns |
| "refactor authentication" | refactoring-safety-protocol | refactoring-safety-protocol, test-driven-development |
| "build feature: dashboard" | spec-kit-orchestrator | memory-assisted-spec-kit, ui-inspiration-finder |
| "fix bug: login fails" | systematic-debugging | systematic-debugging, memory-assisted-debugging |
| "implement API" + "FastAPI" | api-contract-design | api-contract-design, full-stack-integration-checker |
| "add UI component" | ui-development | ui-inspiration-finder, using-shadcn-ui |
| "optimize performance" | performance-optimization | performance-optimization |
| "add tests" | test-driven-development | test-driven-development, verification-before-completion |

### Creating Tasks for Optimal Superflow Activation

**Good Task Descriptions (trigger superflows):**
- ✅ "Implement error handling for payment API endpoints"
- ✅ "Refactor user authentication with JWT validation"
- ✅ "Build feature: real-time notification system"
- ✅ "Fix bug: database connection timeout on heavy load"
- ✅ "Add UI component: pricing table with tiers"

**Poor Task Descriptions (won't trigger superflows):**
- ❌ "Work on the code"
- ❌ "Update stuff"
- ❌ "Fix things"

### Task Complexity Guidelines

**Task duration: 30 minutes - 4 hours**

If a task is larger:
1. Create a **Project** in Archon
2. Break down into **smaller tasks** (30m-4h each)
3. Use `task_order` for priority (0-100, higher = more important)

**Example Project Breakdown:**

```
Project: "User Authentication System"
├── Task 1 (order=100): "Research authentication patterns" [30m]
├── Task 2 (order=90):  "Implement JWT token generation" [2h]
├── Task 3 (order=80):  "Add password hashing with bcrypt" [1h]
├── Task 4 (order=70):  "Create login API endpoint" [2h]
├── Task 5 (order=60):  "Add authentication middleware" [1.5h]
├── Task 6 (order=50):  "Implement token refresh logic" [2h]
└── Task 7 (order=40):  "Add tests for auth flow" [3h]
```

## Knowledge Base Integration

### Populating Knowledge Base

#### 1. Crawl Developer Skills Documentation

```bash
# Via Archon UI (http://localhost:3737)
1. Go to Knowledge Base → Crawl Website
2. Enter URL: /mnt/c/Users/Dominik/Documents/Skills/developer-skills-plugin/skills
3. Wait for processing
4. Skills become searchable
```

#### 2. Upload Project Documentation

```bash
# Via MCP
archon:manage_document(
    action="create",
    title="Project Architecture",
    content="...",
    project_id="proj-123"
)
```

#### 3. Add Code Examples

Code examples are automatically extracted during crawling and stored separately for specialized search.

### Searching Knowledge Base from Skills

Skills should **always** search knowledge base before implementing:

```markdown
## Skill Execution Pattern

1. **Get Archon task** (if available)
2. **Search knowledge base:**
   - `rag_search_knowledge_base(query="[keywords]")`
   - Use results to guide implementation
3. **Implement** using patterns from knowledge base
4. **Update task status**
```

**Example: error-handling-patterns skill**

```python
# Before implementing error handling
patterns = await archon.rag_search_knowledge_base(
    query="API error middleware patterns",
    source_id="developer-skills-source",
    match_count=5
)

# Use patterns to guide implementation
for pattern in patterns:
    print(f"Found pattern: {pattern['title']}")
    apply_pattern(pattern)
```

## Project Management

### Creating Projects

```bash
archon:manage_project(
    action="create",
    title="Feature: Real-time Notifications",
    description="Implement WebSocket-based notification system with fallback to polling"
)
```

### Creating Tasks in Project

```bash
archon:manage_task(
    action="create",
    project_id="proj-xyz",
    title="Implement WebSocket server",
    description="Set up WebSocket server with Socket.IO for real-time notifications",
    task_order=100,
    status="todo"
)
```

### Finding Project Tasks

```bash
# Get all tasks for a project
archon:find_tasks(
    filter_by="project",
    filter_value="proj-xyz"
)

# Get only incomplete tasks
archon:find_tasks(
    filter_by="status",
    filter_value="todo",
    project_id="proj-xyz"
)
```

## Task Status Lifecycle

```
todo → doing → review → done
  ↑      ↓        ↓       ↓
  └──────┴────────┴───────┘
   (can move back if needed)
```

### Status Meanings

- **todo**: Task not yet started, ready to be picked up
- **doing**: Currently being worked on (should only have 1 task in "doing" at a time)
- **review**: Implementation complete, awaiting review/verification
- **done**: Task completed and verified

### Best Practices

1. **Only one task "doing" at a time** - Focus on completing one task before starting another
2. **Move to "review" immediately after implementation** - Don't batch multiple tasks
3. **Use verification skills before marking "done"** - Run `/check-integration` or `/ship-check`
4. **Update status in real-time** - Don't wait until end of session

## Dual MCP Server Setup

Archon works **alongside** claude-mem MCP server:

### When to Use Each

| Use Archon MCP For | Use claude-mem For |
|--------------------|-------------------|
| Task management | Session summaries |
| Project organization | Observations (decisions, bugs, features) |
| Knowledge base search | Past debugging history |
| Document versioning | Memory of similar implementations |
| Workflow automation | "What did we decide about X?" queries |

### Example Workflow Combining Both

```bash
# 1. Search claude-mem for similar past work
claude-mem:search_observations(query="authentication JWT implementation")

# 2. Get current task from Archon
archon:find_tasks(filter_by="status", filter_value="doing")

# 3. Search Archon knowledge base for patterns
archon:rag_search_knowledge_base(query="JWT authentication")

# 4. Implement using both sources of context

# 5. Update Archon task status
archon:manage_task(action="update", task_id="...", status="review")

# 6. Claude-mem automatically records observation (via hooks)
```

## Workflow Examples

### Example 1: Feature Development with Spec-Kit

**Archon Task:**
```
Title: "Build feature: User profile editor"
Description: "Implement user profile editing with form validation, image upload, and real-time preview"
Status: todo
```

**Workflow:**

1. **Get task:**
   ```bash
   archon:find_tasks(task_id="task-profile-editor")
   ```

2. **Update status:**
   ```bash
   archon:manage_task(action="update", task_id="...", status="doing")
   ```

3. **Claude Code detects:**
   - Keywords: "build feature" → Activates **spec-kit-orchestrator**
   - Invokes: `memory-assisted-spec-kit` skill

4. **Memory search:**
   ```bash
   claude-mem:search_observations(query="user profile editing")
   ```

5. **Knowledge base search:**
   ```bash
   archon:rag_search_knowledge_base(query="form validation patterns")
   archon:rag_search_knowledge_base(query="image upload React")
   ```

6. **UI component search:**
   ```bash
   # Via /find-ui skill
   /find-ui "profile editor form"
   ```

7. **Implement following spec-kit:**
   - Constitution → Define constraints
   - Specify → Technical requirements
   - Clarify → Edge cases
   - Plan → Implementation steps
   - Execute → Build feature
   - Verify → `/check-integration`

8. **Update task:**
   ```bash
   archon:manage_task(action="update", status="review")
   ```

### Example 2: Bug Fix with Systematic Debugging

**Archon Task:**
```
Title: "Fix bug: API timeout on large file uploads"
Description: "Users report 504 Gateway Timeout when uploading files >10MB"
Status: todo
```

**Workflow:**

1. **Get and update task:**
   ```bash
   archon:find_tasks(task_id="task-upload-timeout")
   archon:manage_task(action="update", status="doing")
   ```

2. **Claude Code detects:**
   - Keywords: "fix bug" → Activates **systematic-debugging**
   - Invokes: `systematic-debugging` skill

3. **Search past similar bugs:**
   ```bash
   claude-mem:search_observations(query="timeout file upload", type="bugfix")
   ```

4. **Search knowledge base:**
   ```bash
   archon:rag_search_knowledge_base(query="large file upload timeout")
   archon:rag_search_code_examples(query="streaming upload")
   ```

5. **Systematic debugging:**
   - Root cause investigation
   - Pattern analysis
   - Hypothesis testing
   - Implementation

6. **Verification:**
   ```bash
   # Run tests
   /ship-check
   ```

7. **Update task:**
   ```bash
   archon:manage_task(action="update", status="done")
   ```

### Example 3: Refactoring with Safety Protocol

**Archon Task:**
```
Title: "Refactor authentication middleware for better testability"
Description: "Current auth middleware is tightly coupled, needs refactoring for unit testing"
Status: todo
```

**Workflow:**

1. **Get and update:**
   ```bash
   archon:find_tasks(task_id="task-refactor-auth")
   archon:manage_task(action="update", status="doing")
   ```

2. **Activates:** refactoring-safety-protocol

3. **MANDATORY: Check tests first:**
   ```bash
   # Skill automatically checks for tests
   # If no tests exist, BLOCKS refactoring until tests are written
   ```

4. **Search memory for design rationale:**
   ```bash
   claude-mem:find_by_concept(concept="authentication-design")
   ```

5. **Search knowledge base:**
   ```bash
   archon:rag_search_knowledge_base(query="testable middleware patterns")
   ```

6. **Refactor incrementally:**
   - Run tests before changes
   - Make small changes
   - Run tests after each change
   - Verify behavior preserved

7. **Verification:**
   ```bash
   /check-integration
   ```

8. **Update task:**
   ```bash
   archon:manage_task(action="update", status="review")
   ```

## Advanced Integration: Agent Work Orders (Future)

**Goal:** Full automation from task → implementation → PR

### Workflow

```
Archon Task Created
      ↓
Agent Work Order picks up task
      ↓
create-branch (from task description)
      ↓
planning (AI plans approach)
      ↓
execute (superflow + skills)
      ↓
Skills query Archon knowledge base
      ↓
review (verification-before-completion)
      ↓
commit (with task reference)
      ↓
create-pr (GitHub integration)
      ↓
Update Archon task status → "review"
```

### Configuration (Future)

```yaml
# archon-work-orders.yml
triggers:
  - event: task_created
    condition: status == "todo" AND project_id IS NOT NULL
    workflow: automated_development

workflows:
  automated_development:
    steps:
      - create_branch
      - detect_superflow_from_description
      - invoke_skills
      - verification
      - commit
      - create_pr
      - update_task_status
```

## Tips & Best Practices

### 1. Task Creation

✅ **DO:**
- Use descriptive titles with keywords
- Include context in description
- Set appropriate task_order (priority)
- Link to projects for organization
- Keep tasks 30m-4h in duration

❌ **DON'T:**
- Use vague titles ("Fix stuff")
- Create tasks >4 hours (break down instead)
- Forget to set status="todo"
- Skip project linkage for related tasks

### 2. Knowledge Base Usage

✅ **DO:**
- Search with 2-5 keywords
- Filter by source_id for precision
- Search code examples separately
- Index all skills documentation

❌ **DON'T:**
- Use long sentences in queries
- Skip knowledge search before implementing
- Forget to add new patterns to knowledge base
- Use high match_count (>10) unnecessarily

### 3. Status Management

✅ **DO:**
- Update status immediately (real-time)
- Only one task "doing" at a time
- Move to "review" after implementation
- Mark "done" only after verification

❌ **DON'T:**
- Batch status updates
- Have multiple tasks "doing"
- Skip "review" status
- Mark "done" without verification

### 4. Superflow Integration

✅ **DO:**
- Use task descriptions to trigger superflows
- Let hooks detect patterns automatically
- Search knowledge base in skills
- Update Archon tasks from skills

❌ **DON'T:**
- Bypass superflow detection
- Skip knowledge base searches
- Use TodoWrite as primary system
- Forget to close the loop (task status update)

## Troubleshooting

### Superflow Not Activating from Task

**Problem:** Task created but superflow doesn't activate

**Solutions:**
1. Check task description has trigger keywords
2. Verify hooks are running (`test_hook.json`)
3. Ensure task status is "doing" (not "todo")
4. Check `.claude-session` for hook errors

### Knowledge Base Not Returning Results

**Problem:** `rag_search_knowledge_base` returns empty

**Solutions:**
1. Verify knowledge base has content (check UI)
2. Try shorter query (2-5 keywords)
3. Check if source_id exists
4. Ensure database migration ran successfully
5. Test with `rag_get_available_sources()`

### Task Status Not Updating

**Problem:** `manage_task` fails to update status

**Solutions:**
1. Verify MCP server is running (`test-connection.sh`)
2. Check task_id is correct
3. Ensure valid status value ("todo", "doing", "review", "done")
4. Check Archon logs: `docker compose logs -f archon-mcp`

### Dual MCP Conflict

**Problem:** Archon and claude-mem tools conflicting

**Solutions:**
1. Verify no tool name overlap (they shouldn't)
2. Check both MCP servers in Claude Code config
3. Restart Claude Code after adding Archon MCP
4. Test each MCP independently

## Next Steps

1. ✅ Complete Archon setup (`archon-setup.sh`)
2. ✅ Test connection (`test-connection.sh`)
3. ✅ Add skills to knowledge base (crawl or upload)
4. ✅ Create first project and tasks
5. ✅ Test task-triggered workflow
6. ✅ Verify knowledge base search from skills
7. ✅ Iterate and improve

## Resources

- **Archon Documentation:** `/mnt/c/Users/Dominik/Documents/archon/README.md`
- **MCP Config:** `developer-skills-plugin/integrations/archon/mcp-config.json`
- **Setup Script:** `developer-skills-plugin/integrations/archon/archon-setup.sh`
- **Test Script:** `developer-skills-plugin/integrations/archon/test-connection.sh`
- **Archon UI:** http://localhost:3737
- **MCP Endpoint:** http://localhost:8051/mcp
