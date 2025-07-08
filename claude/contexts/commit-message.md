# Commit Message Standards

## Commit Structure

```
<type>[optional scope]: <subject>

[optional body]

[optional footer(s)]
```

## Seven Rules

1. Separate subject from body with a blank line
2. Limit the subject line to 50 characters
3. Capitalize the subject line
4. Do not end the subject line with a period
5. Use the imperative mood in the subject line
6. Wrap the body at 72 characters
7. Use the body to explain what and why vs. how

## Type Prefixes

- `feat`: A new feature (correlates with MINOR in Semantic Versioning)
- `fix`: A bug fix (correlates with PATCH in Semantic Versioning)
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools
- `build`: Changes that affect the build system or external dependencies
- `ci`: Changes to CI configuration files and scripts

## Breaking Changes

Breaking changes should be indicated in one of two ways:

1. Using an `!` after the type/scope: `feat(api)!: remove users endpoint`
2. Adding a `BREAKING CHANGE:` footer: `BREAKING CHANGE: environment variables now take precedence over config files`

## Examples

```
feat(checkout): add payment method selection

Implement PayPal and Stripe integrations for payment processing.
This allows users to save their preferred payment methods.

Refs: #123
```

```
fix(auth): resolve token expiration issue

Tokens were expiring prematurely due to incorrect timestamp calculation.
The expiry time is now correctly set to 24 hours from creation.
```

```
docs: update installation instructions

Update the README with more detailed installation steps and troubleshooting.
```

```
refactor!: drop support for Node 6

BREAKING CHANGE: use JavaScript features not available in Node 6.
```
