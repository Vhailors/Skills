#!/bin/bash
# Debug hook to log what we receive
INPUT=$(cat)
echo "=== DEBUG UserPromptSubmit ===" >> /tmp/hook-debug.log
echo "Input received:" >> /tmp/hook-debug.log
echo "$INPUT" >> /tmp/hook-debug.log
echo "===" >> /tmp/hook-debug.log
exit 0
