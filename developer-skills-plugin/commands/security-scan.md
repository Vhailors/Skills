# security-scan

Comprehensive security review - identifies vulnerabilities and security risks before they reach production.

## Usage

```bash
/security-scan [scope]
```

If no scope provided, scans entire codebase with focus on high-risk areas.

## Description

Multi-layered security validation:
1. **Dependency vulnerabilities** - Known CVEs in packages
2. **Code pattern analysis** - SQL injection, XSS, CSRF risks
3. **Authentication/Authorization** - Access control review
4. **Secrets exposure** - API keys, passwords in code
5. **Input validation** - Injection attack vectors
6. **Security headers** - CORS, CSP, security configs

Returns clear verdict: ✅ **Secure** or ❌ **Vulnerabilities found with report**

## What It Checks

### Layer 1: Dependency Security
- [ ] No known CVEs in dependencies (npm audit, pip-audit, etc.)
- [ ] All packages up-to-date with security patches
- [ ] No deprecated packages with security issues
- [ ] License compliance (no incompatible licenses)

### Layer 2: Code Pattern Analysis
- [ ] No SQL string concatenation (use parameterized queries)
- [ ] No eval() or exec() with user input
- [ ] No innerHTML/dangerouslySetInnerHTML without sanitization
- [ ] No direct file path access with user input
- [ ] No command injection vectors (shell execution with user input)
- [ ] Proper error handling (no sensitive data in error messages)

### Layer 3: Authentication & Authorization
- [ ] All protected endpoints require authentication
- [ ] Authorization checks on data access (ownership verification)
- [ ] Password hashing (bcrypt, argon2, not plain or MD5)
- [ ] Session management secure (httpOnly, secure, sameSite cookies)
- [ ] JWT properly signed and verified (no "none" algorithm)
- [ ] No trust of client-provided data for auth decisions

### Layer 4: Input Validation
- [ ] All user input validated (type, length, format)
- [ ] File upload restrictions (type, size, scanning)
- [ ] URL validation (no SSRF vulnerabilities)
- [ ] JSON/XML parsing safe (no XXE attacks)
- [ ] Rate limiting on sensitive endpoints (login, API)

### Layer 5: Secrets Management
- [ ] No hardcoded API keys, passwords, tokens
- [ ] Environment variables used for secrets
- [ ] No secrets in git history
- [ ] No secrets in logs or error messages
- [ ] .env files in .gitignore

### Layer 6: Security Headers & Config
- [ ] HTTPS enforced (no HTTP in production)
- [ ] CORS properly configured (not wildcard *)
- [ ] Content-Security-Policy header set
- [ ] X-Frame-Options header (clickjacking protection)
- [ ] X-Content-Type-Options: nosniff
- [ ] Secure session configuration

## Execution Flow

```mermaid
graph TD
    A[/security-scan] --> B[Identify Project Type]
    B --> C[Run Dependency Scan]
    C --> D[Analyze Code Patterns]
    D --> E[Check Authentication]
    E --> F[Validate Input Handling]
    F --> G[Scan for Secrets]
    G --> H[Review Security Config]
    H --> I[Generate Security Report]
    I --> J{Vulnerabilities found?}
    J -->|No| K[✅ SECURE]
    J -->|Yes| L[❌ VULNERABILITIES - Show Report]
```

## Skills Used

This command orchestrates:
1. **security-patterns** - Main security analysis engine
2. **error-handling-patterns** - Validate error handling doesn't leak info
3. **api-contract-design** - Check API security (auth, validation)
4. **memory-assisted-debugging** (optional) - Check for known security issues

## Step-by-Step Execution

### Step 1: Identify Project Type

**Detect technology stack:**
- Node.js (package.json, npm/yarn)
- Python (requirements.txt, Pipfile, pyproject.toml)
- Frontend framework (React, Vue, etc.)
- Backend framework (Express, FastAPI, Django, etc.)
- Database type (SQL, NoSQL)

### Step 2: Run Dependency Scan

**Check for known vulnerabilities:**

```bash
# Node.js
npm audit --json
# or
yarn audit --json

# Python
pip-audit --format json
# or
safety check --json

# Ruby
bundle audit check

# Report format:
## Dependency Vulnerabilities

✅ No critical vulnerabilities found
⚠️ 2 moderate vulnerabilities:
  - lodash@4.17.15 (Prototype Pollution) → Upgrade to 4.17.21
  - axios@0.21.0 (SSRF) → Upgrade to 0.21.4
```

### Step 3: Analyze Code Patterns

**Search for dangerous patterns:**

```bash
# SQL injection risks
rg "SELECT.*\+.*req\.|query\(.*\$\{|execute\(.*\+.*\)" --type js --type py

# XSS risks
rg "innerHTML|dangerouslySetInnerHTML|v-html" --type js --type vue

# Command injection risks
rg "exec\(.*req\.|system\(|spawn\(.*user" --type js --type py

# Report:
## Code Pattern Analysis

❌ SQL Injection Risk Found:
   Location: src/api/users.js:45
   Pattern: db.query("SELECT * FROM users WHERE id = " + req.params.id)
   Fix: Use parameterized query: db.query("SELECT * FROM users WHERE id = ?", [req.params.id])

⚠️ XSS Risk Found:
   Location: src/components/Comment.jsx:23
   Pattern: <div dangerouslySetInnerHTML={{__html: comment.text}} />
   Fix: Use sanitization: <div>{DOMPurify.sanitize(comment.text)}</div>
```

### Step 4: Check Authentication & Authorization

**Verify access controls:**

```typescript
// Check for:
// 1. Endpoints without authentication
// 2. Missing ownership checks
// 3. Weak password hashing
// 4. Insecure session management

## Authentication & Authorization

✅ All protected endpoints use auth middleware
❌ Missing ownership check:
   Location: src/api/posts.js:78
   Issue: DELETE /api/posts/:id doesn't verify user owns post
   Fix: Add ownership check: if (post.userId !== req.user.id) throw 403

⚠️ Weak password hashing:
   Location: src/auth/users.js:34
   Issue: Using bcrypt with only 8 rounds
   Fix: Increase to 12 rounds: bcrypt.hash(password, 12)
```

### Step 5: Validate Input Handling

**Check input validation:**

```typescript
## Input Validation

❌ No input validation:
   Location: src/api/comments.js:56
   Issue: POST /api/comments accepts unlimited length
   Fix: Add validation: body('text').isLength({max: 5000})

❌ File upload without restrictions:
   Location: src/api/upload.js:23
   Issue: No file type or size validation
   Fix: Add multer file filter for allowed types, max size 10MB
```

### Step 6: Scan for Secrets

**Search for exposed secrets:**

```bash
# Common secret patterns
rg "API_KEY|api_key|apikey|password|secret|token" \
   --type js --type env --type json \
   -g '!node_modules' -g '!.env.example'

# Check git history
git log -p | rg "API_KEY|password" --context 2

## Secrets Exposure

❌ Hardcoded API key found:
   Location: src/config/stripe.js:3
   Pattern: const STRIPE_KEY = "sk_live_abc123..."
   Fix: Move to environment variable: process.env.STRIPE_SECRET_KEY

⚠️ Secret in git history:
   Commit: abc123 (2024-10-15)
   Pattern: AWS_SECRET_ACCESS_KEY
   Fix: Rotate the secret immediately, use git-filter-branch to remove
```

### Step 7: Review Security Config

**Check security headers and HTTPS:**

```typescript
## Security Configuration

❌ CORS misconfigured:
   Location: src/server.js:15
   Issue: app.use(cors({origin: '*'}))
   Fix: Specify allowed origins: cors({origin: 'https://yourdomain.com'})

❌ Missing security headers:
   Location: src/server.js
   Issue: No Content-Security-Policy header
   Fix: Add helmet.js: app.use(helmet())

⚠️ HTTP allowed in production:
   Location: src/config/production.js:10
   Issue: FORCE_HTTPS = false
   Fix: Set FORCE_HTTPS = true, redirect HTTP to HTTPS
```

### Step 8: Generate Security Report

**Comprehensive security report:**

```markdown
# Security Scan Report

Generated: 2025-10-28 15:30:00

## Summary

❌ **NOT SECURE** - 5 critical issues, 4 warnings

**Risk Level: HIGH**

---

## Critical Issues (Fix Immediately)

❌ **SQL Injection Vulnerability**
   Risk: HIGH - Database compromise possible
   Location: src/api/users.js:45
   Pattern: String concatenation in SQL query
   CVSS: 9.8 (Critical)
   Fix: Use parameterized queries

❌ **Hardcoded API Secret**
   Risk: CRITICAL - Production credentials exposed
   Location: src/config/stripe.js:3
   Pattern: sk_live_abc123... in source code
   Fix: Rotate secret, use environment variable

❌ **Missing Authorization Check**
   Risk: HIGH - Privilege escalation possible
   Location: src/api/posts.js:78
   Pattern: DELETE without ownership verification
   Fix: Add req.user.id === post.userId check

❌ **CORS Misconfiguration**
   Risk: MEDIUM-HIGH - Cross-origin attacks possible
   Location: src/server.js:15
   Pattern: origin: '*' allows all domains
   Fix: Whitelist specific domains

❌ **No Rate Limiting**
   Risk: MEDIUM - Brute force attacks possible
   Location: src/api/auth.js (login endpoint)
   Pattern: No rate limiter on /api/login
   Fix: Add express-rate-limit (5 attempts per 15 min)

---

## Warnings (Should Fix)

⚠️ **Weak Password Hashing**
   Location: src/auth/users.js:34
   Issue: bcrypt rounds = 8 (too low)
   Recommendation: Increase to 12 rounds

⚠️ **XSS Risk (Low Severity)**
   Location: src/components/Comment.jsx:23
   Issue: dangerouslySetInnerHTML without sanitization
   Recommendation: Use DOMPurify

⚠️ **Outdated Dependencies**
   Package: lodash@4.17.15
   CVE: CVE-2020-8203 (Prototype Pollution)
   Severity: Moderate
   Fix: npm install lodash@latest

⚠️ **Missing Security Headers**
   Location: src/server.js
   Issue: No CSP, X-Frame-Options, etc.
   Recommendation: Add helmet.js middleware

---

## What's Secure ✅

✅ HTTPS enforced
✅ Password hashing used (though weak)
✅ JWT tokens signed properly
✅ Session cookies use httpOnly
✅ .env files in .gitignore
✅ No eval() or exec() found
✅ File upload size limits present

---

## OWASP Top 10 Status

- [❌] A01: Broken Access Control (missing ownership checks)
- [❌] A02: Cryptographic Failures (hardcoded secrets)
- [❌] A03: Injection (SQL injection found)
- [⚠️] A04: Insecure Design (no rate limiting)
- [✅] A05: Security Misconfiguration (mostly secure)
- [⚠️] A06: Vulnerable Components (outdated packages)
- [⚠️] A07: Auth/Auth Failures (weak bcrypt rounds)
- [✅] A08: Data Integrity Failures (JWT signed)
- [⚠️] A09: Security Logging (no logging found)
- [✅] A10: SSRF (no vulnerable patterns)

**Score: 4/10 categories secure**

---

## Immediate Action Required

**Priority 1 (Do Now):**
1. Rotate hardcoded Stripe API key (CRITICAL)
2. Fix SQL injection in users.js:45
3. Add authorization check to DELETE /api/posts/:id
4. Fix CORS configuration

**Priority 2 (This Week):**
1. Add rate limiting to login endpoint
2. Update lodash dependency
3. Increase bcrypt rounds
4. Add helmet.js security headers

**Priority 3 (This Month):**
1. Implement security logging
2. Add CSP header
3. Review all file upload handling
4. Security training for team

---

## Estimated Fix Time

- Critical issues: 2-4 hours
- Warnings: 2-3 hours
- Total: 4-7 hours

**Recommendation:** Fix critical issues before next deployment

---

## Re-Scan Command

After fixes, re-run:
```bash
/security-scan
```

Expected result after fixes: 0 critical issues, <2 warnings
```

## Exit Codes

**For CI/CD integration:**
- Exit 0: ✅ No critical vulnerabilities
- Exit 1: ❌ Critical vulnerabilities found
- Exit 2: ⚠️ Warnings only (acceptable risk)

## Examples

### Example 1: Secure Project

```bash
/security-scan

# Output:
✅ SECURE - No vulnerabilities found

All security checks passed:
✅ No dependency vulnerabilities
✅ No dangerous code patterns
✅ Authentication properly implemented
✅ Input validation present
✅ No secrets exposed
✅ Security headers configured

This project follows security best practices!
```

### Example 2: High-Risk Project

```bash
/security-scan

# Output:
❌ NOT SECURE - 3 critical vulnerabilities

IMMEDIATE ACTION REQUIRED:
❌ SQL injection in api/users.js
❌ Hardcoded AWS credentials
❌ No authentication on admin endpoints

Fix these before deploying!
```

## Integration with Other Tools

**Works with:**
- `security-patterns` skill (main security engine)
- `error-handling-patterns` skill (secure error handling)
- `api-contract-design` skill (API security validation)
- CI/CD pipelines (exit codes for automation)

**Complements:**
- `/ship-check` - Includes basic security checks
- `/deploy-prep` - Pre-deployment security validation
- Git hooks (can run on pre-commit/pre-push)

## Configuration

**Optional: Create `.securityscan.json` in repo root:**

```json
{
  "skipDependencyCheck": false,
  "allowedCORSOrigins": ["https://yourdomain.com"],
  "customPatterns": [
    {
      "name": "Custom API pattern",
      "regex": "apiCall\\(.*req\\.query",
      "severity": "high",
      "message": "Never use req.query directly in API calls"
    }
  ],
  "excludePaths": ["tests/", "scripts/"],
  "strictMode": true
}
```

## Notes

- Run BEFORE every major deployment
- Integrate into CI/CD pipeline
- Re-run after dependency updates
- Schedule regular scans (weekly recommended)
- Complements but doesn't replace: penetration testing, security audits

## Quick Reference

| Risk Level | Action Required | Timeline |
|------------|-----------------|----------|
| Critical | Fix before deploy | Immediately |
| High | Fix this week | 1-7 days |
| Medium | Fix this sprint | 2-4 weeks |
| Low | Backlog | As time permits |
