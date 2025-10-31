#!/bin/bash
# generate-skill.sh - Generate project skill using Skill Seekers
#
# Usage:
#   ./generate-skill.sh --name <skill-name> --source <url> [--type <doc|github|pdf>]
#   ./generate-skill.sh --name <skill-name> --config <config-path>
#
# Examples:
#   ./generate-skill.sh --name supabase-expert --source https://supabase.com/docs
#   ./generate-skill.sh --name stripe-expert --config configs/stripe.json
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"
PROJECT_ROOT="$(pwd)"  # Current working directory = actual project

# Use bundled Skill Seekers from plugin
SKILL_SEEKERS_DIR="$PLUGIN_ROOT/vendor/Skill_Seekers"
PROJECT_SKILLS_DIR="$PROJECT_ROOT/.claude/project-skills"
METADATA_FILE="$PROJECT_ROOT/.claude/skill-metadata.json"

# Parse arguments
NAME=""
SOURCE=""
TYPE="doc"
CONFIG=""
ENHANCE=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --name)
      NAME="$2"
      shift 2
      ;;
    --source)
      SOURCE="$2"
      shift 2
      ;;
    --type)
      TYPE="$2"
      shift 2
      ;;
    --config)
      CONFIG="$2"
      shift 2
      ;;
    --enhance)
      ENHANCE=true
      shift
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      exit 1
      ;;
  esac
done

# Extract name from config if using config mode
if [[ -n "$CONFIG" ]] && [[ -z "$NAME" ]]; then
  # Convert to absolute path if relative
  if [[ ! "$CONFIG" = /* ]]; then
    CONFIG="$PROJECT_ROOT/$CONFIG"
  fi

  if [[ ! -f "$CONFIG" ]]; then
    echo -e "${RED}Error: Config file not found: $CONFIG${NC}"
    exit 1
  fi
  NAME=$(jq -r '.name' "$CONFIG")
fi

# Validation
if [[ -z "$NAME" ]]; then
  echo -e "${RED}Error: --name is required (or use --config with name field)${NC}"
  exit 1
fi

if [[ -z "$CONFIG" ]] && [[ -z "$SOURCE" ]]; then
  echo -e "${RED}Error: Either --source or --config is required${NC}"
  exit 1
fi

# Check if Skill Seekers exists
if [[ ! -d "$SKILL_SEEKERS_DIR" ]]; then
  echo -e "${RED}Error: Skill Seekers not found at $SKILL_SEEKERS_DIR${NC}"
  echo -e "${YELLOW}Run: git clone https://github.com/yusufkaraaslan/Skill_Seekers.git${NC}"
  exit 1
fi

# Check if skill already exists
SKILL_DIR="$PROJECT_SKILLS_DIR/$NAME"
if [[ -d "$SKILL_DIR" ]]; then
  echo -e "${YELLOW}⚠️  Skill '$NAME' already exists${NC}"
  read -p "Overwrite? (y/N): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Aborted${NC}"
    exit 0
  fi
  rm -rf "$SKILL_DIR"
fi

# Create project-skills directory if needed
mkdir -p "$PROJECT_SKILLS_DIR"

# Run Skill Seekers
echo -e "${BLUE}🔍 Generating skill: $NAME${NC}"
echo -e "${BLUE}Source: ${SOURCE:-$CONFIG}${NC}"
echo ""

cd "$SKILL_SEEKERS_DIR"

if [[ -n "$CONFIG" ]]; then
  # Use config file
  if $ENHANCE; then
    python3 cli/doc_scraper.py --config "$CONFIG" --enhance-local
  else
    python3 cli/doc_scraper.py --config "$CONFIG"
  fi
else
  # Use quick mode
  DESCRIPTION="Expert assistance for $NAME"
  if $ENHANCE; then
    python3 cli/doc_scraper.py --name "$NAME" --url "$SOURCE" --description "$DESCRIPTION" --enhance-local
  else
    python3 cli/doc_scraper.py --name "$NAME" --url "$SOURCE" --description "$DESCRIPTION"
  fi
fi

# Check if generation succeeded
OUTPUT_DIR="$SKILL_SEEKERS_DIR/output/$NAME"
if [[ ! -d "$OUTPUT_DIR" ]]; then
  echo -e "${RED}Error: Skill generation failed${NC}"
  exit 1
fi

# Copy to project-skills
echo ""
echo -e "${BLUE}📦 Installing skill to project...${NC}"
cp -r "$OUTPUT_DIR" "$SKILL_DIR"

# Create skill metadata
METADATA_JSON=$(cat <<EOF
{
  "name": "$NAME",
  "source": "${SOURCE:-$CONFIG}",
  "type": "$TYPE",
  "created": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "last_used": null,
  "usage_count": 0,
  "enhanced": $ENHANCE
}
EOF
)

# Update master metadata file
if [[ ! -f "$METADATA_FILE" ]]; then
  echo '{"skills": [], "dismissals": [], "statistics": {"total_skills": 0}}' > "$METADATA_FILE"
fi

# Add skill to registry (using jq)
TEMP_FILE=$(mktemp)
jq --argjson skill "$METADATA_JSON" '.skills += [$skill] | .statistics.total_skills += 1' "$METADATA_FILE" > "$TEMP_FILE"
mv "$TEMP_FILE" "$METADATA_FILE"

# Save skill-specific metadata
echo "$METADATA_JSON" > "$SKILL_DIR/.metadata.json"

echo ""
echo -e "${GREEN}✅ Skill '$NAME' created successfully!${NC}"
echo ""
echo -e "${BLUE}📁 Location: $SKILL_DIR${NC}"
echo -e "${BLUE}📄 Files:${NC}"
ls -lh "$SKILL_DIR" | tail -n +2
echo ""
echo -e "${GREEN}💡 Skill will auto-load in next session${NC}"
echo -e "${BLUE}   Or manually load: /load-skill $NAME${NC}"
