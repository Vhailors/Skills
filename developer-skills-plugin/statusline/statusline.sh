#!/usr/bin/env bash
# Developer-Skills Statusline
# Technical, concise status display for Claude Code sessions
#
# Line 1: Directory, git, active superflow, todo progress
# Line 2: Memory context, recent observation

set -euo pipefail

# ANSI color codes
readonly RESET='\033[0m'
readonly BOLD='\033[1m'
readonly DIM='\033[2m'
readonly CYAN='\033[36m'
readonly BLUE='\033[34m'

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

    local flow
    flow=$(grep -oP 'ACTIVE_SUPERFLOW=\K.*' .claude-session 2>/dev/null || true)

    if [[ -n $flow ]]; then
        printf "%s" "$flow"
    fi
}

todo_progress() {
    # Placeholder for todo progress
    # Would integrate with Claude Code todo API when available
    # Format: ✅ 3/6
    return
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
    local git
    if git=$(git_branch); then
        components+=("$git")
    fi

    # Active superflow (conditional)
    local flow
    if flow=$(active_superflow); then
        components+=("$flow")
    fi

    # Todo progress (conditional)
    local todos
    if todos=$(todo_progress); then
        components+=("$todos")
    fi

    # Join with double spaces for readability
    printf "%b%s%b\n" "$CYAN" "${components[*]}" "$RESET"
}

build_line2() {
    local components=()

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
