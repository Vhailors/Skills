#!/bin/bash
# dismiss-skill.sh - Dismiss skill suggestions for a technology
#
# Usage: ./dismiss-skill.sh [technology]
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"
PROJECT_ROOT="$(pwd)"  # Current working directory = actual project

SKILL_METADATA="$PROJECT_ROOT/.claude/skill-metadata.json"

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 [technology]"
  echo "Example: $0 supabase"
  exit 1
fi

TECH="$1"
NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Add to dismissals
TEMP_FILE=$(mktemp)
jq --arg tech "$TECH" --arg now "$NOW" \
  '.dismissals += [{"technology": $tech, "dismissed_at": $now}]' \
  "$SKILL_METADATA" > "$TEMP_FILE"
mv "$TEMP_FILE" "$SKILL_METADATA"

echo "✅ Skill suggestion for '$TECH' has been dismissed."
echo ""
echo "I will not suggest creating a ${TECH}-expert skill in the future."
