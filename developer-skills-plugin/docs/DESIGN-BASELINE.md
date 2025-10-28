# Statusline & Output Style: Baseline Analysis

## Problem Definition

**Gap**: No visual workflow state; verbose, narrative-heavy outputs
**Impact**: Technical users parse prose for actionable info; no session awareness
**Solution**: Statusline (glanceable state) + Output Style (structured, technical)

## Baseline: Current Behavior

### Output Example 1: Refactoring Request
```
I'll help you refactor the authentication module. This is a great opportunity
to improve the code quality and make the code more maintainable. First, let
me check if there are any existing tests for this module, since testing is
very important to ensure that our changes don't break existing functionality...

[continues with 3-4 more paragraphs of explanation]
```

**Issues**:
- Filler words ("great opportunity", "very important")
- Explains obvious concepts ("testing helps ensure...")
- No structure - wall of text
- Action buried in prose

### Output Example 2: Bug Investigation
```
Let me investigate this error for you. I'll start by looking at the error
message to understand what's happening. Then I'll check the relevant code
files to see if I can identify the root cause. After that, I'll suggest
a fix and we can implement it together...
```

**Issues**:
- Describes the process rather than doing it
- No status indicators
- No structured steps
- Verbose narration

## Desired: Post-Implementation Behavior

### Output Example 1: Refactoring Request (With Output Style)
```
## 🛡️ Refactoring Safety Protocol

**Target**: auth module
**Status**: Checking tests

### 🎯 Immediate Actions
- Check existing test coverage
- Create missing tests (non-negotiable)
- Execute refactoring
- Verify tests pass

Checking for tests...
```

**Improvements**:
- Structured blocks with headers
- Emoji indicators for scanning (🛡️ workflow, 🎯 action)
- Technical, direct language
- Action-oriented

### Output Example 2: Bug Investigation (With Output Style)
```
## 🐛 Debugging Superflow

**Error**: TypeError: Cannot read property 'user'
**Location**: auth/middleware.ts:42

### 📋 Investigation
- Checking memory for similar bugs → /recall-bug
- Root cause analysis in progress

Searching memory first...
```

**Improvements**:
- Error details upfront
- Structured investigation plan
- Memory-first approach visible
- No narrative filler

### Statusline Display

```
📁 ~/dev/project  🌿 feature/auth  🛡️ Refactoring  ✅ 2/6 todos
🧠 Memory: 271 obs  📝 Last: Hook blocking fix (#267)
```

**Components**:
- Line 1: Location, git branch, active superflow, progress
- Line 2: Memory context, latest observation

## Success Criteria

### Statusline
- [ ] Shows current directory (abbreviated ~)
- [ ] Shows git branch when in repo
- [ ] Shows active superflow when triggered
- [ ] Shows todo progress (completed/total)
- [ ] Shows memory observation count (if MCP available)
- [ ] Updates in real-time during session

### Output Style
- [ ] Emoji indicators for quick scanning
- [ ] Structured blocks with ## headers
- [ ] Technical language (no filler)
- [ ] Tables and bullets > prose
- [ ] Action-oriented (what's happening now)
- [ ] Key info upfront (error, location, status)
- [ ] Zero unnecessary explanations

## Testing Plan

### Statusline Tests
1. Display in non-git directory → Shows directory only
2. Display in git repo → Shows directory + branch
3. Trigger refactoring → Shows 🛡️ Refactoring
4. Complete todos → Progress updates (3/6 → 4/6 → 6/6)

### Output Style Tests
1. Refactoring request → Structured with 🛡️ header
2. Bug report → Structured with 🐛 header, error details upfront
3. Feature request → Structured with 🏗️ header, spec-kit workflow
4. Completion claim → Structured with ✅ header, verification steps

## Implementation Priority

1. **Output Style** (higher impact, easier to test)
   - Create output-style.md template
   - Define patterns for each superflow
   - Test with real scenarios

2. **Statusline** (requires integration with Claude Code hooks)
   - Implement basic version (directory + git)
   - Add superflow detection
   - Add todo progress (if API available)
