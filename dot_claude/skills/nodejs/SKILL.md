---
name: nodejs
description: Node.js development standards including project structure, quality tools (npm, Biome, Vitest, TypeScript), testing patterns, and best practices.
---

# Node.js Development Standards

Apply these standards when working with Node.js/TypeScript projects.

## Toolchain Summary

| Category | Preferred Tool | Alternative |
|----------|---------------|-------------|
| Package Manager | npm | - |
| Linting/Formatting | Biome | ESLint + Prettier |
| Testing | Vitest | Jest |
| Type Checking | TypeScript (strict) | - |

## Key Commands

```bash
npm ci                        # Clean install
npm run lint && npm run test  # Quality check
npm run typecheck             # Type validation
npm run test:coverage         # Coverage report
```

## Quality Requirements

- 80% minimum test coverage
- No linting errors
- 100% type coverage
- Clean npm audit

See [reference.md](./reference.md) for complete tooling standards and configurations.
