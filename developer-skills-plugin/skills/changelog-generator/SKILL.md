---
name: Technical Changelog Generator
description: Automatically creates technical changelogs from git commits by analyzing commit history, schema changes, logic differences, and data structure modifications. Generates developer-focused documentation with commit hashes, file references, and implementation details.
---

# Technical Changelog Generator

This skill transforms git commits into detailed, developer-focused changelogs that document what actually changed in the codebase - including schema modifications, logic differences, API changes, and data structure updates with full commit traceability.

## When to Use This Skill

- Preparing technical release notes for developers
- Documenting schema and database migrations
- Creating detailed changelogs with commit references
- Analyzing logic changes between versions
- Documenting API breaking changes
- Generating internal technical documentation
- Creating migration guides for version upgrades
- Reviewing what changed in pull requests or releases

## What This Skill Does

1. **Scans Git History**: Analyzes commits from a specific time period or between versions with full commit hashes
2. **Categorizes Technical Changes**: Groups into schema, API, logic, data structures, breaking changes, dependencies, performance, and bug fixes
3. **Analyzes Implementation Details**: Examines actual code differences, schema changes, and logic modifications
4. **Documents Before/After States**: Shows what changed from old behavior to new behavior
5. **Includes Commit Traceability**: Every change includes the commit hash and file references
6. **Highlights Breaking Changes**: Clearly marks breaking changes with migration instructions
7. **Tracks Schema Evolution**: Documents database migrations and schema modifications

## How to Use

### Basic Usage

From your project repository:

```
Create a technical changelog from commits since last release
```

```
Generate technical changelog for all commits from the past week
```

```
Create detailed release notes for version 2.5.0 with schema changes
```

### With Specific Date Range

```
Create a technical changelog for all commits between March 1 and March 15
```

### Focusing on Specific Areas

```
Generate changelog focusing on schema changes and API modifications from the last 30 days
```

```
Create changelog with logic differences and breaking changes since v2.4.0
```

## Example

**User**: "Create a technical changelog for commits from the past 7 days"

**Output**:
```markdown
# Technical Changelog - Week of 2025-03-10

## Schema/Database Changes

- `a7f3d2c` Add user_role column to users table (files: migrations/20250310_add_roles.sql)
  - Table: `users`
  - Added: `role VARCHAR(50) NOT NULL DEFAULT 'user'`
  - Index: Added index on `role` column
  - Migration: `npm run migrate:up 20250310`

- `b8e4c1a` Modify orders table for soft deletes (files: migrations/20250312_soft_delete.sql)
  - Added: `deleted_at TIMESTAMP NULL`
  - Modified: Updated queries to filter deleted records

## API Changes

- `c9d5f2b` Add role-based authorization endpoint (files: src/api/auth.controller.ts:156)
  - New endpoint: `GET /api/v1/users/:id/permissions`
  - Response format: `{ permissions: string[], role: string }`
  - Requires: Authentication token

- `d1a6e3c` Breaking: Change user creation response format (files: src/api/users.controller.ts:45)
  - Old response: `{ id, name, email }`
  - New response: `{ user: { id, name, email, role }, token }`
  - Migration: Update client code to access nested `user` object

## Logic Changes

- `e2b7f4d` Optimize order processing algorithm (files: src/services/order.service.ts:89-145)
  - Old behavior: Sequential processing with N+1 queries
  - New behavior: Batch processing with single query + in-memory sorting
  - Performance impact: ~70% faster for orders >100 items
  - Reason: Reduce database load during peak hours

- `f3c8g5e` Change password validation rules (files: src/utils/validation.ts:23)
  - Old logic: Min 8 chars, one number
  - New logic: Min 12 chars, one number, one special char, one uppercase
  - Reason: Enhanced security requirements

## Data Structure Changes

- `g4d9h6f` Add TypeScript interfaces for user roles (files: src/types/user.types.ts)
  ```typescript
  // New interfaces:
  interface UserRole {
    id: string;
    name: RoleName;
    permissions: Permission[];
  }

  type RoleName = 'admin' | 'user' | 'moderator';
  ```

## Breaking Changes ⚠️

- `d1a6e3c` User creation API response format changed
  - Impact: All clients using POST /api/v1/users
  - Migration: Update response parsing to access nested `user` object
  - Timeline: Old format deprecated, will be removed in v3.0

## Dependencies

- `h5e1i7g` Updated express 4.18.0 -> 4.19.2 (security patch)
- `i6f2j8h` Added @types/jsonwebtoken@9.0.6
- `j7g3k9i` Removed deprecated library moment -> date-fns

## Commit History

- a7f3d2c - 2025-03-10 14:32 - Add user_role column to users table (@dominik)
- b8e4c1a - 2025-03-12 09:15 - Modify orders table for soft deletes (@dominik)
- c9d5f2b - 2025-03-12 16:44 - Add role-based authorization endpoint (@dominik)
- d1a6e3c - 2025-03-13 11:22 - Breaking: Change user creation response format (@dominik)
- e2b7f4d - 2025-03-14 13:50 - Optimize order processing algorithm (@dominik)
- f3c8g5e - 2025-03-14 15:30 - Change password validation rules (@dominik)
- g4d9h6f - 2025-03-15 10:18 - Add TypeScript interfaces for user roles (@dominik)
- h5e1i7g - 2025-03-15 14:05 - Updated express security patch (@dominik)
- i6f2j8h - 2025-03-16 09:33 - Add jsonwebtoken types (@dominik)
- j7g3k9i - 2025-03-16 11:47 - Replace moment with date-fns (@dominik)
```

## Instructions for Claude

When generating technical changelogs:

1. **Analyze Git History**
   - Use `git log` with appropriate flags to get commits in the specified range
   - Include commit hashes (7-character short form)
   - Note authors, timestamps, and commit messages

2. **Categorize Changes**
   - **Schema/Database**: Migrations, ALTER TABLE, model changes
   - **API Changes**: New/modified endpoints, request/response changes
   - **Logic Changes**: Algorithm modifications, business logic updates, before/after behavior
   - **Data Structures**: New classes, interfaces, types, schema definitions
   - **Breaking Changes**: API breaks, removed functionality (mark with ⚠️)
   - **Dependencies**: Package additions/updates/removals
   - **Performance**: Optimizations with measurable impact
   - **Bug Fixes**: Issue resolutions with technical details

3. **Document Implementation Details**
   - For schema changes: Show table/column modifications, migration commands
   - For API changes: Document endpoints, parameters, response formats
   - For logic changes: Describe old behavior vs new behavior with reasoning
   - For data structures: Show type/interface definitions
   - Include file paths and line numbers: `path/to/file.ts:123`

4. **Highlight Breaking Changes**
   - Mark clearly with ⚠️
   - Provide migration instructions
   - Note impact and affected components

5. **Generate Commit History Section**
   - List all commits with: hash - date time - message (@author)
   - Keep chronological order

6. **Output Format**
   - Use markdown
   - Group by technical category
   - Include commit hash at start of each entry
   - Reference files as: `(files: path/to/file:line)`
   - Use code blocks for schema/type definitions

## Tips

- Run from your git repository root
- Use `git log --since="2025-03-01" --until="2025-03-15"` for date ranges
- Use `git log v2.4.0..v2.5.0` for version-to-version changes
- Include `--stat` or `--name-only` to see affected files
- Review generated changelog before sharing with team
- Save output directly to CHANGELOG.md or RELEASE_NOTES.md

## Related Use Cases

- Creating GitHub release notes
- Documenting breaking changes for major versions
- Generating migration guides
- Code review documentation
- Internal developer updates
- Technical blog posts
- API versioning documentation
