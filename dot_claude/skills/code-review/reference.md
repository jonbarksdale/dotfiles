# Code Review Detailed Standards

## SOLID Principles Checklist

### Single Responsibility
- Each class/module has one reason to change
- Functions do one thing and do it well
- Avoid "god objects" that know too much

### Open/Closed
- Open for extension, closed for modification
- Prefer composition over inheritance
- Use interfaces/protocols for extensibility

### Liskov Substitution
- Subtypes must be substitutable for base types
- Don't violate contracts in derived classes

### Interface Segregation
- Prefer small, focused interfaces
- Clients shouldn't depend on methods they don't use

### Dependency Inversion
- Depend on abstractions, not concretions
- High-level modules shouldn't depend on low-level modules

## Security Review Patterns

### Input Validation
- Validate at system boundaries (user input, API requests, file uploads)
- Use allowlists over denylists when possible
- Sanitize data before use in SQL, HTML, shell commands

### Authentication & Authorization
- Verify auth checks exist for protected resources
- Check for proper session management
- Look for privilege escalation vulnerabilities

### Data Protection
- No secrets in code (API keys, passwords, tokens)
- Sensitive data encrypted at rest and in transit
- Proper error handling (don't leak internal details)

### OWASP Top 10 Awareness
- Injection (SQL, NoSQL, OS command, LDAP)
- Broken authentication
- Sensitive data exposure
- XML external entities (XXE)
- Broken access control
- Security misconfiguration
- Cross-site scripting (XSS)
- Insecure deserialization
- Using components with known vulnerabilities
- Insufficient logging and monitoring

## Performance Considerations

### Database
- N+1 query detection
- Missing indexes on frequently queried columns
- Unbounded queries (missing LIMIT)
- Connection pool management

### Memory
- Large object allocations in loops
- Resource leaks (file handles, connections)
- Unbounded caches or collections

### Concurrency
- Race conditions
- Deadlock potential
- Thread safety of shared state

## Testing Adequacy

### Coverage Questions
- Are happy paths tested?
- Are error paths tested?
- Are edge cases covered (null, empty, boundary values)?
- Are integrations tested with real dependencies?

### Test Quality
- Tests are independent and repeatable
- Tests verify behavior, not implementation
- Test names describe the scenario and expectation

## Error Handling Patterns

### Best Practices
- Fail fast and loud (don't swallow exceptions)
- Provide context in error messages
- Log errors with enough detail to debug
- Return appropriate HTTP status codes (APIs)

### Anti-Patterns to Flag
- Empty catch blocks
- Generic exception handling hiding specific errors
- Logging without context
- Returning null instead of throwing/empty collection

## Code Style Review

### Consistency
- Matches surrounding code style
- Follows project conventions
- Consistent naming patterns

### Readability
- Self-documenting code (good names, clear structure)
- Comments explain WHY, not WHAT
- Appropriate abstraction level (not too clever)

### Maintainability
- No magic numbers or strings
- Configuration externalized where appropriate
- No dead code or commented-out code
