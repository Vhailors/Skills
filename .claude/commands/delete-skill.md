# Delete Project Skill

You have been asked to delete a project-specific skill.

## Your Task

1. **Confirm Deletion**:
   - Ask user to confirm (this is destructive!)
   - Show what will be deleted

2. **Delete Skill**:
   ```bash
   # Remove skill directory
   rm -rf .claude/project-skills/[skill-name]

   # Update metadata (remove from registry)
   jq 'del(.skills[] | select(.name == "[skill-name]"))' \
     .claude/skill-metadata.json > .claude/skill-metadata.json.tmp
   mv .claude/skill-metadata.json.tmp .claude/skill-metadata.json

   # Update statistics
   jq '.statistics.total_skills = (.skills | length)' \
     .claude/skill-metadata.json > .claude/skill-metadata.json.tmp
   mv .claude/skill-metadata.json.tmp .claude/skill-metadata.json
   ```

3. **Confirm Success**:
   - Show that skill was deleted
   - Explain that skill will no longer load in sessions
   - Suggest `/list-skills` to see remaining skills

## Example Interaction

User: "Delete the supabase-expert skill"

You should:
1. **Confirm first**:
   ```
   ⚠️ This will permanently delete the 'supabase-expert' skill.

   Files to be deleted:
   - .claude/project-skills/supabase-expert/SKILL.md
   - .claude/project-skills/supabase-expert/references/
   - All associated files

   Are you sure? (yes/no)
   ```

2. **After user confirms**:
   ```bash
   # Delete directory
   rm -rf .claude/project-skills/supabase-expert

   # Update metadata
   jq 'del(.skills[] | select(.name == "supabase-expert"))' \
     .claude/skill-metadata.json > .claude/skill-metadata.json.tmp
   mv .claude/skill-metadata.json.tmp .claude/skill-metadata.json
   ```

3. **Show success**:
   ```
   ✅ Skill 'supabase-expert' has been deleted.

   Remaining skills: 1
   - stripe-expert

   Use /list-skills to see all remaining skills.
   ```

## Notes

- **Irreversible**: Deletion is permanent (no undo)
- **Regenerate**: User can recreate with `/generate-skill` if needed
- **Metadata**: Always update both directory AND metadata file
- **Statistics**: Update total_skills count
