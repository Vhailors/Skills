#!/bin/bash

# Archon MCP Integration Setup Script
# This script automates the setup of Archon MCP server for developer-skills system

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ARCHON_REPO_URL="https://github.com/coleam00/archon.git"
DEFAULT_ARCHON_PATH="/mnt/c/Users/Dominik/Documents/archon"
ARCHON_BRANCH="stable"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}   Archon MCP Integration Setup${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Function to print status messages
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Step 1: Check Prerequisites
echo -e "${BLUE}[1/7] Checking prerequisites...${NC}"

# Check Docker
if command_exists docker; then
    print_status "Docker found: $(docker --version | head -n1)"
else
    print_error "Docker not found. Please install Docker Desktop."
    exit 1
fi

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker Desktop."
    exit 1
fi
print_status "Docker is running"

# Check docker-compose
if command_exists docker-compose || docker compose version >/dev/null 2>&1; then
    print_status "Docker Compose found"
else
    print_error "Docker Compose not found"
    exit 1
fi

# Check curl
if command_exists curl; then
    print_status "curl found"
else
    print_error "curl not found. Please install curl."
    exit 1
fi

echo ""

# Step 2: Verify/Clone Archon Repository
echo -e "${BLUE}[2/7] Setting up Archon repository...${NC}"

read -p "Enter Archon installation path [${DEFAULT_ARCHON_PATH}]: " ARCHON_PATH
ARCHON_PATH=${ARCHON_PATH:-$DEFAULT_ARCHON_PATH}

if [ -d "$ARCHON_PATH" ]; then
    print_info "Archon directory exists at: $ARCHON_PATH"
    read -p "Pull latest changes? (y/n) [y]: " PULL_LATEST
    PULL_LATEST=${PULL_LATEST:-y}

    if [ "$PULL_LATEST" = "y" ]; then
        cd "$ARCHON_PATH"
        git fetch origin
        git checkout "$ARCHON_BRANCH"
        git pull origin "$ARCHON_BRANCH"
        print_status "Pulled latest changes from ${ARCHON_BRANCH} branch"
    fi
else
    print_info "Cloning Archon repository..."
    git clone -b "$ARCHON_BRANCH" "$ARCHON_REPO_URL" "$ARCHON_PATH"
    print_status "Repository cloned to: $ARCHON_PATH"
fi

cd "$ARCHON_PATH"
echo ""

# Step 3: Environment Configuration
echo -e "${BLUE}[3/7] Configuring environment...${NC}"

if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        cp .env.example .env
        print_info "Created .env from .env.example"
    else
        print_error ".env.example not found"
        exit 1
    fi
fi

print_info "Please provide the following configuration values:"
echo ""

# Supabase Configuration
read -p "Supabase URL (e.g., https://xxx.supabase.co): " SUPABASE_URL
read -p "Supabase Service Key (the LONGER legacy key): " SUPABASE_SERVICE_KEY

# OpenAI API Key (required for embeddings)
read -p "OpenAI API Key (required for embeddings): " OPENAI_API_KEY

# Optional configurations
read -p "Anthropic API Key (optional, for Agent Work Orders) [skip]: " ANTHROPIC_API_KEY
read -p "GitHub PAT Token (optional, for PR creation) [skip]: " GITHUB_PAT_TOKEN
read -p "Claude Code OAuth Token (optional, for Work Orders) [skip]: " CLAUDE_CODE_OAUTH_TOKEN

# Update .env file
sed -i "s|^SUPABASE_URL=.*|SUPABASE_URL=${SUPABASE_URL}|" .env
sed -i "s|^SUPABASE_SERVICE_KEY=.*|SUPABASE_SERVICE_KEY=${SUPABASE_SERVICE_KEY}|" .env

if [ ! -z "$OPENAI_API_KEY" ]; then
    sed -i "s|^OPENAI_API_KEY=.*|OPENAI_API_KEY=${OPENAI_API_KEY}|" .env
fi

if [ ! -z "$ANTHROPIC_API_KEY" ]; then
    sed -i "s|^ANTHROPIC_API_KEY=.*|ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}|" .env
fi

if [ ! -z "$GITHUB_PAT_TOKEN" ]; then
    sed -i "s|^GITHUB_PAT_TOKEN=.*|GITHUB_PAT_TOKEN=${GITHUB_PAT_TOKEN}|" .env
fi

if [ ! -z "$CLAUDE_CODE_OAUTH_TOKEN" ]; then
    sed -i "s|^CLAUDE_CODE_OAUTH_TOKEN=.*|CLAUDE_CODE_OAUTH_TOKEN=${CLAUDE_CODE_OAUTH_TOKEN}|" .env
fi

print_status "Environment configured"
echo ""

# Step 4: Database Setup
echo -e "${BLUE}[4/7] Database setup...${NC}"
print_warning "IMPORTANT: You need to run the database migration manually!"
print_info "Steps:"
echo "  1. Go to https://supabase.com/dashboard"
echo "  2. Select your project"
echo "  3. Go to SQL Editor"
echo "  4. Copy the contents of: ${ARCHON_PATH}/migration/complete_setup.sql"
echo "  5. Paste and execute in SQL Editor"
echo ""
read -p "Press Enter after you've completed the database setup..."
echo ""

# Step 5: Start Services
echo -e "${BLUE}[5/7] Starting Archon services...${NC}"

read -p "Which services to start? (1=minimal, 2=with agents, 3=with work-orders) [1]: " SERVICE_PROFILE
SERVICE_PROFILE=${SERVICE_PROFILE:-1}

case $SERVICE_PROFILE in
    1)
        print_info "Starting minimal services (server, mcp, ui)..."
        docker compose up -d --build
        ;;
    2)
        print_info "Starting with agents service..."
        docker compose --profile agents up -d --build
        ;;
    3)
        print_info "Starting with agent work orders..."
        docker compose --profile work-orders up -d --build
        ;;
    *)
        print_error "Invalid option"
        exit 1
        ;;
esac

# Wait for services to be ready
print_info "Waiting for services to start..."
sleep 10

# Check service health
ARCHON_MCP_PORT=$(grep "^ARCHON_MCP_PORT=" .env | cut -d '=' -f2)
ARCHON_MCP_PORT=${ARCHON_MCP_PORT:-8051}

ARCHON_UI_PORT=$(grep "^ARCHON_UI_PORT=" .env | cut -d '=' -f2)
ARCHON_UI_PORT=${ARCHON_UI_PORT:-3737}

print_info "Checking service health..."
if curl -f http://localhost:${ARCHON_MCP_PORT}/health >/dev/null 2>&1; then
    print_status "Archon MCP server is running on port ${ARCHON_MCP_PORT}"
else
    print_warning "Archon MCP server might not be ready yet (port ${ARCHON_MCP_PORT})"
fi

if curl -f http://localhost:${ARCHON_UI_PORT} >/dev/null 2>&1; then
    print_status "Archon UI is running on port ${ARCHON_UI_PORT}"
else
    print_warning "Archon UI might not be ready yet (port ${ARCHON_UI_PORT})"
fi

echo ""

# Step 6: Claude Code MCP Configuration
echo -e "${BLUE}[6/7] Claude Code MCP configuration...${NC}"
print_info "Add Archon to Claude Code MCP servers:"
echo ""
echo -e "${GREEN}Command:${NC}"
echo "  claude mcp add --transport http archon http://localhost:${ARCHON_MCP_PORT}/mcp"
echo ""
echo -e "${GREEN}Or manually add to your MCP config:${NC}"
echo "  {"
echo "    \"name\": \"archon\","
echo "    \"transport\": \"http\","
echo "    \"url\": \"http://localhost:${ARCHON_MCP_PORT}/mcp\""
echo "  }"
echo ""
read -p "Would you like to copy the command to clipboard? (y/n) [n]: " COPY_CMD
if [ "$COPY_CMD" = "y" ]; then
    echo "claude mcp add --transport http archon http://localhost:${ARCHON_MCP_PORT}/mcp" | clip.exe 2>/dev/null || xclip -selection clipboard 2>/dev/null || pbcopy 2>/dev/null || echo "(clipboard not available)"
    print_status "Command copied to clipboard (if supported)"
fi
echo ""

# Step 7: Verification
echo -e "${BLUE}[7/7] Verification...${NC}"
print_info "Running verification checks..."

# Test MCP endpoint
if curl -f http://localhost:${ARCHON_MCP_PORT}/mcp >/dev/null 2>&1; then
    print_status "MCP endpoint accessible"
else
    print_warning "MCP endpoint not yet accessible"
fi

# List running containers
print_info "Running containers:"
docker ps --filter "name=archon-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}   Setup Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
print_info "Next steps:"
echo "  1. Open http://localhost:${ARCHON_UI_PORT} to access Archon dashboard"
echo "  2. Complete API key setup in Settings if not done during .env config"
echo "  3. Add Archon MCP to Claude Code (see command above)"
echo "  4. Test connection: Run test-connection.sh"
echo ""
print_info "Useful commands:"
echo "  • View logs: docker compose -f ${ARCHON_PATH}/docker-compose.yml logs -f"
echo "  • Stop services: docker compose -f ${ARCHON_PATH}/docker-compose.yml down"
echo "  • Restart: docker compose -f ${ARCHON_PATH}/docker-compose.yml restart"
echo ""
print_info "Documentation:"
echo "  • Setup guide: ${ARCHON_PATH}/README.md"
echo "  • Integration docs: developer-skills-plugin/integrations/archon/README.md"
echo "  • Workflow guide: developer-skills-plugin/integrations/archon/WORKFLOW.md"
echo ""
