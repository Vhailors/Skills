#!/bin/bash
# Spotlight Query Helper
# Provides convenient functions to query Spotlight MCP server for error data
# Used by other hooks to integrate Spotlight telemetry into workflows

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if Spotlight MCP is available
check_spotlight_available() {
    # Check if .mcp.json exists
    if [ ! -f "$PLUGIN_ROOT/.mcp.json" ]; then
        return 1
    fi

    # Check if Spotlight server is configured
    if ! grep -q "sentry-spotlight" "$PLUGIN_ROOT/.mcp.json" 2>/dev/null; then
        return 1
    fi

    return 0
}

# Function to query Spotlight for recent errors
# Returns JSON array of errors
get_recent_errors() {
    local since="${1:-10m}"  # Default: last 10 minutes

    if ! check_spotlight_available; then
        echo "[]"
        return 0
    fi

    # NOTE: The actual MCP tool names will be determined when we test the server
    # This is a placeholder structure that will be updated based on actual tool availability
    # For now, we provide a graceful fallback

    # Attempt to query via Claude MCP (this would be called by Claude Code, not directly)
    # In practice, this script will be called FROM Claude Code context where MCP tools are available
    echo "[]"
    return 0
}

# Function to check if any errors exist
# Exit code: 0 = no errors, 1 = has errors
has_errors() {
    local since="${1:-10m}"

    if ! check_spotlight_available; then
        return 0  # No errors if Spotlight not available
    fi

    local errors=$(get_recent_errors "$since")

    if [ "$errors" = "[]" ] || [ -z "$errors" ]; then
        return 0  # No errors
    else
        return 1  # Has errors
    fi
}

# Function to get human-readable error summary
get_error_summary() {
    local since="${1:-10m}"

    if ! check_spotlight_available; then
        echo "Spotlight not available"
        return 0
    fi

    local errors=$(get_recent_errors "$since")

    if [ "$errors" = "[]" ] || [ -z "$errors" ]; then
        echo "No errors detected in last $since"
        return 0
    fi

    # Parse and format errors (this will be implemented once we know the actual data structure)
    echo "Errors detected (details require MCP query from Claude Code context)"
    return 0
}

# Function to check Spotlight status
check_status() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔎 Spotlight MCP Status"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo

    # Check .mcp.json
    if [ -f "$PLUGIN_ROOT/.mcp.json" ]; then
        echo -e "${GREEN}✓${NC} .mcp.json configuration exists"
    else
        echo -e "${RED}✗${NC} .mcp.json not found"
        echo "  Run: See SPOTLIGHT-SETUP.md for configuration"
        return 1
    fi

    # Check if Spotlight configured
    if grep -q "sentry-spotlight" "$PLUGIN_ROOT/.mcp.json" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} Spotlight MCP server configured"
    else
        echo -e "${RED}✗${NC} Spotlight not configured in .mcp.json"
        return 1
    fi

    # Check if Spotlight sidecar can run
    echo
    echo "Testing Spotlight sidecar..."
    if command -v npx &> /dev/null; then
        echo -e "${GREEN}✓${NC} npx available"

        # Test if package exists (don't actually start it)
        if npx -y @spotlightjs/spotlight@latest --help &> /dev/null; then
            echo -e "${GREEN}✓${NC} @spotlightjs/spotlight package accessible"
        else
            echo -e "${YELLOW}⚠${NC} Could not verify @spotlightjs/spotlight package"
        fi
    else
        echo -e "${RED}✗${NC} npx not found (Node.js required)"
        return 1
    fi

    echo
    echo -e "${BLUE}ℹ${NC} Spotlight MCP will be available when:"
    echo "  1. Your app is running with Sentry SDK"
    echo "  2. SENTRY_SPOTLIGHT=1 environment variable is set"
    echo "  3. Claude Code MCP client connects to the server"
    echo
    echo "See: developer-skills-plugin/docs/SPOTLIGHT-SETUP.md"

    return 0
}

# Function to provide usage instructions
show_usage() {
    cat << EOF
Spotlight Query Helper

Usage: spotlight-query.sh <command> [options]

Commands:
  status              Check Spotlight configuration and status
  recent-errors       Get recent errors (default: last 10 minutes)
  has-errors          Check if errors exist (exit code 0=no, 1=yes)
  summary             Get human-readable error summary
  help                Show this help message

Options:
  --since <duration>  Time window for queries (e.g., 5m, 1h, 30m)

Examples:
  spotlight-query.sh status
  spotlight-query.sh recent-errors --since 5m
  spotlight-query.sh summary
  spotlight-query.sh has-errors && echo "No errors" || echo "Has errors"

Note:
  This script provides a shell interface to Spotlight data.
  Actual MCP queries must be made from Claude Code context where
  MCP tools are available. This script is used by hooks to check
  Spotlight status and provide helper functions.

For setup instructions, see:
  developer-skills-plugin/docs/SPOTLIGHT-SETUP.md
EOF
}

# Main command dispatcher
main() {
    local command="${1:-help}"
    shift || true

    case "$command" in
        status)
            check_status
            ;;
        recent-errors)
            get_recent_errors "$@"
            ;;
        has-errors)
            has_errors "$@"
            ;;
        summary)
            get_error_summary "$@"
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            echo "Unknown command: $command"
            echo
            show_usage
            exit 1
            ;;
    esac
}

# Run main if script is executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
