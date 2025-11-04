---
name: session-summary
description: Use when ending a coding session or completing major tasks - generates quick technical summary with accomplishments, pending items, known issues, and next steps for team visibility and agent continuity
---

# Session Summary

## Overview

**Session summaries document what happened, what's pending, and what's blocked - without being tedious.**

This skill ensures every session ends with a structured summary that's scannable in 30 seconds and actionable for future agents or team members.

**Core principle:** Session context should be captured in searchable form before the session ends. Future work depends on knowing what was done and why it stopped.

## When to Use

- **End of coding session** - before closing the work
- **Feature completion** - when moving to next feature
- **Bug fix completion** - when fix is verified
- **Task handoff** - when another person/agent continues
- **Blocker encountered** - document what stopped progress

**When NOT to use:**
- Mid-session checkpoints (use todos instead)
- Trivial changes (< 5 minutes work)
- Incomplete work without clear blockers

## Quick Format

**Location:** Project root as `SESSION-SUMMARY-{timestamp}.md`

**File naming:**
```
SESSION-SUMMARY-2025-11-04-1430.md    # timestamp: YYYY-MM-DD-HHMM
```

**Structure (copy this template):**

```markdown
# Session Summary: [Date & Time]

## ✅ Completed

- [Brief accomplishment] (file:line if relevant)
- [Brief accomplishment]

## 📋 Pending

- [Task name] - blocked by [reason] OR [next step needed]
- [Task name] - [status]

## ⚠️ Known Issues

- [Issue title] - [impact]
- [Issue title] - [why it matters]

## 🎯 Next Steps

1. [Immediate next action]
2. [Following action]
3. [Long-term follow-up]

---
**Session Time:** X minutes
**Files Modified:** N
**Tests:** [passing/failing/not run]
```

## Pattern: Accomplishment Entries

**Good entries are scannable:**

```markdown
✅ Completed

- Fixed WebFetch domain verification error (Edit:WebFetch.ts:142)
- Created pixel-perfect site copy skill with Puppeteer extraction
- Configured Spotlight MCP server with stdio transport (.mcp.json)
- Updated 12 skill documentation files for WSL path compatibility
```

**Not just "did work":**
```markdown
# ❌ BAD - Vague
- Fixed issues
- Updated documentation
- Made changes

# ✅ GOOD - Specific with file references
- Fixed WebFetch domain verification (WebFetch.ts:142)
- Updated 12 documentation files for WSL paths (find-ui.md, SKILL.md, etc)
- Created Puppeteer extraction script (extract-styles.js:1)
```

## Pattern: Pending Entries

**Include blocker or next action:**

```markdown
📋 Pending

- FastAPI skill templates - waiting for skill-creator to complete initial structure
- Spotlight MCP integration - blocked by Node.js version requirements
- VedereLMS project setup - next: configure environment variables
```

**Not just status:**
```markdown
# ❌ BAD
- FastAPI templates - in progress
- Spotlight integration - not started
- Project setup - incomplete

# ✅ GOOD - Include context
- FastAPI templates - waiting for: skill directory structure setup
- Spotlight integration - blocked by: Node.js 18+ requirement
- Project setup - next: run `npm install && configure .env`
```

## Pattern: Known Issues Section

**Document what's broken or what you found:**

```markdown
⚠️ Known Issues

- Spotlight MCP plugin fails to load - requires stdio transport, SSE not supported
- WebFetch domain verification blocks github.com requests (working around with allowed_domains)
- VedereLMS uses different environment variable format than local projects
```

**Each issue includes impact:**
- **Why it matters** - affects future work?
- **Severity** - blocks work? Degrades experience? Minor annoyance?
- **Workaround** - if any

## Pattern: Next Steps

**Prioritized and actionable:**

```markdown
🎯 Next Steps

1. Deploy session-summary skill to ~/.claude/skills/
2. Add hook trigger for automatic summary generation at session end
3. Create summary for current session (test the skill)
4. Integrate with project CI to archive summaries
```

**Each step should:**
- Be actionable in < 5 minutes (or clearly break into subtasks)
- Reference files/tools if needed
- Include blocker if one exists

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| **Too detailed** - summarizes every line | Scan-friendly: headlines only, file refs not code snippets |
| **No file references** - "fixed bugs" | Always include path:line or filename |
| **Vague pending** - "incomplete features" | State blocker: "blocked by X" or "next: do Y" |
| **Missing issues** - doesn't capture problems | Always include known issues, even minor ones |
| **No timestamp** - can't correlate with other logs | Include filename with YYYY-MM-DD-HHMM timestamp |
| **Too long** - summary takes 10 minutes to read | Target: 1 minute to scan. If longer, break into sections |
| **No next steps** - future agent has to guess | Always include 2-3 prioritized next actions |

## Implementation

**Auto-trigger with hook:**

Create `.claude/hooks/session-end.sh`:
```bash
#!/bin/bash
# Generates session summary when Claude Code completes
TIMESTAMP=$(date +"%Y-%m-%d-%H%M")
SUMMARY_FILE="SESSION-SUMMARY-${TIMESTAMP}.md"
echo "# Session Summary: $(date)" > "$SUMMARY_FILE"
echo "" >> "$SUMMARY_FILE"
echo "## ✅ Completed" >> "$SUMMARY_FILE"
echo "- [Add from TodoWrite completed items]" >> "$SUMMARY_FILE"
# ... rest of template
```

**Manual trigger:**
```bash
echo "# Session Summary: $(date)" > SESSION-SUMMARY-$(date +"%Y-%m-%d-%H%M").md
```

## Real-World Impact

**Without session summaries:**
- Next agent wastes 20+ minutes re-reading conversation
- Blockers get re-encountered
- Context is lost across sessions
- Team can't track what was attempted

**With session summaries:**
- Next agent scans 1 page in 30 seconds
- Blockers are documented → workarounds available
- Context is searchable in project history
- Team visibility into progress and issues

## Red Flags - STOP If You're Doing This

- ❌ "Session ended without summary" - STOP, create it before closing session
- ❌ "I'll summarize later when I have time" - Time = never. Do it immediately.
- ❌ "The conversation is detailed enough" - Conversation is not scannable. Summarize.
- ❌ "This summary is too long" - Reduce it. 1-page maximum.
- ❌ "I'll remember what was pending" - Document it anyway. Next agent won't remember.

**All of these mean: Create summary NOW before session ends.**
