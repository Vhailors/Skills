# Intelligent Automation Guide

## Overview

The developer-skills plugin isn't just a collection of skills and commands—it's an **intelligent development assistant** that orchestrates workflows automatically. This guide explains how to leverage the plugin's superflows and hooks for maximum productivity.

---

## Quick Start

### 1. Enable Hooks

The plugin's hooks are defined in `hooks/hooks.json`. To activate them:

```bash
# Check if hooks are enabled
claude config get hooks

# Enable hooks globally
claude config set hooks.enabled true
```

### 2. Experience Automated Workflows

Simply work naturally, and the plugin will:
- ✅ Auto-resume your work when you start a session
- ✅ Check memory for known issues before debugging
- ✅ Suggest pre-built UI components before you implement from scratch
- ✅ Enforce safety protocols (tests before refactoring, schema before logging)
- ✅ Validate completeness before you ship

---

## The 8 Core Superflows

### 1. Feature Development Flow

**You say**: "Implement user authentication"

**What happens automatically**:
1. 🔍 Checks `/recall-feature` for similar past implementations
2. 📋 Starts `memory-assisted-spec-kit` → `spec-kit-orchestrator` workflow
3. 🏗️ Applies `api-contract-design` + `error-handling-patterns` + `using-shadcn-ui`
4. ✅ Runs `/check-integration` to verify DB → API → Frontend
5. 🚀 Prompts `/ship-check` before commit

**Your benefit**: Consistent, high-quality feature implementation with built-in verification.

---

### 2. Intelligent Debugging Flow

**You say**: "The login is broken"

**What happens automatically**:
1. 🚀 Runs `/quick-fix` to check memory for known solutions
   - **If known**: Applies proven fix immediately
   - **If unknown**: Continues to systematic debugging
2. 🔍 Uses `memory-assisted-debugging` to check failed past solutions
3. 🧠 Applies `systematic-debugging` (4-phase root cause analysis)
4. 📖 Suggests `/explain-code` to understand affected code
5. ✅ Enforces `verification-before-completion` before claiming fixed

**Your benefit**: Faster debugging by learning from past issues. Never waste time on solved problems.

---

### 3. Safe Refactoring Flow

**You say**: "Refactor the auth middleware"

**What happens automatically**:
1. 📖 Suggests `/explain-code` to understand current implementation first
2. 🛡️ **Enforces** `refactoring-safety-protocol`: NO REFACTORING WITHOUT TESTS
3. 🔍 Checks `/recall-pattern` for past refactoring lessons
4. ✏️ Refactors with tests as safety net
5. ✅ Verifies all tests still pass

**Your benefit**: Refactor confidently without breaking existing functionality.

---

### 4. Session Continuity Flow

**You say**: *[Nothing - session starts]*

**What happens automatically**:
1. 🔄 Auto-runs `/continue-work`
2. 📚 Loads recent context from claude-mem
3. 📋 Identifies in-progress features and pending tasks
4. 💡 Suggests next actions based on last session

**Your benefit**: Pick up exactly where you left off, no context loss.

---

### 5. Pre-Ship Validation Flow

**You say**: *[About to commit]*

**What happens automatically**:
1. 💬 Prompts: "Run `/ship-check` before committing?"
2. 🔍 Validates:
   - Full-stack integration (DB → API → Frontend)
   - All acceptance criteria met
   - CRUD operations complete
   - Tests passing
   - Security checks (auth, validation)
   - Code quality
3. 📝 If passing: Suggests `changelog-generator`

**Your benefit**: Ship with confidence. Catch gaps before they reach production.

---

### 6. UI Development Flow

**You say**: "Build a pricing section"

**What happens automatically**:
1. 🎨 Suggests `/find-ui` to check premium library (51 screenshots, 100+ components)
2. 🔍 If found: Adapts existing premium component (5 min vs 45 min)
3. 🚀 If not: Suggests `using-shadcn-ui` (829 production-ready blocks)
4. ⚠️ Reminds to add error handling and loading states
5. ✅ Verifies before completion

**Your benefit**: Professional UI in minutes, not hours.

---

### 7. Rapid Prototyping Flow

**You say**: "Build an MVP for a todo app"

**What happens automatically**:
1. 🚀 Triggers `rapid-prototyping` skill (strategic build vs buy decisions)
2. 🎨 Auto-checks `/find-ui` and `using-shadcn-ui` for pre-built components
3. ⚡ Focuses on core value, leverages existing solutions
4. ✅ Maintains quality despite speed

**Your benefit**: Ship MVPs in days, not weeks.

---

### 8. Skill Creation Flow

**You say**: "Create a new skill for X"

**What happens automatically**:
1. 📝 **Enforces** `writing-skills` TDD process
2. 🔴 RED Phase: Run baseline scenarios WITHOUT skill
3. 🟢 GREEN Phase: Write skill addressing failures
4. 🔄 REFACTOR: Close loopholes, test until bulletproof

**Your benefit**: High-quality, tested skills that actually work.

---

## Intelligent Triggers

### Automatic (No Action Needed)

| Event | What Happens | Benefit |
|-------|-------------|---------|
| **Session starts** | Runs `/continue-work` | Resume instantly |
| **Error occurs** | Suggests `/quick-fix` | Check memory first |
| **"Refactor..."** | Enforces safety protocol | Tests required |
| **Before commit** | Suggests `/ship-check` | Catch gaps early |
| **"Build UI..."** | Suggests `/find-ui` | Use existing |
| **"Create API..."** | Reminds about breaking changes | Safe evolution |
| **Adding logs** | Checks logging schema first | Consistency |

### User-Initiated

| You Say | Command Triggered | What It Does |
|---------|------------------|--------------|
| "Continue where we left off" | `/continue-work` | Load context |
| "Is this a known issue?" | `/quick-fix` | Memory search |
| "How did we handle auth before?" | `/recall-pattern` | Pattern search |
| "Similar bugs in the past?" | `/recall-bug` | Bug history |
| "Explain this code" | `/explain-code` | Deep analysis |
| "Ready to ship?" | `/ship-check` | Comprehensive validation |
| "Find UI components" | `/find-ui` | Premium library search |
| "Verify integration" | `/check-integration` | Full-stack check |

---

## Hook Types Explained

### 1. **Auto-Run** (Automatic Execution)
- **Example**: Session starts → `/continue-work` runs automatically
- **Benefit**: Zero-friction context loading

### 2. **Suggest** (Prompt with Option)
- **Example**: Error detected → "Should I run `/quick-fix`?"
- **Benefit**: Intelligent assistance without being intrusive

### 3. **Enforce** (Block Until Condition Met)
- **Example**: Refactoring → "Tests required before proceeding"
- **Benefit**: Prevents costly mistakes

### 4. **Remind** (Gentle Nudge)
- **Example**: Creating API → "Remember to check breaking changes"
- **Benefit**: Best practices without blocking workflow

---

## Customizing Automation

### Enable/Disable Specific Hooks

Edit `hooks/hooks.json`:

```json
{
  "name": "session-continuity",
  "enabled": false  // Disable auto-resume
}
```

### Adjust Hook Sensitivity

Change pattern matching:

```json
{
  "condition": {
    "type": "pattern",
    "pattern": ".*(refactor|rewrite).*",  // Add more keywords
    "flags": "i"
  }
}
```

### Add Custom Hooks

```json
{
  "name": "my-custom-hook",
  "event": "OnUserMessage",
  "condition": {
    "type": "pattern",
    "pattern": ".*deploy.*",
    "flags": "i"
  },
  "action": {
    "type": "suggest",
    "message": "Run deployment checklist?",
    "command": "/ship-check"
  },
  "enabled": true
}
```

---

## Memory-Enhanced Intelligence

### The Plugin Learns From Your Work

**4 Memory Search Commands**:
1. `/recall-bug` - Similar past bugs
2. `/recall-feature` - Similar past features
3. `/recall-pattern` - Implementation patterns
4. `/recall-feature` - Technical approaches

**When Memory Helps**:
- 🐛 **Debugging**: "We fixed this exact error in Session #23"
- 🏗️ **Features**: "We built similar auth in Session #45"
- 🔧 **Patterns**: "Our standard approach for this is..."
- 🚨 **Pitfalls**: "Failed solution: Don't try X, it caused Y"

**Your benefit**: Your assistant gets smarter with every session.

---

## Iron Laws (Enforced by Hooks)

These rules are **automatically enforced** by the hook system:

### 1. NO REFACTORING WITHOUT TESTS
**Skill**: `refactoring-safety-protocol`
**Hook**: Blocks refactoring until tests exist

### 2. NO LOGGING WITHOUT SCHEMA CHECK
**Skill**: `standardized-logging`
**Hook**: Enforces schema check before adding logs

### 3. NO COMPLETION CLAIMS WITHOUT EVIDENCE
**Skill**: `verification-before-completion`
**Hook**: Requires fresh verification before claiming success

### 4. NO SKILL WITHOUT FAILING TEST FIRST
**Skill**: `writing-skills`
**Hook**: Enforces TDD process for skill creation

---

## Workflow Optimization Tips

### 1. Trust the Automation
- ✅ Let `/continue-work` run automatically
- ✅ Accept suggestions from `/quick-fix`
- ✅ Follow prompted workflows

### 2. Use Memory-First Approach
**Before debugging**: Run `/recall-bug`
**Before features**: Run `/recall-feature`
**Before architecting**: Run `/recall-pattern`

### 3. Verify Before Shipping
**Always run** `/ship-check` before:
- Creating PRs
- Committing major features
- Deploying to production

### 4. Leverage Existing Solutions
**For UI**: Always check `/find-ui` first
**For MVPs**: Use `rapid-prototyping` strategy
**For APIs**: Review `api-contract-design` patterns

---

## Real-World Impact

### Without Intelligent Automation:
- ❌ Forget to check memory (repeat solved problems)
- ❌ Skip verification steps (ship incomplete features)
- ❌ Refactor without tests (break existing code)
- ❌ Build UI from scratch (waste 40 minutes)
- ❌ Lose context between sessions
- ❌ Inconsistent logging/API patterns

### With Intelligent Automation:
- ✅ Memory-first debugging (10x faster)
- ✅ Automatic verification (catch gaps early)
- ✅ Safe refactoring (tests enforced)
- ✅ Rapid UI development (5 min vs 45 min)
- ✅ Instant session continuity
- ✅ Consistent patterns across codebase

---

## Troubleshooting

### Hooks Not Triggering?

```bash
# Check if hooks are enabled
claude config get hooks

# Enable hooks
claude config set hooks.enabled true

# Verify plugin is installed
claude plugin list
```

### Commands Not Found?

```bash
# Verify commands directory
ls -la developer-skills-plugin/commands/

# Ensure .md extension
# ✅ check-integration.md
# ❌ check-integration
```

### Want to Disable Automation?

Edit `hooks/hooks.json` and set `"enabled": false` for specific hooks.

---

## Advanced: Creating Your Own Superflows

### Step 1: Identify Workflow Pattern
- What tasks frequently occur together?
- What steps do you often forget?
- What verification is often skipped?

### Step 2: Map Skills and Commands
- Which skills should chain together?
- What commands should trigger?
- When should enforcement happen?

### Step 3: Create Hook
Add to `hooks/hooks.json`:

```json
{
  "name": "my-workflow",
  "description": "Custom workflow for X",
  "event": "OnUserMessage",
  "condition": {
    "type": "pattern",
    "pattern": ".*trigger keyword.*"
  },
  "action": {
    "type": "suggest",
    "message": "Would you like to run the X workflow?",
    "command": "/my-command"
  },
  "enabled": true
}
```

### Step 4: Test and Refine
- Test with real tasks
- Observe friction points
- Adjust patterns and actions
- Iterate based on usage

---

## Philosophy

**The right skill at the right time, automatically.**

This plugin doesn't just provide tools—it provides an **intelligent orchestration layer** that:
- 🧠 Learns from your past work
- 🛡️ Enforces best practices
- 🚀 Accelerates workflows
- ✅ Ensures completeness
- 🎯 Guides decisions

**The goal**: Development that feels like having an expert pair programmer who never forgets, always learns, and enforces quality without being annoying.

---

## Resources

- **Full Superflow Documentation**: `SUPERFLOWS.md`
- **Hook Configuration**: `hooks/hooks.json`
- **Plugin Structure**: `README.md`
- **Individual Skills**: `skills/*/SKILL.md`
- **Command Docs**: `commands/*.md`

---

## Feedback & Iteration

This automation system evolves with your workflows. If you notice:
- Hooks that trigger too often → Adjust patterns
- Missing automation opportunities → Add new hooks
- Friction points → Refine workflows

The plugin is designed to learn and adapt to your development style.

**Happy coding with intelligent assistance!** 🚀
