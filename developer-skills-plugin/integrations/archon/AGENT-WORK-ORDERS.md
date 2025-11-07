# Agent Work Orders Integration

## Overview

**Agent Work Orders** is Archon's workflow automation engine that spawns Claude Code CLI instances to execute multi-step development workflows autonomously. With this integration, spawned CLI instances have full access to:

- ✅ **Archon MCP** - Knowledge base, task management, project organization
- ✅ **claude-mem MCP** - Observations, debugging history, past decisions
- ✅ **Developer Skills Plugin** - 28 skills + superflows system

## Architecture

```
User creates Work Order in UI
         ↓
Agent Work Orders Service (port 8053)
         ↓ spawns subprocess with custom env
Claude Code CLI (in isolated git worktree)
         ↓ loads config from .claude/config.json
┌────────────────────────────────────────┐
│ Archon MCP (http://archon-mcp:8051/mcp) │
│ claude-mem MCP (npx @dominikwilkowski/claude-mem)  │
│ Skills Plugin (/skills/developer-skills-plugin)    │
└────────────────────────────────────────┘
```

### What Gets Injected

**Before spawning CLI**, Agent Work Orders:

1. **Creates `.claude/config.json` in worktree** with:
   - Archon MCP server configuration (HTTP transport)
   - claude-mem MCP server configuration (isolated database per work order)
   - Skills plugin path (if mounted)

2. **Sets custom environment variables**:
   - `CLAUDE_SKILLS_PATH=/skills`
   - OAuth token (inherited from parent)

3. **Spawns CLI in git worktree**:
   - Isolated branch per work order
   - Config file loaded automatically
   - MCP servers connect on startup

## Configuration Changes

### 1. Code Modifications

#### agent_cli_executor.py

**Added method** (`_create_claude_config`):
- Creates `.claude/config.json` in worktree before spawning CLI
- Configures both MCP servers (Archon + claude-mem)
- Adds skills plugin if path exists
- Isolated claude-mem database per work order

**Modified method** (`execute_async`):
- Calls `_create_claude_config()` before spawning
- Passes custom environment with `env=custom_env`
- Skills path added to environment

#### config.py

**Added configuration**:
```python
ENABLE_MCP_INTEGRATION: bool = os.getenv("ENABLE_MCP_INTEGRATION", "true").lower() == "true"
CLAUDE_SKILLS_PATH: str = os.getenv("CLAUDE_SKILLS_PATH", "/skills")
CLAUDE_MEM_DB_PATH: str = os.getenv("CLAUDE_MEM_DB_PATH", "/tmp/agent-work-orders/mem")
```

**Existing** (already present):
```python
get_archon_mcp_url() -> str  # Returns correct URL based on service discovery mode
```

#### docker-compose.yml

**Added volumes**:
```yaml
volumes:
  - /mnt/c/Users/Dominik/Documents/Skills:/skills:ro  # Skills mounted read-only
```

**Added environment variables**:
```yaml
environment:
  - ENABLE_MCP_INTEGRATION=true
  - CLAUDE_SKILLS_PATH=/skills
  - CLAUDE_MEM_DB_PATH=/tmp/agent-work-orders/mem
```

---

## Usage

### Starting Agent Work Orders

```bash
cd /mnt/c/Users/Dominik/Documents/archon
docker compose --profile work-orders up -d --build
```

**Services started**:
- archon-server (8181)
- archon-mcp (8051)
- archon-agent-work-orders (8053)
- archon-ui (3737)

### Creating a Work Order

#### Via UI (Recommended)

1. **Open Archon UI**: http://localhost:3737
2. **Go to Projects** → Create project (if needed)
3. **Create Task**:
   - Title: "Implement error handling for API endpoints"
   - Description: "Add comprehensive error handling with user-friendly messages and logging"
   - Status: todo
4. **Go to Agent Work Orders** → Create Work Order
5. **Configure**:
   - Select task
   - Repository: Your repo URL
   - Base branch: main
   - Workflow: Standard (planning → execute → review → commit → PR)
6. **Submit**

#### What Happens Next

```
1. Service creates git worktree → /tmp/agent-work-orders/repos/<hash>/trees/<work-order-id>/
2. Service creates .claude/config.json with MCP servers + skills
3. Service spawns: claude --print --output-format stream-json --model sonnet --dangerously-skip-permissions
4. Claude CLI:
   - Loads config from .claude/config.json
   - Connects to Archon MCP (http://archon-mcp:8051/mcp)
   - Connects to claude-mem MCP (isolated database)
   - Loads skills plugin from /skills/developer-skills-plugin
5. Executes workflow steps:
   - planning: AI plans implementation approach
   - execute: AI implements using skills + knowledge base
   - review: AI reviews changes
   - commit: AI commits changes
   - create-pr: AI creates GitHub PR
6. Service streams progress via SSE to UI
```

---

## Skills Integration

### How Skills Are Used

When Claude CLI executes inside worktree:

1. **Skills plugin loaded** from `/skills/developer-skills-plugin`
2. **Superflows activated** based on task description keywords
3. **Skills invoked** automatically by superflows
4. **Knowledge base queried** via Archon MCP for patterns

**Example: Error Handling Task**

```
Task: "Implement error handling for API endpoints"
  ↓ Spawned CLI detects keywords
Superflow: error-handling-patterns activated
  ↓ Skill invokes MCP tools
archon:rag_search_knowledge_base(query="API error patterns")
  ↓ Returns patterns from knowledge base
Skill applies patterns to implementation
  ↓ Updates code
Result: Error handling implemented with proven patterns
```

### Superflows Available

All 28 skills + superflows active in spawned CLI:

| Trigger Pattern | Superflow | Skills Invoked |
|-----------------|-----------|----------------|
| "implement error handling" | error-handling-patterns | error-handling-patterns |
| "build feature" | spec-kit-orchestrator | memory-assisted-spec-kit |
| "fix bug" | systematic-debugging | systematic-debugging, memory-assisted-debugging |
| "refactor" | refactoring-safety-protocol | refactoring-safety-protocol, test-driven-development |
| "add UI" | ui-development | ui-inspiration-finder, using-shadcn-ui |

---

## MCP Tools Available

### Archon MCP (http://archon-mcp:8051/mcp)

**Knowledge Base**:
- `archon:rag_search_knowledge_base` - Semantic search
- `archon:rag_search_code_examples` - Find code snippets
- `archon:rag_get_available_sources` - List sources
- `archon:rag_read_full_page` - Get complete page

**Tasks**:
- `archon:find_tasks` - Search/filter tasks
- `archon:manage_task` - Create/update/delete tasks

**Projects**:
- `archon:find_projects` - List/search projects
- `archon:manage_project` - Create/update/delete projects

### claude-mem MCP (isolated database)

**Observations**:
- `search_observations` - Search past decisions/bugs/features
- `find_by_concept` - Find by tag
- `find_by_type` - Find by observation type

**Sessions**:
- `search_sessions` - Search past session summaries
- `get_recent_context` - Get recent work context

**Each work order has isolated claude-mem database** at:
```
/tmp/agent-work-orders/mem/<work-order-id>.db
```

---

## Monitoring & Debugging

### Real-Time Logs

**Via UI**: http://localhost:3737/agent-work-orders
- Real-time SSE stream
- Structured progress events
- Step-by-step execution log

**Via Docker**:
```bash
docker compose logs -f archon-agent-work-orders
```

### Inspecting Worktrees

```bash
# List all active worktrees
docker exec archon-agent-work-orders ls /tmp/agent-work-orders/repos/*/trees/

# View specific worktree
docker exec archon-agent-work-orders ls -la /tmp/agent-work-orders/repos/<hash>/trees/<work-order-id>/

# Check generated config
docker exec archon-agent-work-orders cat /tmp/agent-work-orders/repos/<hash>/trees/<work-order-id>/.claude/config.json
```

### Checking MCP Connectivity

```bash
# Test Archon MCP from container
docker exec archon-agent-work-orders curl http://archon-mcp:8051/health

# Test skills mount
docker exec archon-agent-work-orders ls -la /skills

# Verify plugin structure
docker exec archon-agent-work-orders ls -la /skills/developer-skills-plugin
```

### Log Patterns to Look For

**✅ Success Indicators**:
```
INFO agent_command_started command="claude --print..."
INFO archon_mcp_configured url="http://archon-mcp:8051/mcp"
INFO claude_mem_configured db_path="/tmp/agent-work-orders/mem/<id>.db"
INFO skills_plugin_configured path="/skills/developer-skills-plugin"
INFO claude_config_created config_file=".../.claude/config.json"
INFO agent_command_completed session_id="..." duration=45.2
```

**❌ Error Indicators**:
```
ERROR claude_config_creation_failed error="..."
WARNING skills_plugin_path_not_found path="..."
WARNING claude_skills_path_not_set_or_missing
ERROR agent_command_failed exit_code=1 error="..."
```

---

## Troubleshooting

### Skills Not Found

**Problem**: `skills_plugin_path_not_found` in logs

**Solution**:
```bash
# Verify mount exists
docker exec archon-agent-work-orders ls /skills

# If empty, check docker-compose.yml volume mount
# Should have: - /mnt/c/Users/Dominik/Documents/Skills:/skills:ro

# Restart container
docker compose restart archon-agent-work-orders
```

### MCP Connection Failed

**Problem**: Claude CLI can't connect to Archon MCP

**Solution**:
```bash
# Test connectivity from container
docker exec archon-agent-work-orders curl http://archon-mcp:8051/health

# Check service discovery mode
docker exec archon-agent-work-orders env | grep SERVICE_DISCOVERY_MODE
# Should be: docker_compose

# Verify MCP service running
docker ps --filter "name=archon-mcp"

# Check generated config
docker exec archon-agent-work-orders cat /tmp/agent-work-orders/repos/<hash>/trees/<id>/.claude/config.json
# Should have archon MCP URL
```

### claude-mem Database Issues

**Problem**: claude-mem not working in spawned CLI

**Solution**:
```bash
# Check if mem directory exists
docker exec archon-agent-work-orders ls /tmp/agent-work-orders/mem/

# Create if missing
docker exec archon-agent-work-orders mkdir -p /tmp/agent-work-orders/mem

# Verify database created after work order
docker exec archon-agent-work-orders ls /tmp/agent-work-orders/mem/<work-order-id>.db
```

### Work Order Timeout

**Problem**: Work order times out after 1 hour

**Solution**:
```bash
# Increase timeout in .env
AGENT_WORK_ORDER_TIMEOUT=7200  # 2 hours

# Or disable max turns for complex tasks
CLAUDE_CLI_MAX_TURNS=  # Empty = unlimited

# Rebuild
docker compose --profile work-orders up -d --build
```

### Git Worktree Cleanup

**Problem**: Old worktrees accumulating disk space

**Solution**:
```bash
# List worktrees
docker exec archon-agent-work-orders find /tmp/agent-work-orders/repos -type d -name "wo-*"

# Remove old worktrees (manual)
docker exec archon-agent-work-orders rm -rf /tmp/agent-work-orders/repos/<hash>/trees/<old-work-order-id>

# Or clear all (WARNING: loses all work orders)
docker exec archon-agent-work-orders rm -rf /tmp/agent-work-orders/repos
```

---

## Best Practices

### Task Description Guidelines

✅ **DO**: Use keywords that trigger superflows
```
"Implement error handling for payment API endpoints"
"Refactor authentication service for better testability"
"Build feature: real-time notification system"
```

❌ **DON'T**: Use vague descriptions
```
"Work on code"
"Fix stuff"
"Update things"
```

### Workflow Selection

**Standard Workflow**: Most features
- planning → execute → review → commit → create-pr

**Custom Workflows** (future):
- Spec-kit: constitution → specify → clarify → plan → execute
- Refactoring: tests → refactor → verify
- Bug fix: reproduce → debug → fix → verify

### Knowledge Base Preparation

Before creating work orders:

1. **Crawl documentation** into Archon knowledge base
2. **Index skills** - All 28 skills searchable
3. **Add project patterns** - Document your conventions
4. **Test RAG search** - Verify relevant results

### Monitoring

1. **Watch SSE stream** during execution
2. **Check logs** for MCP tool usage
3. **Verify config created** in worktree
4. **Inspect branches** created by agent

---

## Performance

### Typical Timings

| Task Complexity | Duration | Steps |
|----------------|----------|-------|
| Simple bug fix | 2-5 min | planning + execute + commit |
| Medium feature | 5-15 min | planning + execute + review + commit + PR |
| Complex feature | 15-45 min | full spec-kit workflow + implementation |

### Optimization Tips

1. **Prepare knowledge base** - Pre-index all documentation
2. **Clear task descriptions** - Better pattern matching
3. **Isolated databases** - No cross-contamination
4. **Parallel execution** - Run multiple work orders simultaneously

---

## Advanced Features

### Isolated claude-mem Per Work Order

Each work order gets its own claude-mem database:
```
/tmp/agent-work-orders/mem/wo-abc123.db
```

**Benefits**:
- No cross-contamination between work orders
- Each agent has clean slate
- Can analyze individual work order memory
- Easy to debug specific workflows

### Skills + Knowledge Base Synergy

Work order workflow:
```
1. Agent searches knowledge base for patterns
   → archon:rag_search_knowledge_base(query="error handling API")

2. Agent finds similar past work
   → claude-mem:search_observations(query="API error implementation")

3. Agent applies skill with context
   → error-handling-patterns skill uses both sources

4. Result: Implementation with proven patterns + past learnings
```

### GitHub Integration

Automatic PR creation:
- Branch naming: `feat/` `fix/` `refactor/` based on task type
- Commit messages: Descriptive with context
- PR description: Auto-generated with changes summary
- Links back to Archon task

---

## Configuration Reference

### Environment Variables

```bash
# MCP Integration
ENABLE_MCP_INTEGRATION=true           # Enable MCP + skills
CLAUDE_SKILLS_PATH=/skills            # Skills mount path
CLAUDE_MEM_DB_PATH=/tmp/agent-work-orders/mem  # claude-mem databases

# Service Discovery
SERVICE_DISCOVERY_MODE=docker_compose # Use Docker service names
ARCHON_MCP_URL=http://archon-mcp:8051 # Explicit MCP URL (optional)

# CLI Configuration
CLAUDE_CLI_PATH=claude                # CLI command
CLAUDE_CLI_MODEL=sonnet               # Model to use
CLAUDE_CLI_MAX_TURNS=                 # Unlimited turns (empty)
CLAUDE_CLI_SKIP_PERMISSIONS=true      # Non-interactive

# Authentication
CLAUDE_CODE_OAUTH_TOKEN=              # OAuth token (required)
GITHUB_PAT_TOKEN=                     # GitHub token (for PRs)

# Timeouts
AGENT_WORK_ORDER_TIMEOUT=3600         # 1 hour timeout
```

### Docker Volume Mounts

```yaml
volumes:
  - ./python/src/agent_work_orders:/app/src/agent_work_orders  # Hot reload
  - /tmp/agent-work-orders:/tmp/agent-work-orders              # Worktrees
  - /mnt/c/Users/Dominik/Documents/Skills:/skills:ro           # Skills (RO)
```

---

## Example: Complete Workflow

### 1. Create Task in Archon UI

```
Project: "API Improvements"
Task: "Implement comprehensive error handling for user API endpoints"
Description: "Add error handling with proper HTTP status codes, user-friendly messages, and structured logging for /api/users/* endpoints"
Status: todo
```

### 2. Create Work Order

- Repository: https://github.com/yourorg/your-api
- Base branch: main
- Task: Select "Implement comprehensive error handling..."
- Workflow: Standard

### 3. Watch Execution

**SSE Stream shows**:
```
workflow_started: work_order_id=wo-abc123
step_started: step=planning
step_completed: step=planning duration=15s
step_started: step=execute
  [MCP] archon:rag_search_knowledge_base query="API error handling patterns"
  [MCP] archon:rag_search_code_examples query="FastAPI error middleware"
  [Skill] error-handling-patterns invoked
  [Files] Modified: api/middleware/error_handler.py
  [Files] Modified: api/routes/users.py
  [Tests] Added: tests/test_error_handling.py
step_completed: step=execute duration=180s
step_started: step=review
step_completed: step=review duration=30s
step_started: step=commit
  [Git] Committed: "feat: Add comprehensive error handling for user API endpoints"
step_completed: step=commit duration=5s
step_started: step=create-pr
  [GitHub] PR created: #42 "feat: Add error handling for user API"
step_completed: step=create-pr duration=10s
workflow_completed: duration=240s status=success
```

### 4. Review Result

- **Branch created**: `feat/add-error-handling-user-api`
- **Commits**: 1 commit with descriptive message
- **PR**: https://github.com/yourorg/your-api/pull/42
- **Files changed**: 3 files (middleware, routes, tests)
- **Tests added**: Yes
- **Archon task updated**: Status → review

---

## Next Steps

1. ✅ **Test basic work order** - Create simple task, verify execution
2. ✅ **Monitor MCP usage** - Check logs for tool calls
3. ✅ **Verify skills activation** - Confirm superflows trigger
4. ✅ **Test knowledge base** - Ensure RAG search works
5. ✅ **Create complex workflow** - Full feature implementation
6. ✅ **Iterate and improve** - Refine based on results

---

## Resources

- **Agent Work Orders Code**: `/mnt/c/Users/Dominik/Documents/archon/python/src/agent_work_orders/`
- **Docker Compose**: `/mnt/c/Users/Dominik/Documents/archon/docker-compose.yml`
- **Skills Plugin**: `/mnt/c/Users/Dominik/Documents/Skills/developer-skills-plugin/`
- **Archon UI**: http://localhost:3737
- **Integration Docs**: `developer-skills-plugin/integrations/archon/`
