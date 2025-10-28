# recall-feature

Search project memory for similar features implemented in the past.

## Usage

```bash
/recall-feature [feature-name-or-concept]
```

## Description

Queries claude-mem to find past feature development sessions. Shows:
- Similar features built before
- Specifications and clarifications
- Implementation approaches used
- Patterns that worked vs. failed
- Lessons learned from past work

**Use this command when:**
- Starting spec-kit workflow for new feature
- Need reference implementation for similar feature
- Want to reuse successful patterns
- Looking to avoid past mistakes

## Examples

```bash
/recall-feature "comments system"
/recall-feature "authentication"
/recall-feature "user profiles"
/recall-feature "real-time notifications"
/recall-feature "CRUD operations"
```

## How It Works

This command queries claude-mem's MCP tools:
1. Searches by concept (feature category)
2. Finds user prompts for similar features
3. Extracts specifications and requirements
4. Identifies implementation patterns
5. Notes what worked well vs. what had issues

## Output Format

Returns structured results:
- **Similar Features:** List of past related features
- **Specifications:** Requirements and clarifications from past
- **Implementation Patterns:** Technical approaches used
- **Success Patterns:** What worked well
- **Anti-Patterns:** What to avoid (caused issues)
- **Key Learnings:** Insights to apply to new feature

## Integration

Works with:
- **memory-assisted-spec-kit skill** - Automates this during spec creation
- **spec-kit-orchestrator** - Enhances specification quality
- **full-stack-integration-checker** - References past integration approaches

## Notes

- Requires claude-mem plugin installed and running
- Most useful after several features implemented
- Returns empty for truly novel features
- Helps maintain consistency across features
- Prevents reinventing solutions

## Example Output

```
## Memory Results for "comments system"

### Similar Features Found
1. Session #42: Product reviews feature (like comments)
2. Session #67: Forum posts system

### Key Learnings
✅ Soft delete (status field) worked better than hard delete
✅ Include isEdited flag for transparency
❌ Forgot rate limiting → spam issue
❌ No pagination → slow page load

### Implementation Patterns
- Database: User relation + createdAt index
- API: POST /comments, GET /comments?postId=X, DELETE /comments/:id
- Frontend: CommentList + CommentForm components
- Security: Auth middleware + ownership checks

### Recommended Approach
Based on product reviews feature (session #42):
1. Add rate limiting from start
2. Implement pagination (20 per page)
3. Use soft delete pattern
4. Include edit tracking
```
