#!/bin/bash
# Superflow Summary Capture Hook
# Triggered when a superflow command completes (/developer-skills:*)
# Captures workflow output and appends to session summary

set -e

PROJECT_ROOT="${1:-.}"
SUPERFLOW_NAME="${2:-unknown-superflow}"
SUPERFLOW_OUTPUT="${3:-.}"
TIMESTAMP=$(date +"%Y-%m-%d-%H%M")

# Find or create current session summary
CURRENT_SUMMARY=$(ls -t "$PROJECT_ROOT"/SESSION-SUMMARY-*.md 2>/dev/null | head -1)

if [ -z "$CURRENT_SUMMARY" ]; then
    # No existing summary, create baseline
    CURRENT_SUMMARY="$PROJECT_ROOT/SESSION-SUMMARY-${TIMESTAMP}.md"
    cat > "$CURRENT_SUMMARY" << 'EOF'
# Session Summary: AUTO-GENERATED

## ✅ Completed

[Superflow results captured below]

## 📋 Pending

[Updated by superflow hooks]

## ⚠️ Known Issues

[Updated by superflow hooks]

## 🎯 Next Steps

[Updated by superflow hooks]

---
EOF
fi

# Extract key information from superflow output
COMPLETION_STATUS=$(echo "$SUPERFLOW_OUTPUT" | grep -i "completed\|success" | head -1 || echo "")
BLOCKERS=$(echo "$SUPERFLOW_OUTPUT" | grep -i "blocked\|error\|fail" | head -3 || echo "")

# Append superflow result to summary
cat >> "$CURRENT_SUMMARY" << EOF

## Superflow: $SUPERFLOW_NAME
**Completed**: $(date '+%Y-%m-%d %H:%M:%S')

### Results
$COMPLETION_STATUS

### Blockers/Issues
$(if [ -n "$BLOCKERS" ]; then echo "$BLOCKERS"; else echo "None identified"; fi)

---
EOF

echo "✅ Superflow summary captured: $CURRENT_SUMMARY"
exit 0
