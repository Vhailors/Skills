#!/bin/bash

# test-superflows.sh - Automated test suite for all 14 superflows
# Tests that each superflow triggers correctly with its designated keywords

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANALYZE_SCRIPT="$SCRIPT_DIR/scripts/analyze-prompt.sh"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counter
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Test function
test_superflow() {
    local test_name="$1"
    local test_prompt="$2"
    local expected_pattern="$3"
    local test_number="$4"

    TOTAL_TESTS=$((TOTAL_TESTS + 1))

    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}Test #$test_number: $test_name${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo "Input: $test_prompt"
    echo ""

    # Run the test
    output=$(echo "{\"prompt\":\"$test_prompt\"}" | bash "$ANALYZE_SCRIPT" 2>&1)

    # Check if expected pattern is in output
    if echo "$output" | grep -q "$expected_pattern"; then
        echo -e "${GREEN}✅ PASS${NC} - Correctly triggered: $expected_pattern"
        PASSED_TESTS=$((PASSED_TESTS + 1))

        # Show first few lines of output
        echo ""
        echo "Output preview:"
        echo "$output" | head -15
    else
        echo -e "${RED}❌ FAIL${NC} - Expected pattern not found: $expected_pattern"
        FAILED_TESTS=$((FAILED_TESTS + 1))

        # Show what we got instead
        echo ""
        echo "Actual output:"
        echo "$output" | head -20
    fi

    echo ""
    echo ""
}

# Start tests
echo -e "${YELLOW}╔════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║   SUPERFLOW TEST SUITE - All 14 Superflows    ║${NC}"
echo -e "${YELLOW}╚════════════════════════════════════════════════╝${NC}"
echo ""

# Test 1: Pixel-Perfect Site Copy
test_superflow \
    "🎨 Pixel-Perfect Site Copy" \
    "copy site https://example.com" \
    "PIXEL-PERFECT SITE COPY SUPERFLOW: ACTIVE" \
    "1"

# Test 2: Refactoring Safety Protocol
test_superflow \
    "🛡️ Refactoring Safety Protocol" \
    "refactor the authentication module" \
    "REFACTORING SAFETY PROTOCOL" \
    "2"

# Test 3: Debugging (Memory-Assisted)
test_superflow \
    "🐛 Debugging (Memory-Assisted)" \
    "there's a bug in the login function" \
    "DEBUGGING SUPERFLOW" \
    "3"

# Test 4: Feature Development (Spec-Kit)
test_superflow \
    "🏗️ Feature Development" \
    "implement user profile management feature" \
    "FEATURE DEVELOPMENT SUPERFLOW" \
    "4"

# Test 5: UI Development
test_superflow \
    "🎨 UI Development" \
    "create a pricing table component" \
    "UI DEVELOPMENT SUPERFLOW" \
    "5"

# Test 6: API Contract Design
test_superflow \
    "🔌 API Contract Design" \
    "design the user registration API endpoint" \
    "API.*SUPERFLOW" \
    "6"

# Test 7: Verification Before Completion
test_superflow \
    "✅ Verification Before Completion" \
    "I'm done with the feature, ready to ship" \
    "Verification.*SUPERFLOW" \
    "7"

# Test 8: Rapid Prototyping
test_superflow \
    "🚀 Rapid Prototyping" \
    "build a quick MVP for task tracking" \
    "RAPID.*SUPERFLOW" \
    "8"

# Test 9: Security Patterns
test_superflow \
    "🔐 Security Patterns" \
    "add authentication to the API" \
    "SECURITY.*SUPERFLOW" \
    "9"

# Test 10: Performance Optimization
test_superflow \
    "⚡ Performance Optimization" \
    "the dashboard is loading slowly" \
    "PERFORMANCE.*SUPERFLOW" \
    "10"

# Test 11: Dependency Management
test_superflow \
    "📦 Dependency Management" \
    "update all npm dependencies" \
    "DEPENDENCY.*SUPERFLOW" \
    "11"

# Test 12: Learning/Onboarding
test_superflow \
    "🎓 Learning/Onboarding" \
    "help me learn how this project works" \
    "LEARNING.*SUPERFLOW" \
    "12"

# Test 13: Code Explanation
test_superflow \
    "📖 Code Explanation" \
    "explain what the middleware function does" \
    "CODE EXPLANATION SUPERFLOW" \
    "13"

# Test 14: Pattern Recall
test_superflow \
    "🔍 Pattern Recall" \
    "how did we handle file uploads before?" \
    "PATTERN RECALL SUPERFLOW" \
    "14"

# Summary
echo -e "${YELLOW}╔════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║              TEST SUMMARY                      ║${NC}"
echo -e "${YELLOW}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo "Total Tests:  $TOTAL_TESTS"
echo -e "Passed:       ${GREEN}$PASSED_TESTS${NC}"
echo -e "Failed:       ${RED}$FAILED_TESTS${NC}"
echo ""

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}✅ ALL TESTS PASSED!${NC}"
    exit 0
else
    echo -e "${RED}❌ SOME TESTS FAILED${NC}"
    echo ""
    echo "Review failed tests above for details."
    exit 1
fi
