---
name: security-patterns
description: Use when implementing authentication, handling user input, building APIs, or addressing security concerns - provides OWASP Top 10 framework and defense-in-depth patterns to prevent vulnerabilities
---

# Security Patterns

## Overview

Security vulnerabilities destroy user trust and cost millions. **Core principle:** Defense-in-depth with systematic validation at every layer.

## The Iron Law

```
NO TRUST OF CLIENT-SIDE DATA
NO UNVALIDATED USER INPUT
NO SECURITY THROUGH OBSCURITY
```

## When to Use

Use for ANY security-related work:
- Authentication/authorization
- User input handling
- API endpoints
- File uploads
- Database queries
- Password handling
- Session management

## OWASP Top 10 Quick Reference

### 1. Broken Access Control
```typescript
// ❌ INSECURE
app.delete('/api/posts/:id', async (req, res) => {
  await db.posts.delete(req.params.id); // ANY user can delete ANY post!
});

// ✅ SECURE
app.delete('/api/posts/:id', authenticate, async (req, res) => {
  const post = await db.posts.findOne(req.params.id);
  if (post.userId !== req.user.id) {
    return res.status(403).json({ error: 'Forbidden' });
  }
  await db.posts.delete(req.params.id);
});
```

### 2. Cryptographic Failures
```typescript
// ❌ INSECURE
const hash = crypto.createHash('md5').update(password).digest('hex');

// ✅ SECURE
import bcrypt from 'bcrypt';
const hash = await bcrypt.hash(password, 12); // 12+ rounds
```

### 3. Injection Attacks
```typescript
// ❌ INSECURE
const query = `SELECT * FROM users WHERE email = '${email}'`;

// ✅ SECURE
const query = 'SELECT * FROM users WHERE email = ?';
db.execute(query, [email]); // Parameterized queries
```

### 4. Insecure Design
```typescript
// ✅ SECURE: Rate limiting
import rateLimit from 'express-rate-limit';
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5 // 5 attempts
});
app.post('/api/login', loginLimiter, async (req, res) => {...});
```

### 5. Security Misconfiguration
```typescript
// ❌ INSECURE
app.use(cors({ origin: '*' }));

// ✅ SECURE
app.use(cors({
  origin: ['https://yourdomain.com'],
  credentials: true
}));
```

### 6. Vulnerable Components
```bash
# Check and fix regularly
npm audit
npm audit fix
```

### 7. Auth Failures
```typescript
// ✅ SECURE: Secure sessions
app.use(session({
  secret: process.env.SESSION_SECRET,
  cookie: {
    httpOnly: true,
    secure: true,
    sameSite: 'strict',
    maxAge: 3600000
  }
}));
```

### 8. Software Integrity
```typescript
// ✅ SECURE: Verify JWT properly
jwt.verify(token, process.env.JWT_SECRET, {
  algorithms: ['HS256'] // Only allow secure algorithms
});
```

### 9. Security Logging
```typescript
// ✅ SECURE: Log security events
securityLogger.warn('Authorization failure', {
  userId: req.user.id,
  attemptedAction: 'DELETE',
  resource: 'post',
  resourceId: req.params.id
});
```

### 10. SSRF Prevention
```typescript
// ❌ INSECURE
const response = await fetch(req.body.url); // User controls URL!

// ✅ SECURE
const ALLOWED_DOMAINS = ['api.example.com'];
const url = new URL(req.body.url);
if (!ALLOWED_DOMAINS.includes(url.hostname)) {
  return res.status(400).json({ error: 'Domain not allowed' });
}
```

## Input Validation Framework

```typescript
import { body, validationResult } from 'express-validator';

app.post('/api/users',
  body('email').trim().isEmail().normalizeEmail(),
  body('username').trim().isLength({ min: 3, max: 30 })
    .matches(/^[a-zA-Z0-9_]+$/),
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    // Input is validated
  }
);
```

## File Upload Security

```typescript
const upload = multer({
  limits: { fileSize: 10 * 1024 * 1024 }, // 10MB
  fileFilter: (req, file, cb) => {
    const allowedTypes = ['image/jpeg', 'image/png'];
    if (!allowedTypes.includes(file.mimetype)) {
      return cb(new Error('File type not allowed'));
    }
    cb(null, true);
  }
});
```

## Security Checklist

**Before shipping:**
- [ ] All endpoints require authentication
- [ ] Ownership/permission checks on data access
- [ ] All input validated (type, length, format)
- [ ] Parameterized SQL queries
- [ ] HTML sanitized
- [ ] No secrets in code
- [ ] CORS configured (no wildcard)
- [ ] Rate limiting on auth endpoints
- [ ] Security headers (helmet.js)
- [ ] HTTPS enforced
- [ ] Dependencies audited

## Common Vulnerabilities

| Vulnerability | Fix |
|---------------|-----|
| SQL Injection | Parameterized queries |
| XSS | DOMPurify.sanitize() |
| Missing Auth | Check req.user.id === resource.userId |
| Weak Hashing | bcrypt with 12+ rounds |
| CSRF | CSRF token middleware |
| Rate Limit | express-rate-limit |

## Integration

**Works with:**
- `/security-scan` command for comprehensive review
- `api-contract-design` for secure API design
- `error-handling-patterns` for secure error handling
