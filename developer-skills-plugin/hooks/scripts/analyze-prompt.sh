#!/bin/bash
# Intelligent prompt analyzer for developer-skills superflows
# Detects patterns and injects appropriate workflow instructions via JSON output

# Read JSON from stdin
INPUT_JSON=$(cat)

# Extract the prompt field using jq if available, otherwise use grep
if command -v jq &> /dev/null; then
    USER_PROMPT=$(echo "$INPUT_JSON" | jq -r '.prompt // empty' 2>/dev/null)
else
    # Fallback: simple extraction (handles basic cases)
    USER_PROMPT=$(echo "$INPUT_JSON" | sed -n 's/.*"prompt":"\([^"]*\)".*/\1/p')
fi

# If empty, exit silently (no context injection)
if [ -z "$USER_PROMPT" ]; then
    exit 0
fi

# Initialize the context that will be injected
CONTEXT=""

# Pattern detection flags
REFACTOR_PATTERN="refactor|rewrite|restructure|clean up"
BUG_PATTERN="bug|error|issue|problem|fail|broken|not working"
FEATURE_PATTERN="implement|build|create|add.*(feature|functionality|component|system)"
UI_PATTERN="ui|component|interface|design|hero|pricing|testimonial|navbar|form|modal|dialog|card"
API_PATTERN="api|endpoint|route|controller.*(change|modify|update|add|remove)"
COMPLETE_PATTERN="done|complete|finished|ready"
MVP_PATTERN="mvp|prototype|poc|proof of concept|quick|fast|rapid"
EXPLAIN_PATTERN="what does|explain|how does|understand|why does"
PATTERN_RECALL="how did we|how do we|what's the pattern"

# Helper function to write active superflow to session file
write_active_superflow() {
    local flow_indicator="$1"
    local workflow_key=$(echo "$flow_indicator" | tr ' ' '_' | tr -d '🛡️🐛🏗️🎨🔌✅🚀🔐⚡📦🎓')

    # Read existing session data
    local violations=0
    if [ -f .claude-session ]; then
        violations=$(grep -oP "${workflow_key}_VIOLATIONS=\K\d+" .claude-session 2>/dev/null || echo "0")
    fi

    # Write to .claude-session
    {
        echo "ACTIVE_SUPERFLOW=$flow_indicator"
        echo "${workflow_key}_VIOLATIONS=$violations"
        echo "LAST_WORKFLOW_CHECK=$(date -Iseconds)"
    } > .claude-session
}

# Helper function to get enforcement level based on violations
get_enforcement_level() {
    local workflow_key="$1"
    local violations=0

    if [ -f .claude-session ]; then
        violations=$(grep -oP "${workflow_key}_VIOLATIONS=\K\d+" .claude-session 2>/dev/null || echo "0")
    fi

    # Return enforcement level: SUGGEST(0), WARN(1), REQUIRE(2), BLOCK(3+)
    if [ "$violations" -eq 0 ]; then
        echo "SUGGEST"
    elif [ "$violations" -eq 1 ]; then
        echo "WARN"
    elif [ "$violations" -eq 2 ]; then
        echo "REQUIRE"
    else
        echo "BLOCK"
    fi
}

# Helper function to add header once
add_header() {
    if [ -z "$CONTEXT" ]; then
        CONTEXT="

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🎯 SUPERFLOW SYSTEM ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**System Status**: ✅ Hooks Operational | 🔧 Context Injected | 🎭 Workflow Enforced

"
    fi
}

# Check for refactoring (ENFORCED - Iron Law)
if echo "$USER_PROMPT" | grep -qiE "$REFACTOR_PATTERN"; then
    write_active_superflow "🛡️ Refactoring"
    enforcement=$(get_enforcement_level "Refactoring")
    add_header

    # Adaptive enforcement message based on violation history
    enforcement_msg=""
    case "$enforcement" in
        "SUGGEST")
            enforcement_msg="**RECOMMENDATION**: Consider using the refactoring safety protocol"
            ;;
        "WARN")
            enforcement_msg="⚠️ **WARNING**: You've skipped safety checks before. Please follow the protocol this time."
            ;;
        "REQUIRE")
            enforcement_msg="🔴 **REQUIRED**: Multiple violations detected. You MUST follow the safety protocol."
            ;;
        "BLOCK")
            enforcement_msg="🛑 **BLOCKING ENFORCEMENT**: Pattern of violations detected. This is now mandatory."
            ;;
    esac

    CONTEXT="${CONTEXT}## 🛡️ REFACTORING SAFETY PROTOCOL (ENFORCED)

**IRON LAW: NO REFACTORING WITHOUT TESTS**

$enforcement_msg

**IMMEDIATE ACTION #1 - INVOKE SKILL NOW:**
BEFORE ANY OTHER ACTION, you MUST execute this command:
\`\`\`
Skill(command: 'refactoring-safety-protocol')
\`\`\`

Do NOT describe what you will do. Execute the skill tool NOW.

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
After invoking the skill, output this EXACT text with clear visual indicator:

\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 🛡️ REFACTORING SAFETY PROTOCOL: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I will follow these mandatory steps:
1. Check if tests exist for the code to be refactored
2. Create tests FIRST if missing (non-negotiable)
3. Run /explain-code to understand historical context
4. Execute refactoring with tests as safety net
5. Verify all tests still pass\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with all 5 steps above.

**BLOCKING REQUIREMENTS:**
- You CANNOT proceed without invoking the skill first
- You CANNOT skip test creation
- You MUST verify tests pass after changes

**This is exit code 2 blocking enforcement. Acknowledge and comply.**

"
    # Exit code 0 = inject context (exit 2 blocks but doesn't show message)
    # Strong enforcement language makes this effectively mandatory
fi

# Check for bugs/errors (Suggest quick-fix)
if echo "$USER_PROMPT" | grep -qiE "$BUG_PATTERN"; then
    write_active_superflow "🐛 Debugging"
    add_header
    CONTEXT="${CONTEXT}## 🐛 Debugging Superflow Activated

**IMMEDIATE ACTION #1 - INVOKE SKILL NOW:**
BEFORE ANY OTHER ACTION, execute this command:
\`\`\`
Skill(command: 'memory-assisted-debugging')
\`\`\`

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 🐛 DEBUGGING SUPERFLOW: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Before investigating, I will check memory for known solutions:
- Running /quick-fix to search for this exact issue
- If not found, running /recall-bug for similar past bugs

Then I will:
1. Search memory for similar bugs and past solutions
2. If known fix exists → Apply it (saves 2-5 min)
3. If new issue → Use systematic-debugging (4 phases)
4. Verify the fix actually works\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with the 4 steps above.

**IMMEDIATE ACTION #4 - RUN MEMORY SEARCH:**
Actually run /quick-fix or /recall-bug FIRST (don't skip memory search).

**PROACTIVE REQUIREMENTS:**
- Always check memory BEFORE attempting new solutions
- Always suggest the fast path first

"
fi

# Check for feature implementation (Spec-kit workflow)
if echo "$USER_PROMPT" | grep -qiE "$FEATURE_PATTERN"; then
    write_active_superflow "🏗️ Feature Dev"
    add_header
    CONTEXT="${CONTEXT}## 🏗️ Feature Development Superflow

**IMMEDIATE ACTION #1 - INVOKE SKILLS NOW:**
Execute these commands in order:
\`\`\`
Skill(command: 'memory-assisted-spec-kit')
\`\`\`
\`\`\`
Skill(command: 'spec-kit-orchestrator')
\`\`\`

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 🏗️ FEATURE DEVELOPMENT SUPERFLOW: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I will follow the complete spec-kit workflow:
1. Run /recall-feature to check for similar past implementations
2. Follow Constitution → Specify → Clarify → Plan phases
3. Implement following the plan
4. Before marking complete: Run /check-integration + /ship-check

Starting with memory search to avoid reinventing solutions...\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with all workflow steps.

**IMMEDIATE ACTION #4 - RUN MEMORY SEARCH:**
Actually run /recall-feature BEFORE planning (don't skip memory).

**PROACTIVE REQUIREMENTS:**
- Always check memory for similar features FIRST
- Always use the full spec-kit workflow (don't shortcut)
- Always verify integration before claiming done

"
fi

# Check for UI work (Library search first)
if echo "$USER_PROMPT" | grep -qiE "$UI_PATTERN"; then
    write_active_superflow "🎨 UI Dev"
    add_header
    CONTEXT="${CONTEXT}## 🎨 UI Development Superflow

**IMMEDIATE ACTION #1 - INVOKE SKILLS NOW:**
Execute these commands:
\`\`\`
Skill(command: 'ui-inspiration-finder')
\`\`\`
\`\`\`
Skill(command: 'using-shadcn-ui')
\`\`\`

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 🎨 UI DEVELOPMENT SUPERFLOW: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Before building from scratch, I will search existing resources:
1. Running /find-ui to search premium UI library
2. If found → Adapt existing component (saves significant time)
3. If not found → Use shadcn/ui blocks (829 production components)
4. Plan error handling patterns
5. Implement with loading states, error states, and proper UX

Let me search the premium library first...\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with all 5 steps.

**IMMEDIATE ACTION #4 - RUN LIBRARY SEARCH:**
Actually suggest /find-ui with a specific pattern (don't skip this).

**IRON LAW: SEARCH BEFORE BUILD**
- ALWAYS check /find-ui FIRST
- ALWAYS consider shadcn/ui blocks SECOND
- ONLY build from scratch as last resort

"
fi

# Check for API changes (Contract review)
if echo "$USER_PROMPT" | grep -qiE "$API_PATTERN"; then
    write_active_superflow "🔌 API Design"
    add_header
    CONTEXT="${CONTEXT}## 🔌 API Contract Design Reminder

**REQUIRED ACTIONS (DO NOT SKIP):**
1. **IMMEDIATELY OUTPUT** to user: \"🔌 API Contract Design activated\"
2. **IMMEDIATELY USE TodoWrite** with these steps:
   - Use api-contract-design skill
   - Check for breaking changes
   - Consider versioning needs
   - Ensure backward compatibility
   - Validate request/response schemas

When modifying APIs, use \`api-contract-design\` skill:
- Check for breaking changes
- Consider versioning needs
- Ensure backward compatibility
- Validate request/response schemas

"
fi

# Check for completion claims (Verification required)
if echo "$USER_PROMPT" | grep -qiE "$COMPLETE_PATTERN"; then
    write_active_superflow "✅ Verifying"
    add_header
    CONTEXT="${CONTEXT}## ✅ Verification Before Completion (ENFORCED)

**THIS IS BLOCKING ENFORCEMENT - YOU MUST RESPOND TO THIS MESSAGE**

**IRON LAW: NO COMPLETION CLAIMS WITHOUT FRESH EVIDENCE**

**IMMEDIATE ACTION #1 - INVOKE SKILL NOW:**
\`\`\`
Skill(command: 'verification-before-completion')
\`\`\`

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## ✅ VERIFICATION PROTOCOL: ACTIVE (ENFORCED)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I will NOT mark work as complete until I:
1. Run /check-integration for full-stack verification (DB → API → Frontend)
2. Run /ship-check for comprehensive validation
3. Gather FRESH evidence from actual command execution
4. Confirm ALL tests pass with real output

I will NOT rely on cached results or assumptions.\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with all 4 verification steps.

**IMMEDIATE ACTION #4 - RUN VERIFICATION COMMANDS:**
Actually run /check-integration and /ship-check.

**BLOCKING REQUIREMENTS:**
- You CANNOT claim work is complete without running verification
- You CANNOT use cached/old test results
- You MUST provide actual command output as evidence

"
fi

# Check for MVP/rapid prototyping
if echo "$USER_PROMPT" | grep -qiE "$MVP_PATTERN"; then
    write_active_superflow "🚀 Rapid Proto"
    add_header
    CONTEXT="${CONTEXT}## 🚀 Rapid Prototyping Superflow

**IMMEDIATE ACTION #1 - INVOKE SKILL NOW:**
\`\`\`
Skill(command: 'rapid-prototyping')
\`\`\`

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
\"🚀 Rapid Prototyping Superflow activated\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with these steps:
- Determine Build vs Buy vs Integrate
- Use /find-ui + using-shadcn-ui for UI
- Implement MVP with quality gates
- Run verification-before-completion

**Strategic Decisions:**
- Focus on what NOT to build
- Build vs Buy vs Integrate matrix
- Leverage premium UI resources
- Fast ≠ Broken (still verify)

"
fi

# Check for security concerns
SECURITY_PATTERN="security|vulnerability|hack|exploit|attack|auth.*issue|inject|xss|csrf"
if echo "$USER_PROMPT" | grep -qiE "$SECURITY_PATTERN"; then
    write_active_superflow "🔐 Security"
    add_header
    CONTEXT="${CONTEXT}## 🔐 Security Hardening Workflow

**IMMEDIATE ACTION #1 - INVOKE SKILL NOW:**
\`\`\`
Skill(command: 'security-patterns')
\`\`\`

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 🔐 SECURITY HARDENING: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I will follow the complete security review process:
1. Run /security-scan for comprehensive vulnerability analysis
2. Check authentication and authorization
3. Validate all input handling
4. Review secrets management
5. Verify security headers and configuration

Starting with security scan...\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with all 5 steps above.

**IMMEDIATE ACTION #4 - RUN SECURITY SCAN:**
Actually run /security-scan to identify vulnerabilities.

**IRON LAW: SECURITY FIRST**
- ALWAYS scan before implementing fixes
- NEVER trust client-side data
- ALWAYS validate all user input

"
fi

# Check for performance issues
PERF_PATTERN="slow|performance|latency|optimize.*speed|bottleneck|takes.*long"
if echo "$USER_PROMPT" | grep -qiE "$PERF_PATTERN"; then
    write_active_superflow "⚡ Performance"
    add_header
    CONTEXT="${CONTEXT}## ⚡ Performance Optimization Workflow

**IMMEDIATE ACTION #1 - INVOKE SKILL NOW:**
\`\`\`
Skill(command: 'performance-optimization')
\`\`\`

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## ⚡ PERFORMANCE OPTIMIZATION: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I will follow systematic profiling and optimization:
1. Run /perf-check to identify bottlenecks
2. Profile current performance (before metrics)
3. Optimize highest-impact bottlenecks first
4. Measure improvements (after metrics)
5. Verify no regressions with tests

Starting with performance analysis...\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with all 5 steps above.

**IMMEDIATE ACTION #4 - RUN PROFILING:**
Actually run /perf-check to profile.

**IRON LAW: PROFILE FIRST, OPTIMIZE SECOND**
- NO optimization without profiling first
- ALWAYS measure impact
- Fix bottlenecks, not symptoms

"
fi

# Check for dependency updates
DEPENDENCY_PATTERN="update.*dependenc|upgrade.*package|npm.*update|vulnerabilit.*package|outdated"
if echo "$USER_PROMPT" | grep -qiE "$DEPENDENCY_PATTERN"; then
    write_active_superflow "📦 Dependencies"
    add_header
    CONTEXT="${CONTEXT}## 📦 Dependency Update Workflow

**YOU MUST START YOUR RESPONSE WITH:**
\"📦 Dependency Update Workflow activated

I will follow systematic update process:
1. Check current state (npm outdated, npm audit)
2. Use dependency-management skill for strategy
3. Review changelogs for breaking changes
4. Update incrementally (one at a time)
5. Run test suite after each update
6. Verify with /check-integration

Starting with dependency audit...\"

**THEN IMMEDIATELY:**
1. Use TodoWrite with all 6 steps above
2. Run npm audit and npm outdated
3. Use dependency-management skill for risk assessment
4. Update ONE package at a time
5. Test after EACH update
6. Don't batch updates - isolate failures

**IRON LAW: INCREMENTAL UPDATES**
- ONE package at a time
- TEST after each update
- NEVER batch security + feature updates

"
fi

# Check for learning/explanation requests
LEARNING_PATTERN="learn|teach me|how does.*work|explain|understand|what is|show me how"
if echo "$USER_PROMPT" | grep -qiE "$LEARNING_PATTERN"; then
    write_active_superflow "🎓 Learning"
    add_header
    CONTEXT="${CONTEXT}## 🎓 Learning Mode Workflow

**YOU MUST START YOUR RESPONSE WITH:**
\"🎓 Learning Mode Workflow activated

I will provide comprehensive explanation:
1. Run /explain-code for historical context
2. Use /recall-pattern for similar implementations
3. Provide architectural overview
4. Show concrete examples
5. Suggest practice exercises
6. Create memory observation for future reference

Starting with code analysis...\"

**THEN IMMEDIATELY:**
1. Use TodoWrite with all 6 steps above
2. Run /explain-code for context
3. Use /recall-pattern for past patterns
4. Explain with examples, not just theory
5. Make it interactive - ask clarifying questions
6. Create memory observation when done

**LEARNING PRINCIPLES:**
- Show, don't just tell
- Use concrete examples from THIS codebase
- Build on existing knowledge
- Check understanding with questions

"
fi

# Check for code explanation requests
if echo "$USER_PROMPT" | grep -qiE "$EXPLAIN_PATTERN"; then
    add_header
    CONTEXT="${CONTEXT}## 📖 Code Explanation Available

Suggest: \`/explain-code\` for comprehensive understanding with:
- Historical context (why code exists)
- Design rationale
- Architecture decisions

"
fi

# Check for pattern recall
if echo "$USER_PROMPT" | grep -qiE "$PATTERN_RECALL"; then
    add_header
    CONTEXT="${CONTEXT}## 🔍 Pattern Recall

Suggest: \`/recall-pattern\` to search project memory for implementation patterns

"
fi

# Output JSON with additionalContext if we have any context to inject
if [ -n "$CONTEXT" ]; then
    # Escape the context for JSON (escape quotes and newlines)
    ESCAPED_CONTEXT=$(echo "$CONTEXT" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | awk '{printf "%s\\n", $0}')

    # Output proper JSON format for UserPromptSubmit hook
    cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "$ESCAPED_CONTEXT"
  }
}
EOF
fi

# Exit code 0 = success
exit 0
