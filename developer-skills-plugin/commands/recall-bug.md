# recall-bug

Search project memory for similar bugs, errors, or debugging sessions.

## Usage

```bash
/recall-bug [error-message-or-symptom]
```

## Description

Queries claude-mem to find past debugging sessions for similar errors. Shows:
- When similar errors occurred (session numbers, dates)
- Root causes identified
- Solutions that worked vs. failed
- Debugging approaches used

**Use this command when:**
- Encountering an error or bug
- Need to check if this was solved before
- Want to avoid repeating failed solutions
- Looking for debugging patterns in the project

## Examples

```bash
/recall-bug "Cannot read property"
/recall-bug "500 error"
/recall-bug "test failing randomly"
/recall-bug "slow query"
/recall-bug "ENOENT"
```

## How It Works

This command queries claude-mem's MCP tools:
1. Searches observations for error messages
2. Finds similar debugging sessions
3. Extracts root causes and solutions
4. Shows pattern frequency if recurring

## Output Format

Returns structured results:
- **Past Occurrences:** List of sessions with dates
- **Root Causes:** What actually caused each error
- **Solutions Tried:** What worked vs. failed
- **Pattern Recognition:** If this is a recurring issue
- **Recommended Approach:** Next debugging steps based on history

## Integration

Works with:
- **memory-assisted-debugging skill** - Automates this search process
- **systematic-debugging skill** - Informs where to start investigation
- **full-stack-integration-checker** - References past integration issues

## Notes

- Requires claude-mem plugin installed and running
- Returns empty if no similar errors in project history
- Search is fuzzy - partial matches will be found
- More memory = better results (learns over time)
