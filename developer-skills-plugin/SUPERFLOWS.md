# Developer Skills Plugin: Superflows & Intelligent Automation

## Overview

This document defines **superflows** - intelligent workflow chains that connect the plugin's 18 skills and 9 commands into cohesive, automated development processes. Combined with the hook system, these superflows transform the plugin from a collection of tools into an intelligent development assistant.

**Philosophy**: The right skill at the right time, automatically.

---

## Core Superflows

### 1. FEATURE DEVELOPMENT SUPERFLOW

**Trigger**: User requests new feature implementation

**Flow**:
```
Session Context → Spec Phase → Design Phase → Implementation → Verification → Ship
```

**Detailed Chain**:
1. **Context Loading**
   - Command: `/continue-work` (if returning) OR `/recall-feature` (check similar past work)
   - Loads: Recent work, similar features, lessons learned

2. **Specification Phase**
   - Skill: `memory-assisted-spec-kit` (query past features first)
   - Skill: `spec-kit-orchestrator` (constitution → specify → clarify → plan)
   - Output: Complete spec document with clarifications

3. **Design Phase** (Parallel activities based on feature type)
   - **If API**: `api-contract-design` (RESTful patterns, breaking changes)
   - **If UI**: `/find-ui` → `ui-inspiration-finder` → `using-shadcn-ui`
   - **Always**: `error-handling-patterns` (plan error handling upfront)
   - Output: Design decisions documented

4. **Implementation Phase**
   - **Logging**: `standardized-logging` (check schema FIRST)
   - **Tech-specific**: Apply relevant technical skills
   - Output: Working code

5. **Verification Phase**
   - Command: `/check-integration` (full-stack verification)
   - Skill: `full-stack-integration-checker` (DB → API → Frontend)
   - Skill: `verification-before-completion` (run tests, verify claims)
   - Output: Verified integration

6. **Ship Phase**
   - Command: `/ship-check` (comprehensive pre-ship validation)
   - Skill: `changelog-generator` (generate release notes)
   - Output: Ready to deploy

**Hook Integration**:
- `UserPromptSubmit` (pattern: "implement|build|create feature") → Injects Feature Development Superflow instructions
- `PreToolUse` (Bash: git commit) → Strongly suggests `/ship-check` before committing

---

### 2. DEBUGGING SUPERFLOW

**Trigger**: Bug reports, errors, test failures

**Flow**:
```
Quick Memory Check → Systematic Analysis → Understanding → Fix → Verify → Record
```

**Detailed Chain**:
1. **Memory Search**
   - Command: `/quick-fix` (searches memory for known solutions)
   - Branches:
     - **Known issue** → Apply proven fix → Verify → Done
     - **Unknown issue** → Continue to systematic debugging

2. **Root Cause Analysis**
   - Command: `/recall-bug` (search similar past bugs)
   - Skill: `memory-assisted-debugging` (past failed solutions)
   - Skill: `systematic-debugging` (4-phase investigation)
   - Output: Root cause identified

3. **Code Understanding**
   - Command: `/explain-code` (understand affected code)
   - Loads: Historical context, design rationale
   - Output: Deep code comprehension

4. **Solution Implementation**
   - Apply fix addressing root cause
   - Skill: `error-handling-patterns` (if error handling issue)
   - Output: Fix implemented

5. **Verification**
   - Skill: `verification-before-completion` (run tests, confirm fix)
   - Output: Bug verified fixed

6. **Learning**
   - Record solution in memory system
   - Document failed approaches
   - Output: Knowledge captured for future

**Hook Integration**:
- `UserPromptSubmit` (pattern: "bug|error|issue") → Injects Debugging Superflow with `/quick-fix` and `/recall-bug` suggestions
- `PostToolUse` (Bash: test commands) → Enforces evidence-based verification

---

### 3. REFACTORING SUPERFLOW

**Trigger**: Code refactoring requests

**Flow**:
```
Understand → Safety Check → Plan → Execute → Verify
```

**Detailed Chain**:
1. **Understanding Phase**
   - Command: `/explain-code` (understand WHY before changing)
   - Command: `/recall-pattern` (past refactoring lessons)
   - Output: Comprehension of current implementation

2. **Safety Protocol**
   - Skill: `refactoring-safety-protocol` (ENFORCES tests first)
   - Iron Law: NO REFACTORING WITHOUT TESTS
   - Output: Tests in place

3. **Memory Check**
   - Skill: `memory-assisted-debugging` (past refactoring issues)
   - Searches: Design rationale, past attempts
   - Output: Context on past decisions

4. **Execution**
   - Refactor with tests as safety net
   - Maintain behavior preservation
   - Output: Refactored code

5. **Verification**
   - Skill: `verification-before-completion` (all tests pass)
   - Command: `/check-integration` (if cross-layer refactor)
   - Output: Verified safe refactor

**Hook Integration**:
- `UserPromptSubmit` (pattern: "refactor|rewrite") → **ENFORCES** `refactoring-safety-protocol` with IRON LAW language
- Context injection requires tests before any refactoring

---

### 4. SESSION START SUPERFLOW

**Trigger**: User starts new session

**Flow**:
```
Load Context → Resume State → Present Options
```

**Detailed Chain**:
1. **Auto-Execute**
   - Command: `/continue-work` (automatically runs)

2. **Context Loading**
   - Loads: Recent project context from claude-mem
   - Identifies: In-progress features, pending tasks
   - Searches: Last session's stopping point

3. **State Resume**
   - Presents: Current state summary
   - Suggests: Next actions based on context
   - Lists: Pending items and blockers

**Hook Integration**:
- `SessionStart` → Injects superflow system awareness and suggests checking recent context

---

### 5. PRE-SHIP VALIDATION SUPERFLOW

**Trigger**: About to commit, create PR, or deploy

**Flow**:
```
Comprehensive Checks → Integration Verification → Quality Gates → Changelog
```

**Detailed Chain**:
1. **Ship Check**
   - Command: `/ship-check` (comprehensive validation)
   - Checks:
     - Full-stack integration (DB → API → Frontend)
     - Spec acceptance criteria met
     - CRUD completeness
     - Tests passing
     - Security (auth, validation)
     - Code quality

2. **Integration Verification**
   - Skill: `full-stack-integration-checker` (systematic layer check)
   - Validates: No gaps, no unused code, complete CRUD

3. **Final Verification**
   - Skill: `verification-before-completion` (evidence before claims)
   - Runs: Fresh verification commands
   - Output: Proof of success

4. **Documentation**
   - Skill: `changelog-generator` (technical changelog from commits)
   - Output: Release documentation

**Result**: ✅ Ready to ship or ❌ Gaps found with checklist

**Hook Integration**:
- `PreToolUse` (Bash: git commit/push) → Strongly suggests `/ship-check` and `/check-integration`
- Context injection provides comprehensive pre-ship checklist

---

### 6. UI DEVELOPMENT SUPERFLOW

**Trigger**: Building user interface components

**Flow**:
```
Search Premium Library → Use Existing → Adapt shadcn/ui → Error Handling → Verify
```

**Detailed Chain**:
1. **Premium Library Search**
   - Command: `/find-ui` (search premium UI library FIRST)
   - Skill: `ui-inspiration-finder` (51 screenshots, 100+ components)
   - Pattern: "Don't build basic UI when premium implementations exist"

2. **Decision Branch**:
   - **If found**: Adapt existing component (5 min)
   - **If not found**: Continue to step 3

3. **shadcn/ui Integration**
   - Skill: `using-shadcn-ui` (829 production-ready blocks)
   - Source: shadcnblocks.com
   - Copy-paste and customize

4. **Error & Loading States**
   - Skill: `error-handling-patterns` (user-friendly errors, loading states)
   - Ensures: Network errors, validation errors handled

5. **Verification**
   - Skill: `verification-before-completion` (visual and functional testing)
   - Output: Polished, professional UI

**Hook Integration**:
- `UserPromptSubmit` (pattern: "ui|component") → Suggests `/find-ui` and `using-shadcn-ui` skill before building from scratch

---

### 7. RAPID PROTOTYPING SUPERFLOW

**Trigger**: MVP, POC, or tight timeline projects

**Flow**:
```
Strategic Decisions → Leverage Existing → Fast Iteration → Verification
```

**Detailed Chain**:
1. **Strategy Phase**
   - Skill: `rapid-prototyping` (build vs buy vs integrate)
   - Decision Matrix: What NOT to build
   - Output: Strategic plan (6-day cycles)

2. **UI Acceleration**
   - Command: `/find-ui` (premium library)
   - Skill: `using-shadcn-ui` (pre-built blocks)
   - Pattern: Use existing, don't reinvent

3. **Fast Implementation**
   - Focus: Core value, not polish
   - Leverage: Pre-built components, libraries
   - Output: Working prototype

4. **Quality Maintenance**
   - Skill: `verification-before-completion` (quality despite speed)
   - Output: Fast AND good

**Hook Integration**:
- `UserPromptSubmit` (pattern: "mvp|prototype|poc") → Injects `rapid-prototyping` workflow with strategic decisions framework

---

### 8. SKILL CREATION SUPERFLOW

**Trigger**: Creating or updating skills

**Flow**:
```
TDD Baseline → Write Skill → Test with Agents → Close Loopholes → Deploy
```

**Detailed Chain**:
1. **Test-Driven Documentation**
   - Skill: `writing-skills` (TDD for documentation)
   - Iron Law: NO SKILL WITHOUT FAILING TEST FIRST

2. **RED Phase**:
   - Create pressure scenarios
   - Run WITHOUT skill → document rationalizations

3. **GREEN Phase**:
   - Skill: `skill-creator` (anatomy and structure)
   - Write skill addressing specific failures
   - Run WITH skill → verify compliance

4. **REFACTOR Phase**:
   - Find new loopholes
   - Add explicit counters
   - Re-test until bulletproof

**Hook Integration**:
- `UserPromptSubmit` (pattern: "create skill|write skill") → Enforces TDD process through `writing-skills` skill instructions

---

## Cross-Cutting Enforcement Skills

These skills apply across ALL superflows:

### Always Active:
1. **`standardized-logging`** - Check schema FIRST before any logging
2. **`verification-before-completion`** - Evidence before completion claims
3. **`error-handling-patterns`** - Plan error handling in every feature
4. **`api-contract-design`** - Review breaking changes in API modifications

### Context-Dependent:
- **`50klph-data-pipeline`** - When working on 50kLinesPerHour project
- **`canvas-design`** - When creating visual art/posters

---

## Memory-Enhanced Workflows

Skills with claude-mem integration that provide historical learning:

1. **`memory-assisted-debugging`** - Learn from past bugs
2. **`memory-assisted-spec-kit`** - Learn from past features
3. **`refactoring-safety-protocol`** - Learn from past refactorings
4. **`/continue-work`** - Resume from past sessions
5. **`/quick-fix`** - Apply known solutions
6. **`/recall-bug`** - Search bug history
7. **`/recall-feature`** - Search feature history
8. **`/recall-pattern`** - Search implementation patterns
9. **`/explain-code`** - Historical context and rationale

**Pattern**: Always search memory BEFORE attempting new solutions.

---

## Intelligent Triggers

### Automatic Context Injection (via hooks):
- **Session starts** → Injects superflow awareness and workflow guidance
- **User mentions "bug/error"** → Injects Debugging Superflow with `/quick-fix` suggestion
- **Before git commit** → Injects pre-ship validation checklist with `/ship-check` suggestion
- **User mentions "refactor"** → **ENFORCES** refactoring safety protocol (IRON LAW)
- **User mentions "feature"** → Injects Feature Development workflow with spec-kit steps
- **User mentions "ui/component"** → Suggests `/find-ui` and shadcn/ui blocks
- **After test commands** → Enforces evidence-based verification

### User-Initiated:
- **Explicit commands**: `/ship-check`, `/explain-code`, `/recall-bug`, etc.
- **Implicit triggers**: "Build feature X" → Hook injects feature development flow → Claude follows it
- **Question-based**: "How did we..." → Hook suggests `/recall-pattern` command

---

## Skill Interaction Matrix

| Skill | Commonly Chains With | Output Feeds Into |
|-------|---------------------|-------------------|
| `memory-assisted-spec-kit` | `spec-kit-orchestrator` | Implementation |
| `spec-kit-orchestrator` | `api-contract-design`, `using-shadcn-ui` | Design phase |
| `api-contract-design` | `error-handling-patterns`, `standardized-logging` | Implementation |
| `using-shadcn-ui` | `ui-inspiration-finder`, `error-handling-patterns` | UI implementation |
| `systematic-debugging` | `memory-assisted-debugging`, `/explain-code` | Bug fixing |
| `refactoring-safety-protocol` | `/explain-code`, `verification-before-completion` | Refactoring |
| `full-stack-integration-checker` | `verification-before-completion`, `/ship-check` | Pre-ship |
| `changelog-generator` | Post-ship | Documentation |

---

## Hook System Architecture

See `hooks.json` for the complete hook configuration.

**Hook Types Used**:
1. **SessionStart** - On session initialization → Injects superflow system awareness
2. **UserPromptSubmit** - Pattern matching on user input → Injects workflow-specific instructions
3. **PreToolUse** - Before using specific tools (Write/Edit/Bash) → Enforces standards and suggests validation
4. **PostToolUse** - After tool execution (test commands) → Enforces evidence-based verification

**Hook Mechanisms**:
- **Context Injection**: Hooks output markdown instructions that become part of Claude's context
- **Strong Language**: IRON LAW and enforcement language for critical workflows (refactoring, verification)
- **Suggestions**: Recommend commands and skills at appropriate times
- **Enforcement**: Block-level language that Claude must acknowledge before proceeding

---

## Benefits of Superflows

### Without Superflows:
- ❌ Skills used in isolation
- ❌ Manual workflow coordination
- ❌ Easy to skip verification steps
- ❌ Forget to check memory first
- ❌ Inconsistent process adherence

### With Superflows:
- ✅ Intelligent workflow orchestration
- ✅ Automatic best practice enforcement
- ✅ Memory-driven learning
- ✅ Verification built into process
- ✅ Consistent, high-quality output
- ✅ Faster development with fewer errors

---

## Next Steps

1. Review `hooks.json` for hook configurations
2. Test superflows with real development tasks
3. Iterate based on workflow observations
4. Add new superflows as patterns emerge
5. Refine hook triggers for optimal automation

**The goal**: Development assistant that anticipates needs and guides best practices automatically.
