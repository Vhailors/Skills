# Archon MCP Integration

> **Archon-First Rule**: This project uses Archon MCP server for knowledge management, task tracking, and project organization. ALWAYS start with Archon MCP server task management.

## Overview

**Archon** is a knowledge management and AI agent orchestration platform that integrates with the developer-skills superflows system to provide:

- ✅ **Persistent Task Management** - Tasks survive across sessions (replaces TodoWrite)
- ✅ **Knowledge Base with RAG** - Searchable documentation, code examples, patterns
- ✅ **Project Organization** - Hierarchical projects with tasks
- ✅ **Dual MCP Setup** - Works alongside claude-mem MCP server
- ✅ **Workflow Automation** - Task descriptions trigger superflows
- ✅ **Real-time Dashboard** - Web UI for managing everything

## Quick Start

### 1. Prerequisites

Before starting, ensure you have:

- [x] Docker Desktop installed and running
- [x] Supabase account (free tier works)
- [x] OpenAI API key (for embeddings)
- [x] Node.js 18+ (optional, for development)

### 2. Automated Setup

Run the automated setup script:

```bash
cd developer-skills-plugin/integrations/archon
./archon-setup.sh
```

This script will:
1. Check prerequisites (Docker, curl)
2. Clone/verify Archon repository
3. Configure environment (.env file)
4. Guide you through database setup
5. Start Docker services
6. Provide MCP configuration instructions
7. Run verification tests

**Estimated time:** 10-15 minutes

### 3. Add to Claude Code

After setup completes, add Archon MCP server:

```bash
claude mcp add --transport http archon http://localhost:8051/mcp
```

Or manually add to your MCP config file:

```json
{
  "name": "archon",
  "transport": "http",
  "url": "http://localhost:8051/mcp"
}
```

### 4. Verify Connection

Test that everything is working:

```bash
./test-connection.sh
```

This checks:
- Docker containers running
- MCP server accessible
- Database connected
- UI available
- claude-mem still working (dual MCP)

### 5. Access Dashboard

Open the Archon UI dashboard:

```
http://localhost:3737
```

Complete the onboarding flow to:
- Set your OpenAI API key (if not done in .env)
- Upload first document or crawl website
- Create your first project

## Agent Work Orders (Workflow Automation)

**NEW**: Archon can now spawn Claude Code CLI instances with full skills + MCP access for automated workflows!

### What It Does

**Agent Work Orders** autonomously executes multi-step development workflows:
- Creates branch → Plans → Implements → Reviews → Commits → Creates PR
- Each spawned CLI has access to Archon MCP, claude-mem MCP, and all 28 skills
- Real-time progress monitoring via SSE stream
- Isolated git worktrees per work order

### Enable Agent Work Orders

```bash
cd /mnt/c/Users/Dominik/Documents/archon
docker compose --profile work-orders up -d --build
```

**Additional service started**:
- archon-agent-work-orders (port 8053)

### Quick Usage

1. **Create task in Archon UI** with descriptive keywords:
   ```
   "Implement error handling for API endpoints"
   ```

2. **Go to Agent Work Orders** → Create Work Order

3. **Watch it work** - Real-time SSE stream shows:
   - Planning using knowledge base
   - Implementation using skills
   - Review and commit
   - PR creation

**📖 Complete Documentation**: [AGENT-WORK-ORDERS.md](./AGENT-WORK-ORDERS.md)
- Configuration changes made
- How spawned CLI gets MCP + skills access
- Monitoring and debugging
- Troubleshooting guide
- Example workflows

## Architecture

### System Hierarchy

```
┌────────────────────────────────────────┐
│  Archon MCP (Persistent Tasks)        │  ← PRIMARY
│  http://localhost:8051/mcp             │
└──────────────┬─────────────────────────┘
               │ Task → Superflow Trigger
               ↓
┌──────────────────────────────────────┐
│  Superflows (Pattern Detection)      │
│  • error-handling-patterns           │
│  • spec-kit-orchestrator             │
│  • systematic-debugging              │
│  • refactoring-safety-protocol       │
└──────────────┬───────────────────────┘
               │ Invokes Skills
               ↓
┌──────────────────────────────────────┐
│  Skills (Execution Logic)            │
│  • Query Archon knowledge base       │
│  • Update task status                │
│  • Search claude-mem for history     │
└──────────────┬───────────────────────┘
               │ Execution Details (optional)
               ↓
┌──────────────────────────────────────┐
│  TodoWrite (Session-Only)            │  ← OPTIONAL
│  • Break down current task           │
│  • Track step-by-step progress       │
└──────────────────────────────────────┘
```

### Dual MCP Server Setup

Archon works **alongside** claude-mem (not replacing it):

| MCP Server | Purpose | Port |
|------------|---------|------|
| **archon** | Task management, knowledge base, projects | 8051 |
| **claude-mem** | Observations, sessions, debugging history | (npx) |

**Both servers coexist** - use each for their strengths!

## Core Workflow

### 1. Create Task in Archon

Via UI (http://localhost:3737):
- Go to Projects → Create Project
- Add Task with descriptive title and keywords

Or via MCP:
```bash
archon:manage_task(
    action="create",
    title="Implement error handling for API endpoints",
    description="Add comprehensive error handling with user-friendly messages",
    status="todo",
    task_order=100
)
```

### 2. Claude Code Detects Task

When you start work, Claude Code:
1. Gets active task: `archon:find_tasks(filter_by="status", filter_value="todo")`
2. Updates status: `archon:manage_task(action="update", status="doing")`
3. Analyzes task description for keywords
4. Activates appropriate superflow

### 3. Superflow Executes

Based on task keywords:
- "implement error handling" → **error-handling-patterns** skill
- "build feature" → **spec-kit-orchestrator** → memory-assisted-spec-kit
- "fix bug" → **systematic-debugging** skill
- "refactor" → **refactoring-safety-protocol** skill

### 4. Skill Searches Knowledge

Skill queries Archon knowledge base:

```bash
archon:rag_search_knowledge_base(
    query="API error patterns",  # 2-5 keywords only!
    match_count=5
)
```

Uses results to guide implementation.

### 5. Complete and Update

After implementation:

```bash
archon:manage_task(
    action="update",
    task_id="task-123",
    status="review"  # or "done" after verification
)
```

## Key Files

```
developer-skills-plugin/integrations/archon/
├── README.md              # This file - setup overview
├── WORKFLOW.md            # Detailed workflow documentation ⭐
├── archon-setup.sh        # Automated setup script
├── test-connection.sh     # Connection verification
└── mcp-config.json        # MCP configuration template
```

**Read WORKFLOW.md next!** It contains:
- Complete task-driven development flow
- Task description → superflow mapping
- Knowledge base integration patterns
- Real-world workflow examples
- Troubleshooting guide

## Configuration

### Default Ports

| Service | Port | URL |
|---------|------|-----|
| Archon UI | 3737 | http://localhost:3737 |
| MCP Server | 8051 | http://localhost:8051/mcp |
| API Server | 8181 | http://localhost:8181 |

### Custom Ports

Edit `/mnt/c/Users/Dominik/Documents/archon/.env`:

```bash
ARCHON_UI_PORT=3737
ARCHON_MCP_PORT=8051
ARCHON_SERVER_PORT=8181
```

After changing ports:
```bash
cd /mnt/c/Users/Dominik/Documents/archon
docker compose down
docker compose up -d --build
```

## Available MCP Tools

Once connected, you have access to:

### Knowledge Base
- `archon:rag_search_knowledge_base` - Semantic search
- `archon:rag_search_code_examples` - Find code snippets
- `archon:rag_get_available_sources` - List all sources
- `archon:rag_list_pages_for_source` - Browse docs
- `archon:rag_read_full_page` - Get complete page

### Project Management
- `archon:find_projects` - Search/list projects
- `archon:manage_project` - Create/update/delete

### Task Management
- `archon:find_tasks` - Search/filter tasks
- `archon:manage_task` - Create/update/delete

### Document Management
- `archon:find_documents` - Search documents
- `archon:manage_document` - CRUD operations
- `archon:find_versions` - Version history
- `archon:manage_version` - Create/restore versions

## Common Operations

### Create a Project

```bash
archon:manage_project(
    action="create",
    title="User Authentication System",
    description="Implement JWT-based authentication with refresh tokens"
)
```

### Add Task to Project

```bash
archon:manage_task(
    action="create",
    project_id="proj-abc-123",
    title="Implement JWT token generation",
    description="Create service for generating and validating JWT tokens with configurable expiry",
    task_order=100,
    status="todo"
)
```

### Search Knowledge Base

```bash
# Short queries work best (2-5 keywords)
archon:rag_search_knowledge_base(
    query="JWT authentication",
    match_count=5
)

# Filter by specific source
archon:rag_search_knowledge_base(
    query="error handling",
    source_id="developer-skills-docs",
    match_count=3
)
```

### Get Next Task

```bash
# Find next todo task
archon:find_tasks(
    filter_by="status",
    filter_value="todo"
)

# Find tasks for specific project
archon:find_tasks(
    filter_by="project",
    filter_value="proj-abc-123"
)
```

### Update Task Status

```bash
archon:manage_task(
    action="update",
    task_id="task-xyz-789",
    status="doing"  # todo | doing | review | done
)
```

## Knowledge Base Setup

### 1. Crawl Developer Skills

In Archon UI:
1. Go to Knowledge Base → Crawl Website
2. Enter path: `/mnt/c/Users/Dominik/Documents/Skills/developer-skills-plugin/skills`
3. Wait for processing
4. All 28 skills become searchable

### 2. Upload Project Documentation

- PDFs, Word docs, Markdown files
- Via UI or MCP tools
- Automatically processed and indexed

### 3. Search from Skills

Skills can now query:

```python
# In skill execution
patterns = await archon.rag_search_knowledge_base(
    query="error handling patterns",
    source_id="skills-docs"
)
```

## Best Practices

### ✅ DO

- Use Archon tasks as PRIMARY task system
- Create descriptive task titles with keywords
- Search knowledge base before implementing
- Keep tasks 30 minutes - 4 hours duration
- Update task status in real-time
- Use short queries for RAG (2-5 keywords)
- Only one task "doing" at a time

### ❌ DON'T

- Use TodoWrite as primary system
- Create vague task descriptions
- Skip knowledge base searches
- Make tasks >4 hours (break down instead)
- Batch status updates at end of session
- Use long sentences in RAG queries
- Have multiple tasks "doing" simultaneously

## Troubleshooting

### MCP Server Not Accessible

```bash
# Check if containers are running
docker ps --filter "name=archon-"

# Check logs
cd /mnt/c/Users/Dominik/Documents/archon
docker compose logs -f archon-mcp

# Restart services
docker compose restart
```

### Knowledge Base Returns No Results

1. **Verify content exists:** Check UI → Knowledge Base
2. **Use shorter queries:** "API error" instead of "How to handle API errors?"
3. **Check source ID:** `rag_get_available_sources()` to verify
4. **Database migration:** Ensure `migration/complete_setup.sql` ran successfully

### Superflow Not Activating

1. **Check task description:** Must contain trigger keywords
2. **Verify hooks:** Check `.claude-session` for hook errors
3. **Task status:** Must be "doing" (not "todo")
4. **Test manually:** Try invoking skill directly

### Port Conflicts

```bash
# Check what's using port
lsof -i :8051

# Change port in .env
vim /mnt/c/Users/Dominik/Documents/archon/.env

# Restart with new port
docker compose down && docker compose up -d
```

## Useful Commands

```bash
# View logs
docker compose -f /mnt/c/Users/Dominik/Documents/archon/docker-compose.yml logs -f

# Stop services
docker compose -f /mnt/c/Users/Dominik/Documents/archon/docker-compose.yml down

# Restart services
docker compose -f /mnt/c/Users/Dominik/Documents/archon/docker-compose.yml restart

# Test connection
cd developer-skills-plugin/integrations/archon
./test-connection.sh

# Pull latest Archon updates
cd /mnt/c/Users/Dominik/Documents/archon
git pull origin stable
docker compose up -d --build
```

## Next Steps

1. ✅ Complete setup → `./archon-setup.sh`
2. ✅ Verify connection → `./test-connection.sh`
3. ✅ Read workflow docs → `WORKFLOW.md`
4. ✅ Crawl skills documentation into knowledge base
5. ✅ Create first project and tasks
6. ✅ Test task-triggered superflow
7. ✅ Iterate and improve!

## Resources

### Documentation
- **Workflow Guide:** [WORKFLOW.md](./WORKFLOW.md) ⭐ READ THIS NEXT
- **Archon README:** `/mnt/c/Users/Dominik/Documents/archon/README.md`
- **Archon Contributing:** `/mnt/c/Users/Dominik/Documents/archon/CONTRIBUTING.md`

### Tools
- **Setup Script:** `./archon-setup.sh`
- **Test Script:** `./test-connection.sh`
- **MCP Config:** `mcp-config.json`

### Services
- **Dashboard:** http://localhost:3737
- **MCP Endpoint:** http://localhost:8051/mcp
- **API Server:** http://localhost:8181

### Support
- **Archon GitHub:** https://github.com/coleam00/Archon
- **Archon Discussions:** https://github.com/coleam00/Archon/discussions
- **Developer Skills:** `/mnt/c/Users/Dominik/Documents/Skills`

## License

Archon is licensed under the Archon Community License (ACL) v1.2. See the [LICENSE](https://github.com/coleam00/Archon/blob/main/LICENSE) file in the Archon repository for details.

---

**Ready to get started?** Run `./archon-setup.sh` and then read [WORKFLOW.md](./WORKFLOW.md) for detailed integration patterns!
