#!/usr/bin/env python3
"""
PostToolUse:TodoWrite Observer Hook
Enforces workflow compliance and sequential execution

Features:
1. Detects active superflow from todo content
2. Updates .claude-session with state
3. Validates todos match workflow requirements
4. Auto-corrects missing mandatory steps
5. Enforces sequential execution (one in_progress at a time)
6. Prevents random stopping with pending todos
"""

import json
import sys
import os
import re
from datetime import datetime
from pathlib import Path

# === WORKFLOW DEFINITIONS ===

WORKFLOWS = {
    "🛡️ Refactoring": {
        "patterns": ["refactor", "rewrite", "restructure", "clean up"],
        "required_steps": [
            "check.*test",
            "create.*test",
            "verify.*test"
        ],
        "forbidden": ["skip.*test"],
    },
    "🐛 Debugging": {
        "patterns": ["bug", "error", "issue", "debug", "fix.*problem", "broken"],
        "required_steps": [
            "quick-fix|recall-bug|memory",
            "reproduce|verify.*bug"
        ],
        "suggested": ["/quick-fix", "/recall-bug"],
    },
    "🏗️ Feature Dev": {
        "patterns": ["implement", "build", "create.*feature", "add.*functionality"],
        "required_steps": [
            "recall-feature|memory.*search",
            "check-integration|verify.*integration"
        ],
        "suggested": ["/recall-feature", "/check-integration"],
    },
    "🎨 UI Dev": {
        "patterns": ["ui", "component", "interface", "design", "hero", "pricing", "navbar"],
        "required_steps": [
            "find-ui|search.*ui|premium.*library"
        ],
        "suggested": ["/find-ui", "shadcn"],
    },
    "✅ Verifying": {
        "patterns": ["done", "complete", "finished", "verify", "ship"],
        "required_steps": [
            "check-integration",
            "ship-check|verification"
        ],
        "forbidden": ["skip.*verify", "assume.*works"],
    },
    "🚀 Rapid Proto": {
        "patterns": ["mvp", "prototype", "poc", "quick", "rapid"],
        "suggested": ["/find-ui", "verification-before-completion"],
    },
    "🔐 Security": {
        "patterns": ["security", "vulnerability", "auth.*issue", "exploit"],
        "required_steps": [
            "security-scan|security.*check"
        ],
        "suggested": ["/security-scan"],
    },
    "⚡ Performance": {
        "patterns": ["slow", "performance", "optimize.*speed", "bottleneck"],
        "required_steps": [
            "perf-check|profile|measure"
        ],
        "suggested": ["/perf-check"],
    },
}

# === HELPER FUNCTIONS ===

def detect_superflow(todos):
    """Detect active superflow from todo content"""
    all_content = " ".join(t.get("content", "").lower() for t in todos)

    for flow_name, flow_def in WORKFLOWS.items():
        for pattern in flow_def["patterns"]:
            if re.search(pattern, all_content, re.IGNORECASE):
                return flow_name

    return None

def validate_workflow_compliance(todos, workflow):
    """Check if todos contain required steps for the workflow"""
    if workflow not in WORKFLOWS:
        return {"valid": True, "missing": []}

    flow_def = WORKFLOWS[workflow]
    all_content = " ".join(t.get("content", "").lower() for t in todos)

    missing = []

    # Check required steps
    for required_pattern in flow_def.get("required_steps", []):
        if not re.search(required_pattern, all_content, re.IGNORECASE):
            missing.append(required_pattern)

    # Check forbidden patterns
    for forbidden in flow_def.get("forbidden", []):
        if re.search(forbidden, all_content, re.IGNORECASE):
            return {
                "valid": False,
                "missing": [],
                "error": f"❌ Forbidden pattern detected: {forbidden}"
            }

    return {
        "valid": len(missing) == 0,
        "missing": missing,
        "suggested": flow_def.get("suggested", [])
    }

def check_sequential_execution(todos):
    """Validate one in_progress at a time"""
    in_progress = [t for t in todos if t.get("status") == "in_progress"]

    if len(in_progress) == 0:
        return {"valid": False, "message": "⚠️ No todo marked as in_progress. Mark current task."}
    elif len(in_progress) > 1:
        return {"valid": False, "message": f"❌ Multiple todos in_progress ({len(in_progress)}). Only one at a time."}

    return {"valid": True}

def check_completion_blocker(todos):
    """Check if all todos are completed or if work should continue"""
    statuses = [t.get("status") for t in todos]

    completed = sum(1 for s in statuses if s == "completed")
    pending = sum(1 for s in statuses if s == "pending")
    in_progress = sum(1 for s in statuses if s == "in_progress")

    total = len(todos)

    # If all completed, we're done
    if completed == total:
        return {"continue": False, "message": "✅ All todos completed"}

    # If there are pending todos, work should continue
    if pending > 0:
        return {
            "continue": True,
            "message": f"📋 {pending} todo(s) pending. Continue with next task.",
            "stats": {"completed": completed, "pending": pending, "in_progress": in_progress, "total": total}
        }

    return {"continue": False}

def update_session_state(todos, workflow):
    """Write state to .claude-session for statusline"""
    session_file = Path(".claude-session")

    statuses = [t.get("status") for t in todos]
    completed = sum(1 for s in statuses if s == "completed")
    pending = sum(1 for s in statuses if s == "pending")
    in_progress = sum(1 for s in statuses if s == "in_progress")
    total = len(todos)

    # Get current in_progress todo
    current_todo = next((t for t in todos if t.get("status") == "in_progress"), None)
    current_step = current_todo.get("activeForm", "Planning") if current_todo else "Planning"

    # Read existing session data
    session_data = {}
    if session_file.exists():
        for line in session_file.read_text().strip().split("\n"):
            if "=" in line:
                key, value = line.split("=", 1)
                session_data[key] = value

    # Update with new data
    if workflow:
        session_data["ACTIVE_SUPERFLOW"] = workflow

    session_data.update({
        "TODO_TOTAL": str(total),
        "TODO_COMPLETED": str(completed),
        "TODO_PENDING": str(pending),
        "TODO_IN_PROGRESS": str(in_progress),
        "TODO_PROGRESS": f"{completed}/{total}",
        "TODO_CURRENT_STEP": current_step,
    })

    # Create session start time if not exists
    if "SESSION_START" not in session_data:
        session_data["SESSION_START"] = datetime.now().isoformat()

    # Write back
    session_file.write_text("\n".join(f"{k}={v}" for k, v in session_data.items()) + "\n")

def generate_missing_todos(missing_patterns, workflow):
    """Generate suggested todos for missing workflow steps"""
    suggestions = []

    for pattern in missing_patterns:
        if "test" in pattern:
            suggestions.append({
                "content": "Check existing tests and create missing ones",
                "activeForm": "Checking and creating tests",
                "status": "pending"
            })
        elif "memory|recall" in pattern:
            suggestions.append({
                "content": f"Search memory with /recall-feature or /recall-bug",
                "activeForm": "Searching memory for similar work",
                "status": "pending"
            })
        elif "integration" in pattern:
            suggestions.append({
                "content": "Run /check-integration for full-stack verification",
                "activeForm": "Running integration checks",
                "status": "pending"
            })
        elif "verify|ship" in pattern:
            suggestions.append({
                "content": "Run /ship-check for comprehensive validation",
                "activeForm": "Running ship checks",
                "status": "pending"
            })

    return suggestions

# === MAIN HOOK LOGIC ===

def main():
    # Read TodoWrite tool output from stdin
    try:
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError:
        sys.exit(0)  # Silently pass if not valid JSON

    # Extract todos from the tool result
    # PostToolUse hook receives the tool parameters, not the result
    todos = input_data.get("todos", [])

    if not todos:
        sys.exit(0)  # Nothing to observe

    # Detect active workflow
    workflow = detect_superflow(todos)

    # Update session state (always do this)
    update_session_state(todos, workflow)

    # Validate workflow compliance
    if workflow:
        compliance = validate_workflow_compliance(todos, workflow)

        if not compliance["valid"]:
            if "error" in compliance:
                # Hard block - forbidden pattern detected
                output = {
                    "hookSpecificOutput": {
                        "hookEventName": "PostToolUse",
                        "additionalContext": f"\n\n{compliance['error']}\n\nWorkflow: {workflow}\n"
                    }
                }
                print(json.dumps(output))
                sys.exit(0)  # Don't block, just warn

            # Soft warning - missing required steps
            if compliance["missing"]:
                missing_desc = ", ".join(compliance["missing"])
                suggested_cmds = ", ".join(compliance.get("suggested", []))

                warning = f"""
⚠️ **Workflow Compliance Warning**

**Active Workflow**: {workflow}
**Missing Required Steps**: {missing_desc}

**Suggested Actions**:
{chr(10).join(f"- Add todo: {s}" for s in compliance.get("suggested", []))}

**You should update your todo list to include these mandatory steps.**
"""

                output = {
                    "hookSpecificOutput": {
                        "hookEventName": "PostToolUse",
                        "additionalContext": warning
                    }
                }
                print(json.dumps(output))
                sys.exit(0)

    # Check sequential execution
    seq_check = check_sequential_execution(todos)
    if not seq_check["valid"]:
        output = {
            "hookSpecificOutput": {
                "hookEventName": "PostToolUse",
                "additionalContext": f"\n\n{seq_check['message']}\n"
            }
        }
        print(json.dumps(output))
        sys.exit(0)

    # Check if work should continue
    blocker = check_completion_blocker(todos)
    if blocker["continue"]:
        stats = blocker.get("stats", {})
        reminder = f"""

📋 **Work Status**: {stats['completed']}/{stats['total']} completed, {stats['pending']} pending

**Continue with the next pending todo from your list.** You created this list for a reason - follow it through to completion.
"""

        output = {
            "hookSpecificOutput": {
                "hookEventName": "PostToolUse",
                "additionalContext": reminder
            }
        }
        print(json.dumps(output))
        sys.exit(0)

    # All checks passed
    sys.exit(0)

if __name__ == "__main__":
    main()
