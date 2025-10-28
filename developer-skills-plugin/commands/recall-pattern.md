# recall-pattern

Search project memory for implementation patterns and technical approaches.

## Usage

```bash
/recall-pattern [pattern-name-or-technical-area]
```

## Description

Queries claude-mem to find how specific technical challenges were solved in the past. Shows:
- Implementation patterns used in project
- Technical decisions and trade-offs
- Code structures and architectures
- Libraries and tools chosen
- What scaled well vs. what caused issues

**Use this command when:**
- Implementing technical solution (auth, validation, caching, etc.)
- Need to match existing project patterns
- Want to reuse proven approaches
- Looking for project-specific conventions

## Examples

```bash
/recall-pattern "authentication"
/recall-pattern "database migrations"
/recall-pattern "API error handling"
/recall-pattern "form validation"
/recall-pattern "WebSocket connections"
/recall-pattern "state management"
/recall-pattern "testing strategy"
```

## How It Works

This command queries claude-mem's MCP tools:
1. Searches observations for technical implementations
2. Finds files related to the pattern (by path)
3. Extracts approaches and decisions
4. Identifies what worked vs. caused problems
5. Shows project-specific conventions

## Output Format

Returns structured results:
- **Pattern Usage:** Where/how pattern is used in project
- **Files Involved:** Key files implementing this pattern
- **Technical Decisions:** Choices made and why
- **Success Stories:** Implementations that work well
- **Problem Cases:** Implementations that had issues
- **Project Conventions:** Specific patterns to follow
- **Recommended Approach:** Best practice for this project

## Integration

Works with:
- **memory-assisted-spec-kit** - Informs technical constraints
- **memory-assisted-debugging** - References successful methodologies
- **spec-kit-orchestrator** - Ensures pattern consistency

## Notes

- Requires claude-mem plugin installed and running
- Most useful for recurring technical patterns
- Helps maintain consistency across codebase
- Prevents introducing competing patterns
- Shows project-specific conventions (not generic best practices)

## Example Output

```
## Memory Results for "authentication"

### Pattern Usage in Project
Found in 15 files across 8 sessions

### Technical Approach
**Library:** JWT (jsonwebtoken)
**Strategy:** Middleware-based (auth.requireUser)
**Session storage:** HTTP-only cookies (not localStorage)

### Project Conventions
1. Auth middleware: Always named `auth.requireUser` or `auth.optional`
2. Token expiry: 7 days for web, 30 days for mobile
3. Refresh tokens: Separate `/auth/refresh` endpoint
4. Error handling: 401 for missing auth, 403 for insufficient permissions

### Success Patterns
✅ Middleware composition works well
✅ Separate auth concerns from business logic
✅ HTTP-only cookies prevent XSS

### Problem Patterns Found
❌ Session #23: Used req.body.userId → Security hole
❌ Session #31: Forgot middleware on route → "userId undefined" error
❌ Session #45: Client-side token storage → XSS vulnerability

### Recommended Implementation
```typescript
// Middleware composition (session #23 pattern)
router.post('/api/comments',
  auth.requireUser,  // Always authenticate first
  validate.comment,  // Then validate
  commentsController.create
);

// Never trust client
function createComment(req, res) {
  const userId = req.user.id;  // From auth middleware
  // NOT: const userId = req.body.userId;  ← Security hole
}
```

### Key Files
- middleware/auth.js - Auth middleware implementation
- routes/api/*.js - All use same auth pattern
- controllers/*.js - All use req.user from middleware
```
