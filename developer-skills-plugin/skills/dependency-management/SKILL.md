---
name: dependency-management
description: Use when updating packages, adding new dependencies, or managing dependency vulnerabilities - systematic approach to dependency selection, updates, and security
---

# Dependency Management

## Overview

Dependencies are liabilities. Each one brings security risks, breaking changes, and maintenance burden. **Core principle:** Minimize dependencies, keep them updated, audit regularly.

## The Iron Law

```
NO DEPENDENCY WITHOUT JUSTIFICATION
NO OUTDATED PACKAGES WITH KNOWN CVES
ALWAYS CHECK BUNDLE SIZE IMPACT
```

## When to Use

- Adding new dependency
- Updating existing packages
- Security vulnerabilities found
- Bundle size too large
- Breaking changes in updates
- Dependency conflicts

## Dependency Selection Criteria

### Before Adding a Dependency

**Ask these questions:**
1. Can I implement this in <100 lines? (If yes, don't add dependency)
2. Is this well-maintained? (Last commit <6 months ago)
3. What's the bundle size impact? (Use bundlephobia.com)
4. How many dependencies does IT have? (Fewer is better)
5. Are there known security issues? (Check npm audit)
6. What's the license? (Compatible with my project?)

```bash
# Check package info before installing
npm info <package-name>
npx bundlephobia <package-name>
```

### Dependency Risk Assessment

| Factor | Low Risk | Medium Risk | High Risk |
|--------|----------|-------------|-----------|
| Last Update | <3 months | 3-12 months | >12 months |
| Dependencies | <5 | 5-20 | >20 |
| Bundle Size | <10KB | 10-100KB | >100KB |
| Known CVEs | 0 | 1-2 low | 3+ or critical |
| Maintainers | >3 active | 1-2 active | Single/inactive |

## Update Strategy

### Regular Maintenance Schedule

```bash
# Weekly: Check for updates
npm outdated

# Monthly: Update non-breaking changes
npm update

# Quarterly: Major version updates (requires testing)
npm install package@latest
```

### Update Process

```bash
# 1. Check current state
npm outdated

# 2. Update one package at a time
npm install package@latest

# 3. Run tests
npm test

# 4. Check for breaking changes
git diff package.json
npm run build

# 5. Commit if successful
git commit -am "chore: update package to vX.Y.Z"

# 6. If tests fail, investigate before next update
```

## Security Vulnerability Management

### Audit Dependencies

```bash
# Check for vulnerabilities
npm audit

# Show detailed report
npm audit --json

# Fix automatically (non-breaking)
npm audit fix

# Fix with breaking changes (review carefully!)
npm audit fix --force
```

### Vulnerability Response

| Severity | Action | Timeline |
|----------|--------|----------|
| Critical | Fix immediately | <24 hours |
| High | Fix this week | <7 days |
| Moderate | Fix this sprint | <2 weeks |
| Low | Backlog | Next maintenance window |

### When Vulnerability Can't Be Fixed

```json
// .npmrc - Temporarily ignore until fix available
{
  "audit-level": "moderate"
}
```

**Document why:**
```markdown
## Known Issues

- lodash@4.17.20: Prototype pollution (CVE-2020-8203)
  - Status: No fix available yet
  - Mitigation: Not exposed to user input
  - Will update when lodash@4.17.21 is released
```

## Bundle Size Management

### Analyze Bundle

```bash
# Webpack Bundle Analyzer
npm install --save-dev webpack-bundle-analyzer

# Add to webpack config
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;
plugins: [new BundleAnalyzerPlugin()]

# Run build and view report
npm run build
```

### Reduce Bundle Size

```javascript
// ❌ BAD: Import entire library
import _ from 'lodash'; // 70KB!
import moment from 'moment'; // 230KB!

// ✅ GOOD: Import specific functions
import debounce from 'lodash/debounce'; // 2KB
import dayjs from 'dayjs'; // 2KB (moment alternative)

// ✅ GOOD: Use tree-shakeable libraries
import { formatDistance } from 'date-fns'; // Only what you need
```

### Dependency Alternatives

| Heavy Dependency | Lightweight Alternative | Size Savings |
|------------------|-------------------------|--------------|
| moment (230KB) | dayjs (2KB) | 228KB |
| lodash (70KB) | Individual imports or native | 60KB+ |
| axios (15KB) | fetch API (native) | 15KB |
| jquery (87KB) | Native DOM APIs | 87KB |

## Version Pinning Strategy

```json
// package.json strategies

// ❌ RISKY: Allow any version
"dependencies": {
  "express": "*"
}

// ⚠️ MODERATE: Allow patch updates
"dependencies": {
  "express": "~4.18.0" // Allows 4.18.x
}

// ✅ SAFE: Allow minor updates
"dependencies": {
  "express": "^4.18.0" // Allows 4.x.x
}

// ✅ SAFEST: Pin exact version
"dependencies": {
  "express": "4.18.2" // No automatic updates
}
```

**Recommendation:** Use `^` for most packages, exact version for critical dependencies.

## Lock Files

```bash
# ALWAYS commit lock files
git add package-lock.json  # npm
git add yarn.lock          # yarn
git add pnpm-lock.yaml     # pnpm

# Use same package manager across team
# Set in .npmrc or document in README
```

## Dependency Update Workflow

```markdown
# Dependency Update Process

1. **Check for updates** (weekly)
   ```bash
   npm outdated
   ```

2. **Review changelog** for each package
   - Breaking changes?
   - Security fixes?
   - New features needed?

3. **Update incrementally**
   - One package at a time
   - Test after each update
   - Commit successful updates

4. **Run full test suite**
   ```bash
   npm test
   npm run build
   /check-integration
   ```

5. **Update documentation**
   - Note breaking changes
   - Update usage examples
   - Document migration steps

6. **Deploy to staging first**
   - Test in production-like environment
   - Monitor for issues
   - Rollback plan ready
```

## Transitive Dependencies

### Check Dependency Tree

```bash
# View full dependency tree
npm ls

# Check specific package
npm ls lodash

# Find why package is installed
npm explain lodash
```

### Resolve Conflicts

```bash
# Force resolution (use carefully!)
# package.json
{
  "overrides": {
    "lodash": "4.17.21"  // Force all packages to use this version
  }
}
```

## Deprecated Packages

### Find Deprecated Packages

```bash
npm outdated --deprecated
```

### Migration Path

1. **Identify replacement** (npm suggests alternatives)
2. **Check migration guide** (package README usually has one)
3. **Update incrementally** (don't batch with other changes)
4. **Test thoroughly** (APIs often change)
5. **Document changes** (for team awareness)

## Monorepo Dependency Management

```bash
# Use workspaces
# package.json
{
  "workspaces": ["packages/*"]
}

# Install in workspace root
npm install -w @myorg/package-a

# Hoist common dependencies
# This prevents duplicate installations
```

## License Compliance

### Check Licenses

```bash
npm install -g license-checker
license-checker --summary
```

### License Compatibility

| Project License | Compatible Dep Licenses | Incompatible |
|-----------------|-------------------------|--------------|
| MIT | MIT, Apache, BSD | GPL, AGPL |
| Apache 2.0 | MIT, Apache, BSD | GPL (sometimes) |
| GPL | MIT, Apache, BSD, GPL | Proprietary |

## Integration

**Works with:**
- `/security-scan` for vulnerability detection
- `verification-before-completion` before deployment
- `systematic-debugging` when updates cause issues

## Quick Reference

```bash
# Daily/Weekly
npm audit                    # Check vulnerabilities
npm outdated                 # Check for updates

# Before Adding Dependency
npm info <package>           # Check package details
npx bundlephobia <package>   # Check bundle size
npm audit <package>          # Check for CVEs

# Updating
npm update                   # Non-breaking updates
npm install package@latest   # Major updates

# Troubleshooting
npm ls <package>             # Find all versions
npm explain <package>        # Why is this installed?
rm -rf node_modules package-lock.json && npm install  # Nuclear option
```
