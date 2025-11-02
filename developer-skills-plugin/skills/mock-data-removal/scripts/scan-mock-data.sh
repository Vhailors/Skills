#!/usr/bin/env bash

# Mock Data Scanner - Systematic detection of test artifacts before shipping
# Exit codes: 0 = found issues (BLOCK), 1 = clean (PASS), 2 = error

set -euo pipefail

PROJECT_ROOT="${1:-.}"
ISSUES_FOUND=0

echo "🔍 Scanning for mock data and test artifacts..."
echo "Project: $PROJECT_ROOT"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track findings
declare -a FINDINGS=()

#############################################
# 1. Keyword Scan
#############################################
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1️⃣  Scanning for mock/test keywords..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

KEYWORD_RESULTS=$(rg -i "\b(mock|fake|sample|dummy|temp(?!late)|placeholder|fixme|hack)\b" \
  --type-not markdown \
  --glob '!test/**' \
  --glob '!tests/**' \
  --glob '!*.test.*' \
  --glob '!*.spec.*' \
  --glob '!__tests__/**' \
  --glob '!__mocks__/**' \
  --glob '!*.md' \
  --glob '!package-lock.json' \
  --glob '!yarn.lock' \
  --glob '!pnpm-lock.yaml' \
  --color always \
  --heading \
  --line-number \
  "$PROJECT_ROOT" 2>/dev/null || true)

if [ -n "$KEYWORD_RESULTS" ]; then
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
  echo -e "${RED}❌ Found mock/test keywords in production code:${NC}"
  echo "$KEYWORD_RESULTS"
  echo ""
else
  echo -e "${GREEN}✅ No mock/test keywords found${NC}"
  echo ""
fi

#############################################
# 2. TODO/FIXME Comments Scan
#############################################
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2️⃣  Scanning for TODO/FIXME removal comments..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

TODO_RESULTS=$(rg -i "TODO.*\b(remove|delete|fix|before prod|production)\b" \
  --type-not markdown \
  --glob '!test/**' \
  --glob '!*.test.*' \
  --glob '!*.md' \
  --color always \
  --heading \
  --line-number \
  "$PROJECT_ROOT" 2>/dev/null || true)

if [ -n "$TODO_RESULTS" ]; then
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
  echo -e "${RED}❌ Found TODO comments about removal:${NC}"
  echo "$TODO_RESULTS"
  echo ""
else
  echo -e "${GREEN}✅ No TODO removal comments found${NC}"
  echo ""
fi

#############################################
# 3. Test Patterns Scan
#############################################
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3️⃣  Scanning for test data patterns..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

PATTERN_RESULTS=$(rg -i "(test@|example\.com|12345|xxxxx|test-user|user-test|admin@test)" \
  --type-not markdown \
  --glob '!test/**' \
  --glob '!tests/**' \
  --glob '!*.test.*' \
  --glob '!*.spec.*' \
  --glob '!*.md' \
  --glob '!README*' \
  --color always \
  --heading \
  --line-number \
  "$PROJECT_ROOT" 2>/dev/null || true)

if [ -n "$PATTERN_RESULTS" ]; then
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
  echo -e "${RED}❌ Found test data patterns:${NC}"
  echo "$PATTERN_RESULTS"
  echo ""
else
  echo -e "${GREEN}✅ No test data patterns found${NC}"
  echo ""
fi

#############################################
# 4. Test API Keys/Credentials Scan
#############################################
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "4️⃣  Scanning for test API keys and credentials..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

CRED_RESULTS=$(rg -i "(sk-test-|pk-test-|dev-secret|test-?key|api-?key.*test|secret.*test)" \
  --type-not markdown \
  --glob '!test/**' \
  --glob '!*.test.*' \
  --glob '!*.md' \
  --glob '!.env.example' \
  --glob '!.env.template' \
  --color always \
  --heading \
  --line-number \
  "$PROJECT_ROOT" 2>/dev/null || true)

if [ -n "$CRED_RESULTS" ]; then
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
  echo -e "${RED}❌ Found test API keys or credentials:${NC}"
  echo "$CRED_RESULTS"
  echo ""
else
  echo -e "${GREEN}✅ No test API keys found${NC}"
  echo ""
fi

#############################################
# 5. Development URLs Scan
#############################################
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "5️⃣  Scanning for localhost/development URLs..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

URL_RESULTS=$(rg "(localhost|127\.0\.0\.1)(:[\d]+)?" \
  --type-not markdown \
  --glob '!test/**' \
  --glob '!*.test.*' \
  --glob '!*.md' \
  --glob '!README*' \
  --glob '!package.json' \
  --color always \
  --heading \
  --line-number \
  "$PROJECT_ROOT" 2>/dev/null || true)

if [ -n "$URL_RESULTS" ]; then
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
  echo -e "${YELLOW}⚠️  Found localhost URLs (verify if intentional):${NC}"
  echo "$URL_RESULTS"
  echo ""
else
  echo -e "${GREEN}✅ No localhost URLs found${NC}"
  echo ""
fi

#############################################
# 6. Debug Flags Scan
#############################################
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "6️⃣  Scanning for debug flags..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

DEBUG_RESULTS=$(rg -i "(DEBUG\s*=\s*[Tt]rue|VERBOSE\s*=\s*[Tt]rue|ALLOWED_HOSTS\s*=\s*\[.*\*.*\])" \
  --glob '*config*' \
  --glob '*settings*' \
  --glob '*.env' \
  --color always \
  --heading \
  --line-number \
  "$PROJECT_ROOT" 2>/dev/null || true)

if [ -n "$DEBUG_RESULTS" ]; then
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
  echo -e "${YELLOW}⚠️  Found debug flags (verify if production-safe):${NC}"
  echo "$DEBUG_RESULTS"
  echo ""
else
  echo -e "${GREEN}✅ No debug flags found${NC}"
  echo ""
fi

#############################################
# 7. Commented Production Code Scan
#############################################
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "7️⃣  Scanning for commented production code..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

COMMENT_RESULTS=$(rg "^[\s]*(//|#).*\b(fetch|api|prod|real|actual)\b" \
  --type-not markdown \
  --glob '!test/**' \
  --glob '!*.test.*' \
  --glob '!*.md' \
  --color always \
  --heading \
  --line-number \
  "$PROJECT_ROOT" 2>/dev/null || true)

if [ -n "$COMMENT_RESULTS" ]; then
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
  echo -e "${YELLOW}⚠️  Found commented code mentioning production:${NC}"
  echo "$COMMENT_RESULTS"
  echo ""
else
  echo -e "${GREEN}✅ No suspicious commented code found${NC}"
  echo ""
fi

#############################################
# Summary
#############################################
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 SCAN SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $ISSUES_FOUND -eq 0 ]; then
  echo -e "${GREEN}✅ PASS - No mock data or test artifacts detected${NC}"
  echo ""
  echo "Code is clean and ready for production."
  exit 1  # ripgrep exit code 1 = no matches = success
else
  echo -e "${RED}❌ BLOCK - Found $ISSUES_FOUND categories of issues${NC}"
  echo ""
  echo "CANNOT SHIP until all mock data and test artifacts are removed."
  echo ""
  echo "Review each finding above and either:"
  echo "  1. Remove the test artifact"
  echo "  2. Move to test files (if test-only code)"
  echo "  3. Verify false positive (document reason)"
  exit 0  # ripgrep exit code 0 = found matches = block
fi
