# List Project Skills

You have been asked to list all project-specific skills.

## Your Task

1. **Read Skill Metadata**:
   - Read `.claude/skill-metadata.json` to get the complete list
   - Show skill name, source, created date, usage count, last used

2. **Present Information**:
   Display in a clear table format:

   ```
   ## 📚 Project Skills

   | Name | Source | Created | Usage | Last Used |
   |------|--------|---------|-------|-----------|
   | supabase-expert | https://supabase.com/docs | 2025-10-31 | 15 | 2025-10-31 |
   | stripe-expert | https://stripe.com/docs | 2025-10-30 | 8 | 2025-10-31 |
   ```

3. **Additional Details** (optional):
   - Show total skills count
   - Show acceptance rate from statistics
   - List available commands: /generate-skill, /delete-skill, /refresh-skill

## Example Response

```markdown
## 📚 Project Skills (2 total)

| Skill | Description | Created | Usage |
|-------|-------------|---------|-------|
| **supabase-expert** | Expert assistance for Supabase development | Oct 31, 2025 | 15 times |
| **stripe-expert** | Stripe payment processing expert | Oct 30, 2025 | 8 times |

### 📊 Statistics
- Total skills: 2
- Total suggestions: 5
- Acceptance rate: 40%

### 💡 Available Commands
- `/generate-skill` - Create new skill
- `/delete-skill [name]` - Remove a skill
- `/refresh-skill [name]` - Regenerate from source

All skills are automatically loaded in every session.
Location: `.claude/project-skills/`
```

## Implementation

```bash
# Read metadata
cat .claude/skill-metadata.json | jq .

# Or manually list skills
ls -la .claude/project-skills/
```
