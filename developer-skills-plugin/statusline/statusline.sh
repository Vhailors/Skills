#!/usr/bin/env bash
# Developer-Skills Statusline - Enhanced Edition
# Technical, colorful status display for Claude Code sessions
#
# Line 1: Directory, git, active superflow
# Line 2: Git changes (+/-), context remaining, memory

set -euo pipefail

# ANSI color codes - Enhanced for visibility
readonly RESET='\033[0m'
readonly BOLD='\033[1m'
readonly DIM='\033[2m'
readonly CYAN='\033[96m'           # Bright cyan for line 1
readonly BLUE='\033[94m'           # Bright blue for accents
readonly GREEN='\033[92m'          # Bright green for additions/good status
readonly YELLOW='\033[93m'         # Bright yellow for warnings
readonly RED='\033[91m'            # Bright red for deletions/critical
readonly MAGENTA='\033[95m'        # Bright magenta for superflows
readonly WHITE='\033[97m'          # Bright white for emphasis
readonly GRAY='\033[90m'           # Gray for separators

# === STDIN JSON CAPTURE ===
# Claude Code passes session data as JSON via stdin
CLAUDE_SESSION_JSON=""
if [[ -t 0 ]]; then
    # No stdin (interactive testing mode)
    CLAUDE_SESSION_JSON=""
else
    # Read stdin (when called by Claude Code)
    CLAUDE_SESSION_JSON=$(cat)
fi

# === DATA COLLECTORS ===

parse_json_field() {
    # Parse a field from CLAUDE_SESSION_JSON
    # Args: $1 = field name
    # Returns: field value or empty string

    local field="$1"
    local json="$CLAUDE_SESSION_JSON"

    if [[ -z "$json" ]]; then
        return
    fi

    # Try jq first (fastest and most reliable)
    if command -v jq &>/dev/null; then
        echo "$json" | jq -r ".$field // empty" 2>/dev/null || true
        return
    fi

    # Fall back to Python (more common than jq)
    if command -v python3 &>/dev/null; then
        echo "$json" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('$field', ''))" 2>/dev/null || true
        return
    fi

    # Last resort: grep/sed (less reliable but no dependencies)
    echo "$json" | grep -oP "\"$field\":\s*\K[^,}]+" 2>/dev/null | tr -d '"' || true
}

active_superflow() {
    # Check .claude-session for active superflow marker
    # Set by hooks when superflow triggers
    if [[ ! -f .claude-session ]]; then
        return
    fi

    local flow progress
    flow=$(grep -oP 'ACTIVE_SUPERFLOW=\K.*' .claude-session 2>/dev/null || true)
    progress=$(grep -oP 'TODO_PROGRESS=\K.*' .claude-session 2>/dev/null || true)

    if [[ -n $flow ]]; then
        if [[ -n $progress ]]; then
            printf "%b%s %s%b" "$MAGENTA$BOLD" "$flow" "$progress" "$RESET"
        else
            printf "%b%s%b" "$MAGENTA$BOLD" "$flow" "$RESET"
        fi
    fi
}

context_remaining() {
    # Parse context/token usage from Claude Code JSON (via stdin)
    # Falls back to env var or ccusage if stdin not available
    # Format: 🧠 Context: 95% [=========-] ✓

    local percentage=""
    local tokens_used=""
    local tokens_total=""

    # Priority 1: Parse from Claude Code JSON stdin
    if [[ -n "$CLAUDE_SESSION_JSON" ]]; then
        # Try to find token/context fields in JSON
        # Common field patterns: tokensUsed, tokensTotal, contextUsed, contextTotal
        # Also check for budget fields

        # Try different field name patterns for tokens used
        tokens_used=$(parse_json_field "tokensUsed")
        [[ -z "$tokens_used" ]] && tokens_used=$(parse_json_field "tokens_used")
        [[ -z "$tokens_used" ]] && tokens_used=$(parse_json_field "context_used")

        # Try different field name patterns for tokens total
        tokens_total=$(parse_json_field "tokensTotal")
        [[ -z "$tokens_total" ]] && tokens_total=$(parse_json_field "tokens_total")
        [[ -z "$tokens_total" ]] && tokens_total=$(parse_json_field "context_total")

        # Calculate percentage if we have both values
        if [[ -n "$tokens_used" ]] && [[ -n "$tokens_total" ]] && [[ "$tokens_total" -gt 0 ]]; then
            # Calculate remaining percentage
            percentage=$(( 100 - (tokens_used * 100 / tokens_total) ))
        else
            # Try to get percentage directly
            percentage=$(parse_json_field "contextRemaining")
            [[ -z "$percentage" ]] && percentage=$(parse_json_field "context_remaining")
        fi
    fi

    # Priority 2: Check environment variable
    if [[ -z "$percentage" ]] && [[ -n "${CLAUDE_CONTEXT_REMAINING:-}" ]]; then
        percentage="$CLAUDE_CONTEXT_REMAINING"
    fi

    # Priority 3: Try ccusage if available
    if [[ -z "$percentage" ]] && command -v ccusage &>/dev/null; then
        local usage_output
        usage_output=$(ccusage 2>/dev/null || true)
        percentage=$(echo "$usage_output" | grep -oP 'Context:\s+\K\d+' || true)
    fi

    # Exit if no percentage found
    if [[ -z "$percentage" ]] || [[ "$percentage" == "null" ]]; then
        return
    fi

    # Build progress bar
    local bar_length=10
    local filled=$(( (percentage * bar_length) / 100 ))
    local empty=$(( bar_length - filled ))

    local bar=""
    for ((i=0; i<filled; i++)); do bar+="="; done
    for ((i=0; i<empty; i++)); do bar+="-"; done

    # Color and status based on percentage
    local color="$GREEN"
    local status_emoji="✓"
    if [[ $percentage -lt 50 ]]; then
        color="$YELLOW"
        status_emoji="⚠"
    fi
    if [[ $percentage -lt 25 ]]; then
        color="$RED"
        status_emoji="⚠"
    fi

    printf "%b🧠 Context: %d%% [%s] %s%b" "$color$BOLD" "$percentage" "$bar" "$status_emoji" "$RESET"
}

git_changes() {
    # Count changed lines in git repo with insertions/deletions
    # Format: +155/-3 (green/red)

    if ! git rev-parse --git-dir &>/dev/null; then
        return
    fi

    # Get insertions and deletions separately for unstaged changes
    local unstaged_result
    unstaged_result=$(git diff --numstat 2>/dev/null | awk '{added+=$1; deleted+=$2} END {print added" "deleted}')
    local unstaged_add=$(echo "$unstaged_result" | awk '{print $1}')
    local unstaged_del=$(echo "$unstaged_result" | awk '{print $2}')

    # Get insertions and deletions for staged changes
    local staged_result
    staged_result=$(git diff --cached --numstat 2>/dev/null | awk '{added+=$1; deleted+=$2} END {print added" "deleted}')
    local staged_add=$(echo "$staged_result" | awk '{print $1}')
    local staged_del=$(echo "$staged_result" | awk '{print $2}')

    local total_add=$((${unstaged_add:-0} + ${staged_add:-0}))
    local total_del=$((${unstaged_del:-0} + ${staged_del:-0}))

    if [[ $total_add -eq 0 && $total_del -eq 0 ]]; then
        return
    fi

    # Format with colors
    printf "📝 %b+%d%b/%b-%d%b" "$GREEN$BOLD" "$total_add" "$RESET" "$RED$BOLD" "$total_del" "$RESET"
}

memory_stats() {
    # Placeholder for claude-mem MCP integration
    # Would query observation count when MCP available
    # Format: 🧠 Memory: 271 obs
    return
}

last_observation() {
    # Placeholder for claude-mem MCP integration
    # Would fetch most recent observation title
    # Format: 📝 Last: Hook blocking fix (#267)
    return
}

# === LINE BUILDERS ===

build_line1() {
    # Directory (always) - bright cyan, show only last folder name
    local dir_name
    dir_name=$(basename "$PWD")
    printf "%b📁 %s%b" "$CYAN$BOLD" "$dir_name" "$RESET"

    # Git branch (conditional) - bright green
    if git rev-parse --git-dir &>/dev/null; then
        local branch
        branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || echo "detached")
        printf "  %b🌿 %s%b" "$GREEN$BOLD" "$branch" "$RESET"
    fi

    # Active superflow (conditional) - bright magenta, already colored
    local flow
    if flow=$(active_superflow); then
        printf "  %s" "$flow"
    fi

    printf "\n"
}

build_line2() {
    local has_content=false

    # Git changes (conditional) - colored green/red
    local changes
    if changes=$(git_changes); then
        printf "%s" "$changes"
        has_content=true
    fi

    # Context remaining (conditional) - colored
    local ctx
    if ctx=$(context_remaining); then
        if [[ "$has_content" == "true" ]]; then
            printf "  %b│%b  " "$GRAY" "$RESET"
        fi
        printf "%s" "$ctx"
        has_content=true
    fi

    # Memory stats (conditional)
    local mem
    if mem=$(memory_stats); then
        if [[ "$has_content" == "true" ]]; then
            printf "  %b│%b  " "$GRAY" "$RESET"
        fi
        printf "%s" "$mem"
        has_content=true
    fi

    # Last observation (conditional)
    local obs
    if obs=$(last_observation); then
        if [[ "$has_content" == "true" ]]; then
            printf "  %b│%b  " "$GRAY" "$RESET"
        fi
        printf "%s" "$obs"
        has_content=true
    fi

    # Only add newline if we have content
    if [[ "$has_content" == "true" ]]; then
        printf "\n"
    fi
}

# === MAIN ===

main() {
    build_line1
    build_line2
}

main "$@"
