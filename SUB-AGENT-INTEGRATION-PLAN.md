# Sub-Agent Integration Plan for Developer Skills Plugin

**Date**: November 2, 2025
**Status**: Analysis Complete, Ready for Implementation
**Expected Impact**: 5-10x faster verification, 67% context reduction, 3x faster debugging

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Current Architecture](#current-architecture)
3. [Sub-Agent Opportunities](#sub-agent-opportunities)
4. [Agent Definitions (Ready to Deploy)](#agent-definitions-ready-to-deploy)
5. [Implementation Roadmap](#implementation-roadmap)
6. [Cost/Benefit Analysis](#costbenefit-analysis)
7. [Integration with Existing Superflows](#integration-with-existing-superflows)
8. [Critical Success Factors](#critical-success-factors)
9. [Next Steps](#next-steps)

---

## Executive Summary

### What Are Sub-Agents?

Sub-agents are specialized AI assistants that can be delegated specific tasks. Each operates with:
- **Isolated context window** (doesn't pollute main conversation)
- **Custom system prompt** (focused on single purpose)
- **Configurable tool access** (only what's needed)
- **Parallel execution capability** (multiple agents run simultaneously)

### Key Benefits for Our System

| Benefit | Current | With Sub-Agents | Improvement |
|---------|---------|-----------------|-------------|
| **Verification Time** | 5-10 min | 30-60 sec | **5-10x faster** |
| **Context Usage** | 15,000 tokens | 5,000 tokens | **67% reduction** |
| **Debugging Time** | 10-15 min | 3-5 min | **3x faster** |
| **Code Exploration** | Pollutes context | Clean context | **Unmeasurable UX win** |
| **Parallel Operations** | 0 | 5-10 | **New capability** |

### Recommended Implementation

**Phase 1 (Week 1)**: Implement 3 Tier-1 agents
- `verification-checker` - Parallel /ship-check validation
- `codebase-explorer` - Clean codebase exploration
- `changelog-generator-agent` - Isolated git analysis

**Phase 2 (Week 2-3)**: Add 3 layer analyzers
- Database, API, Frontend layer specialists

**Phase 3 (Week 4+)**: Advanced workflows
- Style extraction, QA validation, diagnostic gathering

---

## Current Architecture

### Superflow System

Our current system uses:
- **14+ workflows**: Refactoring, Debugging, Feature Dev, UI Dev, API Design, Verification, etc.
- **Single hook script**: `analyze-prompt.sh` detects patterns and injects context
- **Skill invocation**: Via `Skill(command: 'skill-name')` tool
- **Sequential execution**: All workflows run in main conversation context

### Skills Structure

- **24 comprehensive skills** with multi-phase workflows
- **Complex processes**:
  - spec-kit (8 phases)
  - systematic-debugging (4 phases)
  - pixel-perfect-site-copy (4 phases)
  - full-stack-integration-checker (4 layers)

### Current Limitations

1. **Sequential verification**: /ship-check runs 5 checks one after another (5-10 minutes)
2. **Context pollution**: Code exploration fills main context with search results
3. **No parallelization**: Can't run independent tasks simultaneously
4. **Token waste**: Git log analysis consumes 20-50k tokens in main context

---

## Sub-Agent Opportunities

### Tier 1: Immediate High-Value (Implement First)

#### 1. Parallel Verification Sub-Agents

**Problem**: /ship-check command runs sequential checks

**Current Workflow**:
```bash
# Sequential execution (slow)
1. Run tests → wait (2 min)
2. Check integration → wait (2 min)
3. Scan for mock data → wait (1 min)
4. Verify logging standards → wait (1 min)
5. Check security patterns → wait (1 min)
Total: 7-10 minutes
```

**With Sub-Agents**:
```typescript
// Launch 5 agents in parallel
const results = await Promise.all([
  Task({ description: "Run test suite", model: "haiku" }),
  Task({ description: "Check full-stack integration", model: "haiku" }),
  Task({ description: "Scan for mock data", model: "haiku" }),
  Task({ description: "Verify logging standards", model: "haiku" }),
  Task({ description: "Run security scan", model: "haiku" })
])

// All complete in ~same time as slowest check (~2 min)
```

**Impact**:
- **Time Saved**: 7-10 min → 2 min (5x faster)
- **Context Saved**: 10,000 tokens (5 agents × 1,000 each vs. 15,000 sequential)
- **User Experience**: Instant multi-check feedback
- **Complexity**: Low

---

#### 2. Code Exploration Sub-Agent

**Problem**: Exploring codebase pollutes main context

**Current Approach**:
```
Main conversation:
1. Grep for patterns → 2,000 tokens of results
2. Read files → 5,000 tokens
3. Search for related code → 3,000 tokens
4. Analyze relationships → 5,000 tokens
Total: 15,000+ tokens in main context
```

**With Exploration Sub-Agent**:
```typescript
// Delegate exploration to sub-agent
const findings = await Task({
  subagent_type: "Explore",
  description: "Find all authentication patterns",
  prompt: `Search for auth middleware, JWT handling, session management.
  Return summary with file locations and key patterns.`
})

// Agent explores in isolation, returns only 500-token summary
// Main context stays clean
```

**Impact**:
- **Context Saved**: 10,000-20,000 tokens
- **Main Conversation**: Only receives clean summary
- **Use Cases**: "Where is auth?", "How does payment work?", "Find all API endpoints"
- **Complexity**: Low

---

#### 3. Changelog Generator Agent

**Problem**: Git history analysis fills main context

**Current Workflow**:
```
Main context:
1. Run git log → 500-1000 lines (10,000 tokens)
2. Analyze each commit → context grows (20,000 tokens)
3. Identify changes → more context (30,000 tokens)
4. Generate changelog → massive context (40,000+ tokens)
```

**With Sub-Agent**:
```typescript
Task({
  description: "Generate technical changelog",
  prompt: `Analyze git commits from ${startDate} to ${endDate}.

  Focus on:
  - Schema changes (migrations, model updates)
  - Logic changes (algorithm differences)
  - Breaking changes (API contract changes)

  Return technical changelog with commit hashes.`,
  model: "haiku"
})

// Returns only final changelog (~2,000 tokens)
```

**Impact**:
- **Context Saved**: 20,000-40,000 tokens
- **Speed**: Faster with haiku model
- **Main Context**: Receives only clean changelog
- **Complexity**: Low

---

### Tier 2: Medium-Value (Implement After Tier 1)

#### 4. Full-Stack Integration Checker (Parallel Layer Analysis)

**Problem**: Checking database → API → frontend sequentially takes time

**Current Workflow**:
```
1. Check database schema → read migrations (2 min)
2. Check backend API → grep routes (2 min)
3. Check frontend → search components (2 min)
4. Verify integration → manual tracing (2 min)
Total: 8-10 minutes
```

**With Sub-Agents**:
```typescript
// Launch 3 layer-specific agents in parallel
const [dbResults, apiResults, frontendResults] = await Promise.all([
  Task({
    description: "Database layer analysis for 'favorites' feature",
    prompt: "Analyze schema. Report: fields, constraints, relations, migrations"
  }),
  Task({
    description: "API layer analysis for 'favorites' feature",
    prompt: "Analyze API. Report: CRUD endpoints, auth, error handling"
  }),
  Task({
    description: "Frontend layer analysis for 'favorites' feature",
    prompt: "Analyze frontend. Report: components, API calls, state, UI"
  })
])

// Then verify integration in main context (1 min)
```

**Impact**:
- **Time Saved**: 8-10 min → 3-4 min (3x faster)
- **Accuracy**: Each agent focused on single layer
- **Main Context**: Only receives integration summary
- **Complexity**: Medium (3 agents + integration logic)

---

#### 5. Systematic Debugging (Multi-Component Evidence Gathering)

**Problem**: Gathering diagnostic logs across layers is sequential

**Current Approach**:
```
1. Add logging to component A → run → analyze (3 min)
2. Add logging to component B → run → analyze (3 min)
3. Add logging to component C → run → analyze (3 min)
4. Correlate all evidence in main context (2 min)
Total: 11 minutes
```

**With Sub-Agents**:
```typescript
// Launch parallel diagnostic agents
const diagnostics = await Promise.all([
  Task({
    description: "Workflow layer diagnostics",
    prompt: "Add logging to GitHub Actions. Run and capture output."
  }),
  Task({
    description: "Build script diagnostics",
    prompt: "Add logging to build.sh. Run and capture output."
  }),
  Task({
    description: "Signing layer diagnostics",
    prompt: "Add logging to codesign. Run and capture output."
  })
])

// Main context analyzes combined evidence (2 min)
```

**Impact**:
- **Time Saved**: 11 min → 4 min (3x faster)
- **Debugging Accuracy**: Parallel evidence reveals layer interactions
- **Context**: Aggregated evidence only
- **Complexity**: Medium

---

### Tier 3: Advanced (Implement When Tier 1-2 Proven)

#### 6. Pixel-Perfect Site Copy (Multi-Stage Pipeline)

**Problem**: 4 sequential phases take 40-65 minutes

**Current Workflow**:
```
Phase 1: Site Inspection (5-10 min)
  ↓
Phase 2: Style Guide Generation (10-15 min)
  ↓
Phase 3: Implementation (20-30 min)
  ↓
Phase 4: QA Validation (5-10 min)

Total: 40-65 minutes, all in main context
```

**With Sub-Agents**:
```typescript
// Phase 1: Extraction sub-agent
const styleData = await Task({
  description: "Extract all styles from site",
  prompt: "Connect to [URL] via Chrome DevTools MCP. Extract typography, colors, spacing.",
  model: "sonnet"
})

// Phase 2: Parallel style guide + screenshot organization
const [styleGuide, screenshots] = await Promise.all([
  Task({
    description: "Generate style guide from extracted data",
    model: "haiku"
  }),
  Task({
    description: "Organize screenshots and capture at breakpoints",
    model: "haiku"
  })
])

// Phase 3: Implementation (main context - 20-30 min)

// Phase 4: QA sub-agent
const qaReport = await Task({
  description: "Validate pixel-perfect quality",
  prompt: "Compare replica to screenshots. Report deviations."
})
```

**Impact**:
- **Time Saved**: 40-65 min → 25-35 min (40% faster)
- **Context Saved**: 30,000+ tokens (extraction + QA in sub-agents)
- **Main Context**: Focused on implementation only
- **Complexity**: High (requires MCP integration)

---

## Agent Definitions (Ready to Deploy)

### 1. verification-checker.md

**Location**: `developer-skills-plugin/agents/verification-checker.md`

```markdown
---
name: verification-checker
description: MUST BE USED when /ship-check runs or user claims work complete - runs comprehensive verification checks in parallel. Each invocation should specify which check to run (tests, integration, mock-data, logging, security).
tools: Bash, Read, Grep, Glob
model: haiku
---

# Verification Checker Agent

You are a specialized verification agent. Run ONE specific check and exit immediately with results.

## Your Task

Based on the check type provided in the prompt, run the appropriate verification:

### Check Type: tests
```bash
# Run test suite
npm test || pytest || cargo test || go test ./...
```
Report: Test results with pass/fail counts

### Check Type: integration
1. Search for schema files (Prisma, SQL migrations)
2. Search for API routes
3. Search for frontend API calls
4. Report gaps (unused schema fields, missing endpoints, etc.)

### Check Type: mock-data
```bash
grep -r "MOCK\|TODO.*data\|FAKE\|DUMMY\|test@example\.com\|hardcoded.*user" src/ --exclude-dir=node_modules
```
Report: Locations of mock/test data

### Check Type: logging
```bash
grep -r "console\.log\|print\(" src/ --exclude-dir=node_modules | grep -v "logger\."
```
Report: Non-standard logging instances

### Check Type: security
```bash
grep -r "req\.body\.userId\|eval\(\|innerHTML\|dangerouslySetInnerHTML" src/ --exclude-dir=node_modules
```
Report: Potential security issues

## Output Format

```
═══════════════════════════════════════
VERIFICATION CHECK: [check-type]
═══════════════════════════════════════

STATUS: ✅ PASS / ⚠️ WARNING / ❌ FAIL

EVIDENCE:
[command output or specific findings]

ISSUES FOUND:
[specific problems with file:line references, or "None"]

RECOMMENDATION:
[what to fix, if anything]
═══════════════════════════════════════
```

**Exit immediately after reporting. Do not wait for further instructions.**
```

---

### 2. codebase-explorer.md

**Location**: `developer-skills-plugin/agents/codebase-explorer.md`

```markdown
---
name: codebase-explorer
description: PROACTIVELY use when user asks questions like "where is X", "how does Y work", "find all Z" - explores codebase systematically and returns concise summaries without polluting main conversation context
tools: Glob, Grep, Read
model: sonnet
---

# Codebase Explorer Agent

You are a codebase exploration specialist. Your goal: Find information quickly and summarize concisely.

## Your Process

1. **Understand the query**: What pattern or concept are you searching for?

2. **Search systematically**:
   ```bash
   # Find files by pattern
   Glob(pattern: "**/*auth*.{ts,js,py}")

   # Search for code patterns
   Grep(pattern: "middleware.*auth", output_mode: "files_with_matches")

   # Read key files (max 3-5 files to avoid context explosion)
   Read(file_path: "src/middleware/auth.ts")
   ```

3. **Summarize findings**: Focus on file locations, key patterns, and how it works

## Output Format

```markdown
## 🔍 Exploration: [what you searched for]

### 📍 Locations Found

| File | Line | Description |
|------|------|-------------|
| middleware/auth.ts | 42 | Main auth middleware definition |
| routes/api.ts | 18 | Auth middleware usage |
| types/auth.ts | 5 | Auth type definitions |

### 🎯 Key Patterns

**Pattern 1: Middleware Composition**
\`\`\`typescript
router.use(auth.requireUser) // Always authenticate first
router.post('/api/comments', validate.comment, createComment)
\`\`\`

**Pattern 2: Token Extraction**
\`\`\`typescript
const token = req.headers.authorization?.split(' ')[1]
const user = jwt.verify(token, SECRET)
\`\`\`

### 📚 Summary

Authentication is handled through middleware in `middleware/auth.ts`. The `requireUser` middleware:
- Extracts JWT from Authorization header
- Verifies token and attaches user to `req.user`
- Returns 401 if missing/invalid

All protected routes use this middleware before their handlers.

### 🔗 Related Files
- middleware/auth.ts - Main implementation
- types/auth.ts - TypeScript types
- routes/api.ts - Usage examples
```

**DO NOT:**
- Include entire file contents
- Explain every line of code
- Make recommendations (just report what exists)
- Continue exploring after summary

**Exit immediately after providing summary.**
```

---

### 3. changelog-generator-agent.md

**Location**: `developer-skills-plugin/agents/changelog-generator-agent.md`

```markdown
---
name: changelog-generator-agent
description: Analyzes git commit history and generates technical changelog with schema changes, logic differences, and breaking changes - used for debugging and understanding recent changes
tools: Bash, Read, Grep
model: haiku
---

# Changelog Generator Agent

Generate technical changelog from git history for debugging purposes.

## Your Task

Given a date range or commit range, analyze commits and categorize changes:

```bash
# Get commits in range
git log --oneline --since="7 days ago" --until="now"

# For each relevant commit, analyze
git show <hash> --stat
git show <hash> -- '*.prisma' '*.sql'  # Schema changes
git show <hash> -- 'src/**/*.ts'        # Logic changes
git show <hash> -- 'package.json'       # Dependencies
```

## Categories to Track

1. **Schema Changes**: Migrations, model changes, database structure
2. **Logic Changes**: Algorithm modifications, business logic updates
3. **API Changes**: Endpoint modifications, contract changes
4. **Breaking Changes**: Incompatible updates
5. **Dependency Updates**: Package version changes

## Output Format

```markdown
# Technical Changelog
**Period**: [date range]
**Commits Analyzed**: [count]

## 🗄️ Schema Changes

### [Commit hash] - [Date]
**File**: schema.prisma
**Change**: Added `favorites` table with userId and productId
**Impact**: ⚠️ Requires migration

\`\`\`sql
model Favorite {
  id        String   @id @default(cuid())
  userId    String
  productId String
  @@unique([userId, productId])
}
\`\`\`

## 🔧 Logic Changes

### [Commit hash] - [Date]
**File**: src/auth/middleware.ts:42
**Old Behavior**: Allowed unauthenticated requests
**New Behavior**: Returns 401 for missing auth
**Impact**: ⚠️ BREAKING - All API calls now require authentication

## 🔌 API Changes

### [Commit hash] - [Date]
**Endpoint**: POST /api/favorites
**Change**: Added new endpoint
**Contract**:
\`\`\`typescript
Request: { productId: string }
Response: { id: string, productId: string, createdAt: Date }
\`\`\`

## 📦 Dependencies

### [Commit hash] - [Date]
**Package**: next 13.4.0 → 14.0.0
**Impact**: ⚠️ Potential breaking changes in App Router

## ⚠️ Breaking Changes Summary

1. Auth middleware now required (commit abc123)
2. Next.js major version update (commit def456)

## 📊 Statistics

- Total commits: 15
- Schema changes: 3
- Logic changes: 8
- API changes: 2
- Breaking changes: 2
```

**Exit immediately after generating changelog.**
```

---

### 4. layer-analyzer-db.md

**Location**: `developer-skills-plugin/agents/layer-analyzer-db.md`

```markdown
---
name: layer-analyzer-db
description: Analyzes database layer for a specific feature - checks schema, migrations, constraints, and relations
tools: Read, Grep, Bash
model: haiku
---

# Database Layer Analyzer

Analyze database schema and migrations for a specific feature.

## Your Task

Given a feature name (e.g., "favorites", "user-profiles"), analyze the database layer:

1. **Find schema definition**:
   - Prisma schema: `grep -r "model.*Favorite" schema.prisma`
   - SQL migrations: `find . -name "*favorites*.sql"`

2. **Check migrations applied**:
   ```bash
   npx prisma migrate status
   # OR check migrations table in database
   ```

3. **Analyze schema quality**:
   - Required fields marked correctly?
   - Unique constraints where needed?
   - Foreign key relations defined?
   - Indexes for performance?
   - Cascading deletes configured?

## Output Format

```markdown
## 🗄️ Database Layer Analysis: [feature-name]

### Schema Definition
**File**: schema.prisma:42
**Model**: [ModelName]

\`\`\`prisma
model Favorite {
  id        String   @id @default(cuid())
  userId    String
  productId String
  user      User     @relation(fields: [userId], references: [id])
  product   Product  @relation(fields: [productId], references: [id])
  @@unique([userId, productId])
}
\`\`\`

### Migration Status
- ✅ Migration applied: `20231101_add_favorites.sql`
- ⚠️ Pending migration: None

### Schema Quality Checks
- ✅ Required fields: id, userId, productId
- ✅ Unique constraint: [userId, productId]
- ✅ Foreign keys: user, product
- ⚠️ Missing index: Consider index on userId for faster lookups
- ✅ Cascading delete: Not needed (keep favorites on user delete)

### Issues Found
[List specific issues or "None"]

### Recommendations
[Suggestions for improvement or "Schema looks good"]
```

**Exit after analysis.**
```

---

### 5. layer-analyzer-api.md

**Location**: `developer-skills-plugin/agents/layer-analyzer-api.md`

```markdown
---
name: layer-analyzer-api
description: Analyzes backend API layer for a specific feature - checks CRUD endpoints, authentication, error handling, and data relationships
tools: Grep, Read
model: haiku
---

# API Layer Analyzer

Analyze backend API endpoints for a specific feature.

## Your Task

Given a feature name, analyze the API layer:

1. **Find API endpoints**:
   ```bash
   grep -r "POST.*favorites\|GET.*favorites\|PUT.*favorites\|DELETE.*favorites" src/routes/
   ```

2. **Check CRUD completeness**:
   - Create (POST)
   - Read (GET list + GET detail)
   - Update (PUT/PATCH)
   - Delete (DELETE)

3. **Verify security**:
   - Authentication middleware?
   - Authorization checks (user owns resource)?
   - Input validation?
   - No client-provided userIds?

4. **Check error handling**:
   - try-catch blocks?
   - Proper status codes (400, 404, 409, 500)?
   - Related data included?

## Output Format

```markdown
## 🔌 API Layer Analysis: [feature-name]

### Endpoints Found

| Method | Endpoint | File | Line |
|--------|----------|------|------|
| POST | /api/favorites | routes/favorites.ts | 12 |
| GET | /api/favorites | routes/favorites.ts | 34 |
| DELETE | /api/favorites/:id | routes/favorites.ts | 56 |

### CRUD Completeness
- ✅ Create (POST)
- ✅ Read List (GET /api/favorites)
- ⚠️ Read Detail (GET /api/favorites/:id) - MISSING
- ⚠️ Update (PUT/PATCH) - MISSING
- ✅ Delete (DELETE)

### Security Checks

**Authentication**: routes/favorites.ts:10
\`\`\`typescript
router.use(auth.requireUser) // ✅ Auth middleware present
\`\`\`

**Authorization**: routes/favorites.ts:60
\`\`\`typescript
// ⚠️ No ownership check before delete
// Should verify: favorite.userId === req.user.id
\`\`\`

**Client-provided userId**: routes/favorites.ts:15
\`\`\`typescript
const userId = req.user.id // ✅ Using authenticated user
\`\`\`

### Error Handling

- ✅ Try-catch blocks present
- ✅ 404 for not found
- ✅ 400 for bad input
- ⚠️ No 409 for duplicate favorites
- ✅ 500 for server errors

### Data Relationships

\`\`\`typescript
// routes/favorites.ts:35
const favorites = await db.favorite.findMany({
  where: { userId },
  include: { product: true } // ✅ Related data included
})
\`\`\`

### Issues Found
1. ⚠️ Missing GET /api/favorites/:id endpoint
2. ⚠️ Missing UPDATE functionality
3. ⚠️ No authorization check on DELETE
4. ⚠️ No duplicate favorite handling (409 status)

### Recommendations
1. Add detail endpoint: GET /api/favorites/:id
2. Add authorization check before delete
3. Handle duplicate favorites with 409 status
```

**Exit after analysis.**
```

---

### 6. layer-analyzer-frontend.md

**Location**: `developer-skills-plugin/agents/layer-analyzer-frontend.md`

```markdown
---
name: layer-analyzer-frontend
description: Analyzes frontend layer for a specific feature - checks components, API calls, state management, and UI completeness
tools: Grep, Read
model: haiku
---

# Frontend Layer Analyzer

Analyze frontend implementation for a specific feature.

## Your Task

Given a feature name, analyze the frontend layer:

1. **Find components**:
   ```bash
   grep -r "favorite\|Favorite" src/components/ src/pages/ --include="*.tsx" --include="*.jsx"
   ```

2. **Check API integration**:
   - All backend endpoints called?
   - Proper HTTP methods?
   - Error handling?
   - Loading states?

3. **Verify state management**:
   - State updates after mutations?
   - Optimistic updates?
   - Error rollback?

4. **Check UI completeness**:
   - Can user create?
   - Can user view list?
   - Can user delete?
   - Empty states?
   - Error states?
   - Loading states?

## Output Format

```markdown
## 🎨 Frontend Layer Analysis: [feature-name]

### Components Found

| Component | File | Line | Purpose |
|-----------|------|------|---------|
| FavoriteButton | components/FavoriteButton.tsx | 1 | Toggle favorite |
| FavoritesList | components/FavoritesList.tsx | 1 | Display user's favorites |

### API Integration

**POST /api/favorites**: components/FavoriteButton.tsx:24
\`\`\`typescript
const handleFavorite = async () => {
  await fetch('/api/favorites', {
    method: 'POST',
    body: JSON.stringify({ productId })
  })
}
\`\`\`
- ✅ Calls POST endpoint
- ⚠️ No error handling
- ⚠️ No loading state

**GET /api/favorites**: components/FavoritesList.tsx:12
\`\`\`typescript
const { data, error, isLoading } = useSWR('/api/favorites')
\`\`\`
- ✅ Calls GET endpoint
- ✅ Has loading state
- ✅ Has error handling

**DELETE /api/favorites/:id**: components/FavoriteButton.tsx:34
\`\`\`typescript
// ⚠️ DELETE endpoint not called
// Missing unfavorite functionality
\`\`\`

### State Management

- ⚠️ No state update after POST (doesn't refetch list)
- ⚠️ No optimistic update
- ⚠️ No error rollback

### UI Completeness

| Action | Status | Notes |
|--------|--------|-------|
| Create | ✅ | FavoriteButton component |
| View List | ✅ | FavoritesList component |
| Delete | ❌ | Missing unfavorite UI |
| Empty State | ⚠️ | Shows "Loading..." but no "No favorites yet" |
| Error State | ⚠️ | FavoriteButton has none |
| Loading State | ⚠️ | FavoriteButton has none |

### Issues Found
1. ❌ Missing unfavorite functionality (no DELETE call)
2. ⚠️ No error handling in FavoriteButton
3. ⚠️ No loading state in FavoriteButton
4. ⚠️ State doesn't update after favorite added
5. ⚠️ No empty state in FavoritesList

### Recommendations
1. Add unfavorite button/functionality
2. Add error handling to FavoriteButton
3. Add loading state (disable button while processing)
4. Refetch favorites list after add/remove
5. Add empty state: "No favorites yet. Click ❤️ to save items!"
```

**Exit after analysis.**
```

---

## Implementation Roadmap

### Week 1: Foundation (Tier 1 Agents)

**Days 1-2: Create Agent Definitions**
```bash
# Create agents directory
mkdir -p developer-skills-plugin/agents

# Copy agent definitions
# - verification-checker.md
# - codebase-explorer.md
# - changelog-generator-agent.md
```

**Days 3-4: Update Commands & Skills**
- Update `commands/ship-check.md` to use parallel verification
- Update `skills/verification-before-completion/SKILL.md` to suggest agents
- Update `skills/systematic-debugging/SKILL.md` to suggest changelog agent
- Test with real `/ship-check` execution

**Day 5: Documentation & Testing**
- Document agent usage patterns
- Create examples in SKILL.md files
- Test all 3 agents with real scenarios
- Measure performance improvements

**Deliverables**:
- ✅ 3 working agents
- ✅ 5-10x faster verification
- ✅ Clean context management
- ✅ Documentation complete

---

### Week 2-3: Layer Analysis (Tier 2 Agents)

**Week 2: Create Layer Analyzers**
```bash
# Create layer-specific agents
# - layer-analyzer-db.md
# - layer-analyzer-api.md
# - layer-analyzer-frontend.md
```

**Week 3: Integration**
- Update `skills/full-stack-integration-checker/SKILL.md`
- Update `skills/systematic-debugging/SKILL.md`
- Update `commands/check-integration.md`
- Test parallel layer analysis

**Deliverables**:
- ✅ 3 layer-specific agents
- ✅ 3x faster integration checking
- ✅ Better debugging workflows

---

### Week 4+: Advanced Workflows (Tier 3 Agents)

**Week 4: Specialized Agents**
```bash
# Create advanced agents
# - style-extractor.md (Chrome DevTools MCP)
# - qa-validator.md (visual comparison)
# - diagnostic-gatherer.md (multi-component debugging)
```

**Week 5+: Complex Integrations**
- Update `skills/pixel-perfect-site-copy/SKILL.md`
- Update `skills/systematic-debugging/SKILL.md`
- Performance testing & optimization
- Measure ROI across all agents

**Deliverables**:
- ✅ Advanced workflow automation
- ✅ 40% faster complex tasks
- ✅ Complete agent ecosystem

---

## Cost/Benefit Analysis

### Token Economics

**Scenario: /ship-check with 5 verification tasks**

**Current (Sequential)**:
- Main conversation: 15,000 tokens (running all checks)
- Time: 5-10 minutes
- User waits for each check sequentially

**With Sub-Agents (Parallel)**:
- Main conversation: 2,000 tokens (launching agents + aggregating results)
- 5 sub-agents: 1,000 tokens each = 5,000 tokens
- **Total: 7,000 tokens (53% reduction)**
- **Time: 30-60 seconds** (fastest check determines total time)

### Cost per Check (Approximate)

- **Sonnet**: $3 per 1M input tokens
- **Haiku**: $0.25 per 1M input tokens
- **Using haiku for verification**: 5,000 tokens × $0.25/1M = **$0.00125** (negligible)

### Overall Impact

| Metric | Current | With Sub-Agents | Improvement |
|--------|---------|-----------------|-------------|
| **Verification Time** | 5-10 min | 30-60 sec | **5-10x faster** |
| **Context Usage** | 15,000 tokens | 5,000 tokens | **67% reduction** |
| **User Wait Time** | Sequential (cumulative) | Parallel (max) | **Massive UX win** |
| **Cost per /ship-check** | $0.045 | $0.021 | **53% cheaper** |
| **Debugging Time** | 10-15 min | 3-5 min | **3x faster** |
| **Code Exploration** | Pollutes context | Clean context | **Unmeasurable** |

### ROI by Agent

| Agent | Implementation Time | Time Saved per Use | Break-even Uses |
|-------|---------------------|-------------------|-----------------|
| **verification-checker** | 2 hours | 5 min | 24 uses |
| **codebase-explorer** | 1 hour | 3 min | 20 uses |
| **changelog-generator** | 1 hour | 10 min | 6 uses |
| **layer-analyzer (3x)** | 4 hours | 5 min | 48 uses |

**Assumption**: Each agent used 2-5 times per week → break-even in 1-2 months

---

## Integration with Existing Superflows

### Update ship-check Command

**File**: `developer-skills-plugin/commands/ship-check.md`

**Add this section**:

```markdown
## Parallel Verification (NEW)

**Before claiming work is complete, run comprehensive verification in parallel:**

\`\`\`typescript
// Launch 5 verification agents simultaneously
const verificationResults = await Promise.all([
  Task({
    description: "Test suite verification",
    prompt: "verification-checker agent: Run type 'tests'. Execute test suite and report pass/fail with evidence.",
    model: "haiku"
  }),
  Task({
    description: "Integration verification",
    prompt: "verification-checker agent: Run type 'integration'. Check database → API → frontend gaps.",
    model: "haiku"
  }),
  Task({
    description: "Mock data scan",
    prompt: "verification-checker agent: Run type 'mock-data'. Scan for hardcoded test data.",
    model: "haiku"
  }),
  Task({
    description: "Logging standards check",
    prompt: "verification-checker agent: Run type 'logging'. Verify standardized logging.",
    model: "haiku"
  }),
  Task({
    description: "Security scan",
    prompt: "verification-checker agent: Run type 'security'. Check for common vulnerabilities.",
    model: "haiku"
  })
])

// Aggregate results
const allPassed = verificationResults.every(r => r.status === 'PASS')
if (!allPassed) {
  // Report specific failures
  // DO NOT mark work as complete
}
\`\`\`

**Time savings**: 5-10 minutes → 30-60 seconds (5-10x faster)
```

---

### Update Debugging Superflow

**File**: `developer-skills-plugin/hooks/scripts/analyze-prompt.sh`

**Modify the bug detection section** (around line 238):

```bash
# Check for bugs/errors (Suggest quick-fix + agents)
if echo "$USER_PROMPT" | grep -qiE "$BUG_PATTERN"; then
    write_active_superflow "🐛 Debugging"
    add_header

    CONTEXT="${CONTEXT}## 🐛 Debugging Superflow Activated

**IMMEDIATE ACTION #1 - LAUNCH EXPLORATION AGENT:**
Before investigating manually, use codebase-explorer agent to find relevant code:
\`\`\`
Task({
  description: 'Explore error-related code',
  prompt: 'codebase-explorer: Find all error handling patterns related to [specific error]. Return file locations and key patterns.',
  model: 'sonnet'
})
\`\`\`

**IMMEDIATE ACTION #2 - GENERATE CHANGELOG IF RECENT BUG:**
If bug appeared recently, use changelog agent:
\`\`\`
Task({
  description: 'Generate recent changelog',
  prompt: 'changelog-generator-agent: Analyze commits from last 7 days. Focus on schema and logic changes.',
  model: 'haiku'
})
\`\`\`

**IMMEDIATE ACTION #3 - INVOKE DEBUGGING SKILL:**
\`\`\`
Skill(command: 'memory-assisted-debugging')
\`\`\`

This keeps main context clean while gathering comprehensive information.
"
fi
```

---

### Update Full-Stack Integration Checker

**File**: `developer-skills-plugin/skills/full-stack-integration-checker/SKILL.md`

**Add this section after "When to Use"**:

```markdown
## Parallel Layer Analysis (NEW)

**For faster integration checking, use layer-specific sub-agents:**

\`\`\`typescript
// Launch 3 layer analyzers in parallel
const [dbAnalysis, apiAnalysis, frontendAnalysis] = await Promise.all([
  Task({
    description: "Database layer analysis",
    prompt: "layer-analyzer-db: Analyze database schema for 'favorites' feature. Report fields, constraints, relations, migration status.",
    model: "haiku"
  }),
  Task({
    description: "API layer analysis",
    prompt: "layer-analyzer-api: Analyze API endpoints for 'favorites' feature. Report CRUD completeness, auth, error handling.",
    model: "haiku"
  }),
  Task({
    description: "Frontend layer analysis",
    prompt: "layer-analyzer-frontend: Analyze frontend components for 'favorites' feature. Report API integration, state management, UI completeness.",
    model: "haiku"
  })
])

// In main context: Verify integration between layers
// - Does API expose all schema fields?
// - Does frontend call all API endpoints?
// - Are there unused endpoints or schema fields?
\`\`\`

**Time savings**: 8-10 minutes → 3-4 minutes (3x faster)

**When to use parallel analysis**:
- ✅ Complex features with database + API + frontend
- ✅ When you need systematic layer-by-layer verification
- ✅ Before claiming feature is complete

**When to use manual checklist**:
- Small features (single-layer changes)
- When agents aren't available
- When you need to learn the codebase (don't delegate exploration)
```

---

## Critical Success Factors

### 1. Agent Scope Discipline

**DO:**
- ✅ **Single-purpose agents**: One job, one output format
- ✅ **Clear exit criteria**: Return results immediately, no follow-up
- ✅ **Limit tool access**: Only what's needed for the task
- ✅ **Use haiku for simple tasks**: Cost + speed optimization
- ✅ **Explicit instructions**: Tell agent exactly what to do

**DON'T:**
- ❌ **General-purpose agents**: "Do whatever the user needs" (confusing)
- ❌ **Interactive agents**: Can't respond after task complete
- ❌ **Nested agents**: Forbidden by Claude Code (agents can't spawn agents)
- ❌ **Give all tools**: Limits context, slows execution

---

### 2. Context Management Strategy

**Correct Pattern**:
```
Main conversation
   ↓ (launches agent with specific task)
Sub-agent in isolation
   ↓ (explores, analyzes, generates)
   ↓ (context discarded after summary)
Main conversation receives summary (500-2000 tokens)
   ↓ (continues with clean context)
```

**Anti-pattern** (avoid):
```
Main conversation
   ↓ (searches codebase directly)
   ↓ (context fills with search results: 10,000 tokens)
   ↓ (reads files: 15,000 tokens)
   ↓ (context nearly full: 30,000 tokens)
   ❌ (can't continue, must summarize or lose info)
```

---

### 3. Parallelization Strategy

**When to Parallelize** (✅):
- Independent verification tasks (tests, integration, security)
- Multi-layer analysis (DB, API, Frontend can be checked simultaneously)
- Separate diagnostic checks (different components/layers)
- Data gathering tasks (git history, file searches)

**When NOT to Parallelize** (❌):
- Sequential dependencies (need result A before starting B)
- Single file edits (no benefit from parallelization)
- Trivial tasks (overhead > benefit)
- Interactive workflows (user input needed between steps)

**Example - Good Parallelization**:
```typescript
// These 5 checks are independent
const [tests, integration, mockData, logging, security] = await Promise.all([...])
```

**Example - Bad Parallelization**:
```typescript
// These have dependencies (need schema before checking API integration)
const [schema, api] = await Promise.all([
  analyzeSchema(),  // ❌ BAD: API analysis needs schema results
  analyzeAPI()
])

// Correct sequential approach:
const schema = await analyzeSchema()
const api = await analyzeAPI(schema)  // ✅ GOOD: Uses schema results
```

---

### 4. Model Selection

| Agent Type | Recommended Model | Reasoning |
|------------|-------------------|-----------|
| **Verification** | haiku | Fast, cheap, simple task |
| **Code Exploration** | sonnet | Needs understanding of code patterns |
| **Changelog Generation** | haiku | Pattern matching, no complex reasoning |
| **Layer Analysis** | haiku | Checklist-based, straightforward |
| **Style Extraction** | sonnet | Complex visual analysis |
| **QA Validation** | haiku | Comparison task, simple logic |

**Rule of thumb**:
- **Haiku**: Checklist-based tasks, pattern matching, simple verification
- **Sonnet**: Code understanding, complex analysis, multi-step reasoning
- **Opus**: Only if task requires deep reasoning (rare for agents)

---

### 5. Error Handling

**Agents should handle failures gracefully**:

```markdown
## Error Handling (Add to all agents)

If a command fails:

1. **Capture the error**: Include error message in output
2. **Explain what failed**: "Test suite failed to run: npm not found"
3. **Suggest fix**: "Install dependencies with 'npm install' first"
4. **Exit with partial results**: Don't hang waiting for user

**Example**:
\`\`\`
STATUS: ❌ FAIL

EVIDENCE:
Error: Command 'npm test' failed with exit code 1
npm ERR! missing script: test

ISSUES FOUND:
No test script defined in package.json

RECOMMENDATION:
Add test script to package.json:
"scripts": { "test": "jest" }
\`\`\`
```

---

## Next Steps

### Option A: Implement All Tier 1 Agents Now (Recommended)

**What you get**:
- 3 working agents (verification, exploration, changelog)
- 5-10x faster verification
- Clean context management
- Foundation for Tier 2 agents

**Time required**: 4-6 hours
**ROI**: Immediate (payback after 20-30 uses)

**Action items**:
1. Create `developer-skills-plugin/agents/` directory
2. Copy 3 agent definitions from this document
3. Update `/ship-check` command to use parallel verification
4. Update `analyze-prompt.sh` to suggest agents for debugging
5. Test with real scenarios
6. Document usage in SKILL.md files

---

### Option B: Start with verification-checker Only (Fastest Win)

**What you get**:
- 1 working agent
- 5-10x faster /ship-check
- Proof of concept for parallel execution

**Time required**: 1-2 hours
**ROI**: Immediate (payback after 10-15 uses)

**Action items**:
1. Create `developer-skills-plugin/agents/verification-checker.md`
2. Update `/ship-check` command
3. Test with real /ship-check
4. Measure time savings

---

### Option C: Review Analysis, Decide Later

**What you get**:
- Complete understanding of opportunities
- Time to consider implementation approach
- This document as reference

**Action items**:
- Review agent definitions
- Consider which agents provide most value for your workflow
- Decide on implementation timeline
- Bookmark this document for future reference

---

## Appendix: Quick Reference

### Sub-Agent Invocation Examples

**Single Agent**:
```typescript
const result = await Task({
  description: "Run test suite verification",
  prompt: "verification-checker agent: Run type 'tests'. Execute test suite and report results.",
  model: "haiku"
})
```

**Parallel Agents**:
```typescript
const [result1, result2, result3] = await Promise.all([
  Task({ description: "Check 1", prompt: "...", model: "haiku" }),
  Task({ description: "Check 2", prompt: "...", model: "haiku" }),
  Task({ description: "Check 3", prompt: "...", model: "haiku" })
])
```

**Exploration Agent**:
```typescript
const findings = await Task({
  description: "Explore authentication patterns",
  prompt: "codebase-explorer: Find all authentication and JWT handling code. Return summary with file locations.",
  model: "sonnet"
})
```

**Changelog Agent**:
```typescript
const changelog = await Task({
  description: "Generate recent changelog",
  prompt: "changelog-generator-agent: Analyze last 7 days of commits. Focus on schema and breaking changes.",
  model: "haiku"
})
```

---

### Agent Directory Structure

```
developer-skills-plugin/
├── agents/
│   ├── verification-checker.md           (Tier 1)
│   ├── codebase-explorer.md              (Tier 1)
│   ├── changelog-generator-agent.md      (Tier 1)
│   ├── layer-analyzer-db.md              (Tier 2)
│   ├── layer-analyzer-api.md             (Tier 2)
│   ├── layer-analyzer-frontend.md        (Tier 2)
│   ├── style-extractor.md                (Tier 3)
│   ├── qa-validator.md                   (Tier 3)
│   └── diagnostic-gatherer.md            (Tier 3)
├── commands/
│   └── ship-check.md                     (Updated to use agents)
├── skills/
│   ├── verification-before-completion/
│   │   └── SKILL.md                      (Updated to suggest agents)
│   ├── full-stack-integration-checker/
│   │   └── SKILL.md                      (Updated for parallel analysis)
│   └── systematic-debugging/
│       └── SKILL.md                      (Updated to suggest agents)
└── hooks/
    └── scripts/
        └── analyze-prompt.sh             (Updated to suggest agents)
```

---

### Testing Checklist

**After implementing agents, test each scenario**:

- [ ] `/ship-check` runs 5 parallel verification agents
- [ ] Verification completes in < 1 minute (vs. 5-10 min before)
- [ ] All 5 agent results are aggregated correctly
- [ ] "Where is authentication?" triggers codebase-explorer
- [ ] Explorer returns clean summary (not thousands of lines)
- [ ] "What changed recently?" triggers changelog-generator
- [ ] Changelog shows schema/logic/breaking changes
- [ ] Full-stack integration checker uses parallel layer analysis
- [ ] Layer analyzers return structured reports
- [ ] Main context stays clean (< 5,000 tokens after agent results)

---

## Conclusion

Sub-agents unlock **parallel execution** and **context isolation** - two capabilities the current Superflow system doesn't have. This enables:

1. **5-10x faster verification** via parallel checks
2. **67% context reduction** via isolated exploration
3. **3x faster debugging** via parallel diagnostics
4. **Better scalability** (can run 5-10 agents simultaneously)

**Recommended approach**: Start with Tier 1 agents (verification, exploration, changelog) for immediate wins, then expand to layer analysis and advanced workflows.

**ROI**: High - payback in 20-30 uses (1-2 months for typical usage)

**Next step**: Choose Option A, B, or C from "Next Steps" section.
