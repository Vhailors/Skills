#!/bin/bash

# Archon MCP Connection Test Script
# Verifies that Archon MCP server is accessible and working correctly

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DEFAULT_MCP_PORT=8051
DEFAULT_UI_PORT=3737
DEFAULT_SERVER_PORT=8181

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}   Archon MCP Connection Test${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Status printing functions
print_pass() {
    echo -e "${GREEN}✓${NC} $1"
}

print_fail() {
    echo -e "${RED}✗${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Read ports from .env if available
ARCHON_PATH="/mnt/c/Users/Dominik/Documents/archon"
if [ -f "${ARCHON_PATH}/.env" ]; then
    MCP_PORT=$(grep "^ARCHON_MCP_PORT=" "${ARCHON_PATH}/.env" | cut -d '=' -f2)
    UI_PORT=$(grep "^ARCHON_UI_PORT=" "${ARCHON_PATH}/.env" | cut -d '=' -f2)
    SERVER_PORT=$(grep "^ARCHON_SERVER_PORT=" "${ARCHON_PATH}/.env" | cut -d '=' -f2)
fi

MCP_PORT=${MCP_PORT:-$DEFAULT_MCP_PORT}
UI_PORT=${UI_PORT:-$DEFAULT_UI_PORT}
SERVER_PORT=${SERVER_PORT:-$DEFAULT_SERVER_PORT}

PASSED=0
FAILED=0
WARNINGS=0

# Test 1: Check Docker containers
echo -e "${BLUE}[1/8] Checking Docker containers...${NC}"
if docker ps --filter "name=archon-" --format "{{.Names}}" | grep -q "archon-"; then
    print_pass "Archon containers are running"
    docker ps --filter "name=archon-" --format "  • {{.Names}} - {{.Status}}"
    ((PASSED++))
else
    print_fail "No Archon containers running"
    print_info "Run: docker compose -f ${ARCHON_PATH}/docker-compose.yml up -d"
    ((FAILED++))
    exit 1
fi
echo ""

# Test 2: Check MCP server health endpoint
echo -e "${BLUE}[2/8] Testing MCP server health...${NC}"
if curl -sf "http://localhost:${MCP_PORT}/health" >/dev/null 2>&1; then
    print_pass "MCP server health endpoint responding (port ${MCP_PORT})"
    ((PASSED++))
else
    print_fail "MCP server health endpoint not accessible"
    ((FAILED++))
fi
echo ""

# Test 3: Check MCP endpoint
echo -e "${BLUE}[3/8] Testing MCP endpoint...${NC}"
MCP_RESPONSE=$(curl -sf "http://localhost:${MCP_PORT}/mcp" 2>/dev/null || echo "")
if [ ! -z "$MCP_RESPONSE" ]; then
    print_pass "MCP endpoint accessible at http://localhost:${MCP_PORT}/mcp"
    ((PASSED++))
else
    print_fail "MCP endpoint not accessible"
    ((FAILED++))
fi
echo ""

# Test 4: Check UI accessibility
echo -e "${BLUE}[4/8] Testing UI accessibility...${NC}"
if curl -sf "http://localhost:${UI_PORT}" >/dev/null 2>&1; then
    print_pass "UI accessible at http://localhost:${UI_PORT}"
    ((PASSED++))
else
    print_warn "UI not accessible (might be starting)"
    ((WARNINGS++))
fi
echo ""

# Test 5: Check API server
echo -e "${BLUE}[5/8] Testing API server...${NC}"
if curl -sf "http://localhost:${SERVER_PORT}/health" >/dev/null 2>&1; then
    print_pass "API server responding (port ${SERVER_PORT})"
    ((PASSED++))
else
    print_warn "API server not responding"
    ((WARNINGS++))
fi
echo ""

# Test 6: Check database connectivity (via API)
echo -e "${BLUE}[6/8] Testing database connectivity...${NC}"
DB_TEST=$(curl -sf "http://localhost:${SERVER_PORT}/api/knowledge-base/sources" 2>/dev/null || echo "")
if [ ! -z "$DB_TEST" ]; then
    print_pass "Database connection working"
    ((PASSED++))
else
    print_fail "Cannot connect to database"
    print_info "Have you run the migration/complete_setup.sql in Supabase?"
    ((FAILED++))
fi
echo ""

# Test 7: Check claude-mem MCP server (should coexist)
echo -e "${BLUE}[7/8] Checking claude-mem MCP server...${NC}"
CLAUDE_MEM_RUNNING=false
if pgrep -f "claude-mem" >/dev/null 2>&1; then
    print_pass "claude-mem MCP server is running (dual MCP setup)"
    ((PASSED++))
    CLAUDE_MEM_RUNNING=true
elif command -v npx >/dev/null 2>&1 && npx -y @dominikwilkowski/claude-mem --version >/dev/null 2>&1; then
    print_info "claude-mem is available but not running"
    ((WARNINGS++))
else
    print_warn "claude-mem not detected (optional for dual MCP setup)"
    ((WARNINGS++))
fi
echo ""

# Test 8: MCP Configuration Check
echo -e "${BLUE}[8/8] Checking Claude Code MCP configuration...${NC}"
print_info "To add Archon to Claude Code, run:"
echo ""
echo -e "  ${GREEN}claude mcp add --transport http archon http://localhost:${MCP_PORT}/mcp${NC}"
echo ""
print_info "Or manually add to MCP config:"
echo "  {"
echo "    \"name\": \"archon\","
echo "    \"transport\": \"http\","
echo "    \"url\": \"http://localhost:${MCP_PORT}/mcp\""
echo "  }"
echo ""

# Summary
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}   Test Summary${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
print_pass "Passed: ${PASSED}"
if [ $FAILED -gt 0 ]; then
    print_fail "Failed: ${FAILED}"
fi
if [ $WARNINGS -gt 0 ]; then
    print_warn "Warnings: ${WARNINGS}"
fi
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}   All Critical Tests Passed!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    print_info "Archon MCP is ready to use!"
    echo ""
    print_info "Next steps:"
    echo "  1. Add Archon MCP to Claude Code (command above)"
    echo "  2. Open UI at http://localhost:${UI_PORT}"
    echo "  3. Create your first knowledge source"
    echo "  4. Test RAG search from Claude Code"
    echo ""
    print_info "Useful resources:"
    echo "  • Workflow guide: developer-skills-plugin/integrations/archon/WORKFLOW.md"
    echo "  • Documentation: ${ARCHON_PATH}/README.md"
    echo ""
    exit 0
else
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}   Some Tests Failed${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    print_info "Troubleshooting:"
    echo "  • Check logs: docker compose -f ${ARCHON_PATH}/docker-compose.yml logs -f"
    echo "  • Verify .env: cat ${ARCHON_PATH}/.env"
    echo "  • Restart services: docker compose -f ${ARCHON_PATH}/docker-compose.yml restart"
    echo "  • Check database migration: ${ARCHON_PATH}/migration/complete_setup.sql"
    echo ""
    exit 1
fi
