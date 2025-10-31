---
name: error-handling-patterns
description: Use when implementing error handling for features, APIs, or user interactions - provides comprehensive patterns for try-catch blocks, user-friendly messages, logging, error boundaries, and recovery strategies across backend and frontend
---

# Error Handling Patterns

## Overview

**Good error handling is invisible when things work, indispensable when they don't.**

This skill provides systematic error handling patterns for backend APIs, frontend UX, and cross-cutting concerns. It ensures errors are caught, logged, communicated clearly, and don't crash the application.

**Core principle:** Every error is an opportunity to provide value - either through clear user feedback or diagnostic information for debugging.

## When to Use

Use this skill when:
- **Implementing new features** - Before writing happy path, plan error handling
- **API development** - Handling database errors, validation, auth failures
- **Frontend development** - Network errors, loading states, user feedback
- **User interactions** - Form submissions, file uploads, async operations
- **Integration points** - External APIs, services, databases

**Triggers:**
- Starting new feature (plan error handling upfront)
- User reports "app crashed", "error message unclear"
- Debugging production issues (improve error visibility)
- Code review finds missing error handling

**DO NOT use for:**
- Logging only (error handling includes user communication)
- Production issues already solved (use memory-assisted-debugging)

## Error Handling Layers

###

 Layer 1: Backend API

**Pattern: Consistent Error Responses**

```javascript
// Standard error response format
{
  "error": {
    "code": "VALIDATION_ERROR",  // Machine-readable
    "message": "Email is required",  // User-friendly
    "field": "email",  // Which field (for forms)
    "details": {...}  // Additional context (optional)
  }
}
```

**HTTP Status Codes (Use Correctly):**
- `400` Bad Request - Client error (validation, malformed)
- `401` Unauthorized - Missing/invalid authentication
- `403` Forbidden - Authenticated but lacks permission
- `404` Not Found - Resource doesn't exist
- `409` Conflict - Duplicate, concurrent modification
- `422` Unprocessable Entity - Semantic errors
- `429` Too Many Requests - Rate limit exceeded
- `500` Internal Server Error - Unexpected server error
- `503` Service Unavailable - Temporary outage

**Example: Database Error Handling**

```javascript
// ❌ BAD: Exposes internal details
app.post('/api/users', async (req, res) => {
  const user = await User.create(req.body);  // No try-catch
  res.json(user);
});

// ✅ GOOD: Comprehensive error handling
app.post('/api/users', async (req, res) => {
  try {
    // Validation first
    if (!req.body.email) {
      return res.status(400).json({
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Email is required',
          field: 'email'
        }
      });
    }

    const user = await User.create(req.body);
    res.status(201).json(user);

  } catch (error) {
    // Duplicate email (unique constraint)
    if (error.code === 'ER_DUP_ENTRY' || error.code === '23505') {
      return res.status(409).json({
        error: {
          code: 'DUPLICATE_EMAIL',
          message: 'An account with this email already exists',
          field: 'email'
        }
      });
    }

    // Log unexpected errors
    console.error('User creation failed:', error);

    // Generic 500 for unexpected errors
    res.status(500).json({
      error: {
        code: 'SERVER_ERROR',
        message: 'Failed to create user. Please try again.'
      }
    });
  }
});
```

### Layer 2: Frontend UX

**Pattern: User-Friendly Error States**

```jsx
// ✅ GOOD: Comprehensive error UX
function UserForm() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const handleSubmit = async (data) => {
    setLoading(true);
    setError(null);  // Clear previous errors

    try {
      await api.createUser(data);
      // Success handling
      showSuccessMessage('Account created!');
      navigate('/dashboard');

    } catch (err) {
      setLoading(false);

      // Network error
      if (!err.response) {
        setError({
          message: 'Network error. Check your connection and try again.',
          type: 'network'
        });
        return;
      }

      // Backend error
      const { error } = err.response.data;

      // Field-specific error
      if (error.field) {
        setFieldError(error.field, error.message);
      } else {
        // General error
        setError({
          message: error.message || 'Something went wrong. Please try again.',
          type: 'server'
        });
      }
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      {error && (
        <ErrorAlert type={error.type}>
          {error.message}
        </ErrorAlert>
      )}

      <input name="email" />
      {/* Show loading state */}
      <button disabled={loading}>
        {loading ? 'Creating account...' : 'Sign Up'}
      </button>
    </form>
  );
}
```

### Layer 3: Error Boundaries (React)

**Pattern: Catch Rendering Errors**

```jsx
class ErrorBoundary extends React.Component {
  state = { hasError: false, error: null };

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  componentDidCatch(error, errorInfo) {
    // Log to error tracking service
    console.error('React error:', error, errorInfo);
    // Or: Sentry.captureException(error);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="error-boundary">
          <h1>Something went wrong</h1>
          <p>We've been notified and are working on it.</p>
          <button onClick={() => window.location.reload()}>
            Reload Page
          </button>
        </div>
      );
    }

    return this.props.children;
  }
}

// Usage
<ErrorBoundary>
  <App />
</ErrorBoundary>
```

## Common Error Patterns

### Pattern 1: Input Validation

```javascript
// Validate BEFORE processing
function validateUserInput(data) {
  const errors = {};

  if (!data.email) {
    errors.email = 'Email is required';
  } else if (!isValidEmail(data.email)) {
    errors.email = 'Email is invalid';
  }

  if (!data.password) {
    errors.password = 'Password is required';
  } else if (data.password.length < 8) {
    errors.password = 'Password must be at least 8 characters';
  }

  return Object.keys(errors).length > 0 ? errors : null;
}

// Use in handler
const errors = validateUserInput(req.body);
if (errors) {
  return res.status(400).json({ error: { code: 'VALIDATION_ERROR', fields: errors } });
}
```

### Pattern 2: External API Errors

```javascript
async function fetchUserData(userId) {
  try {
    const response = await externalAPI.getUser(userId);
    return response.data;

  } catch (error) {
    // Timeout
    if (error.code === 'ETIMEDOUT') {
      throw new Error('Request timed out. Service may be slow.');
    }

    // Rate limited
    if (error.response?.status === 429) {
      throw new Error('Too many requests. Please wait and try again.');
    }

    // Service down
    if (error.response?.status >= 500) {
      throw new Error('External service is temporarily unavailable.');
    }

    // Unknown error
    console.error('External API error:', error);
    throw new Error('Failed to fetch user data.');
  }
}
```

### Pattern 3: File Upload Errors

```javascript
async function handleFileUpload(file) {
  try {
    // Size check
    if (file.size > 5 * 1024 * 1024) {  // 5MB
      throw new Error('File size must be less than 5MB');
    }

    // Type check
    const allowedTypes = ['image/jpeg', 'image/png', 'image/gif'];
    if (!allowedTypes.includes(file.type)) {
      throw new Error('Only JPEG, PNG, and GIF images are allowed');
    }

    // Upload
    const url = await uploadToS3(file);
    return url;

  } catch (error) {
    // Re-throw validation errors
    if (error.message.includes('size') || error.message.includes('allowed')) {
      throw error;
    }

    // Log and wrap unexpected errors
    console.error('Upload failed:', error);
    throw new Error('Failed to upload file. Please try again.');
  }
}
```

## Error Message Guidelines

**User-Friendly Messages:**

```javascript
// ❌ BAD: Technical jargon
"ECONNREFUSED on port 5432"
"Null pointer exception in UserService.create"

// ✅ GOOD: User-friendly
"Can't connect to the server. Check your internet connection."
"Failed to create account. Please try again."

// ✅ BETTER: Actionable
"Email already in use. Try logging in or use a different email."
"Session expired. Please log in again."
```

**Error Message Template:**
```
[What happened] + [Why it might have happened] + [What user can do]

Examples:
- "Failed to save changes. Your session may have expired. Please log in again."
- "Can't load user data. The server may be busy. Please refresh the page."
- "Invalid email format. Please enter a valid email address like user@example.com."
```

## Logging Strategy

**What to Log:**
```javascript
try {
  await riskyOperation();
} catch (error) {
  // Log with context
  console.error('Operation failed:', {
    operation: 'riskyOperation',
    userId: req.user?.id,
    timestamp: new Date().toISOString(),
    error: error.message,
    stack: error.stack
  });

  // Show user-friendly message
  res.status(500).json({
    error: { message: 'Operation failed. Our team has been notified.' }
  });
}
```

**Don't Log:**
- Passwords, API keys, secrets
- Full credit card numbers
- Personal identifiable information (unless necessary and compliant)

## Quick Reference

| Scenario | Status Code | User Message | Log Level |
|----------|------------|--------------|-----------|
| Missing required field | 400 | "Email is required" | Info |
| Invalid email format | 400 | "Email is invalid" | Info |
| Wrong password | 401 | "Invalid credentials" | Warn |
| No permission | 403 | "You don't have access to this" | Warn |
| Resource not found | 404 | "User not found" | Info |
| Duplicate email | 409 | "Email already in use" | Info |
| Rate limit hit | 429 | "Too many requests. Try again later" | Warn |
| Database error | 500 | "Something went wrong. Try again" | Error |
| External API down | 503 | "Service temporarily unavailable" | Error |

## Integration Checklist

**For every new feature:**
- [ ] Input validation with user-friendly messages
- [ ] Try-catch blocks around async operations
- [ ] Proper HTTP status codes
- [ ] Loading states in frontend
- [ ] Error states in frontend
- [ ] Network error handling
- [ ] Error logging (without secrets)
- [ ] User-friendly error messages
- [ ] Retry logic (where appropriate)
- [ ] Error recovery paths

## Common Mistakes

### ❌ Silent Failures
```javascript
try {
  await saveData();
} catch (e) {
  // Nothing - error swallowed
}
```
**Fix:** Always handle errors - log, show message, or both.

### ❌ Generic "Something Went Wrong"
**Fix:** Be specific about what went wrong and what user can do.

### ❌ Exposing Stack Traces to Users
```javascript
res.status(500).send(error.stack);  // Security risk
```
**Fix:** Log stack traces server-side, show friendly message to user.

### ❌ Not Handling Network Errors
```javascript
fetch('/api/data').then(res => res.json())  // No .catch()
```
**Fix:** Always add .catch() or try-catch for network errors.

## Real-World Impact

**Without comprehensive error handling:**
- Apps crash unexpectedly
- Users see cryptic error messages
- Hard to debug production issues
- Poor user experience

**With this skill:**
- Graceful error recovery
- Clear user communication
- Diagnostic information logged
- Professional UX even when things fail
