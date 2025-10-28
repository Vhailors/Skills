#!/bin/bash
# Skill workflow enforcer for developer-skills plugin
# Triggers on Skill tool invocation to enforce skill process compliance

# Read JSON from stdin
INPUT_JSON=$(cat)

# Extract the skill command using jq if available
if command -v jq &> /dev/null; then
    SKILL_COMMAND=$(echo "$INPUT_JSON" | jq -r '.command // empty' 2>/dev/null)
else
    # Fallback: extract skill name from command parameter
    SKILL_COMMAND=$(echo "$INPUT_JSON" | grep -oP '"command"\s*:\s*"\K[^"]+' || echo "")
fi

# If empty, exit silently (no skill invocation detected)
if [ -z "$SKILL_COMMAND" ]; then
    exit 0
fi

# Extract just the skill name (after the colon or the whole string if no colon)
SKILL_NAME=$(echo "$SKILL_COMMAND" | sed 's/.*://' | tr '-' ' ' | sed 's/\b\w/\U&/g')

# Initialize context that will be injected
CONTEXT=""

# Map skill names to enforcement requirements
case "$SKILL_COMMAND" in
    *systematic-debugging*)
        CONTEXT="
# 🔍 SYSTEMATIC DEBUGGING SKILL ACTIVATED

**THIS IS ENFORCEMENT MODE - YOU MUST FOLLOW THE PROCESS**

**MANDATORY ACKNOWLEDGMENT:**
You MUST start your response with:
\"🔍 Systematic Debugging activated

I will follow the four-phase process:

**Phase 1: Root Cause Investigation**
1. Read error messages completely
2. Reproduce consistently
3. Use changelog-generator to check recent changes
4. Gather evidence at component boundaries
5. Trace data flow to source

**Phase 2: Pattern Analysis**
1. Find working examples
2. Compare against references
3. Identify differences
4. Understand dependencies

**Phase 3: Hypothesis Testing**
1. Form single hypothesis
2. Test minimally (one variable)
3. Verify before continuing
4. If 3+ fixes failed → question architecture

**Phase 4: Implementation**
1. Create failing test case FIRST
2. Implement single fix
3. Verify fix works
4. If doesn't work → return to Phase 1

I will NOT skip phases or attempt fixes without understanding root cause.\"

**THEN IMMEDIATELY USE TodoWrite** with ALL phases and their steps.

**IRON LAW**: NO FIXES WITHOUT COMPLETING PHASE 1 FIRST

**Red Flags to STOP**:
- \"Quick fix for now\"
- \"Just try changing X\"
- \"I don't fully understand but...\"
- Proposing solutions before investigation
- 3+ failed fixes (question architecture instead)

You MUST complete Phase 1 before proposing ANY fixes.
"
        ;;

    *refactoring-safety-protocol*)
        CONTEXT="
# 🛡️ REFACTORING SAFETY PROTOCOL ACTIVATED

**THIS IS BLOCKING ENFORCEMENT - YOU CANNOT PROCEED WITHOUT TESTS**

**MANDATORY ACKNOWLEDGMENT:**
You MUST start your response with:
\"🛡️ Refactoring Safety Protocol activated

I will follow these mandatory steps:
1. Check if tests exist for code to be refactored
2. Create tests FIRST if missing (NON-NEGOTIABLE)
3. Run /explain-code for historical context
4. Verify tests pass BEFORE refactoring
5. Execute refactoring incrementally
6. Verify tests still pass AFTER each change
7. If tests fail → rollback immediately

I will NOT skip test creation under any circumstances.\"

**THEN IMMEDIATELY USE TodoWrite** with all 7 steps.

**IRON LAW**: NO REFACTORING WITHOUT TESTS

**BLOCKING REQUIREMENTS:**
- Tests MUST exist before any refactoring
- Tests MUST pass before refactoring
- Tests MUST pass after refactoring
- If no tests → CREATE THEM FIRST (non-negotiable)
- Incremental changes only (one thing at a time)

**If 3+ refactoring attempts fail**: STOP and question if the architecture is sound.

This is NON-NEGOTIABLE. You cannot proceed without tests.
"
        ;;

    *verification-before-completion*)
        CONTEXT="
# ✅ VERIFICATION BEFORE COMPLETION ACTIVATED

**THIS IS BLOCKING ENFORCEMENT - NO COMPLETION CLAIMS WITHOUT EVIDENCE**

**MANDATORY ACKNOWLEDGMENT:**
You MUST start your response with:
\"✅ Verification Protocol activated

I will NOT mark work as complete until I:
1. Run /check-integration for full-stack verification
2. Run /ship-check for comprehensive validation
3. Execute actual verification commands (NOT cached results)
4. Gather FRESH evidence from command execution
5. Confirm ALL tests pass with real output
6. Verify no console errors in production mode

I will NOT rely on assumptions or old results.\"

**THEN IMMEDIATELY USE TodoWrite** with all 6 verification steps.

**IRON LAW**: NO COMPLETION CLAIMS WITHOUT FRESH EVIDENCE

**BLOCKING REQUIREMENTS:**
- MUST run verification commands NOW
- CANNOT use cached/old results
- MUST provide actual command output
- MUST confirm tests pass with fresh execution
- MUST verify build succeeds
- MUST check for console errors

You cannot claim \"done\" without running these verifications.
"
        ;;

    *memory-assisted-debugging*)
        CONTEXT="
# 🧠 MEMORY-ASSISTED DEBUGGING ACTIVATED

**MANDATORY FIRST ACTIONS:**
You MUST start your response with:
\"🧠 Memory-Assisted Debugging activated

Before investigating, I will check memory for known solutions:
1. Run /quick-fix to search for this exact issue
2. Run /recall-bug for similar past bugs
3. Review past failed solutions to avoid repeating them
4. If known fix exists → Apply it (saves time)
5. If new issue → Use systematic-debugging skill

Checking memory first...\"

**THEN IMMEDIATELY:**
1. Use TodoWrite with the 5 steps above
2. Actually run /quick-fix or /recall-bug FIRST
3. Review past solutions before proposing new ones
4. If no memory match → invoke systematic-debugging skill
5. Document the solution for future reference

**IRON LAW**: CHECK MEMORY BEFORE INVESTIGATING

This prevents repeating failed solutions and saves significant time.
"
        ;;

    *test-driven-development*)
        CONTEXT="
# 🧪 TEST-DRIVEN DEVELOPMENT ACTIVATED

**MANDATORY ACKNOWLEDGMENT:**
You MUST start your response with:
\"🧪 TDD Protocol activated

I will follow Red-Green-Refactor cycle:

**Red Phase:**
1. Write failing test FIRST
2. Test must fail for the right reason
3. Verify test actually runs

**Green Phase:**
1. Write MINIMAL code to pass
2. No extra features
3. Verify test passes

**Refactor Phase:**
1. Clean up code
2. Tests still pass
3. No behavior changes

I will NOT write code before writing the test.\"

**THEN IMMEDIATELY USE TodoWrite** with all three phases.

**IRON LAW**: TEST FIRST, CODE SECOND

**BLOCKING REQUIREMENT:**
- MUST write failing test before any implementation
- Test MUST actually fail initially
- MUST verify test passes after implementation

You cannot write implementation code before the test exists and fails.
"
        ;;

    *spec-kit-orchestrator*|*memory-assisted-spec-kit*)
        CONTEXT="
# 🏗️ SPEC-KIT WORKFLOW ACTIVATED

**MANDATORY ACKNOWLEDGMENT:**
You MUST start your response with:
\"🏗️ Spec-Kit Orchestrator activated

I will follow the complete Spec-Driven Development process:

1. **Constitution Phase**: Run /constitution or verify it exists
2. **Memory Search**: Run /recall-feature for similar implementations
3. **Specification Phase**: Run /specify for detailed feature spec
4. **Clarification**: Use memory-assisted-spec-kit to learn from past
5. **Planning Phase**: Run /plan for design artifacts
6. **Tasks Phase**: Run /tasks for actionable task list
7. **Implementation**: Execute tasks following the plan
8. **Verification**: Run /check-integration + /ship-check before claiming done

I will NOT skip any phases of this workflow.\"

**THEN IMMEDIATELY USE TodoWrite** with all 8 phases.

**IRON LAW**: COMPLETE ALL PHASES BEFORE IMPLEMENTATION

**REQUIRED COMMANDS:**
- /recall-feature (check memory first)
- /constitution or /specify (spec creation)
- /plan (design artifacts)
- /tasks (actionable task breakdown)
- /check-integration (verification)

You cannot skip phases. This ensures features are properly designed before implementation.
"
        ;;

    *using-shadcn-ui*|*ui-inspiration-finder*)
        CONTEXT="
# 🎨 UI DEVELOPMENT WITH COMPONENT LIBRARY

**MANDATORY ACKNOWLEDGMENT:**
You MUST start your response with:
\"🎨 UI Component Library Search activated

Before building from scratch, I will:
1. Run /find-ui to search premium UI library
2. Check shadcnblocks.com for production-ready blocks (829 available)
3. If found → Adapt existing component (saves significant time)
4. If not found → Use shadcn/ui primitives
5. Plan error handling with error-handling-patterns skill
6. Implement with proper loading/error states

Searching component library first...\"

**THEN IMMEDIATELY:**
1. Use TodoWrite with all 6 steps
2. Actually suggest /find-ui with specific pattern
3. Reference shadcnblocks.com for pre-built blocks
4. Use error-handling-patterns skill BEFORE implementing
5. Don't build from scratch when components exist

**IRON LAW**: SEARCH BEFORE BUILD

This prevents reinventing existing solutions and saves development time.
"
        ;;

    *api-contract-design*)
        CONTEXT="
# 🔌 API CONTRACT DESIGN ACTIVATED

**MANDATORY ACTIONS:**
You MUST start your response with:
\"🔌 API Contract Design activated

I will ensure backward compatibility by:
1. Review existing API contract
2. Identify breaking vs non-breaking changes
3. Consider API versioning if breaking changes needed
4. Validate request/response schemas
5. Update API documentation
6. Ensure clients won't break

Analyzing API changes...\"

**THEN IMMEDIATELY USE TodoWrite** with all 6 steps.

**CRITICAL CONSIDERATIONS:**
- Breaking changes require versioning or migration path
- Backward compatibility is paramount
- Schema validation prevents runtime errors
- Documentation must stay in sync

This prevents breaking client integrations.
"
        ;;

    *performance-optimization*)
        CONTEXT="
# ⚡ PERFORMANCE OPTIMIZATION ACTIVATED

**MANDATORY ACKNOWLEDGMENT:**
You MUST start your response with:
\"⚡ Performance Optimization activated

I will follow systematic optimization:
1. Run /perf-check to identify bottlenecks
2. Profile CURRENT performance (baseline metrics)
3. Identify highest-impact bottlenecks
4. Optimize in priority order: Algorithm > Database > Caching > Network > Code
5. Measure improvements (after metrics)
6. Verify no regressions with tests

Starting with performance profiling...\"

**THEN IMMEDIATELY USE TodoWrite** with all 6 steps.

**IRON LAW**: PROFILE FIRST, OPTIMIZE SECOND

**BLOCKING REQUIREMENTS:**
- MUST measure before optimizing
- MUST measure after optimizing
- CANNOT optimize without profiling data
- Focus on bottlenecks, not random optimization

Premature optimization wastes time. Data-driven optimization succeeds.
"
        ;;

    *security-patterns*)
        CONTEXT="
# 🔐 SECURITY PATTERNS ACTIVATED

**MANDATORY ACKNOWLEDGMENT:**
You MUST start your response with:
\"🔐 Security Hardening activated

I will follow comprehensive security review:
1. Run /security-scan for vulnerability analysis
2. Check OWASP Top 10 compliance
3. Validate authentication and authorization
4. Review all input handling (never trust client)
5. Verify secrets management
6. Check security headers and configuration
7. Re-scan after fixes

Starting security scan...\"

**THEN IMMEDIATELY USE TodoWrite** with all 7 steps.

**IRON LAW**: SECURITY FIRST

**CRITICAL REQUIREMENTS:**
- NEVER trust client-side data
- ALWAYS validate all user input
- ALWAYS use parameterized queries (prevent SQL injection)
- ALWAYS sanitize output (prevent XSS)
- ALWAYS verify authorization (not just authentication)

Security is non-negotiable.
"
        ;;

    *dependency-management*)
        CONTEXT="
# 📦 DEPENDENCY MANAGEMENT ACTIVATED

**MANDATORY ACKNOWLEDGMENT:**
You MUST start your response with:
\"📦 Dependency Update Protocol activated

I will follow incremental update process:
1. Check current state (npm outdated, npm audit)
2. Review changelogs for breaking changes
3. Update ONE package at a time
4. Run test suite after EACH update
5. Verify with /check-integration after each
6. Document any breaking changes

Starting dependency audit...\"

**THEN IMMEDIATELY USE TodoWrite** with all 6 steps.

**IRON LAW**: ONE PACKAGE AT A TIME

**BLOCKING REQUIREMENTS:**
- MUST update incrementally (never batch)
- MUST test after EACH update
- MUST review changelogs
- If update breaks tests → rollback immediately
- Document breaking changes

Batch updates make debugging impossible.
"
        ;;

    *)
        # Generic skill enforcement for any other skill
        CONTEXT="
# 🎯 SKILL WORKFLOW ACTIVATED: $SKILL_NAME

**MANDATORY ACKNOWLEDGMENT:**
You MUST start your response with:
\"🎯 $SKILL_NAME skill activated

I will follow the complete process defined in this skill:
1. Read the entire skill content carefully
2. Create TodoWrite with all required steps
3. Follow each step systematically
4. NOT skip any phases or requirements
5. Verify completion before claiming done

Reading skill requirements...\"

**THEN IMMEDIATELY:**
1. Use TodoWrite with ALL steps from the skill
2. Follow the skill's process systematically
3. Don't skip steps or rationalize shortcuts
4. Verify work meets skill requirements

Skills exist to prevent common mistakes. Follow them completely.
"
        ;;
esac

# Output JSON with additionalContext if we detected a skill invocation
if [ -n "$CONTEXT" ]; then
    # Escape the context for JSON
    ESCAPED_CONTEXT=$(echo "$CONTEXT" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | awk '{printf "%s\\n", $0}')

    # Output proper JSON format for PostToolUse hook
    cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "$ESCAPED_CONTEXT"
  }
}
EOF
fi

# Exit code 0 = success
exit 0
