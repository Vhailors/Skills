# Dismiss Skill Suggestion

You have been asked to dismiss a skill suggestion for a specific technology.

## Your Task

When a user says "never suggest [technology]" or "dismiss [technology] skill", you should:

1. **Add to Dismissals List**:
   ```bash
   # Update skill-metadata.json
   jq --arg tech "[technology]" --arg now "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
     '.dismissals += [{"technology": $tech, "dismissed_at": $now}]' \
     .claude/skill-metadata.json > .claude/skill-metadata.json.tmp
   mv .claude/skill-metadata.json.tmp .claude/skill-metadata.json
   ```

2. **Confirm to User**:
   ```
   ✅ Skill suggestion for **[technology]** has been dismissed.

   I will not suggest creating a [technology]-expert skill in the future.

   **To undo**: You can manually edit `.claude/skill-metadata.json`
   and remove the dismissal entry, or delete the file to reset all dismissals.
   ```

## Example Interaction

**User**: "Never suggest Supabase skills"

**You**:
```bash
jq --arg tech "supabase" --arg now "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
  '.dismissals += [{"technology": $tech, "dismissed_at": $now}]' \
  .claude/skill-metadata.json > .claude/skill-metadata.json.tmp && \
  mv .claude/skill-metadata.json.tmp .claude/skill-metadata.json
```

Then respond:
```
✅ Skill suggestion for **Supabase** has been dismissed.

I will not suggest creating a supabase-expert skill in the future.

If you change your mind later, you can:
- Manually create the skill with: `/generate-skill`
- Remove the dismissal by editing `.claude/skill-metadata.json`
```

## Technical Details

**Dismissal Format**:
```json
{
  "dismissals": [
    {
      "technology": "supabase",
      "dismissed_at": "2025-10-31T12:00:00Z"
    }
  ]
}
```

**How It Works**:
- Pattern detection hook checks dismissals before suggesting
- If technology is in dismissals list, no suggestion is made
- User can still manually create skills with `/generate-skill`

## Notes

- Dismissals are permanent (no expiration)
- User can undo by editing JSON
- Dismissals don't affect manually created skills
- Technology names are case-insensitive
