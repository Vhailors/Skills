---
name: refactoring-safety-protocol
description: Use when refactoring existing code - requires tests before changes, searches memory for design rationale, verifies behavior preservation through empirical validation, prevents regressions with incremental approach and rollback plan
---

# Refactoring Safety Protocol

## Overview

**Never refactor without a safety net. Tests are not optional.**

This skill enforces systematic safety checks before and during refactoring. It prevents breaking working code through empirical validation, historical context, and incremental changes.

**Core principle:** Logical reasoning about correctness is not enough. Tests must prove behavior is preserved.

**The Iron Law:**
```
NO REFACTORING WITHOUT TESTS
NO TESTS = WRITE TESTS FIRST
NO EXCEPTIONS
```

## When to Use

Use this skill when:
- **Refactoring existing code** - Making structural changes without changing behavior
- **Cleaning up code** - Simplifying, extracting, renaming
- **Performance optimization** - Changing implementation for speed
- **Updating patterns** - Modernizing code (callbacks → async/await, etc.)
- **User says "refactor"** - Any refactoring request

**Triggers:**
- "Refactor", "simplify", "clean up", "extract", "rename"
- "Make this more readable", "modernize this code"
- "Optimize", "improve performance"
- Before modifying working code

**DO NOT use for:**
- New features (use spec-kit-orchestrator)
- Bug fixes (use systematic-debugging)
- First implementation (nothing to refactor yet)

## Prerequisites

**Before ANY refactoring:**
- Code is working (not broken)
- Tests exist OR can be written
- Have memory/context access (claude-mem if available)

**Integration:**
- Works WITH memory-assisted-debugging (check history)
- Works WITH verification-before-completion (prove tests pass)
- Works WITH spec-kit-orchestrator (if refactor changes behavior)

## The Safety Protocol (8 Mandatory Steps)

### Step 1: STOP - Check for Tests FIRST

**BEFORE touching any code:**

```bash
# Search for test files related to code being refactored
find . -name "*[filename]*test*"
find . -name "*[filename]*spec*"
grep -r "describe.*[FunctionName]" tests/
```

**Three outcomes:**

**A) Tests exist** ✅
- Proceed to Step 2

**B) Tests don't exist** ❌
- **STOP refactoring immediately**
- Say: "I cannot safely refactor without tests. Let me write tests first."
- Write tests that cover current behavior
- Verify tests pass with current implementation
- THEN proceed to Step 2

**C) Unsure if tests exist** ⚠️
- Ask user: "Are there tests for this code?"
- If no: Go to B (write tests first)
- If yes: Find them, verify they pass

**No exceptions to this rule:**
- "It's a simple refactor" → Still need tests
- "I'm confident it's correct" → Confidence ≠ proof
- "The tests are elsewhere" → Find and verify them
- "I'll test manually" → Manual testing ≠ automated safety net

### Step 2: Search Memory for Context

**Before changing code, understand WHY it was written this way:**

**Query memory (if available):**
```
mcp__claude_mem__search_observations("[filename]")
mcp__claude_mem__find_by_file("[filepath]")
mcp__claude_mem__search_user_prompts("refactor [function-name]")
```

**Look for:**
- Design decisions: "Why this pattern?"
- Past attempts: "Was this refactored before?"
- Known issues: "What bugs were fixed here?"
- Edge cases: "What special cases does this handle?"

**If memory unavailable:**
- Check git history: `git log -p [filepath]`
- Check commit messages: `git blame [filepath]`
- Look for code comments explaining rationale

**Red flags from memory:**
- "Tried X, caused bug, reverted"
- "This handles edge case Y"
- "Performance optimization, don't change"
- "Subtle behavior, be careful"

**If found → incorporate into refactoring plan**

### Step 2.5: Check Project Skills for Framework Conventions

**WHEN refactoring code that uses specific frameworks:**

1. **Look for Framework-Specific Patterns**
   - Check `.claude/project-skills/` for relevant expert skills
   - If refactoring Supabase code → check `supabase-expert/SKILL.md` for conventions
   - If refactoring Stripe integration → check `stripe-expert/SKILL.md` for best practices
   - Project skills contain framework-specific refactoring patterns

2. **Understand Framework Idioms**
   - Frameworks often have "the right way" to do things
   - Project skill Quick Reference shows idiomatic patterns
   - Check references/ for framework-specific conventions
   - Avoid refactoring TO an anti-pattern

3. **When No Project Skill Exists**
   - If repeatedly refactoring same framework code
   - Pattern detection will suggest creating expert skill
   - Generated skill includes framework best practices
   - Prevents future refactorings from violating framework conventions

**Example Integration:**
```
Refactoring: Supabase query optimization
  ↓
Check: .claude/project-skills/supabase-expert/SKILL.md
  ↓
Find: Query performance patterns section
  ↓
Apply: Framework-recommended query structure
  ↓
Result: Refactor using Supabase idioms, not anti-patterns
```

### Step 3: Identify All Dependencies

**Find who uses this code:**

```bash
# Search for all usages
grep -r "functionName" . --exclude-dir=node_modules
rg "functionName" --type js

# For imports/requires
grep -r "import.*filename" .
grep -r "require.*filename" .
```

**Document:**
- How many files use this?
- What are the call patterns?
- Are there edge case usages?
- Will refactor affect callers?

**If breaking callers:**
- Update ALL callers in same refactor
- OR change approach to preserve interface

### Step 4: Run Tests (Baseline)

**BEFORE any changes, verify current tests pass:**

```bash
npm test [test-file]
pytest tests/test_[module].py
cargo test [test-name]
```

**Expected outcome:** All tests pass ✅

**If tests fail:**
- **STOP refactoring**
- Code is already broken
- Fix failing tests first
- THEN refactor

**Record baseline:**
- Test count: "12 tests passing"
- Performance (if relevant): "Runs in 45ms"

### Step 5: Incremental Refactoring

**Make changes in SMALL, verifiable steps:**

**Bad approach:**
- Refactor entire file at once
- Make 20 changes simultaneously
- Test at the end

**Good approach:**
- Change ONE thing
- Run tests immediately
- If pass → commit
- If fail → revert, understand why
- Proceed to next change

**Example incremental approach:**

```
Step 5a: Extract helper function
  → Run tests → Pass ✅ → Commit

Step 5b: Replace first usage with helper
  → Run tests → Pass ✅ → Commit

Step 5c: Replace second usage with helper
  → Run tests → Pass ✅ → Commit

Step 5d: Remove old inline code
  → Run tests → Pass ✅ → Commit
```

**Each commit is a safe rollback point.**

### Step 6: Run Tests (After Each Change)

**After EVERY incremental change:**

```bash
# Run the same test command as Step 4
npm test [test-file]
```

**Required outcomes:**
- ✅ Same number of tests pass
- ✅ No new failures
- ✅ Performance comparable (if relevant)

**If tests fail:**
- **DO NOT PROCEED**
- Revert the change: `git checkout [file]`
- Understand why it failed
- Fix approach
- Try again

**If tests pass:**
- ✅ Commit: `git commit -m "refactor: [specific change]"`
- Document: "Step 5a complete, tests passing"
- Proceed to next incremental change

### Step 7: Verify Behavior Preservation

**After all changes complete, comprehensive validation:**

**A) All tests still pass**
```bash
# Run FULL test suite (not just affected tests)
npm test
```

**B) No regressions introduced**
- Check test coverage didn't decrease
- Verify edge cases still handled
- Confirm performance not degraded

**C) Compare before/after**
```markdown
## Refactor Summary

**Before:**
- 12 tests passing
- Function complexity: 8
- Performance: 45ms

**After:**
- 12 tests passing ✅ (same count)
- Function complexity: 4 ✅ (improved)
- Performance: 43ms ✅ (comparable)

**Behavior preserved:** Yes, all tests pass
```

### Step 8: Document Changes and Rollback Plan

**Create clear commit with rollback instructions:**

```bash
git commit -m "refactor: simplify validateUser function

- Reduced cyclomatic complexity from 8 to 4
- Preserved all edge case handling (id===0)
- Tests: 12/12 passing
- Performance: comparable (45ms → 43ms)

Rollback: git revert HEAD if issues found
Verified: All tests passing, no behavior change"
```

**Provide rollback instructions:**
```markdown
## If Issues Found

**Immediate rollback:**
git revert [commit-hash]

**Specific file rollback:**
git checkout [previous-commit] [filepath]

**Verification after rollback:**
npm test  # Should all pass
```

## Common Mistakes

### ❌ "It's a simple refactor, don't need tests"
**Reality:** Simple refactors break too. Tests are ALWAYS required.

**Fix:** No exceptions. Write tests if they don't exist.

### ❌ "I'll test manually after"
**Reality:** Manual testing catches obvious breaks, misses subtle regressions.

**Fix:** Automated tests are non-negotiable. Manual testing is supplementary.

### ❌ "Tests exist but I didn't run them"
**Reality:** You don't know if your refactor broke anything.

**Fix:** Run tests before AND after. Both times. No exceptions.

### ❌ "Logical reasoning proves it's correct"
**Reality:** Edge cases, race conditions, and subtle bugs defy logical reasoning.

**Fix:** Trust tests, not logic. Empirical validation required.

### ❌ "Refactored everything at once"
**Reality:** When tests fail, impossible to identify which change broke it.

**Fix:** Incremental changes with tests after each. One change = one commit.

### ❌ "Tests failed but I'm confident"
**Reality:** Confidence ≠ correctness. Tests found a real issue.

**Fix:** Never override failing tests. Understand why, fix approach.

## Red Flags - STOP Immediately

**If you think:**
- "Tests aren't necessary for this"
- "I'm confident this is correct"
- "It's just a cleanup, can't break anything"
- "I'll make all changes then test"
- "Tests failed but it's probably fine"
- "No tests exist, but I'll be careful"

**All of these mean:** You're about to break working code. STOP and follow the protocol.

## Refactoring Decision Tree

```
User requests refactor
    │
    ↓
Do tests exist?
    │
    ├─ YES → Run tests (baseline)
    │         │
    │         ├─ PASS → Continue to memory search
    │         └─ FAIL → STOP, fix tests first
    │
    └─ NO → STOP
             │
             Say: "Cannot refactor without tests"
             │
             Write tests for current behavior
             │
             Verify tests pass
             │
             THEN continue to memory search
```

## Example: Safe Refactoring Flow

**User:** "Refactor the calculateDiscount function"

**Step 1: Check for tests**
```bash
grep -r "calculateDiscount" tests/
# Found: tests/pricing.test.js
```
✅ Tests exist

**Step 2: Search memory**
```
mcp__claude_mem__search_observations("calculateDiscount")
# Found: Session #45 - "Added special handling for bulk orders"
```
⚠️ Note: Preserve bulk order logic

**Step 3: Identify dependencies**
```bash
grep -r "calculateDiscount" .
# Found in: cart.js, checkout.js, invoice.js (3 files)
```
📝 3 callers identified

**Step 4: Run baseline tests**
```bash
npm test tests/pricing.test.js
# ✅ 8 tests passing
```

**Step 5: Incremental refactor**
```javascript
// Step 5a: Extract bulk discount logic
function getBulkDiscount(quantity) {
  return quantity >= 10 ? 0.15 : 0;
}
```
Run tests → ✅ Pass → Commit

```javascript
// Step 5b: Use helper in calculateDiscount
function calculateDiscount(price, quantity) {
  const bulkDiscount = getBulkDiscount(quantity);
  // ... rest of logic
}
```
Run tests → ✅ Pass → Commit

**Step 6: Verify after each change**
```bash
npm test tests/pricing.test.js
# ✅ 8 tests passing (same as baseline)
```

**Step 7: Final validation**
```bash
npm test  # All tests
# ✅ All 45 tests passing
```

**Step 8: Document and commit**
```bash
git commit -m "refactor: extract bulk discount calculation

- Extracted getBulkDiscount helper for reusability
- Preserves bulk order logic from session #45
- Tests: 8/8 passing
- No behavior change

Rollback: git revert HEAD"
```

✅ **Safe refactoring complete**

## Integration with Other Skills

**Use BEFORE refactoring:**
- **memory-assisted-debugging:** Check for past issues with this code
- **verification-before-completion:** Establish baseline tests pass

**Use DURING refactoring:**
- **This skill:** Follow 8-step protocol

**Use AFTER refactoring:**
- **verification-before-completion:** Prove tests still pass
- **full-stack-integration-checker:** If refactor affects multiple layers

## Real-World Impact

**Without this protocol:**
- Break working code
- Introduce subtle regressions
- Discover issues in production
- Spend hours fixing "simple" refactors
- Lose trust in refactoring

**With this protocol:**
- Safe refactoring with confidence
- Catch issues before commit
- Preserve all behavior
- Easy rollback if needed
- Refactor fearlessly

**Time investment:** +10-20 min for protocol
**Time saved:** Hours of debugging broken refactors

## Quick Reference

**Before ANY refactoring:**
- [ ] Check if tests exist
- [ ] If no tests: Write tests first
- [ ] Search memory for context
- [ ] Identify all dependencies
- [ ] Run baseline tests (must pass)

**During refactoring:**
- [ ] Make incremental changes (one at a time)
- [ ] Run tests after EACH change
- [ ] Commit each successful change
- [ ] Revert if tests fail

**After refactoring:**
- [ ] Run full test suite
- [ ] Verify behavior preserved
- [ ] Compare before/after metrics
- [ ] Document changes + rollback plan
- [ ] ONLY THEN claim "refactored successfully"
