#!/bin/bash
# detect-skill-gaps.sh - Pattern detection for auto-skill generation
#
# Detects when users repeatedly ask about the same technology (3+ mentions)
# and suggests creating an expert skill using Skill Seekers
#

set -euo pipefail

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
PROJECT_ROOT="$(pwd)"  # Current working directory = actual project

CONVERSATION_HISTORY="$PROJECT_ROOT/.claude/conversation-history.json"
SKILL_METADATA="$PROJECT_ROOT/.claude/skill-metadata.json"
PROJECT_SKILLS_DIR="$PROJECT_ROOT/.claude/project-skills"
CUSTOM_PATTERNS_FILE="$PROJECT_ROOT/.claude/custom-skill-patterns.json"

# Get user prompt from stdin
USER_PROMPT=""
while IFS= read -r line; do
  USER_PROMPT+="$line"$'\n'
done

# Technology patterns to detect
# Format: "pattern:suggested_name:description:docs_url"
TECH_PATTERNS=(
  "supabase:supabase-expert:Supabase backend platform expert:https://supabase.com/docs"
  "stripe:stripe-expert:Stripe payment processing expert:https://stripe.com/docs"
  "firebase:firebase-expert:Firebase backend services expert:https://firebase.google.com/docs"
  "nextjs|next\.js:nextjs-expert:Next.js React framework expert:https://nextjs.org/docs"
  "tailwind:tailwind-expert:Tailwind CSS utility framework expert:https://tailwindcss.com/docs"
  "prisma:prisma-expert:Prisma ORM database toolkit expert:https://www.prisma.io/docs"
  "trpc:trpc-expert:tRPC end-to-end typesafe APIs expert:https://trpc.io/docs"
  "drizzle:drizzle-expert:Drizzle ORM TypeScript expert:https://orm.drizzle.team/docs"
  "shadcn|shadcn/ui:shadcn-expert:shadcn/ui component library expert:https://ui.shadcn.com"
  "clerk:clerk-expert:Clerk authentication expert:https://clerk.com/docs"
  "vercel:vercel-expert:Vercel deployment platform expert:https://vercel.com/docs"
  "astro:astro-expert:Astro web framework expert:https://docs.astro.build"
  "sveltekit:sveltekit-expert:SvelteKit framework expert:https://kit.svelte.dev/docs"
  "nuxt:nuxt-expert:Nuxt.js Vue framework expert:https://nuxt.com/docs"
  "remix:remix-expert:Remix full stack framework expert:https://remix.run/docs"
  "vite:vite-expert:Vite build tool expert:https://vitejs.dev/guide"
  "pnpm:pnpm-expert:pnpm package manager expert:https://pnpm.io/motivation"
  "turborepo:turborepo-expert:Turborepo monorepo tool expert:https://turbo.build/repo/docs"
  "playwright:playwright-expert:Playwright testing framework expert:https://playwright.dev/docs/intro"
  "vitest:vitest-expert:Vitest testing framework expert:https://vitest.dev/guide"
  "fastapi:fastapi-expert:FastAPI Python framework expert:https://fastapi.tiangolo.com"
  "django:django-expert:Django web framework expert:https://docs.djangoproject.com"
  "flask:flask-expert:Flask Python framework expert:https://flask.palletsprojects.com"
  "express:express-expert:Express.js Node framework expert:https://expressjs.com"
  "nestjs:nestjs-expert:NestJS framework expert:https://docs.nestjs.com"
  "golang|go lang:golang-expert:Go programming language expert:https://go.dev/doc"
  "rust:rust-expert:Rust programming language expert:https://doc.rust-lang.org"
  "kubernetes|k8s:kubernetes-expert:Kubernetes container orchestration expert:https://kubernetes.io/docs"
  "docker:docker-expert:Docker containerization expert:https://docs.docker.com"
  "terraform:terraform-expert:Terraform infrastructure as code expert:https://developer.hashicorp.com/terraform/docs"
)

# Load custom patterns from JSON file (if exists and jq available)
if [[ -f "$CUSTOM_PATTERNS_FILE" ]] && command -v jq &> /dev/null; then
  # Extract enabled custom patterns and add to TECH_PATTERNS array
  while IFS= read -r custom_pattern; do
    if [[ -n "$custom_pattern" ]]; then
      TECH_PATTERNS+=("$custom_pattern")
    fi
  done < <(jq -r '.custom_patterns[] | select(.enabled == true) | "\(.pattern):\(.skill_name):\(.description):\(.docs_url)"' "$CUSTOM_PATTERNS_FILE" 2>/dev/null || true)
fi

# Initialize conversation history if needed
if [[ ! -f "$CONVERSATION_HISTORY" ]]; then
  echo '{
    "version": "1.0",
    "sessions": [],
    "technology_mentions": {},
    "last_updated": null
  }' > "$CONVERSATION_HISTORY"
fi

# Initialize skill metadata if needed
if [[ ! -f "$SKILL_METADATA" ]]; then
  echo '{
    "skills": [],
    "dismissals": [],
    "statistics": {"total_skills": 0, "total_suggestions": 0, "acceptance_rate": 0}
  }' > "$SKILL_METADATA"
fi

# Function to check if skill exists
skill_exists() {
  local skill_name="$1"
  if [[ -d "$PROJECT_SKILLS_DIR/$skill_name" ]]; then
    return 0
  fi
  return 1
}

# Function to check if tech was dismissed
is_dismissed() {
  local tech_name="$1"
  if ! command -v jq &> /dev/null; then
    return 1
  fi

  local dismissed=$(jq -r --arg tech "$tech_name" '.dismissals[] | select(.technology == $tech) | .technology' "$SKILL_METADATA" 2>/dev/null)
  if [[ -n "$dismissed" ]]; then
    return 0
  fi
  return 1
}

# Function to update mention count
update_mentions() {
  local tech_name="$1"
  local skill_name="$2"

  if ! command -v jq &> /dev/null; then
    return
  fi

  local now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  local temp_file=$(mktemp)

  # Add or increment mention count
  jq --arg tech "$tech_name" --arg skill "$skill_name" --arg now "$now" '
    .technology_mentions[$tech] = {
      "count": ((.technology_mentions[$tech].count // 0) + 1),
      "skill_name": $skill,
      "last_mention": $now,
      "first_mention": ((.technology_mentions[$tech].first_mention) // $now)
    } | .last_updated = $now
  ' "$CONVERSATION_HISTORY" > "$temp_file" && mv "$temp_file" "$CONVERSATION_HISTORY"
}

# Function to get mention count
get_mention_count() {
  local tech_name="$1"

  if ! command -v jq &> /dev/null; then
    echo "0"
    return
  fi

  local count=$(jq -r --arg tech "$tech_name" '.technology_mentions[$tech].count // 0' "$CONVERSATION_HISTORY" 2>/dev/null)
  echo "${count:-0}"
}

# Detect technology mentions in prompt
DETECTED_TECH=""
SKILL_NAME=""
DESCRIPTION=""
DOCS_URL=""

for pattern_info in "${TECH_PATTERNS[@]}"; do
  IFS=':' read -r pattern skill_name description docs_url <<< "$pattern_info"

  # Case-insensitive match
  if echo "$USER_PROMPT" | grep -iE "\b($pattern)\b" > /dev/null; then
    DETECTED_TECH="$pattern"
    SKILL_NAME="$skill_name"
    DESCRIPTION="$description"
    DOCS_URL="$docs_url"
    break
  fi
done

# No technology detected - exit silently
if [[ -z "$DETECTED_TECH" ]]; then
  exit 0
fi

# Update mention count
update_mentions "$DETECTED_TECH" "$SKILL_NAME"

# Get current count
MENTION_COUNT=$(get_mention_count "$DETECTED_TECH")

# Check conditions for suggestion
SHOULD_SUGGEST=false

# Only suggest on 3rd, 6th, 9th mention (not every time)
if [[ $MENTION_COUNT -eq 3 ]] || [[ $MENTION_COUNT -eq 6 ]] || [[ $MENTION_COUNT -eq 9 ]]; then
  if ! skill_exists "$SKILL_NAME" && ! is_dismissed "$DETECTED_TECH"; then
    SHOULD_SUGGEST=true
  fi
fi

# If we should suggest, output guidance
if [[ "$SHOULD_SUGGEST" = true ]]; then
  # Update statistics
  if command -v jq &> /dev/null; then
    temp_file=$(mktemp)
    jq '.statistics.total_suggestions += 1' "$SKILL_METADATA" > "$temp_file" && mv "$temp_file" "$SKILL_METADATA"
  fi

  # Output suggestion in JSON format for UserPromptSubmit hook
  cat <<EOF
{
  "type": "skill_suggestion",
  "technology": "$DETECTED_TECH",
  "skill_name": "$SKILL_NAME",
  "description": "$DESCRIPTION",
  "docs_url": "$DOCS_URL",
  "mention_count": $MENTION_COUNT,
  "message": "## 💡 Auto-Skill Suggestion

I've noticed you've mentioned **$DETECTED_TECH** $MENTION_COUNT times in recent conversations.

Would you like me to create a **$SKILL_NAME** skill? This would give me expert knowledge of $DETECTED_TECH by scraping the official documentation.

### What You'll Get:
- 📚 Complete $DETECTED_TECH documentation reference
- 💻 Real code examples from official docs
- 🎯 Quick patterns and best practices
- 🔍 Auto-loaded in every session (no more pasting docs!)

### How to Create:
\`\`\`bash
./developer-skills-plugin/commands/generate-skill.sh \\
  --name $SKILL_NAME \\
  --source $DOCS_URL \\
  --enhance
\`\`\`

**Time**: ~20-30 minutes (first scrape) + 60 seconds (AI enhancement)

**Options**:
- ✅ **Create Now**: Run the command above
- ⏭️ **Not Now**: I'll suggest again at next milestone
- 🚫 **Never for $DETECTED_TECH**: I won't suggest this again

Let me know if you'd like me to create this skill!"
}
EOF
fi

exit 0
