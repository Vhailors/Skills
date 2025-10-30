# Quick Test Prompts for All Superflows

## Copy-paste these prompts to test each superflow

### 🔄 Test 1: Session Start
**How:** Just start Claude Code (should auto-activate)
**Expected:** "🔄 Session Continuity (Auto-Loaded)" message

---

### 🛡️ Test 2: Refactoring (ENFORCED)
**Prompt:**
```
I want to refactor the authentication module to use async/await
```
**Expected:** "🛡️ Refactoring Safety Protocol activated" + TodoWrite + IRON LAW message

---

### 🐛 Test 3: Debugging
**Prompt:**
```
There's a bug in the login form - users can't submit their credentials
```
**Expected:** "🐛 Debugging Superflow activated" + TodoWrite + /quick-fix or /recall-bug runs

---

### 🏗️ Test 4: Feature Development
**Prompt:**
```
I want to implement a new feature for user profile management
```
**Expected:** "🏗️ Feature Development Superflow activated" + TodoWrite + /recall-feature runs

---

### 🎨 Test 5: UI Development
**Prompt:**
```
I need to create a hero section with a pricing table
```
**Expected:** "🎨 UI Development Superflow activated" + TodoWrite + /find-ui suggested

---

### ✅ Test 6: Verification (ENFORCED)
**Prompt:**
```
I'm done with the implementation, everything is complete
```
**Expected:** "✅ Verification Protocol activated" + TodoWrite + /check-integration + /ship-check

---

### 🚀 Test 7: Rapid Prototyping
**Prompt:**
```
I need to build a quick MVP for user authentication
```
**Expected:** "🚀 Rapid Prototyping Superflow activated" + TodoWrite + rapid-prototyping skill

---

### 🔐 Test 8: Security
**Prompt:**
```
There's a security vulnerability in our authentication system
```
**Expected:** "🔐 Security Hardening Workflow activated" + TodoWrite + /security-scan

---

### ⚡ Test 9: Performance
**Prompt:**
```
The dashboard is loading too slow, we need to optimize it
```
**Expected:** "⚡ Performance Optimization Workflow activated" + TodoWrite + /perf-check

---

### 📦 Test 10: Dependencies
**Prompt:**
```
We need to update our npm packages to fix security vulnerabilities
```
**Expected:** "📦 Dependency Update Workflow activated" + TodoWrite + incremental strategy

---

### 🎓 Test 11: Learning
**Prompt:**
```
Can you explain how authentication works in this codebase?
```
**Expected:** "🎓 Learning Mode Workflow activated" + TodoWrite + /explain-code

---

### 🔍 Test 12: Pattern Recall
**Prompt:**
```
How did we implement the user registration pattern?
```
**Expected:** Suggestion to use /recall-pattern

---

### 🔧 Test 13: Code Explanation
**Prompt:**
```
What does this authentication middleware do?
```
**Expected:** Suggestion to use /explain-code

---

### 🚨 Test 14: Multi-Pattern Detection
**Prompt:**
```
I need to refactor the authentication bug and then implement a new UI component
```
**Expected:** Multiple superflow activations (🛡️ + 🐛 + 🎨)

---

### 📝 Test 15: Git Commit Detection
**Prompt:**
```
Create a git commit with the message "Add user authentication"
```
**Expected:** Pre-commit validation + /ship-check suggestion

---

### 🧪 Test 16: Test Verification
**Prompt:**
```
Run the test suite
```
**Expected:** After execution, test verification hook should analyze results

---

## Quick Debug Commands

### Check if hooks are running:
```bash
tail -f ~/.claude/debug/latest | grep -E "hook|Hook"
```

### Check if plugin loaded:
```bash
grep "developer-skills" ~/.claude/debug/latest | tail -20
```

### Check workspace trust:
```bash
grep "trust" ~/.claude/debug/latest | tail -5
```

### Check SessionStart execution:
```bash
grep "SessionStart" ~/.claude/debug/latest | tail -10
```

### Check available commands:
Type `/` in Claude Code and look for custom commands

---

## Expected Workflow for Each Test

Every superflow should follow this pattern:

1. **Activation Message**
   - Format: "[Icon] [Name] Superflow activated"
   - Must be VISIBLE to user

2. **TodoWrite Creation**
   - Immediately after activation
   - Contains all workflow steps
   - Shows user the plan

3. **Proactive Tool Usage**
   - Actually RUN suggested commands (/quick-fix, /recall-bug, etc.)
   - Actually USE suggested skills
   - Don't just MENTION them

4. **Follow Workflow**
   - Complete all steps in TodoWrite
   - Don't skip steps
   - Mark as completed when done

---

## Fastest Way to Test All

Run this test sequence in order:

1. Restart Claude Code → Should see Session Start
2. Type: "refactor the code" → Should see Refactoring (ENFORCED)
3. Type: "there's a bug" → Should see Debugging
4. Type: "implement a feature" → Should see Feature Dev
5. Type: "create a UI component" → Should see UI Dev
6. Type: "I'm done" → Should see Verification (ENFORCED)
7. Check debug log for errors

If all 6 tests pass, your superflows are working!

---

## Success Indicators

✅ **Working:**
- Activation messages appear
- TodoWrite created automatically
- Commands suggested/executed
- Skills mentioned
- Debug log shows hook execution

❌ **Not Working:**
- No activation messages
- No TodoWrite
- Commands only mentioned, not executed
- Debug log shows "Skipping" or errors
- Workspace not trusted
