# test-assist

AI-powered test writing assistant - analyzes code and suggests comprehensive test cases.

## Usage

```bash
/test-assist [file-path]
```

If no file provided, prompts for code to analyze.

## Description

Intelligent test case generation:
1. **Code analysis** - Understand function behavior and edge cases
2. **Test case suggestions** - Comprehensive coverage scenarios
3. **Test stub generation** - Ready-to-use test templates
4. **Mock recommendations** - Dependencies to mock
5. **Coverage gap identification** - Untested code paths

Returns: Complete test suite suggestions with implementation templates

## What It Provides

### Analysis Phase
- [ ] Function/method understanding (inputs, outputs, side effects)
- [ ] Dependency identification (what to mock)
- [ ] Edge case discovery (null, empty, boundary values)
- [ ] Error condition identification (exceptions, validation failures)

### Test Case Generation
- [ ] Happy path tests (expected inputs → expected outputs)
- [ ] Edge case tests (boundaries, empty, null)
- [ ] Error case tests (invalid inputs, exceptions)
- [ ] Integration tests (if applicable)
- [ ] Performance tests (for critical paths)

### Test Implementation
- [ ] Test structure (AAA: Arrange-Act-Assert)
- [ ] Mock setup code
- [ ] Assertion examples
- [ ] Test data fixtures
- [ ] Cleanup/teardown code

## Skills Used

This command orchestrates:
1. **test-driven-development** - Testing best practices
2. **systematic-debugging** (optional) - Understanding complex code
3. **memory-assisted-spec-kit** (optional) - Test patterns from past features

## Quick Reference

| Test Type | When to Use | Example |
|-----------|-------------|---------|
| Unit | Isolated functions | `test("adds two numbers")` |
| Integration | Multiple components | `test("API → DB → response")` |
| Edge Case | Boundaries | `test("handles empty array")` |
| Error | Exceptions | `test("throws on invalid input")` |
| Performance | Critical paths | `test("processes 10k items <1s")` |
