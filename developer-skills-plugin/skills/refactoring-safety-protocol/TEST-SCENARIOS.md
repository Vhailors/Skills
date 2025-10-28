# Test Scenarios: Refactoring Safety Protocol

## Purpose
Establish baseline behavior of agents WITHOUT refactoring-safety-protocol skill to identify gaps.

## Test Scenario 1: Refactoring Without Understanding Context

**User Request:** "Refactor the `calculateTotal` function to be more concise"

**Expected Baseline Behavior (WITHOUT skill):**
- Agent reads the function
- Proposes cleaner version (maybe using reduce, map, etc.)
- Rewrites the function
- Doesn't search memory for WHY it was written this way
- Doesn't check if there are tests covering it
- Doesn't identify dependencies or callers

**Gap Identified:**
- Agent doesn't understand original design rationale
- May break subtle behavior the original handled
- Doesn't verify tests exist before refactoring
- Missing context leads to regressions

**What the skill should do:**
- BEFORE refactoring, search memory: "Why was calculateTotal written this way?"
- Check for tests covering this function
- Identify all callers/dependencies
- Understand edge cases the original handled
- Propose refactor that preserves ALL behavior

---

## Test Scenario 2: Breaking Subtle Edge Cases

**User Request:** "Simplify this validation function, it's too complex"

**Context:** Function handles 3 edge cases that look redundant but aren't:
```javascript
function validateUser(user) {
  if (!user) return false;
  if (!user.id) return false;  // Looks redundant
  if (user.id === 0) return false;  // Actually catches 0 (falsy)
  return true;
}
```

**Expected Baseline Behavior (WITHOUT skill):**
- Agent sees redundancy: "user.id check is redundant if !user"
- Simplifies to:
```javascript
function validateUser(user) {
  return user && user.id;  // BREAKS: id=0 is now truthy
}
```
- Doesn't test edge case where id=0
- Ships breaking change

**Gap Identified:**
- Agent doesn't preserve edge case handling
- Simplification introduces bug
- No test verification before claiming "simplified"

**What the skill should do:**
- Search memory for bug reports related to this function
- Check tests: "Is there a test for id=0?"
- If no tests, CREATE tests before refactoring
- Verify refactored version passes ALL tests
- If edge case not tested, document it

---

## Test Scenario 3: Refactoring Without Test Coverage

**User Request:** "Refactor the authentication middleware"

**Context:** No tests exist for this middleware

**Expected Baseline Behavior (WITHOUT skill):**
- Agent refactors the middleware code
- Makes it "cleaner" or "more maintainable"
- Doesn't check if tests exist
- Doesn't run any verification
- Says "Refactored successfully!"

**Gap Identified:**
- Zero test coverage before refactoring
- No way to verify behavior preserved
- High risk of breaking authentication
- Claims success without evidence

**What the skill should do:**
- STOP refactoring if no tests exist
- Say: "I cannot safely refactor without tests. Let me write tests first."
- Write tests that cover current behavior
- Verify tests pass with current implementation
- THEN refactor
- Verify tests still pass
- ONLY THEN claim success

---

## Test Scenario 4: Unknown Dependencies

**User Request:** "Extract this utility function to a shared module"

**Context:** Function is used in 8 places across the codebase

**Expected Baseline Behavior (WITHOUT skill):**
- Agent moves function to utils.js
- Updates import in current file
- Doesn't search for other usages
- Breaks 7 other files silently

**Gap Identified:**
- Doesn't identify all callers
- Incomplete refactoring (only updates one file)
- Breaks other parts of codebase
- No dependency analysis

**What the skill should do:**
- BEFORE moving, search all usages: grep/rg for function name
- List all files that call this function
- Show user: "This function is used in 8 places: [list]"
- Ask: "Should I update all 8 imports?"
- Update ALL usages
- Verify no broken imports

---

## Test Scenario 5: Memory Context Ignored

**User Request:** "Refactor this database query to use an ORM"

**Context (from memory):** Session #12 - "Tried using ORM for similar query, caused N+1 problem, reverted to raw SQL"

**Expected Baseline Behavior (WITHOUT skill):**
- Agent rewrites query using ORM
- Makes it look cleaner
- Doesn't search memory for past attempts
- Reintroduces N+1 problem that was already fixed
- Doesn't know this was tried and failed

**Gap Identified:**
- Repeats past mistakes
- Undoes previous fixes
- Doesn't learn from history
- Wastes time on known-failed approach

**What the skill should do:**
- Search memory: "ORM refactor", "database query refactor"
- Find session #12 with failed attempt
- Say: "This was tried before (session #12) and caused N+1 issues"
- Show user the history
- Propose different approach OR explain why original is best

---

## Test Scenario 6: No Rollback Plan

**User Request:** "Refactor the user authentication system"

**Context:** Large, critical refactor

**Expected Baseline Behavior (WITHOUT skill):**
- Agent refactors entire auth system at once
- Makes many changes simultaneously
- No incremental approach
- No rollback plan
- If something breaks, unclear how to revert

**Gap Identified:**
- All-or-nothing approach
- High risk, no safety net
- Can't easily revert if issues found
- No git strategy

**What the skill should do:**
- Propose incremental refactoring approach
- Step 1: Add tests for current behavior
- Step 2: Refactor small piece
- Step 3: Verify tests pass
- Step 4: Commit (with revert instructions)
- Repeat for next piece
- Document: "If issues arise, revert commit ABC"

---

## Test Scenario 7: Performance Regression

**User Request:** "Refactor this loop to be more readable"

**Context:** Current loop is optimized for performance (processes 10k items)

**Expected Baseline Behavior (WITHOUT skill):**
- Agent rewrites loop for readability
- Uses cleaner syntax (array methods, etc.)
- Doesn't consider performance impact
- New version is 10x slower
- Doesn't benchmark before/after

**Gap Identified:**
- Readability vs. performance trade-off ignored
- No performance testing
- Regression not detected
- Claims "improved" when actually degraded

**What the skill should do:**
- Check if this is performance-critical code
- Search memory for performance issues with this function
- Benchmark current implementation
- Refactor
- Benchmark new implementation
- Compare: "Old: 50ms, New: 500ms - REGRESSION"
- Reject refactor if performance degrades
- OR warn user about trade-off

---

## Summary of Baseline Gaps

| Gap Category | Impact | Skill Solution |
|-------------|--------|---------------|
| No context understanding | Break subtle behavior | Search memory for design rationale |
| Edge cases ignored | Introduce bugs | Preserve all edge case handling |
| Missing test coverage | Unsafe refactoring | Require tests before refactoring |
| Unknown dependencies | Partial updates, broken code | Identify all callers before moving |
| Memory ignored | Repeat past mistakes | Check history for failed attempts |
| No rollback plan | Risk with no safety net | Incremental approach with revert plan |
| Performance not tested | Performance regressions | Benchmark before/after |

---

## Next Step: RED Phase Testing

Run these scenarios with subagents WITHOUT the skill to document actual baseline behavior and confirm these gaps exist.
