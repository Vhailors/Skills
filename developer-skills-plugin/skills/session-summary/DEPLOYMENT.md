# Session Summary Skill - Deployment Guide

## Quick Start

### 1. Copy Skill to Your Claude Code Environment

```bash
cp -r ./session-summary ~/.claude/skills/
```

### 2. Verify Installation

```bash
ls ~/.claude/skills/session-summary/SKILL.md
```

### 3. Use in Sessions

At end of any coding session, create summary:

```bash
cat > SESSION-SUMMARY-$(date +"%Y-%m-%d-%H%M").md << 'EOF'
# Session Summary: $(date)

## ✅ Completed

- [Your accomplishment] (file:line if relevant)

## 📋 Pending

- [Task] - [blocker or next step]

## ⚠️ Known Issues

- [Issue] - [impact]

## 🎯 Next Steps

1. [Action]

---
**Session Time:** X minutes
**Files Modified:** N
**Tests:** [status]
EOF
```

## Integration Options

### Option A: Manual (Simplest)

At end of session, run command above to create summary file.

### Option B: Hook (Automated)

Create `.claude/hooks/session-end.sh`:

```bash
#!/bin/bash
# Auto-generate session summary when Claude Code completes

PROJECT_ROOT=$(pwd)
TIMESTAMP=$(date +"%Y-%m-%d-%H%M")
SUMMARY_FILE="$PROJECT_ROOT/SESSION-SUMMARY-${TIMESTAMP}.md"

# Check if git has uncommitted work
GIT_STATUS=$(git status --short | wc -l)
TESTS_STATUS="not run"

# Create summary
cat > "$SUMMARY_FILE" << 'EOF'
# Session Summary: $(date '+%Y-%m-%d %H:%M')

## ✅ Completed

[Add from git diff summary]

## 📋 Pending

[Add from TodoWrite or git status]

## ⚠️ Known Issues

[Add any known blockers]

## 🎯 Next Steps

1. [First action]
2. [Second action]

---
**Session Time:** [Calculate]
**Files Modified:** $GIT_STATUS
**Tests:** $TESTS_STATUS
EOF

echo "✅ Session summary created: $SUMMARY_FILE"
```

Add to `.claude/settings.json` to trigger on session completion.

### Option C: CI Integration (Production)

In your CI pipeline:

```yaml
# .github/workflows/archive-summaries.yml
name: Archive Session Summaries

on:
  push:
    paths:
      - 'SESSION-SUMMARY-*.md'

jobs:
  archive:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Move summaries to archive
        run: |
          mkdir -p docs/session-archive
          mv SESSION-SUMMARY-*.md docs/session-archive/
          git add docs/session-archive/
          git commit -m "Archive session summaries"
          git push
```

## Example: Real Session Summary

```markdown
# Session Summary: 2025-11-04 14:30

## ✅ Completed

- Created session-summary skill with RED-GREEN-REFACTOR structure (SKILL.md)
- Fixed WSL path compatibility for UI library access (find-ui.md:18, SKILL.md:22)
- Implemented Puppeteer extraction script for pixel-perfect site copy (extract-styles.js)
- Updated 12 documentation files for Windows/WSL path formats
- Configured Spotlight MCP server (.mcp.json:5-10)

## 📋 Pending

- Hook integration for automatic summary generation - next: create .claude/hooks/session-end.sh
- CI pipeline setup for summary archival - blocked by: GitHub Actions configuration
- FastAPI skill templates - waiting for: skill directory structure initialization
- Test coverage for session-summary skill - next: run with 4+ pressure scenarios

## ⚠️ Known Issues

- Spotlight MCP doesn't work with SSE transport (requires stdio) - workaround: use stdio in .mcp.json
- WebFetch blocks github.com domains globally - workaround: use allowed_domains parameter
- VedereLMS environment variables don't match local project format - requires manual mapping

## 🎯 Next Steps

1. Deploy session-summary skill to ~/.claude/skills/
2. Test with actual session and gather feedback
3. Create hook trigger for automatic generation at session end
4. Integrate with CI for archival in docs/session-archive/

---
**Session Time:** 127 minutes
**Files Modified:** 23
**Tests:** All green (12 passing)
**Git Commits:** 3
```

## Project Integration

### Where to Store Summaries

**Option 1:** Project root (visible, searchable)
```
my-project/
  SESSION-SUMMARY-2025-11-04-1430.md
  SESSION-SUMMARY-2025-11-03-1100.md
```

**Option 2:** Dedicated archive directory
```
my-project/
  docs/
    session-archive/
      2025-11-04.md
      2025-11-03.md
```

**Option 3:** Version control (Git tags for sessions)
```bash
git tag "session/2025-11-04-1430" -m "Session: 23 files modified, 3 features completed"
```

## Team Visibility

### Share Summaries

```bash
# Email summary to team
mail -s "Session Summary: $(date +%Y-%m-%d)" team@example.com < SESSION-SUMMARY-*.md

# Slack notification
curl -X POST -H 'Content-type: application/json' \
  --data "$(cat SESSION-SUMMARY-*.md)" \
  $SLACK_WEBHOOK_URL
```

### Dashboard (Optional)

Create `docs/sessions.md` that references all summaries:

```markdown
# Session History

- [Session 2025-11-04](docs/session-archive/2025-11-04.md) - 23 files, 3 features
- [Session 2025-11-03](docs/session-archive/2025-11-03.md) - 12 files, 1 bug fix
```

## FAQ

**Q: How long should a summary be?**
A: 1 page maximum. If longer, you're including too much detail.

**Q: Should I include code snippets?**
A: No. Use file references (path:line) instead. Summary is headlines only.

**Q: What if work is incomplete?**
A: Still create summary. Pending section + Known Issues captures incomplete work.

**Q: Can I skip summary for trivial sessions?**
A: Only if < 5 minutes of work. Otherwise create summary.

**Q: How do I update if more work is done?**
A: Create new summary file with new timestamp. Don't edit old summaries.

## Success Criteria

✅ Summary created for every session
✅ Summaries are scannable in < 1 minute
✅ File references point to actual code changes
✅ Blockers and pending items are clear
✅ Future agent can pick up work without re-reading conversation
