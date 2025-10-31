# Generate Project Skill

You have been asked to generate a new project-specific skill using Skill Seekers.

## Your Task

1. **Gather Information** (if not provided):
   - Ask user for skill name (e.g., "supabase-expert", "stripe-expert")
   - Ask for documentation URL (e.g., https://supabase.com/docs)
   - Ask if they want AI enhancement (recommended)

2. **Run Skill Seekers**:
   - Use the `developer-skills-plugin/commands/generate-skill.sh` script
   - Example command:
     ```bash
     ./developer-skills-plugin/commands/generate-skill.sh \
       --name supabase-expert \
       --source https://supabase.com/docs \
       --enhance
     ```

3. **What Happens**:
   - Skill Seekers scrapes the documentation
   - Generates SKILL.md with examples and patterns
   - Copies to `.claude/project-skills/[name]/`
   - Updates `.claude/skill-metadata.json`
   - Skill auto-loads in next session

4. **Verify Success**:
   - Check that `.claude/project-skills/[name]/SKILL.md` exists
   - Show user the skill location
   - Explain that skill is now available for use

## Configuration Options

**Using Quick Mode** (recommended for first-time):
```bash
./developer-skills-plugin/commands/generate-skill.sh \
  --name [skill-name] \
  --source [url] \
  [--enhance]
```

**Using Config File** (for advanced users):
```bash
./developer-skills-plugin/commands/generate-skill.sh \
  --config [path-to-config.json] \
  [--enhance]
```

**Example Config** (create in `Skill_Seekers/configs/[name].json`):
```json
{
  "name": "supabase-expert",
  "description": "Expert assistance for Supabase development",
  "base_url": "https://supabase.com/docs",
  "selectors": {
    "main_content": "article",
    "title": "h1",
    "code_blocks": "pre code"
  },
  "url_patterns": {
    "include": [],
    "exclude": ["/blog", "/changelog"]
  },
  "categories": {
    "auth": ["auth", "authentication", "login"],
    "database": ["database", "postgres", "sql"],
    "storage": ["storage", "files", "upload"]
  },
  "rate_limit": 0.5,
  "max_pages": 300
}
```

## Notes

- **Enhancement**: Highly recommended! Uses Claude to analyze docs and create better SKILL.md
- **Time**: First scrape takes 15-45 minutes depending on doc size
- **Storage**: Skills are stored in `.claude/project-skills/` (project-scoped)
- **Auto-loading**: Skills load automatically in every session

## Example Interaction

User: "Can you create a Supabase expert skill?"

Response:
```
I'll create a Supabase expert skill for you using Skill Seekers.

Running:
./developer-skills-plugin/commands/generate-skill.sh \
  --name supabase-expert \
  --source https://supabase.com/docs \
  --enhance

This will:
1. Scrape Supabase documentation (~20-30 min)
2. Extract code examples and patterns
3. Enhance with Claude (~60 sec)
4. Install to .claude/project-skills/

The skill will be available in all future sessions automatically!
```
