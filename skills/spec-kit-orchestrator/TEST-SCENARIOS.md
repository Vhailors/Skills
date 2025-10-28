# Test Scenarios: Spec-Kit Workflow Orchestrator

## Purpose
Establish baseline behavior of agents WITHOUT the spec-kit orchestrator skill to identify gaps.

## Test Scenario 1: Out-of-Order Execution

**User Request:** "Run /speckit.implement to build the login feature"

**Expected Behavior (WITHOUT skill):**
- Agent runs `/speckit.implement` directly
- Script outputs error: "Prerequisites not met - no tasks.md found"
- Agent stops and says "Tasks file doesn't exist, need to create it first"
- Agent asks user what to do next

**Gap Identified:**
- Agent doesn't understand the full workflow
- Doesn't automatically backtrack to `/speckit.tasks`
- Doesn't know that tasks requires plan, plan requires spec, spec requires constitution
- Doesn't orchestrate the prerequisite chain automatically

**What the skill should do:**
- Detect missing prerequisites
- Automatically say: "To implement, I need tasks → plan → spec → constitution"
- Ask user: "Should I run the full workflow starting from constitution?"
- If yes, orchestrate: constitution → specify → clarify → plan → tasks → implement

---

## Test Scenario 2: Skipping Clarification Phase

**User Request:** "Create a spec for user profiles feature and implement it"

**Expected Behavior (WITHOUT skill):**
- Agent runs `/speckit.specify` with minimal spec
- Spec has vague requirements: "Users should have profiles"
- Agent runs `/speckit.plan` directly (skips clarify)
- Plan is generic: "Create database schema, API endpoints, UI"
- Implementation fails because requirements were unclear
- Agent doesn't know it skipped mandatory clarification

**Gap Identified:**
- Agent doesn't know clarification is critical for spec quality
- Treats clarify as optional
- Doesn't ask the deep questions that clarify command would prompt
- Results in poor quality specs leading to failed implementations

**What the skill should do:**
- After `/speckit.specify`, automatically trigger `/speckit.clarify`
- Ask clarifying questions from the command template:
  - "What user data should be stored in profiles?"
  - "Who can view/edit profiles - only owner or others?"
  - "What validation rules for profile fields?"
- Refuse to proceed to planning until spec is clear
- Update spec with clarifications before moving forward

---

## Test Scenario 3: Missing Constitution

**User Request:** "Let's build a comments feature"

**Expected Behavior (WITHOUT skill):**
- Agent starts writing code immediately (no workflow)
- OR agent runs `/speckit.specify` without checking for constitution
- Spec is created without project context
- Implementation doesn't align with project principles
- Security considerations missed (auth, ownership checks)
- No consistency with existing features

**Gap Identified:**
- Agent doesn't know constitution is the foundation
- Creates specs in a vacuum without project context
- No guardrails from project principles
- Each feature implemented differently (inconsistent)

**What the skill should do:**
- Before any spec work, check: "Does constitution.md exist?"
- If no: "I need to create the project constitution first. Let me run `/speckit.constitution`"
- Ask constitution questions:
  - "What are the core principles for this project?"
  - "What are the success criteria?"
  - "What are the technical constraints?"
- Use constitution as context for ALL subsequent specs and implementations

---

## Test Scenario 4: Inadequate Specification

**User Request:** "Implement favorites feature"

**Expected Behavior (WITHOUT skill):**
- Agent creates minimal spec: "Users can favorite products"
- Spec missing:
  - Data model details (unique constraint?)
  - API endpoints needed (toggle? list? count?)
  - Frontend UX (button state? optimistic updates?)
  - Error scenarios (duplicate favorite? product not found?)
- Agent proceeds to implementation with incomplete spec
- Implementation has gaps (discovered earlier with full-stack-integration-checker)

**Gap Identified:**
- Agent doesn't know what makes a complete spec
- Doesn't ask thorough questions
- Doesn't validate spec completeness before planning
- Spec template exists but agent doesn't follow it rigorously

**What the skill should do:**
- After user provides initial feature request, use spec template structure:
  - Context: Why are we building this?
  - Requirements: What exactly is needed?
  - Acceptance Criteria: How do we know it's done?
  - Technical Constraints: What are the limitations?
- Validate spec against template - all sections filled?
- Automatically trigger clarify if sections are vague
- Show user: "Spec checklist: ✅ Context, ✅ Requirements, ⚠️ Acceptance criteria incomplete"

---

## Test Scenario 5: Plan Without Task Breakdown

**User Request:** "Plan and implement the notifications feature"

**Expected Behavior (WITHOUT skill):**
- Agent creates plan with phases: "1. Backend, 2. Frontend, 3. Testing"
- Agent jumps to implementation without running `/speckit.tasks`
- Implementation is ad-hoc, no clear order
- Agent forgets steps (e.g., implements create but forgets delete)
- No task tracking or validation

**Gap Identified:**
- Agent doesn't break plan into concrete tasks
- Tasks command exists but agent skips it
- Implements in random order
- Loses track of what's done vs pending

**What the skill should do:**
- After plan is created, automatically run `/speckit.tasks`
- Convert plan phases into concrete, ordered tasks:
  ```
  [ ] Create Notification model in schema
  [ ] Write and apply migration
  [ ] Implement POST /api/notifications endpoint
  [ ] Implement GET /api/notifications endpoint
  [ ] Create NotificationList component
  [ ] Add real-time updates via WebSocket
  [ ] Write integration tests
  ```
- Use tasks as implementation checklist
- After each task, validate completion before proceeding
- Show progress: "Task 3/7 complete - POST endpoint implemented ✅"

---

## Test Scenario 6: No Validation Before Completion

**User Request:** "Build the comments feature and let me know when it's done"

**Expected Behavior (WITHOUT skill):**
- Agent implements create comment functionality
- Agent says "Done! Comments feature is complete"
- User tests, finds issues:
  - Can create but can't delete comments
  - No edit functionality
  - Comments not showing in UI (API exists but not consumed)
  - Security hole (client-provided userId)
- Feature incomplete but agent thinks it's done

**Gap Identified:**
- Agent doesn't validate completeness before claiming done
- No systematic checklist
- `/speckit.checklist` command exists but agent doesn't use it
- Same issue full-stack-integration-checker solves

**What the skill should do:**
- Before saying "Done", automatically run `/speckit.checklist`
- Validate against spec's acceptance criteria
- Run integration checks (database → API → frontend)
- Check CRUD completeness
- Show results:
  ```
  ✅ Can create comments
  ❌ Can't delete comments (DELETE endpoint missing)
  ❌ Can't edit comments (no edit UI)
  ⚠️ Security: Uses req.body.userId (should use auth)
  ```
- Refuse to say "complete" until all criteria met
- Fix gaps before declaring done

---

## Test Scenario 7: Workflow State Confusion

**User Request:** "Continue working on the user profiles feature"

**Expected Behavior (WITHOUT skill):**
- Agent doesn't know current state
- Asks user: "What stage are we at? What's been done?"
- User has to explain what's complete
- Agent might redo work or miss completed steps
- No single source of truth for project state

**Gap Identified:**
- Agent doesn't track workflow state
- No understanding of "where we are" in the process
- Scripts output JSON with state but agent doesn't leverage it
- Each conversation starts from zero context

**What the skill should do:**
- On any spec-kit command, first check state:
  - Read JSON output from check-prerequisites script
  - Identify what exists: constitution ✓, spec ✓, plan ✓, tasks ✗
  - Know current phase: "We're at planning phase, ready for tasks"
- Show user: "Current state: Spec and plan complete. Ready to generate tasks."
- When user says "continue," know exactly what the next step is
- Use update-agent-context script to maintain state

---

## Test Scenario 8: Parallel Feature Development

**User Request:** "Work on both login and profiles features simultaneously"

**Expected Behavior (WITHOUT skill):**
- Agent tries to maintain multiple specs
- Gets confused which spec is being discussed
- Mixes context between features
- File naming conflicts (plan.md for which feature?)
- No clear separation of concerns

**Gap Identified:**
- Spec-kit supports per-feature directories (features/login/, features/profiles/)
- Agent doesn't use this structure
- Treats all features as monolithic
- No isolation between parallel work streams

**What the skill should do:**
- Detect multiple features in progress
- Use feature-specific directories:
  ```
  features/
    login/
      spec.md
      plan.md
      tasks.md
    profiles/
      spec.md
      plan.md
      tasks.md
  ```
- Always clarify which feature when user says "continue"
- Keep context isolated per feature
- Use create-new-feature script to set up structure

---

## Test Scenario 9: Ignoring Constitution Principles

**User Request:** "Implement admin override for user profiles"

**Constitution contains:** "Principle: Users own their data. No admin overrides without audit logs."

**Expected Behavior (WITHOUT skill):**
- Agent implements admin override directly
- Skips audit logging
- Violates constitution principle
- Creates security/compliance issue
- Agent never checked constitution

**Gap Identified:**
- Constitution exists but agent doesn't reference it during implementation
- Principles not enforced automatically
- Agent treats constitution as "nice to have" documentation

**What the skill should do:**
- Before implementing, read constitution.md
- Check if implementation aligns with principles
- Flag violation: "⚠️ Constitution principle: 'Users own their data. No admin overrides without audit logs.'"
- Ask user: "Should I implement audit logging for this admin feature?"
- Refuse to implement if it violates constitution (or explicitly confirm with user)

---

## Test Scenario 10: Incomplete Task Implementation

**User Request:** "Implement the tasks for notifications"

**Tasks file contains:**
```
[ ] Create Notification model
[ ] Implement POST /api/notifications
[ ] Implement GET /api/notifications
[ ] Implement DELETE /api/notifications
[ ] Create NotificationList component
[ ] Add real-time updates
```

**Expected Behavior (WITHOUT skill):**
- Agent implements first 3 tasks
- Gets distracted or forgets remaining tasks
- Says "Notifications feature implemented!"
- User discovers: No delete functionality, no real-time updates
- Agent didn't track task completion systematically

**Gap Identified:**
- Agent doesn't use tasks.md as authoritative checklist
- Implements subset and loses track
- No task-by-task validation
- No marking tasks complete in file

**What the skill should do:**
- Load tasks.md as checklist
- Implement tasks IN ORDER (dependencies!)
- After each task:
  - Validate completion
  - Update tasks.md: `[x] Create Notification model`
  - Show progress: "Task 1/6 complete"
- Don't proceed to next until current is verified
- At end, verify ALL tasks marked complete
- If any incomplete, don't say "done"

---

## Summary of Gaps

| Gap Category | Impact | Skill Solution |
|-------------|--------|---------------|
| Missing prerequisite detection | Workflow fails, wasted time | Auto-detect and orchestrate prerequisite chain |
| Skipping clarification | Poor quality specs | Make clarify mandatory after specify |
| No constitution usage | Inconsistent features, principle violations | Check constitution before every phase |
| Incomplete specifications | Implementation gaps | Validate spec against template, force completeness |
| Task breakdown skipped | Ad-hoc implementation, missing steps | Auto-generate tasks from plan |
| No validation before completion | Ship incomplete features | Auto-run checklist before claiming done |
| State confusion | Redo work, miss completed steps | Track state via script JSON outputs |
| Parallel feature conflicts | Mixed context, file conflicts | Use per-feature directory structure |
| Constitution violations | Security/compliance issues | Validate against principles before implementing |
| Task tracking failure | Incomplete implementations | Use tasks.md as authoritative checklist |

---

## Next Step

These scenarios establish what DOESN'T work without the skill. Next:

**RED Phase Testing:**
- Ask a subagent to implement "favorites feature" WITHOUT the skill
- Document actual behavior matching these scenarios
- Confirm these gaps exist in reality

**Then GREEN Phase:**
- Write the spec-kit-orchestrator skill
- Test that it eliminates these gaps
- Verify workflow runs smoothly end-to-end
