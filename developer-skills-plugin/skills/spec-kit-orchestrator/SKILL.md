---
name: spec-kit-orchestrator
description: Use when implementing new features with spec-kit workflow (github.com/github/spec-kit) - orchestrates the full Spec-Driven Development process from constitution through implementation, ensuring no steps are skipped, prerequisites are met, and features are truly complete before shipping
---

# Spec-Kit Workflow Orchestrator

## Overview

**Master the complete Spec-Driven Development workflow. Never skip steps. Never ship incomplete features.**

This skill orchestrates the GitHub spec-kit workflow (https://github.com/github/spec-kit), which transforms feature development from ad-hoc coding into a systematic process: constitution → specify → clarify → plan → tasks → implement → validate.

**Core principle:** Specifications drive implementation. Every feature starts with clear requirements, every implementation has concrete tasks, every completion has validation.

**The Iron Law:**
```
NO IMPLEMENTATION WITHOUT SPECIFICATION
NO SPECIFICATION WITHOUT CLARIFICATION
NO COMPLETION WITHOUT VALIDATION
```

## When to Use

Use this skill when:
- **Starting any new feature** - "Build a comments system" → Run spec-kit workflow
- **User requests feature work** - "Implement user profiles" → Start with constitution check
- **Before writing code** - ANY feature request → Spec first, code second
- **Managing feature development** - Orchestrate the full workflow automatically
- **Validating completion** - Before saying "done" → Run checklist validation

**Symptoms that trigger this skill:**
- User says "build," "implement," "create feature," "add functionality"
- You're about to write code for a new feature
- User asks "are we done with X feature?"
- You've implemented something and need to validate completeness
- Multiple features in progress simultaneously

**DO NOT use for:**
- Bug fixes (use systematic-debugging)
- Refactoring existing code (unless it's feature-sized work)
- Simple styling changes
- Documentation updates
- **Trivial additions** (< 15 minutes, using existing functionality):
  - Adding single UI elements that call existing functions (e.g., logout button calling existing logout())
  - Adding confirmations/tooltips to existing actions
  - Minor UX improvements to existing features (loading spinners, success messages)
  - Single-line functionality additions with no new business logic

**Threshold guidance:** If the change can be implemented, tested, and validated in under 15 minutes AND doesn't introduce new business logic, API endpoints, database changes, or integration points, it doesn't require spec-kit workflow. When in doubt, ask: "Does this need requirements clarification?" If yes → use spec-kit. If no → proceed directly.

## Prerequisites & Installation

**Before using this skill, verify spec-kit is installed:**

```bash
# Check if spec-kit slash commands exist
ls .claude/commands/speckit.*.md 2>/dev/null || ls .claude-plugins/*/commands/speckit.*.md 2>/dev/null
```

**If commands are missing:**

**Option A - Install spec-kit (recommended):**
1. Visit: https://github.com/github/spec-kit
2. Clone or download the repository
3. Copy the `.claude/commands/speckit.*.md` files to your project's `.claude/commands/` directory
4. Or follow the spec-kit installation instructions in their README

**Option B - Manual workflow (no installation required):**

You can follow all workflow principles manually without slash commands by creating files directly:

- **Constitution:** Create `.speckit/constitution.md` manually using template in Step 1
- **Feature Spec:** Create `features/{name}/spec.md` using template in Step 2
- **Plan:** Create `features/{name}/plan.md` using template in Step 4
- **Tasks:** Create `features/{name}/tasks.md` using template in Step 5

**The workflow principles remain valid with or without slash commands.** Throughout this skill, when you see "Run `/speckit.command`", you can alternatively create the corresponding file manually using the templates provided in each section.

## Spec-Kit Workflow Reference

### The 8 Commands

The spec-kit provides these slash commands:

| Command | Purpose | Prerequisites | Outputs |
|---------|---------|---------------|---------|
| `/speckit.constitution` | Define project principles, success criteria, constraints | None (first step) | `.speckit/constitution.md` |
| `/speckit.specify` | Create feature specification | Constitution exists | `features/{name}/spec.md` |
| `/speckit.clarify` | Ask clarifying questions about spec | Spec exists | Updates `spec.md` |
| `/speckit.plan` | Create implementation plan | Clarified spec | `features/{name}/plan.md` |
| `/speckit.tasks` | Break plan into concrete tasks | Plan exists | `features/{name}/tasks.md` |
| `/speckit.implement` | Execute tasks with validation | Tasks exist | Code + updated `tasks.md` |
| `/speckit.checklist` | Validate feature completeness | Implementation done | Completion report |
| `/speckit.analyze` | Review existing code | Anytime | Analysis report |

### The Workflow Flow

```
┌─────────────────┐
│  Constitution   │ ← One-time setup (or update as project evolves)
│  (Principles)   │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│    Specify      │ ← Define WHAT to build
│  (Requirements) │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│    Clarify      │ ← Ask questions until spec is clear
│   (Questions)   │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│      Plan       │ ← Design HOW to build
│   (Approach)    │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│     Tasks       │ ← Break down into concrete steps
│  (Checklist)    │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│   Implement     │ ← Build it, validate each task
│     (Code)      │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│   Checklist     │ ← Verify completeness before "done"
│  (Validation)   │
└─────────────────┘
```

**Critical: Each arrow represents a mandatory gate. You cannot skip steps.**

## Orchestration Workflow

### Step 0: Detect Current State

**Before any spec-kit work, run the check-prerequisites script:**

```bash
# From repository root
.speckit/scripts/check-prerequisites.sh  # or .ps1 for PowerShell
```

**This outputs JSON showing:**
- What files exist (constitution, specs, plans, tasks)
- What phase each feature is in
- What the next valid action is
- Any blocking issues

**Parse this JSON to understand "where we are."**

### Step 1: Constitution Check (First Time Setup)

**When user requests ANY feature work, FIRST check:**

```bash
# Does constitution exist?
ls .speckit/constitution.md
```

**If constitution does NOT exist:**

1. **STOP all feature work**
2. Say to user: "I need to establish the project constitution first. This defines principles that will guide all features."
3. Run `/speckit.constitution`
4. Ask the constitution questions:
   - **Core Principles:** What are the guiding principles for this project? (e.g., "User privacy first," "Zero breaking changes," "Mobile-first design")
   - **Success Criteria:** How do we measure success? (e.g., "Features ship in < 1 week," "Zero security vulnerabilities," "95%+ test coverage")
   - **Technical Constraints:** What are the boundaries? (e.g., "Must support IE11," "Max 2s page load," "No external dependencies")
   - **Non-Goals:** What are we explicitly NOT doing? (e.g., "No real-time features," "No mobile app," "No user-generated content")
5. Write constitution.md with answers
6. **Then and only then** proceed to feature specification

**If constitution EXISTS:**
- Read it
- Keep it in mind for ALL subsequent decisions
- Validate implementations align with principles

### Step 2: Feature Specification

**When user says "build X feature":**

1. **Run `/speckit.specify [feature-name]`**
   - This creates `features/{feature-name}/` directory structure
   - Outputs `features/{feature-name}/spec.md`

2. **Use the spec template structure:**

   ```markdown
   # Feature: [Name]

   ## Context
   Why are we building this? What problem does it solve?

   ## Requirements
   What exactly is needed? Be specific.

   ### Functional Requirements
   - User can do X
   - System should do Y
   - Feature must support Z

   ### Non-Functional Requirements
   - Performance: [targets]
   - Security: [constraints]
   - Accessibility: [standards]

   ## Acceptance Criteria
   How do we know it's done?

   - [ ] Criterion 1
   - [ ] Criterion 2
   - [ ] Criterion 3

   ## Technical Constraints
   - Must integrate with [existing system]
   - Cannot break [existing feature]
   - Must use [technology/pattern]

   ## Out of Scope
   Explicitly list what this feature does NOT include
   ```

3. **Validate spec completeness:**
   - [ ] Context section filled (not just "TBD")
   - [ ] At least 3 functional requirements listed
   - [ ] Acceptance criteria are specific and testable
   - [ ] Technical constraints identified
   - [ ] Out of scope defined (prevents scope creep)

4. **If spec is vague or incomplete → FORCE clarification (Step 3)**

### Step 3: Clarification (MANDATORY)

**After creating spec, AUTOMATICALLY run `/speckit.clarify`:**

**DO NOT skip this step.** Most incomplete features stem from under-specified requirements.

**Ask deep clarifying questions:**

**Data Model Questions:**
- What data fields are needed?
- What are the data types and constraints?
- What relationships exist with other entities?
- What's the cardinality (1:1, 1:N, M:N)?

**CRUD Completeness Questions:**
- Can users create this? → Need create UI + POST endpoint
- Can users read/list this? → Need display UI + GET endpoints
- Can users edit this? → Need edit UI + PUT/PATCH endpoint
- Can users delete this? → Need delete UI + DELETE endpoint
- **If ANY of these are "no," explicitly document in out-of-scope**

**Security Questions:**
- Who can perform each operation? (authentication)
- What ownership/permission checks are needed? (authorization)
- What happens if user tries unauthorized action?
- Are there rate limits or abuse prevention needs?

**Error Scenario Questions:**
- What if the item doesn't exist? (404 handling)
- What if input is invalid? (400 validation)
- What if user lacks permission? (403 handling)
- What if operation conflicts? (409 handling, e.g., duplicate creation)
- What if external service fails? (500 handling, retries)

**UX Questions:**
- What loading states are needed?
- What error messages should users see?
- What success feedback is shown?
- Are there optimistic updates?
- What happens on network failure?

**Integration Questions:**
- What existing features does this touch?
- What might this break?
- What migration/upgrade path exists?
- Are there backwards compatibility concerns?

**Update spec.md with clarifications.** Do NOT proceed until spec is clear and complete.

### Step 4: Implementation Planning

**After spec is clarified, run `/speckit.plan`:**

1. **Create plan.md with phases:**

   ```markdown
   # Implementation Plan: [Feature Name]

   ## Approach
   High-level strategy for building this feature

   ## Phases

   ### Phase 1: Database Schema
   - Define data models
   - Create migrations
   - Test schema changes

   ### Phase 2: Backend API
   - Implement endpoints (POST, GET, PUT, DELETE)
   - Add authentication/authorization
   - Write API tests

   ### Phase 3: Frontend UI
   - Create components
   - Integrate with API
   - Handle loading/error states

   ### Phase 4: Integration & Testing
   - End-to-end tests
   - Integration validation
   - Performance testing

   ## Dependencies
   - Requires [existing feature] to be complete
   - Blocks [future feature]

   ## Risks
   - Technical challenges
   - Integration complexities

   ## Estimated Effort
   - Phase 1: [time]
   - Phase 2: [time]
   - Phase 3: [time]
   - Phase 4: [time]
   ```

2. **Validate plan against constitution:**
   - Does approach align with project principles?
   - Does it meet technical constraints?
   - Does it avoid non-goals?
   - **If violations exist, flag them to user**

### Step 5: Task Breakdown

**After plan is created, AUTOMATICALLY run `/speckit.tasks`:**

**DO NOT let user start implementing from plan alone.** Plans are too high-level.

1. **Break each phase into concrete, ordered tasks:**

   ```markdown
   # Tasks: [Feature Name]

   ## Phase 1: Database Schema

   - [ ] Define Comment model in schema with fields: id, postId, userId, content, createdAt, updatedAt
   - [ ] Add unique constraint on [userId, postId] if needed
   - [ ] Create migration file
   - [ ] Apply migration to development database
   - [ ] Verify migration with `npx prisma db pull`

   ## Phase 2: Backend API

   - [ ] Implement POST /api/comments endpoint
     - Use authenticated user from session (NOT req.body.userId)
     - Validate: postId exists, content is not empty
     - Return 201 with created comment
   - [ ] Implement GET /api/comments?postId=X endpoint
     - Include user data (name, avatar) to avoid N+1 queries
     - Add pagination (limit 20 per page)
     - Return 200 with array of comments
   - [ ] Implement DELETE /api/comments/:id endpoint
     - Verify ownership (comment.userId === authenticatedUser.id)
     - Return 403 if user doesn't own comment
     - Return 404 if comment not found
     - Return 204 on successful deletion

   ## Phase 3: Frontend UI

   - [ ] Create CommentList component
     - Fetch comments on mount
     - Show loading spinner while fetching
     - Display error message if fetch fails
     - Render list of comments with user info
   - [ ] Create CommentForm component
     - Text input with submit button
     - Disable submit while posting
     - Show error if post fails
     - Clear input on success
     - Trigger CommentList refresh after creation
   - [ ] Add delete button to each comment
     - Only show if user owns comment
     - Confirm before deleting
     - Show loading state during deletion
     - Remove from list on success

   ## Phase 4: Integration & Testing

   - [ ] Write integration test: Create comment → Verify in list
   - [ ] Write integration test: Delete comment → Verify removed
   - [ ] Test authorization: User can't delete others' comments
   - [ ] Test error cases: Invalid postId, empty content
   - [ ] Run full-stack-integration-checker skill
   ```

2. **Task criteria:**
   - Each task is specific and actionable
   - Each task has validation criteria
   - Tasks are ordered by dependencies
   - No task is too large (break down if > 30 min)
   - Security checks are explicit tasks

### Step 6: Implementation

**When implementing, use `/speckit.implement`:**

**CRITICAL: Implement tasks IN ORDER, validate EACH task before proceeding.**

**For each task:**

1. **Mark task as in-progress** in tasks.md:
   ```markdown
   - [>] Implement POST /api/comments endpoint
   ```

2. **Implement the task** (write code)

3. **Validate completion:**
   - Does code work? (run the server/app)
   - Do tests pass? (if test task, run tests)
   - Does it meet acceptance criteria from spec?
   - Does it align with constitution principles?

4. **Mark task complete** in tasks.md:
   ```markdown
   - [x] Implement POST /api/comments endpoint
   ```

5. **Update agent context** (if using agent-file):
   ```bash
   .speckit/scripts/update-agent-context.sh
   ```

6. **Proceed to next task**

**DO NOT:**
- Implement multiple tasks without validation
- Mark task complete without testing
- Skip tasks because they "seem optional"
- Batch all code changes then test at end

### Step 7: Completion Validation

**Before saying "feature is complete," ALWAYS run `/speckit.checklist`:**

**This triggers comprehensive validation:**

1. **Spec acceptance criteria check:**
   - Go through each `[ ]` item in spec.md
   - Verify each is actually done
   - If ANY are incomplete → feature not done

2. **Full-stack integration check:**
   - **Use full-stack-integration-checker skill**
   - Verify database → API → frontend are fully connected
   - Check for unused schema fields
   - Check for missing CRUD operations
   - Check for orphaned API endpoints
   - Check for security holes

3. **Constitution alignment check:**
   - Does implementation follow project principles?
   - Does it meet success criteria?
   - Does it respect technical constraints?
   - Does it avoid non-goals?

4. **Task completeness check:**
   - Are ALL tasks in tasks.md marked `[x]`?
   - If any are `[ ]` or `[>]` → not complete

5. **Generate completion report:**

   ```markdown
   # Feature Completion Report: [Feature Name]

   ## Spec Acceptance Criteria
   - [x] Users can create comments
   - [x] Users can view comments
   - [x] Users can delete their own comments
   - [x] Comments show author information
   - [x] Error handling for all operations

   ## Integration Validation

   ### Database Layer ✅
   - Comment model defined
   - Migration applied
   - Relations configured

   ### Backend API ✅
   - POST /api/comments (authenticated, validated)
   - GET /api/comments (paginated, includes user data)
   - DELETE /api/comments/:id (authorized, error handling)

   ### Frontend UI ✅
   - CommentList displays comments
   - CommentForm creates comments
   - Delete button removes comments
   - Loading/error states present

   ## Constitution Alignment ✅
   - Follows "User privacy first" principle (auth required)
   - Meets "Zero security vulnerabilities" criterion (no client userId)
   - Respects "Mobile-first design" constraint (responsive UI)

   ## All Tasks Complete ✅
   - 14/14 tasks marked complete in tasks.md

   ## Verdict
   ✅ **READY TO SHIP** - Feature is complete and validated.
   ```

**ONLY if all checks pass: Say "Feature complete."**

**If ANY checks fail:**
- Report what's incomplete
- Fix gaps
- Re-run validation
- **Do NOT say "done" prematurely**

## Multi-Feature Management

**When working on multiple features simultaneously:**

1. **Use per-feature directories:**
   ```
   features/
     comments/
       spec.md
       plan.md
       tasks.md
     profiles/
       spec.md
       plan.md
       tasks.md
   ```

2. **Always clarify which feature:**
   - User: "Continue working on the feature"
   - You: "Which feature? (comments, profiles, or notifications)"

3. **Isolate context:**
   - Don't mix context between features
   - Each feature has its own spec/plan/tasks
   - Agent context files are feature-specific

4. **Create new features properly:**
   ```bash
   .speckit/scripts/create-new-feature.sh [feature-name]
   ```

## Red Flags - STOP and Follow Process

If you catch yourself thinking:
- "I'll just start coding and spec it later"
- "This is a simple feature, doesn't need spec-kit"
- "Clarification seems unnecessary, requirements are clear enough"
- "I'll combine these tasks and do them all at once"
- "Tests pass, feature must be done" (without running checklist)
- "User tested it once, must be complete"
- "I'll update the task list after I finish all the code"

**ALL of these mean: STOP. Return to the workflow. Follow the process.**

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Feature is simple, don't need full workflow" | Simple features have requirements too. Spec-kit is fast for simple features. |
| "I'll write spec after prototyping" | Post-hoc specs miss the gaps. Spec first always. |
| "Clarification slows me down" | Under-specified features waste more time. Clarify upfront. |
| "I can track tasks in my head" | You'll forget steps. Tasks.md is authoritative. |
| "Feature works when I tested it" | One test ≠ complete. Run full validation checklist. |
| "Constitution is just documentation" | Constitution is guardrails. Violations create problems. |

## Integration with Other Skills

**This skill REQUIRES using:**
- **full-stack-integration-checker** - MANDATORY for completion validation (Step 7)
- **systematic-debugging** - When implementation encounters bugs
- **verification-before-completion** - Before declaring any phase done

**Complementary skills:**
- **ui-inspiration-finder** - When implementing frontend (Step 6, Phase 3)
- **brainstorming** - When creating specifications (Step 2)

## Real-World Impact

**Without this skill:**
- Features start with ad-hoc code
- Requirements discovered during implementation
- Scope creep (no clear boundaries)
- Incomplete implementations shipped
- Integration gaps missed
- Constitution violated

**With this skill:**
- Every feature starts with clear spec
- Requirements clarified upfront
- Scope defined and protected
- Systematic validation before "done"
- Full-stack integration verified
- Constitution enforced

**Example: Comments feature**
- Without skill: 3 hours coding, 2 hours fixing gaps, incomplete (no delete)
- With skill: 30 min spec/clarify/plan, 2 hours implementation, complete and validated
- Result: Better quality, less rework, actually done

## Quick Reference Card

| Phase | Command | Validation | Next Step |
|-------|---------|-----------|-----------|
| **Setup** | `/speckit.constitution` | Principles defined | Begin feature specs |
| **Specify** | `/speckit.specify [name]` | Template sections filled | Run clarify |
| **Clarify** | `/speckit.clarify` | All questions answered | Create plan |
| **Plan** | `/speckit.plan` | Aligns with constitution | Generate tasks |
| **Tasks** | `/speckit.tasks` | Tasks concrete & ordered | Begin implementation |
| **Implement** | `/speckit.implement` | Each task validated | Run checklist |
| **Validate** | `/speckit.checklist` | All checks pass ✅ | Ship feature |

## The Golden Rule

**When in doubt: SLOW DOWN. Follow the workflow. Validate each step.**

Spec-kit's overhead is minimal (~30 minutes per feature for spec/clarify/plan). The time saved avoiding rework and fixing gaps is 10x that investment.

**The worst mistake: Skipping steps to "save time," then spending hours fixing incomplete implementations.**

**The best practice: Trust the process. It exists because ad-hoc feature development fails repeatedly.**
