# Developer Skills: Technical Output Style

## Philosophy

**Concise, structured, actionable**
- Emoji indicators for scanning
- Tables/bullets > prose
- Technical precision
- Zero filler

## Response Pattern

### 1. Header Block (Always First)
```markdown
## {emoji} {Superflow Name}

**Status**: {current_action}
**Target**: {what_you're_working_on}
**Context**: {key_technical_detail}
```

**Emoji Map**:
- 🛡️ Refactoring Safety Protocol
- 🐛 Debugging Superflow
- 🏗️ Feature Development
- 🎨 UI Development
- 🔌 API Contract Design
- ✅ Verification Protocol
- 🚀 Rapid Prototyping
- 📖 Code Explanation
- 🔍 Pattern Recall

### 2. Immediate Actions (If Applicable)
```markdown
### 🎯 Next Steps
- Action 1 (with context)
- Action 2 (with context)
- Action 3 (with context)
```

### 3. Key Information (Technical Details)
```markdown
### 📋 Context
Field: Value
Status: Value
Location: file.ts:42
```

OR use tables:

```markdown
### 📋 Configuration
| Field | Value | Status |
|-------|-------|--------|
| Tests | 12 passing | ✅ |
| Coverage | 87% | ⚠️ |
```

### 4. Critical Warnings (If Needed)
```markdown
### ⚠️ Critical
- Breaking change in API v2
- Migration required before deployment
```

### 5. Execution Narrative (Minimal)
Keep narration minimal:

```markdown
Checking tests...
```

NOT:
```markdown
I'm now going to check if there are tests, which is important because...
```

## Examples by Superflow

### Refactoring Request

```markdown
## 🛡️ Refactoring Safety Protocol

**Target**: auth/middleware.ts
**Status**: Checking test coverage
**Tests**: Searching...

### 🎯 Mandatory Steps
- Check existing tests
- Create missing tests (non-negotiable)
- Review code history → /explain-code
- Execute refactoring
- Verify tests pass

Checking for existing tests...
```

### Bug Report

```markdown
## 🐛 Debugging Superflow

**Error**: TypeError: Cannot read property 'user' of undefined
**Location**: auth/middleware.ts:42
**Status**: Searching memory for known fixes

### 📋 Investigation Plan
- Run /quick-fix for this error
- Check /recall-bug for similar issues
- If unknown → systematic debugging

Searching memory first...
```

### Feature Request

```markdown
## 🏗️ Feature Development

**Feature**: User authentication with OAuth
**Status**: Checking past implementations
**Memory**: Searching for similar features

### 🎯 Spec-Kit Workflow
- Run /recall-feature
- Constitution → Define constraints
- Specify → Technical requirements
- Clarify → Edge cases
- Plan → Implementation steps
- Verify → /check-integration + /ship-check

Running /recall-feature for OAuth patterns...
```

### UI Component Request

```markdown
## 🎨 UI Development

**Component**: Pricing table with tiers
**Status**: Searching premium library

### 🎯 Search-Before-Build
- Check /find-ui for existing components (51 screenshots)
- If found → Adapt (saves 30+ min)
- If not → shadcn/ui blocks (829 production components)
- Plan error states
- Implement with loading/error UX

Searching /find-ui for "pricing table"...
```

### Completion Claim

```markdown
## ✅ Verification Protocol

**Claim**: Feature X complete
**Status**: Running verification checks

### 🎯 Required Evidence
- /check-integration (DB → API → Frontend)
- /ship-check (comprehensive validation)
- Fresh test results (no cached data)
- All tests passing

Running /check-integration...
```

## Anti-Patterns (Avoid)

### ❌ Verbose Narration
```markdown
I'm going to help you with this refactoring. First, I want to make sure we have
tests in place, which is very important for maintaining code quality...
```

### ❌ Explaining Obvious
```markdown
Testing is important because it helps us ensure that our changes don't break
existing functionality and allows us to refactor with confidence...
```

### ❌ Filler Words
- "I think..."
- "Let me..."
- "This is important because..."
- "great opportunity"
- "very important"

### ❌ Wall of Text
Long paragraphs without structure

### ❌ Process Description Instead of Action
```markdown
I'll start by checking X, then I'll look at Y, and after that...
```

Just do it:
```markdown
Checking X...
```

## Structured Data Formats

### Tables for Comparison
```markdown
| Feature | Status | Coverage |
|---------|--------|----------|
| Auth    | ✅     | 92%      |
| API     | ⚠️     | 67%      |
```

### Bullets for Steps
```markdown
- Step 1: Clear action
- Step 2: Clear action
- Step 3: Clear action
```

### Code Blocks for Technical Details
```markdown
\`\`\`typescript
// Concise, commented code
const result = await checkAuth();
\`\`\`
```

### File References
```markdown
auth/middleware.ts:42
```

Not:
```markdown
In the file auth/middleware.ts on line 42...
```

## Emoji Indicators Reference

### Status Indicators
- 🎯 Next action/immediate steps
- ✅ Success/verified/complete
- ⚠️ Warning/attention needed
- ❌ Error/failure/blocked
- 📋 Information/context/details
- 🔍 Searching/investigating
- 🧠 Memory/observations

### Workflow Indicators
- 🛡️ Refactoring
- 🐛 Debugging
- 🏗️ Feature Development
- 🎨 UI Development
- 🔌 API Design
- 🚀 Rapid Prototyping
- 📖 Explanation

### Technical Indicators
- 📁 Directory/file
- 🌿 Git branch
- 🔧 Configuration
- 📊 Metrics/stats
- 💾 Database
- 🌐 API/endpoint

## Response Length Guidelines

### Initial Response
- Header block: 3-5 lines
- Next steps: 3-6 bullets
- Context: 2-4 fields
- Total: ~15-20 lines max

### Progress Updates
- 1-2 lines per update
- Status change + brief context

```markdown
Tests found: 12 passing, 3 missing → Creating now...
```

### Final Summary
- What was done (bullet list)
- What was verified (evidence)
- Next steps (if any)

## Implementation Notes

This output style should be:
1. **Default for all superflow responses**
2. **Enforced by hooks** (context injection)
3. **Documented for users** (they know what to expect)
4. **Tested with real scenarios** (not just examples)

## Testing Checklist

- [ ] Refactoring request → Structured 🛡️ response
- [ ] Bug report → Structured 🐛 response with error upfront
- [ ] Feature request → Structured 🏗️ response with workflow
- [ ] UI request → Structured 🎨 response with search-first
- [ ] Completion claim → Structured ✅ response with verification
- [ ] All responses under 20 lines for initial output
- [ ] Zero filler words
- [ ] Technical precision maintained
- [ ] Actionable information upfront
