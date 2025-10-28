#!/usr/bin/env bash
# Developer-Skills Statusline
# Technical, concise status display for Claude Code sessions
#
# Line 1: Directory, git, active superflow, context remaining
# Line 2: Git changes, memory context

set -euo pipefail

# ANSI color codes
readonly RESET='\033[0m'
readonly BOLD='\033[1m'
readonly DIM='\033[2m'
readonly CYAN='\033[36m'
readonly BLUE='\033[34m'
readonly GREEN='\033[32m'
readonly YELLOW='\033[33m'
readonly RED='\033[31m'

# === DATA COLLECTORS ===

directory() {
    local dir="${PWD/#$HOME/~}"
    printf "📁 %s" "$dir"
}

git_branch() {
    if ! git rev-parse --git-dir &>/dev/null; then
        return
    fi

    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || echo "detached")
    printf "🌿 %s" "$branch"
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
            printf "%s %s" "$flow" "$progress"
        else
            printf "%s" "$flow"
        fi
    fi
}

context_remaining() {
    # Try to get context from CLAUDE_CONTEXT_REMAINING env var if available
    # Otherwise parse from ccusage if installed
    # Format: 🧠 95% [=========-]

    local percentage=""

    # Check environment variable first
    if [[ -n "${CLAUDE_CONTEXT_REMAINING:-}" ]]; then
        percentage="$CLAUDE_CONTEXT_REMAINING"
    # Try ccusage if available
    elif command -v ccusage &>/dev/null; then
        # Parse context percentage from ccusage output
        local usage_output
        usage_output=$(ccusage 2>/dev/null || true)
        percentage=$(echo "$usage_output" | grep -oP 'Context:\s+\K\d+' || true)
    fi

    if [[ -z "$percentage" ]]; then
        return
    fi

    # Build progress bar
    local bar_length=10
    local filled=$(( (percentage * bar_length) / 100 ))
    local empty=$(( bar_length - filled ))

    local bar=""
    for ((i=0; i<filled; i++)); do bar+="="; done
    for ((i=0; i<empty; i++)); do bar+="-"; done

    # Color based on percentage
    local color="$GREEN"
    if [[ $percentage -lt 50 ]]; then
        color="$YELLOW"
    fi
    if [[ $percentage -lt 25 ]]; then
        color="$RED"
    fi

    printf "%b🧠 %d%% [%s]%b" "$color" "$percentage" "$bar" "$RESET"
}

git_changes() {
    # Count changed lines in git repo
    # Format: ±42 lines

    if ! git rev-parse --git-dir &>/dev/null; then
        return
    fi

    # Get number of changed lines (insertions + deletions)
    local changes
    changes=$(git diff --numstat 2>/dev/null | awk '{added+=$1; deleted+=$2} END {print added+deleted}')

    # Also check staged changes
    local staged
    staged=$(git diff --cached --numstat 2>/dev/null | awk '{added+=$1; deleted+=$2} END {print added+deleted}')

    local total=$((${changes:-0} + ${staged:-0}))

    if [[ $total -eq 0 ]]; then
        return
    fi

    printf "±%d lines" "$total"
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
    local components=()

    # Directory (always)
    components+=("$(directory)")

    # Git branch (conditional)
    local git_br
    if git_br=$(git_branch); then
        components+=("$git_br")
    fi

    # Active superflow (conditional)
    local flow
    if flow=$(active_superflow); then
        components+=("$flow")
    fi

    # Print basic components
    printf "%b%s%b  " "$CYAN" "${components[*]}" "$RESET"

    # Context remaining on same line with color (conditional)
    context_remaining
    printf "\n"
}

build_line2() {
    local components=()

    # Git changes (conditional)
    local changes
    if changes=$(git_changes); then
        components+=("$changes")
    fi

    # Memory stats (conditional)
    local mem
    if mem=$(memory_stats); then
        components+=("$mem")
    fi

    # Last observation (conditional)
    local obs
    if obs=$(last_observation); then
        components+=("$obs")
    fi

    # Only display if we have content
    if [[ ${#components[@]} -gt 0 ]]; then
        printf "%b%s%b\n" "$DIM" "${components[*]}" "$RESET"
    fi
}

# === MAIN ===

main() {
    build_line1
    build_line2
}

main "$@"
