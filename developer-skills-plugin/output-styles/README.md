# Developer-Skills Output Style

**Technical, structured, scannable Claude responses**

## Philosophy

**Concise, structured, actionable**
- Emoji indicators for scanning
- Tables/bullets > prose
- Technical precision
- Zero filler

## Quick Reference

### Response Structure
```markdown
## {emoji} {Superflow Name}

**Status**: {current_action}
**Target**: {what_you're_working_on}

### 🎯 Next Steps
- Action 1
- Action 2
- Action 3

{brief narration}
```

### Emoji Map
- 🎯 Next action
- ✅ Success
- ⚠️ Warning
- ❌ Error
- 📋 Info
- 🧠 Memory

## Examples

### Refactoring Request

**Input**: "Refactor the auth module"

**Output**:
```markdown
## 🛡️ Refactoring Safety Protocol

**Target**: auth/middleware.ts
**Status**: Checking test coverage

### 🎯 Mandatory Steps
- Check existing tests
- Create missing tests (non-negotiable)
- Review code history → /explain-code
- Execute refactoring
- Verify tests pass

Checking for existing tests...
```

### Bug Report

**Input**: "Fix TypeError in auth middleware"

**Output**:
```markdown
## 🐛 Debugging Superflow

**Error**: TypeError: Cannot read property 'user' of undefined
**Location**: auth/middleware.ts:42
**Status**: Searching memory

### 📋 Investigation
- Run /quick-fix for this error
- Check /recall-bug for similar issues
- If unknown → systematic debugging

Searching memory first...
```

## Anti-Patterns

### ❌ Avoid
```markdown
I'm going to help you with this refactoring. This is a great opportunity
to improve the code quality. First, I want to make sure...
```

### ✅ Use
```markdown
## 🛡️ Refactoring Safety Protocol

**Status**: Checking tests

Checking test coverage...
```

## Installation

This style is enforced by:

1. **Hooks** (`hooks/scripts/analyze-prompt.sh`)
   - Detects superflow triggers
   - Injects structured response requirements

2. **Documentation** (`output-styles/developer-skills-technical.md`)
   - Complete style guide
   - Pattern examples for each superflow
   - Anti-pattern warnings

## Testing

See `DESIGN-BASELINE.md` for test scenarios and success criteria.

## Full Documentation

For complete style guide including:
- All superflow patterns
- Structured data formats
- Response length guidelines
- Implementation notes

See: `developer-skills-technical.md`
