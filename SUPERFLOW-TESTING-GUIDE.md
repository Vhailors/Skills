# Complete Superflow Testing Guide

## Prerequisites

Before testing, ensure:
1. ✅ Workspace is trusted (no "Skipping SessionStart" in debug log)
2. ✅ Plugin is enabled: `developer-skills@local-dev-skills: true` in `~/.claude/settings.json`
3. ✅ Check debug log: `tail -f ~/.claude/debug/latest` (in separate terminal)

---

## Test 1: Session Start Hook 🔄

**What it does:** Shows superflow system overview when you start Claude Code

**How to test:**
1. Exit Claude Code completely
2. Restart Claude Code in any project
3. Watch for the session start message

**Expected output:**
```
🔄 Session Continuity (Auto-Loaded)

⚠️ CRITICAL INSTRUCTIONS - Proactive Superflow Usage

Active Superflows System

You have access to 8 intelligent superflows...
```

**Verify in debug log:**
```bash
grep "SessionStart" ~/.claude/debug/latest
```
Should see: Hook execution, NOT "Skipping SessionStart"

**Status:** ✅ Pass / ❌ Fail

---

## Test 2: Refactoring Safety Protocol 🛡️ (ENFORCED)

**What it does:** BLOCKS refactoring without tests - strongest enforcement

**How to test:**
Type this prompt:
```
I want to refactor the authentication module to use async/await
```

**Expected behavior:**
1. Claude MUST output: "🛡️ Refactoring Safety Protocol activated"
2. Claude MUST use TodoWrite with 6 mandatory steps
3. Claude MUST acknowledge the iron law
4. Claude CANNOT proceed without creating tests first

**Expected message includes:**
```
IRON LAW: NO REFACTORING WITHOUT TESTS

MANDATORY FIRST RESPONSE:
You MUST output this EXACT text...

BLOCKING REQUIREMENT:
- You CANNOT proceed with refactoring until you acknowledge this protocol
```

**Verify:**
- [ ] Activation message shown
- [ ] TodoWrite created with 6 steps
- [ ] Claude checks for existing tests
- [ ] Claude refuses to refactor without tests
- [ ] `refactoring-safety-protocol` skill is mentioned/used

**Status:** ✅ Pass / ❌ Fail

---

## Test 3: Debugging Superflow 🐛

**What it does:** Forces memory search before debugging (saves 2-5 min)

**How to test:**
Type this prompt:
```
There's a bug in the login form - users can't submit their credentials
```

**Expected behavior:**
1. Claude MUST output: "🐛 Debugging Superflow activated"
2. Claude MUST use TodoWrite with 5 steps
3. Claude MUST run `/quick-fix` or `/recall-bug` FIRST
4. Claude MUST check memory before investigating new solutions

**Expected message includes:**
```
Before investigating, I will check memory for known solutions:
- Running /quick-fix to search for this exact issue
- If not found, running /recall-bug for similar past bugs
```

**Verify:**
- [ ] Activation message shown
- [ ] TodoWrite created with 5 steps
- [ ] Claude actually runs `/quick-fix` or `/recall-bug`
- [ ] Memory search happens BEFORE manual debugging
- [ ] `memory-assisted-debugging` or `systematic-debugging` skill mentioned

**Status:** ✅ Pass / ❌ Fail

---

## Test 4: Feature Development Superflow 🏗️

**What it does:** Enforces spec-kit workflow with memory search

**How to test:**
Type this prompt:
```
I want to implement a new feature for user profile management
```

**Expected behavior:**
1. Claude MUST output: "🏗️ Feature Development Superflow activated"
2. Claude MUST use TodoWrite with workflow steps
3. Claude MUST run `/recall-feature` FIRST
4. Claude MUST follow: Constitution → Specify → Clarify → Plan

**Expected message includes:**
```
I will follow the complete spec-kit workflow:
1. Run /recall-feature to check for similar past implementations
2. Use memory-assisted-spec-kit skill
3. Use spec-kit-orchestrator: Constitution → Specify → Clarify → Plan
```

**Verify:**
- [ ] Activation message shown
- [ ] TodoWrite created
- [ ] Claude runs `/recall-feature` before planning
- [ ] `spec-kit-orchestrator` skill is used
- [ ] `/check-integration` and `/ship-check` mentioned for end

**Status:** ✅ Pass / ❌ Fail

---

## Test 5: UI Development Superflow 🎨

**What it does:** Forces library search before building UI from scratch

**How to test:**
Type this prompt:
```
I need to create a hero section with a pricing table
```

**Expected behavior:**
1. Claude MUST output: "🎨 UI Development Superflow activated"
2. Claude MUST use TodoWrite with 5 steps
3. Claude MUST suggest `/find-ui` with a search pattern
4. Claude MUST mention shadcn/ui blocks

**Expected message includes:**
```
IRON LAW: SEARCH BEFORE BUILD
- ALWAYS check /find-ui FIRST
- ALWAYS consider shadcn/ui blocks SECOND
- ONLY build from scratch as last resort
```

**Verify:**
- [ ] Activation message shown
- [ ] TodoWrite created
- [ ] Claude suggests `/find-ui "hero"` or similar
- [ ] `using-shadcn-ui` skill mentioned (829 blocks)
- [ ] `error-handling-patterns` skill mentioned

**Status:** ✅ Pass / ❌ Fail

---

## Test 6: Verification Before Completion ✅ (ENFORCED)

**What it does:** BLOCKS completion claims without fresh evidence

**How to test:**
Type this prompt:
```
I'm done with the implementation, everything is complete
```

**Expected behavior:**
1. Claude MUST output: "✅ Verification Protocol activated"
2. Claude MUST use TodoWrite with 5 verification steps
3. Claude MUST run `/check-integration` and `/ship-check`
4. Claude CANNOT claim completion without actual command output

**Expected message includes:**
```
IRON LAW: NO COMPLETION CLAIMS WITHOUT FRESH EVIDENCE

BLOCKING REQUIREMENTS:
- You CANNOT claim work is complete without running verification commands
- You CANNOT use cached/old test results
- You MUST provide actual command output as evidence
```

**Verify:**
- [ ] Activation message shown
- [ ] TodoWrite created with 5 verification steps
- [ ] Claude runs `/check-integration`
- [ ] Claude runs `/ship-check`
- [ ] Claude provides FRESH test output (not assumptions)
- [ ] `verification-before-completion` skill mentioned

**Status:** ✅ Pass / ❌ Fail

---

## Test 7: Rapid Prototyping Superflow 🚀

**What it does:** Guides MVP development with quality gates

**How to test:**
Type this prompt:
```
I need to build a quick MVP for user authentication
```

**Expected behavior:**
1. Claude MUST output: "🚀 Rapid Prototyping Superflow activated"
2. Claude MUST use TodoWrite with steps
3. Claude MUST consider Build vs Buy vs Integrate
4. Claude MUST still enforce quality (no broken MVPs)

**Expected message includes:**
```
Use rapid-prototyping skill for strategic decisions:
- Focus on what NOT to build
- Build vs Buy vs Integrate matrix
- Fast ≠ Broken (still use verification-before-completion)
```

**Verify:**
- [ ] Activation message shown
- [ ] TodoWrite created
- [ ] `rapid-prototyping` skill mentioned
- [ ] `/find-ui` suggested for UI components
- [ ] Verification still required at end

**Status:** ✅ Pass / ❌ Fail

---

## Test 8: Security Hardening Workflow 🔐

**What it does:** Enforces comprehensive security review

**How to test:**
Type this prompt:
```
There's a security vulnerability in our authentication system
```

**Expected behavior:**
1. Claude MUST output: "🔐 Security Hardening Workflow activated"
2. Claude MUST use TodoWrite with 6 security steps
3. Claude MUST run `/security-scan`
4. Claude MUST check OWASP Top 10

**Expected message includes:**
```
IRON LAW: SECURITY FIRST
- ALWAYS scan before implementing fixes
- NEVER trust client-side data
- ALWAYS validate all user input
```

**Verify:**
- [ ] Activation message shown
- [ ] TodoWrite created with 6 steps
- [ ] `/security-scan` command run
- [ ] `security-patterns` skill mentioned
- [ ] OWASP Top 10 compliance checked

**Status:** ✅ Pass / ❌ Fail

---

## Test 9: Performance Optimization Workflow ⚡

**What it does:** Enforces profiling before optimization

**How to test:**
Type this prompt:
```
The dashboard is loading too slow, we need to optimize it
```

**Expected behavior:**
1. Claude MUST output: "⚡ Performance Optimization Workflow activated"
2. Claude MUST use TodoWrite with 6 steps
3. Claude MUST run `/perf-check`
4. Claude MUST profile BEFORE optimizing

**Expected message includes:**
```
IRON LAW: PROFILE FIRST, OPTIMIZE SECOND
- NO optimization without profiling first
- ALWAYS measure impact
- Fix bottlenecks, not symptoms
```

**Verify:**
- [ ] Activation message shown
- [ ] TodoWrite created with 6 steps
- [ ] `/perf-check` command run
- [ ] `performance-optimization` skill mentioned
- [ ] Before and after metrics required

**Status:** ✅ Pass / ❌ Fail

---

## Test 10: Dependency Update Workflow 📦

**What it does:** Enforces incremental dependency updates

**How to test:**
Type this prompt:
```
We need to update our npm packages to fix security vulnerabilities
```

**Expected behavior:**
1. Claude MUST output: "📦 Dependency Update Workflow activated"
2. Claude MUST use TodoWrite with 6 steps
3. Claude MUST update ONE package at a time
4. Claude MUST test after EACH update

**Expected message includes:**
```
IRON LAW: INCREMENTAL UPDATES
- ONE package at a time
- TEST after each update
- NEVER batch security + feature updates
```

**Verify:**
- [ ] Activation message shown
- [ ] TodoWrite created with 6 steps
- [ ] `dependency-management` skill mentioned
- [ ] One-at-a-time update strategy enforced
- [ ] Tests run after each update

**Status:** ✅ Pass / ❌ Fail

---

## Test 11: Learning Mode Workflow 🎓

**What it does:** Provides comprehensive explanations with memory context

**How to test:**
Type this prompt:
```
Can you explain how authentication works in this codebase?
```

**Expected behavior:**
1. Claude MUST output: "🎓 Learning Mode Workflow activated"
2. Claude MUST use TodoWrite with 6 steps
3. Claude MUST run `/explain-code`
4. Claude MUST use concrete examples from YOUR codebase

**Expected message includes:**
```
LEARNING PRINCIPLES:
- Show, don't just tell
- Use concrete examples from THIS codebase
- Build on existing knowledge
```

**Verify:**
- [ ] Activation message shown
- [ ] TodoWrite created with 6 steps
- [ ] `/explain-code` command run
- [ ] `/recall-pattern` suggested
- [ ] Concrete examples provided

**Status:** ✅ Pass / ❌ Fail

---

## Test 12: Hook Visibility in Debug Log

**What it does:** Verifies hooks are actually executing

**How to test:**
```bash
# In separate terminal, watch the debug log
tail -f ~/.claude/debug/latest
```

Then trigger any superflow (e.g., type "refactor the code")

**Expected in debug log:**
```
[DEBUG] Running hook: UserPromptSubmit
[DEBUG] Hook completed: UserPromptSubmit
[DEBUG] Hook output: {"hookSpecificOutput":{"hookEventName":"UserPromptSubmit",...}}
```

**Should NOT see:**
```
[DEBUG] Skipping SessionStart - workspace trust not accepted
[ERROR] Hook execution failed
[ERROR] Plugin path not found
```

**Verify:**
- [ ] Hooks execute without errors
- [ ] Hook output contains additionalContext
- [ ] No "Skipping" messages
- [ ] No path errors

**Status:** ✅ Pass / ❌ Fail

---

## Test 13: Commands Availability

**What it does:** Verifies all custom commands are loaded

**How to test:**
Type `/` in Claude Code and check the command menu

**Expected commands:**
- `/check-integration` - Full-stack verification
- `/continue-work` - Resume previous work
- `/explain-code` - Historical context
- `/find-ui` - Search premium UI library
- `/perf-check` - Performance profiling
- `/quick-fix` - Fast bug search
- `/recall-bug` - Search past bugs
- `/recall-feature` - Search past features
- `/recall-pattern` - Search implementation patterns
- `/security-scan` - Security vulnerability scan
- `/ship-check` - Pre-deployment validation
- `/test-assist` - Test generation help

**Verify:**
- [ ] All 12 commands visible in menu
- [ ] Commands have descriptions
- [ ] Commands are executable

**Status:** ✅ Pass / ❌ Fail

---

## Test 14: Multiple Superflows in One Prompt

**What it does:** Tests multiple pattern detection

**How to test:**
Type this prompt:
```
I need to refactor the authentication bug and then implement a new UI component
```

**Expected behavior:**
1. Multiple superflows should activate
2. Should see: 🛡️ Refactoring + 🐛 Debugging + 🎨 UI Development
3. TodoWrite should include steps from all relevant workflows

**Verify:**
- [ ] Multiple superflow icons shown
- [ ] Combined TodoWrite with all steps
- [ ] All relevant commands suggested
- [ ] No conflicts between workflows

**Status:** ✅ Pass / ❌ Fail

---

## Test 15: Git Commit Detection (PreToolUse Hook)

**What it does:** Detects git operations and triggers validation

**How to test:**
Type this prompt:
```
Create a git commit with the message "Add user authentication"
```

**Expected behavior:**
1. `detect-git-operations.sh` hook should execute
2. Should see pre-commit validation reminders
3. Should suggest `/ship-check` before committing

**Verify in debug log:**
```bash
grep "detect-git-operations" ~/.claude/debug/latest
```

**Verify:**
- [ ] Hook executes on git commit commands
- [ ] Pre-commit validation shown
- [ ] `/ship-check` suggested

**Status:** ✅ Pass / ❌ Fail

---

## Test 16: Test Verification (PostToolUse Hook)

**What it does:** Verifies tests after running test commands

**How to test:**
1. Ask Claude to run tests: "Run the test suite"
2. After tests execute, check for verification hook

**Expected behavior:**
1. `verify-tests.sh` hook should execute after Bash tool
2. Should verify tests passed
3. Should flag if tests failed

**Verify in debug log:**
```bash
grep "verify-tests" ~/.claude/debug/latest
```

**Verify:**
- [ ] Hook executes after test commands
- [ ] Test results analyzed
- [ ] Failures flagged

**Status:** ✅ Pass / ❌ Fail

---

## Comprehensive Test Summary

| # | Superflow | Status | Notes |
|---|-----------|--------|-------|
| 1 | Session Start 🔄 | ⬜ | |
| 2 | Refactoring 🛡️ | ⬜ | ENFORCED |
| 3 | Debugging 🐛 | ⬜ | |
| 4 | Feature Dev 🏗️ | ⬜ | |
| 5 | UI Development 🎨 | ⬜ | |
| 6 | Verification ✅ | ⬜ | ENFORCED |
| 7 | Rapid Proto 🚀 | ⬜ | |
| 8 | Security 🔐 | ⬜ | |
| 9 | Performance ⚡ | ⬜ | |
| 10 | Dependencies 📦 | ⬜ | |
| 11 | Learning 🎓 | ⬜ | |
| 12 | Hook Logs | ⬜ | |
| 13 | Commands | ⬜ | |
| 14 | Multi-Pattern | ⬜ | |
| 15 | Git Detection | ⬜ | |
| 16 | Test Verify | ⬜ | |

---

## Troubleshooting

### If superflows don't activate:

1. **Check workspace trust:**
   ```bash
   grep "trust" ~/.claude/debug/latest
   ```
   Should NOT see: "Skipping SessionStart - workspace trust not accepted"

2. **Check plugin loaded:**
   ```bash
   grep "developer-skills" ~/.claude/debug/latest
   ```
   Should see: "Loading plugin developer-skills from source"
   Should NOT see: "Plugin path not found"

3. **Check hooks registered:**
   ```bash
   grep "Registered.*hooks" ~/.claude/debug/latest
   ```
   Should see: "Registered X hooks from Y plugins"

4. **Check hook execution:**
   ```bash
   grep "Running hook" ~/.claude/debug/latest
   ```
   Should see hooks executing for each event

### If commands don't appear:

1. **Check plugin.json:**
   ```bash
   cat ~/.claude/plugins/developer-skills/.claude-plugin/plugin.json
   ```
   Should include: `"commands": "./commands"`

2. **Check commands loaded:**
   ```bash
   grep "plugin commands loaded" ~/.claude/debug/latest
   ```
   Should see: "Total plugin commands loaded: 12"

3. **Restart Claude Code:**
   ```bash
   # Exit completely and restart
   claude
   ```

---

## Success Criteria

All superflows working when:
- ✅ All 16 tests pass
- ✅ No errors in debug log
- ✅ Hooks execute automatically
- ✅ Commands visible in menu
- ✅ TodoWrite created for each workflow
- ✅ Enforcement blocks actually prevent actions

**Current Status:** [Fill in after testing]

**Date Tested:** [Fill in]

**Tester:** [Fill in]
