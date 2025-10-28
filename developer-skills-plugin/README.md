# Developer Skills Plugin

**Intelligent development assistant with 18 skills, 9 commands, and automated workflow orchestration.**

This isn't just a collection of tools—it's an intelligent system that learns from your past work, enforces best practices, and guides you through complex workflows automatically.

## 🚀 Quick Start

```bash
# Add the marketplace
claude plugin marketplace add /mnt/c/Users/Dominik/Documents/Skills/marketplace.json

# Install the plugin
claude plugin install developer-skills

# Enable intelligent automation
claude config set hooks.enabled true
```

## 🎯 What You Get

### **18 Production Skills**
1. **systematic-debugging** - 4-phase debugging framework
2. **memory-assisted-debugging** - Learn from past bugs
3. **spec-kit-orchestrator** - Spec-driven development workflow
4. **memory-assisted-spec-kit** - Memory-enhanced specs
5. **full-stack-integration-checker** - DB → API → Frontend verification
6. **verification-before-completion** - Evidence before claims
7. **refactoring-safety-protocol** - Tests required before refactoring
8. **rapid-prototyping** - MVP development in 6-day cycles
9. **api-contract-design** - RESTful patterns, breaking change detection
10. **error-handling-patterns** - Comprehensive error handling
11. **standardized-logging** - Unified logging schema
12. **ui-inspiration-finder** - Search 100+ premium components
13. **using-shadcn-ui** - 829 production-ready blocks
14. **changelog-generator** - Technical changelogs from git
15. **skill-creator** - Create effective skills
16. **writing-skills** - TDD for documentation
17. **canvas-design** - Visual art creation
18. **50klph-data-pipeline** - Data pipeline debugging

### **9 Power Commands**
1. **/continue-work** - Resume from where you left off
2. **/quick-fix** - Memory-powered rapid problem solving
3. **/ship-check** - Comprehensive pre-ship validation
4. **/explain-code** - Deep code explanation with history
5. **/check-integration** - Full-stack integration verification
6. **/find-ui** - Search premium UI library
7. **/recall-bug** - Search similar past bugs
8. **/recall-feature** - Search similar past features
9. **/recall-pattern** - Search implementation patterns

### **8 Intelligent Superflows**
Automated workflow orchestration that chains skills and commands:
1. **Feature Development** - Spec → Design → Implement → Verify → Ship
2. **Debugging** - Memory search → Systematic analysis → Fix → Verify
3. **Refactoring** - Understand → Safety checks → Execute → Verify
4. **Session Start** - Auto-resume context
5. **Pre-Ship Validation** - Comprehensive checks before deployment
6. **UI Development** - Check library → Use existing → Adapt
7. **Rapid Prototyping** - Strategic decisions → Fast iteration
8. **Skill Creation** - TDD for documentation

## 🧠 Intelligent Automation

The plugin uses **hooks** to provide intelligent assistance at key moments:

- **Session starts** → Auto-run `/continue-work`
- **Error occurs** → Suggest `/quick-fix` (check memory first)
- **Before refactoring** → Enforce safety protocol (tests required)
- **Before commit** → Suggest `/ship-check` validation
- **Building UI** → Suggest `/find-ui` (check library first)
- **Adding logs** → Enforce standardized logging schema
- **Creating APIs** → Remind about breaking changes

**The result**: Development that feels like having an expert pair programmer.

## 📖 Documentation

- **[INTELLIGENT-AUTOMATION.md](INTELLIGENT-AUTOMATION.md)** - Complete guide to using superflows and hooks
- **[SUPERFLOWS.md](SUPERFLOWS.md)** - Technical details of workflow orchestration
- **[hooks/hooks.json](hooks/hooks.json)** - Hook configuration

## 💡 Real-World Examples

### Example 1: Memory-First Debugging

**Before** (Manual approach):
```
You: "Login is broken"
Claude: Starts debugging from scratch (30 minutes)
```

**After** (With plugin):
```
You: "Login is broken"
Plugin: Auto-runs /quick-fix → finds Session #23 solved this
Claude: "Found it! The JWT secret was missing in .env. Fixed in 2 minutes."
```

### Example 2: UI Development

**Before**:
```
You: "Build a pricing section"
Claude: Creates basic cards from scratch (45 minutes)
```

**After**:
```
You: "Build a pricing section"
Plugin: Auto-suggests /find-ui → finds premium component
Claude: Adapts existing masonry grid component (5 minutes)
```

### Example 3: Safe Refactoring

**Before**:
```
You: "Refactor the auth middleware"
Claude: Refactors immediately → breaks 3 routes
```

**After**:
```
You: "Refactor the auth middleware"
Plugin: ENFORCES refactoring-safety-protocol
Claude: "Tests required first. Adding tests... [tests pass] Now refactoring safely."
```

## 📚 Usage Patterns

### Commands (User-Initiated)

```bash
# Resume your work instantly
/continue-work

# Memory-powered debugging
/quick-fix "Cannot read property of undefined"

# Pre-ship validation
/ship-check authentication-feature

# Deep code understanding
/explain-code auth/middleware.js

# Find premium UI components
/find-ui testimonials

# Search project memory
/recall-bug "500 error"
/recall-feature "authentication"
/recall-pattern "error handling"

# Verify integration
/check-integration user-management
```

### Skills (Auto-Triggered)

Skills activate automatically based on context:

```javascript
// When you say: "Implement user registration"
// Auto-triggers: memory-assisted-spec-kit → spec-kit-orchestrator

// When you say: "Refactor this function"
// Auto-enforces: refactoring-safety-protocol (tests required)

// When you add: console.log(...)
// Auto-checks: standardized-logging schema

// When you're about to commit
// Auto-suggests: /ship-check validation
```

## 🏗️ Plugin Structure

```
developer-skills-plugin/
├── .claude-plugin/
│   └── plugin.json              # Plugin manifest
├── commands/                     # 9 slash commands
│   ├── check-integration.md
│   ├── continue-work.md
│   ├── explain-code.md
│   ├── find-ui.md
│   ├── quick-fix.md
│   ├── recall-bug.md
│   ├── recall-feature.md
│   ├── recall-pattern.md
│   └── ship-check.md
├── skills/                       # 18 production skills
│   ├── systematic-debugging/
│   ├── memory-assisted-debugging/
│   ├── spec-kit-orchestrator/
│   ├── refactoring-safety-protocol/
│   ├── api-contract-design/
│   ├── using-shadcn-ui/
│   └── ... (12 more)
├── hooks/
│   └── hooks.json               # Intelligent automation config
├── SUPERFLOWS.md                # Technical workflow docs
├── INTELLIGENT-AUTOMATION.md    # User guide
└── README.md                    # This file
```

## 🔧 Customization

### Disable Specific Automation

Edit `hooks/hooks.json`:

```json
{
  "name": "session-continuity",
  "enabled": false  // Disable auto-resume
}
```

### Add Custom Workflows

```json
{
  "name": "my-custom-workflow",
  "event": "OnUserMessage",
  "condition": {
    "type": "pattern",
    "pattern": ".*deploy.*"
  },
  "action": {
    "type": "suggest",
    "message": "Run deployment checklist?",
    "command": "/ship-check"
  },
  "enabled": true
}
```

## 🧪 Development & Testing

### Testing Changes

After modifying skills or commands:

```bash
# Refresh the plugin
claude plugin refresh developer-skills

# Or reinstall
claude plugin uninstall developer-skills
claude plugin install developer-skills
```

### Creating New Skills

Follow the TDD approach from `writing-skills`:

1. **RED Phase**: Run baseline scenarios WITHOUT skill
2. **GREEN Phase**: Write skill addressing failures
3. **REFACTOR Phase**: Close loopholes, test until bulletproof

### Adding New Commands

1. Create `.md` file in `commands/` directory
2. Follow existing command format
3. Test with the command syntax

### Adding New Superflows

1. Identify workflow pattern
2. Map skills and commands that should chain
3. Add hook to `hooks/hooks.json`
4. Document in `SUPERFLOWS.md`
5. Test with real tasks

## 🤝 Contributing

To contribute improvements:

1. Test skills using TDD approach (see `writing-skills`)
2. Run pressure scenarios to ensure bulletproof
3. Update version in `.claude-plugin/plugin.json`
4. Document new superflows in `SUPERFLOWS.md`
5. Submit changes

## 📊 Impact

### Without Plugin:
- ❌ Solve same bugs multiple times
- ❌ Skip verification steps
- ❌ Refactor without tests
- ❌ Build UI from scratch (45 min)
- ❌ Lose context between sessions
- ❌ Inconsistent patterns

### With Plugin:
- ✅ Memory-first debugging (10x faster)
- ✅ Automatic verification (catch gaps)
- ✅ Safe refactoring (enforced)
- ✅ Rapid UI development (5 min)
- ✅ Instant session continuity
- ✅ Consistent quality

## 🔗 Resources

- [Claude Code Documentation](https://docs.claude.com/claude-code)
- [Plugin Development Guide](https://docs.claude.com/claude-code/plugins)
- [Hook System Guide](https://docs.claude.com/claude-code/hooks)

## 📝 License

MIT

## 👤 Author

Dominik

---

**Built with Claude Code** - Intelligent development assistance for the modern developer.
