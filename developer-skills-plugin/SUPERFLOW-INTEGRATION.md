# Superflow Integration: Complete Compilation

## Overview

This document shows the complete compilation of **Hooks → Commands → Skills** and how they work together in each superflow.

## Integration Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        USER INPUT                                │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│                    HOOK DETECTION                                │
│  (analyze-prompt.sh detects patterns)                            │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│              CONTEXT INJECTION + BLOCKING                        │
│  (Exit code 2 for refactor/complete, Exit 0 for others)          │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│                CLAUDE ORCHESTRATION                              │
│  1. Output activation message                                    │
│  2. Create TodoWrite with steps                                  │
│  3. Execute Commands (slash commands)                            │
│  4. Invoke Skills (specialized workflows)                        │
│  5. Follow complete workflow                                     │
└─────────────────────────────────────────────────────────────────┘
```

## Complete Superflow Integrations

### 1. 🛡️ Refactoring Safety Protocol

**Trigger Pattern**: `refactor|rewrite|restructure|clean up`

**Hook**: `UserPromptSubmit` → `analyze-prompt.sh`
- **Enforcement**: EXIT CODE 2 (BLOCKING)
- **Output**: Forces acknowledgment before proceeding

**Activation Message**:
```
🛡️ Refactoring Safety Protocol activated

I will follow these mandatory steps:
1. Check if tests exist
2. Create tests FIRST if missing
3. Run /explain-code for context
4. Use refactoring-safety-protocol skill
5. Execute refactoring
6. Verify tests pass
```

**Commands Used**:
- `/explain-code` - Understand historical context and design rationale

**Skills Used**:
- `refactoring-safety-protocol` - Enforces tests-first approach, memory checks, behavior preservation
- `verification-before-completion` - Post-refactor verification

**Workflow**:
1. Hook blocks with exit 2
2. Claude outputs activation message
3. TodoWrite with 6 steps
4. Run `/explain-code` to understand WHY code exists
5. Check for tests, create if missing
6. Use `refactoring-safety-protocol` skill
7. Execute refactoring
8. Use `verification-before-completion` skill
9. Confirm tests still pass

---

### 2. 🐛 Debugging Superflow

**Trigger Pattern**: `bug|error|issue|problem|fail|broken|not working`

**Hook**: `UserPromptSubmit` → `analyze-prompt.sh`
- **Enforcement**: Strong suggestion (exit 0)
- **Output**: Proactive workflow injection

**Activation Message**:
```
🐛 Debugging Superflow activated

Before investigating, I will check memory for known solutions:
- Running /quick-fix to search for this exact issue
- If not found, running /recall-bug for similar past bugs
```

**Commands Used**:
- `/quick-fix` - Search memory for known solutions (2-5 min fast path)
- `/recall-bug` - Search similar past bugs and solutions
- `/explain-code` - Understand affected code

**Skills Used**:
- `memory-assisted-debugging` - Searches past failed solutions to avoid repeating mistakes
- `systematic-debugging` - 4-phase investigation (root cause → pattern → hypothesis → fix)
- `error-handling-patterns` - If error handling is the issue

**Workflow**:
1. Hook injects debugging workflow
2. Claude outputs activation message
3. TodoWrite with 5 steps
4. **FIRST**: Run `/quick-fix` or `/recall-bug` (memory search is mandatory)
5. If known issue → Apply proven fix
6. If new issue → Use `systematic-debugging` skill (4 phases)
7. Use `memory-assisted-debugging` for past failed solutions
8. Implement fix
9. Use `verification-before-completion` to verify fix works

---

### 3. 🏗️ Feature Development Superflow

**Trigger Pattern**: `implement|build|create.*(feature|functionality|component|system)`

**Hook**: `UserPromptSubmit` → `analyze-prompt.sh`
- **Enforcement**: Strong proactive (exit 0)
- **Output**: Complete spec-kit workflow

**Activation Message**:
```
🏗️ Feature Development Superflow activated

I will follow the complete spec-kit workflow:
1. Run /recall-feature for similar past implementations
2. Use memory-assisted-spec-kit
3. Follow: Constitution → Specify → Clarify → Plan
4. Implement
5. Run /check-integration + /ship-check before done
```

**Commands Used**:
- `/recall-feature` - Search similar past features
- `/check-integration` - Full-stack verification (DB → API → Frontend)
- `/ship-check` - Comprehensive pre-ship validation

**Skills Used**:
- `memory-assisted-spec-kit` - Query past features before planning
- `spec-kit-orchestrator` - Complete spec-driven development (Constitution → Specify → Clarify → Plan → Implement)
- `api-contract-design` - If feature involves API
- `using-shadcn-ui` - If feature involves UI
- `error-handling-patterns` - Plan error handling upfront
- `standardized-logging` - Check logging schema
- `full-stack-integration-checker` - Systematic layer verification
- `verification-before-completion` - Evidence-based completion

**Workflow**:
1. Hook injects feature development workflow
2. Claude outputs activation message
3. TodoWrite with all workflow steps
4. **FIRST**: Run `/recall-feature` (memory search mandatory)
5. Use `memory-assisted-spec-kit` skill
6. Use `spec-kit-orchestrator` skill:
   - Constitution phase
   - Specify phase
   - Clarify phase
   - Plan phase
7. Implementation phase:
   - Use `api-contract-design` if API involved
   - Use `using-shadcn-ui` if UI involved
   - Use `error-handling-patterns` proactively
   - Use `standardized-logging` (check schema first)
8. Verification phase:
   - Run `/check-integration` command
   - Use `full-stack-integration-checker` skill
   - Use `verification-before-completion` skill
9. Ship phase:
   - Run `/ship-check` command
   - Use `changelog-generator` skill

---

### 4. 🎨 UI Development Superflow

**Trigger Pattern**: `ui|component|interface|design|hero|pricing|testimonial|navbar|form|modal|dialog|card`

**Hook**: `UserPromptSubmit` → `analyze-prompt.sh`
- **Enforcement**: IRON LAW: Search before build (exit 0)
- **Output**: Library-first approach

**Activation Message**:
```
🎨 UI Development Superflow activated

Before building from scratch, I will search existing resources:
1. Running /find-ui to search premium library
2. If found → Adapt existing component
3. If not → Use using-shadcn-ui (829 blocks)
4. Plan error handling
5. Implement with proper states

Let me search the premium library first...
```

**Commands Used**:
- `/find-ui <pattern>` - Search premium UI library (51 screenshots, 100+ components)

**Skills Used**:
- `ui-inspiration-finder` - Search C:\Users\Dominik\Documents\UI library
- `using-shadcn-ui` - 829 production-ready blocks from shadcnblocks.com
- `error-handling-patterns` - Loading states, error states, UX patterns
- `verification-before-completion` - Visual and functional testing

**Workflow**:
1. Hook injects UI workflow with IRON LAW
2. Claude outputs activation message
3. TodoWrite with 5 steps
4. **FIRST**: Suggest `/find-ui <specific-pattern>` (MANDATORY)
5. If found → Adapt existing premium component (5 min path)
6. If not found:
   - Use `using-shadcn-ui` skill for pre-built blocks
   - Search shadcnblocks.com for similar components
7. Use `error-handling-patterns` skill BEFORE implementing
   - Plan loading states
   - Plan error states
   - Plan empty states
8. Implement component
9. Use `verification-before-completion` for testing

**IRON LAW**: Never build basic UI from scratch when premium implementations exist

---

### 5. ✅ Pre-Ship Validation Superflow

**Trigger Pattern**: `done|complete|finished|ready`

**Hook**: `UserPromptSubmit` → `analyze-prompt.sh`
- **Enforcement**: EXIT CODE 2 (BLOCKING)
- **Output**: Forces verification before completion

**Activation Message**:
```
✅ Verification Protocol activated

I will NOT mark work as complete until I:
1. Run /check-integration for full-stack verification
2. Run /ship-check for comprehensive validation
3. Use verification-before-completion skill
4. Gather FRESH evidence
5. Confirm ALL tests pass

I will NOT rely on cached results.
```

**Additional Hook**: `PreToolUse` (Bash: git commit/push) → `detect-git-operations.sh`
- **Enforcement**: Strong suggestion (exit 0)
- **Output**: Pre-ship checklist

**Commands Used**:
- `/check-integration` - Verifies DB → API → Frontend integration
- `/ship-check` - Comprehensive pre-deployment validation (tests, spec criteria, security, quality)

**Skills Used**:
- `full-stack-integration-checker` - Systematic layer check (no gaps, no unused code, complete CRUD)
- `verification-before-completion` - Evidence before claims (IRON LAW)
- `changelog-generator` - Technical changelog from commits

**Workflow**:
1. Hook blocks with exit 2 on "complete/done" pattern
2. Claude outputs activation message
3. TodoWrite with 5 verification steps
4. **MANDATORY**: Run `/check-integration` command
   - Use `full-stack-integration-checker` skill
   - Verify DB schema, API endpoints, Frontend integration
   - Check for gaps, unused code, incomplete CRUD
5. **MANDATORY**: Run `/ship-check` command
   - Verify tests passing
   - Check spec acceptance criteria
   - Validate security (auth, validation)
   - Assess code quality
6. Use `verification-before-completion` skill
   - Run FRESH verification commands (no cached results)
   - Provide actual command output as evidence
7. Optional: Use `changelog-generator` skill
8. Result: ✅ Ready to ship OR ❌ Gaps found with action items

---

### 6. 🚀 Rapid Prototyping Superflow

**Trigger Pattern**: `mvp|prototype|poc|proof of concept|quick|fast|rapid`

**Hook**: `UserPromptSubmit` → `analyze-prompt.sh`
- **Enforcement**: Strong guidance (exit 0)
- **Output**: Strategic decisions framework

**Activation Message**:
```
🚀 Rapid Prototyping Superflow activated

I will use rapid-prototyping skill for strategic decisions:
- Focus on what NOT to build
- Build vs Buy vs Integrate matrix
- Leverage /find-ui + using-shadcn-ui
- Fast ≠ Broken (still verify)
```

**Commands Used**:
- `/find-ui <pattern>` - Maximize use of existing components

**Skills Used**:
- `rapid-prototyping` - Strategic decisions, build vs buy, 6-day cycles, quality gates
- `ui-inspiration-finder` - Leverage premium library
- `using-shadcn-ui` - Use pre-built blocks extensively
- `verification-before-completion` - Quality despite speed

**Workflow**:
1. Hook injects rapid prototyping workflow
2. Claude outputs activation message
3. TodoWrite with strategic steps
4. Use `rapid-prototyping` skill for decisions:
   - What NOT to build (scope management)
   - Build vs Buy vs Integrate matrix
   - Time-boxing decisions
5. UI acceleration:
   - Suggest `/find-ui` for every UI component
   - Use `using-shadcn-ui` extensively
6. Fast implementation (leverage existing solutions)
7. Use `verification-before-completion` (fast ≠ broken)

---

### 7. 🔄 Session Start Superflow

**Trigger**: Every session initialization

**Hook**: `SessionStart` → `session-start.sh`
- **Enforcement**: Proactive instruction injection (exit 0)
- **Output**: System awareness + proactive usage mandate

**Context Injected**:
- Lists all 8 superflows with icons
- Shows critical instructions for proactive usage
- Explains blocking enforcement
- Reminds about visibility requirements
- Shows pattern-based activation

**Commands Suggested**:
- `/continue-work` - Resume from past sessions
- Memory commands when relevant

**No specific workflow** - This hook sets up the environment for all other superflows

---

### 8. 🔌 API Contract Design

**Trigger Pattern**: `api.*change|modify` OR `endpoint.*change|modify`

**Hook**: `UserPromptSubmit` → `analyze-prompt.sh`
- **Enforcement**: Strong reminder (exit 0)
- **Output**: API contract considerations

**Activation Message**:
```
🔌 API Contract Design activated

When modifying APIs, I will:
1. Use api-contract-design skill
2. Check for breaking changes
3. Consider versioning needs
4. Ensure backward compatibility
5. Validate schemas
```

**Commands Used**: None specific

**Skills Used**:
- `api-contract-design` - RESTful patterns, breaking change detection, schema validation, versioning
- `error-handling-patterns` - API error responses
- `standardized-logging` - API logging schema

**Workflow**:
1. Hook injects API contract workflow
2. Claude outputs activation message
3. TodoWrite with 5 steps
4. Use `api-contract-design` skill proactively
5. Check for breaking changes
6. Consider versioning (v1, v2, etc.)
7. Ensure backward compatibility
8. Validate request/response schemas
9. Use `error-handling-patterns` for error responses
10. Use `standardized-logging` for API logs

---

## Cross-Cutting Enforcement

These apply across ALL superflows:

### Always Active Skills

1. **`standardized-logging`**
   - Hook: `PreToolUse` (Write|Edit) → `check-logging.sh`
   - Enforcement: IRON LAW (exit 0 reminder)
   - Triggers: Detects `log|logger|console.` in code
   - Requirement: Check project logging schema FIRST

2. **`verification-before-completion`**
   - Multiple hooks reference this
   - Enforcement: IRON LAW
   - Requirement: NO SUCCESS CLAIMS WITHOUT FRESH EVIDENCE

3. **`error-handling-patterns`**
   - Suggested in Feature Development, UI Development
   - Requirement: Plan error handling upfront

4. **`api-contract-design`**
   - Triggered by API modification patterns
   - Requirement: Review breaking changes

### Post-Tool Validation

**Hook**: `PostToolUse` (Bash) → `verify-tests.sh`
- Triggers after: test/build/lint commands
- Enforcement: Evidence-based verification (exit 0)
- Requirement: Read actual output, don't assume success

---

## Command Reference

All slash commands available in the plugin:

| Command | Purpose | Used In Superflows |
|---------|---------|-------------------|
| `/check-integration` | Full-stack verification (DB → API → Frontend) | Feature Development, Pre-Ship |
| `/ship-check` | Comprehensive pre-deployment validation | Feature Development, Pre-Ship |
| `/quick-fix` | Search memory for known bug solutions | Debugging |
| `/recall-bug` | Search similar past bugs | Debugging |
| `/recall-feature` | Search similar past features | Feature Development |
| `/recall-pattern` | Search implementation patterns | Any (on request) |
| `/explain-code` | Historical context and rationale | Refactoring, Debugging |
| `/find-ui <pattern>` | Search premium UI library | UI Development, Rapid Prototyping |
| `/continue-work` | Resume from past sessions | Session Start |

---

## Skills Reference

All 19 skills organized by category:

### Memory-Enhanced Skills
- `memory-assisted-debugging` - Past bugs and failed solutions
- `memory-assisted-spec-kit` - Past features and patterns
- `refactoring-safety-protocol` - Past refactoring lessons

### Workflow Orchestration
- `spec-kit-orchestrator` - Complete spec-driven development
- `systematic-debugging` - 4-phase investigation framework
- `rapid-prototyping` - Strategic MVP decisions
- `skill-creator` - TDD for documentation

### Verification & Quality
- `verification-before-completion` - Evidence-based completion
- `full-stack-integration-checker` - Systematic layer verification

### Technical Implementation
- `api-contract-design` - RESTful patterns, breaking changes
- `error-handling-patterns` - Error handling across stack
- `standardized-logging` - Unified logging schema
- `using-shadcn-ui` - 829 production blocks
- `ui-inspiration-finder` - Premium UI library search

### Specialized
- `50klph-data-pipeline` - Project-specific data pipeline
- `canvas-design` - Visual art creation
- `changelog-generator` - Technical release notes
- `writing-skills` - TDD for skill creation

---

## Enforcement Levels

### 🔴 EXIT CODE 2 (BLOCKING)
**Cannot proceed without acknowledgment:**
- 🛡️ Refactoring Safety Protocol
- ✅ Verification Before Completion

### 🟡 IRON LAW (Strong Language)
**Strong enforcement through instruction:**
- Logging schema checking
- UI: Search before build
- Memory: Check before implementing
- Tests: Evidence before claims

### 🟢 PROACTIVE SUGGESTION
**Strong proactive guidance:**
- All other superflows
- Command suggestions
- Skill invocations

---

## Proactive Usage Mandate

**Critical requirement from `session-start.sh`:**

1. **When hooks suggest commands** → ACTUALLY RUN THEM
2. **When hooks mention skills** → ACTUALLY USE THEM
3. **When hooks require TodoWrite** → ACTUALLY CREATE IT
4. **When hooks show activation message** → ACTUALLY OUTPUT IT

**This is not optional.** The system only works if Claude follows through proactively.

---

## Testing the Complete System

### Test 1: Refactoring (Blocking)
```
User: "Can we refactor the auth module"
Expected: Exit code 2 blocks, forces acknowledgment
Claude MUST: Output exact message, create TodoWrite, follow all steps
```

### Test 2: Debugging (Proactive)
```
User: "Login is broken"
Expected: Debugging superflow activates
Claude MUST: Output activation, run /quick-fix, use systematic-debugging
```

### Test 3: Feature (Complete Workflow)
```
User: "Implement user profile feature"
Expected: Feature development superflow
Claude MUST: Output activation, run /recall-feature, use spec-kit-orchestrator
```

### Test 4: UI (Library First)
```
User: "Build a pricing component"
Expected: UI superflow with IRON LAW
Claude MUST: Output activation, suggest /find-ui with pattern, check shadcn/ui
```

### Test 5: Completion (Blocking)
```
User: "I'm done with the feature"
Expected: Exit code 2 blocks, verification required
Claude MUST: Output message, run /check-integration, run /ship-check
```

---

## Summary

This integration shows that the developer-skills plugin is a **complete system** where:

- **Hooks** detect patterns and inject workflows (5 active hooks)
- **Commands** provide quick access to workflows (9 slash commands)
- **Skills** implement specialized capabilities (19 skills)
- **Enforcement** ensures compliance (exit code 2 + IRON LAW + proactive)

All pieces work together to create intelligent, automated development workflows that guide Claude through best practices **proactively and systematically**.
