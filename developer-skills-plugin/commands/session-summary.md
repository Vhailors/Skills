# /session-summary

**Manual trigger for session summary generation**

## Usage

```bash
/session-summary
```

## What it does

1. **Detects current session context**
   - Git changes (files modified, changes staged)
   - Completed todos from TodoWrite
   - Pending work items
   - Known issues from this session

2. **Generates SESSION-SUMMARY-{timestamp}.md**
   - Location: Project root
   - Format: Scan-friendly markdown
   - Includes: Accomplished, Pending, Issues, Next Steps

3. **Optional: Opens in editor**
   - Prompts to edit before committing
   - Allows you to add context, blockers, details

## When to use

- **End of session** - Before closing Claude Code
- **Feature complete** - When moving to next feature
- **Blocking issue** - Document what stopped progress
- **Handoff** - When another person/agent continues work
- **Manual checkpoint** - Any time during session for documentation

## Example output

```markdown
# Session Summary: 2025-11-04 14:30

## ✅ Completed
- Created session-summary skill with TDD structure
- Fixed WSL path compatibility for UI library
- Implemented Puppeteer extraction script

## 📋 Pending
- Hook integration - next: create .claude/hooks/session-end.sh
- CI pipeline setup - blocked by: GitHub Actions config

## ⚠️ Known Issues
- Spotlight MCP doesn't work with SSE transport
- WebFetch blocks github.com domains (workaround: allowed_domains)

## 🎯 Next Steps
1. Deploy session-summary skill
2. Test with actual session
3. Gather feedback

---
**Generated**: 2025-11-04 14:30:05
**Files Modified**: 23
**Test Status**: All green
```

## What happens next

1. Summary is created in project root
2. You can review/edit before committing
3. Future agents can scan it in 30 seconds
4. Team has searchable history of session work

## Pro tips

- **Run at beginning of session too** - Establishes baseline
- **Run multiple times during long sessions** - Checkpoint progress
- **Add blockers immediately** - Don't wait until end
- **Link to related PRs/issues** - Provides context

## Integration with hooks

This command is also triggered automatically when:
- Claude Code session ends
- Major superflow completes
- TodoWrite shows all items completed

Manual invocation ensures you can create summaries anytime without waiting for triggers.
