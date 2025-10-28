# Superflow Visibility Configuration

## Overview

The hooks system now enforces **explicit visibility** for all superflow activations. This ensures users always know when a superflow is active and what steps will be executed.

## What Changed

### Before
- Superflows were activated silently via hook context injection
- Users had no visibility into which workflow was active
- No automatic todo list creation

### After
- **Mandatory Output**: Claude MUST output which superflow is activated
- **Mandatory TodoWrite**: Claude MUST create a todo list with workflow steps
- **Format**: `🛡️ [Superflow Name] activated` with 1-3 line explanation
- **User Confidence**: Users can verify the system is working properly

## Activated Superflows

Each superflow now has **REQUIRED ACTIONS** that Claude must perform immediately:

### 🛡️ Refactoring Safety Protocol
**Trigger**: Keywords like "refactor", "rewrite", "restructure"
**Output**: "🛡️ Refactoring Safety Protocol activated"
**Todos**:
- Check if tests exist for code to refactor
- Create tests first if missing (non-negotiable)
- Run /explain-code for historical context
- Use refactoring-safety-protocol skill
- Execute refactoring changes
- Verify tests still pass

### 🐛 Debugging Superflow
**Trigger**: Keywords like "bug", "error", "issue", "broken"
**Output**: "🐛 Debugging Superflow activated"
**Todos**:
- Run /quick-fix or /recall-bug for known issues
- Search memory for similar bugs
- If known fix → Apply it (2-5 min)
- If new → Use systematic-debugging (4 phases)
- Verify fix works

### 🏗️ Feature Development Superflow
**Trigger**: Keywords like "implement", "build", "create feature"
**Output**: "🏗️ Feature Development Superflow activated"
**Todos**:
- Run /recall-feature for similar past features
- Use memory-assisted-spec-kit + spec-kit-orchestrator
- Follow: Constitution → Specify → Clarify → Plan
- Implement the feature
- Run /check-integration + /ship-check before done

### 🎨 UI Development Superflow
**Trigger**: Keywords like "ui", "component", "interface", "design"
**Output**: "🎨 UI Development Superflow activated"
**Todos**:
- Run /find-ui to search premium library
- If found → Adapt existing component (5 min)
- If not → Use using-shadcn-ui for blocks
- Plan error handling with error-handling-patterns
- Implement and test the component

### 🔌 API Contract Design
**Trigger**: Keywords like "api", "endpoint" with "change"/"modify"
**Output**: "🔌 API Contract Design activated"
**Todos**:
- Use api-contract-design skill
- Check for breaking changes
- Consider versioning needs
- Ensure backward compatibility
- Validate request/response schemas

### ✅ Verification Before Completion
**Trigger**: Keywords like "done", "complete", "finished"
**Output**: "✅ Verification Protocol activated"
**Todos**:
- Run /check-integration for full-stack verification
- Run /ship-check for comprehensive validation
- Use verification-before-completion skill
- Gather fresh evidence (no cached results)
- Confirm all tests pass

### 🚀 Rapid Prototyping Superflow
**Trigger**: Keywords like "mvp", "prototype", "poc", "quick"
**Output**: "🚀 Rapid Prototyping Superflow activated"
**Todos**:
- Use rapid-prototyping skill for decisions
- Determine Build vs Buy vs Integrate
- Use /find-ui + using-shadcn-ui for UI
- Implement MVP with quality gates
- Run verification-before-completion

## Benefits

1. **User Confidence**: Users can see the system is working
2. **Transparency**: Clear visibility into which workflow is active
3. **Progress Tracking**: Todo lists show exactly what will happen
4. **Debugging**: Easy to verify hooks are triggering correctly
5. **Accountability**: Claude must acknowledge and follow the workflow

## Example Interaction

```
User: "I need to refactor the authentication module"

Claude: "🛡️ Refactoring Safety Protocol activated

I'll follow these steps:
1. Check for existing tests
2. Create tests if missing
3. Review code history
4. Execute safe refactoring
5. Verify tests pass

Let me start by checking if tests exist for the authentication module..."

[TodoWrite creates checklist with all steps]
```

## Implementation Details

- **Hook Files Modified**:
  - `hooks/scripts/session-start.sh` - Added critical visibility instructions
  - `hooks/scripts/analyze-prompt.sh` - Added REQUIRED ACTIONS to all patterns

- **Enforcement Level**: CRITICAL
  - Claude MUST NOT skip the output
  - Claude MUST NOT skip the TodoWrite
  - This is not optional or suggested - it's required

## Testing

To test if visibility is working:

1. Use a trigger word (e.g., "refactor", "bug", "implement")
2. Verify Claude outputs the activation message
3. Verify Claude creates a todo list with workflow steps
4. Check that the format matches: "🛡️ [Name] activated"

If any of these are missing, the hooks may not be configured correctly.
