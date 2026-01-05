# Node.js Development Tooling Standards

This reference defines the standard Node.js development toolchain, quality requirements, and verification processes.

## Package Management & Project Setup

**Primary Tool: npm**
- Use `npm` for package management with proper version constraints
- Leverage `package-lock.json` for dependency reproducibility
- Use `npm init` for new projects with proper metadata
- Manage dependencies with appropriate placement (dependencies vs devDependencies)

**Version Management**
- **Volta**: Use Volta for team-consistent Node.js and npm versions
- **Engine Constraints**: Specify minimum Node.js and npm versions in package.json
- **Package Manager**: Pin packageManager field for consistency
- Standard commands:
  - `npm install` - Install dependencies
  - `npm ci` - Clean install for CI environments
  - `npm update` - Update dependencies within semver ranges

## Code Quality & Formatting

**Primary Tools: Biome (preferred) OR ESLint + Prettier**

### Biome Configuration (Recommended for New Projects)
- Use `@biomejs/biome` for unified formatting and linting
- Configure via `biome.jsonc` with appropriate rules
- Standard Biome commands:
  - `npx biome format .` - Format code
  - `npx biome lint .` - Lint code
  - `npx biome check .` - Run both format and lint
  - `npx biome check . --write` - Format and fix automatically

### ESLint + Prettier (For Existing Projects)
- Use ESLint for linting with appropriate configs
- Use Prettier for code formatting
- Standard commands:
  - `npm run lint` - Run ESLint
  - `npm run lint:fix` - Auto-fix ESLint issues
  - `npm run format` - Run Prettier
  - `npm run format:check` - Check format without writing

### Import Organization
- Use automatic import sorting and organization
- Configure path aliases for cleaner imports (@/ for src/, etc.)
- Enforce consistent import grouping (external, internal, relative)

## Testing & Coverage

**Primary Tools: Vitest (preferred) OR Jest**

### Vitest Configuration (Recommended for New Projects)
- Use `vitest` for fast, modern testing with native ES modules support
- Configure multi-environment testing (node, dom, edge)
- Standard Vitest commands:
  - `npm test` - Run all tests
  - `npm run test:watch` - Run tests in watch mode
  - `npm run test:coverage` - Run tests with coverage report
  - `npm run test:ui` - Run tests with UI interface

### Jest Configuration (For Existing Projects)
- Use Jest with appropriate transformers and configuration
- Standard Jest commands:
  - `npm test` - Run all tests
  - `npm run test:watch` - Run tests in watch mode
  - `npm run test:coverage` - Generate coverage reports

### Coverage Requirements
- **Minimum Coverage**: 80% for branches, functions, lines, and statements
- **Exclusions**: Configuration files, build outputs, test files themselves
- **Reporting**: HTML and text reports for local development, LCOV for CI
- **Thresholds**: Enforce coverage gates in CI pipelines

## TypeScript Integration

**Configuration Standards:**
- Use strict TypeScript configuration with latest language features
- Extend from `@tsconfig/strictest` for maximum type safety
- Configure path mapping for clean imports
- Enable incremental compilation for faster builds

**Type Checking:**
- Use `tsc --noEmit` for type checking without compilation
- Standard TypeScript commands:
  - `npm run typecheck` - Check types without emitting
  - `npm run build` - Compile TypeScript to JavaScript
  - `tsc --watch` - Type check in watch mode

**Type Coverage:**
- Aim for 100% type annotation coverage
- Use `any` sparingly with proper justification
- Leverage utility types and generics for reusable code
- Configure strict compiler options (noImplicitAny, strictNullChecks, etc.)

## Project Structure Standards

### Single Repository Structure
```
project-name/
├── package.json
├── package-lock.json
├── README.md
├── tsconfig.json
├── biome.jsonc (or .eslintrc + .prettierrc)
├── vitest.config.ts (or jest.config.js)
├── src/
│   ├── index.ts
│   └── lib/
├── tests/
│   └── *.test.ts
└── dist/ (build output)
```

### Monorepo Structure (with Turborepo)
```
monorepo-name/
├── package.json
├── package-lock.json
├── turbo.json
├── apps/
│   ├── web/
│   └── api/
├── packages/
│   ├── ui/
│   └── shared/
└── tooling/
    ├── eslint-config/
    └── typescript-config/
```

## Monorepo vs Single Repository

### When to Use Monorepo
- **Multiple Related Applications**: Web app + API + mobile app
- **Shared Component Libraries**: Design systems, utility packages
- **Coordinated Releases**: Changes span multiple packages
- **Team Ownership**: Multiple teams working on related codebases

**Recommended Tools for Monorepo:**
- **Turborepo**: Task orchestration, caching, and parallel execution
- **npm Workspaces**: Package management and dependency sharing
- **Changeset**: Version management and release coordination

### When to Use Single Repository
- **Single Application**: Standalone web app, API, or library
- **Independent Releases**: No coordination with other packages required
- **Simple Workflows**: Standard npm scripts sufficient
- **Team Size**: Small team or individual developer

**Recommended Approach for Single Repo:**
- Standard npm scripts in package.json
- Direct tool execution without orchestration layers
- Simple CI/CD pipelines

## Quality Standards Matrix

| Category | Tool | Requirement | Command |
|----------|------|-------------|---------|
| **Code Style** | Biome/Prettier | 100% formatted code | `npm run format` |
| **Linting** | Biome/ESLint | No linting errors | `npm run lint` |
| **Type Safety** | TypeScript | 100% type coverage | `npm run typecheck` |
| **Test Coverage** | Vitest/Jest | Minimum 80% coverage | `npm run test:coverage` |
| **Dependency Security** | npm audit | No known vulnerabilities | `npm audit` |

## Build and Development

**Development Server:**
- Use framework-specific dev servers (Next.js, Vite, etc.)
- Configure hot module replacement for fast development
- Standard commands:
  - `npm run dev` - Start development server
  - `npm run build` - Build for production
  - `npm run start` - Start production server
  - `npm run preview` - Preview production build locally

**Build Optimization:**
- Configure source maps appropriately (development vs production)
- Implement proper tree shaking and code splitting
- Optimize bundle sizes with analysis tools
- Configure appropriate target environments (Node.js version, browser support)

## Environment Management

**Configuration:**
- Use environment variables for configuration
- Never commit secrets or sensitive data
- Use `.env` files for local development with `.env.example` templates
- Validate environment variables at application startup

**Multi-Environment Support:**
- Configure different settings for development, staging, production
- Use proper environment detection and validation
- Document required environment variables in README

## Verification Requirements

**Quality Pipeline:**
- All code must pass formatting, linting, type checking, and testing
- Coverage thresholds must be met before merging
- No security vulnerabilities in dependencies
- Build must complete successfully

**Standard npm Scripts:**
```json
{
  "scripts": {
    "dev": "development server command",
    "build": "production build command",
    "start": "start production server",
    "test": "run all tests",
    "test:coverage": "run tests with coverage",
    "test:watch": "run tests in watch mode",
    "lint": "run linting",
    "lint:fix": "fix auto-fixable lint issues",
    "format": "format code",
    "format:check": "check code formatting",
    "typecheck": "check TypeScript types",
    "audit": "check for security vulnerabilities"
  }
}
```

## Integration with Quality Assurance

**Project Detection:**
- Quality assurance agents detect Node.js projects via package.json
- Automatically identify existing tooling and use appropriate commands
- Respect existing configurations and script names

**Quality Pipeline Execution:**
- Run formatting check: `npm run format:check` or `npx biome check`
- Run linting: `npm run lint` or detected linting command
- Run type checking: `npm run typecheck` or `npx tsc --noEmit`
- Run tests with coverage: `npm run test:coverage`
- Check dependencies: `npm audit`

**Evidence Generation:**
- Save test results, coverage reports, and linting outputs
- Generate build artifacts for verification
- Document successful pipeline execution
