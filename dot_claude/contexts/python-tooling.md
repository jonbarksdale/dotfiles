# Python Development Tooling Standards

This context file defines the standard Python development toolchain, quality requirements, and verification processes used across all Python agents and workflows.

## Package Management & Project Setup

**Primary Tool: uv**
- Use `uv` for all package management, virtual environments, and project initialization
- Prefer `uv add` over pip install for dependency management
- Use `uv init` for new projects and `uv sync` for dependency installation
- Create pyproject.toml-based projects by default
- Leverage uv's speed and reliability for all Python environment operations

## Code Quality & Formatting

**Primary Tools: ruff + mypy**

### Ruff Configuration
- Use `ruff` for linting and formatting (replaces black, isort, flake8)
- Configure ruff in pyproject.toml with appropriate rules
- Standard ruff commands:
  - `uv run ruff format .` - Format code
  - `uv run ruff check .` - Lint code
  - `uv run ruff check . --fix` - Auto-fix linting issues

### Type Checking with mypy
- Use `mypy` for static type checking
- Ensure all code has comprehensive type hints
- Configure mypy for strict checking in pyproject.toml
- Standard command: `uv run mypy .`

## Testing & Coverage

**Primary Tools: pytest + coverage**

### Testing with pytest
- Use `pytest` as the primary testing framework
- Write tests using modern pytest features (fixtures, parametrize, etc.)
- Include unit, integration, and end-to-end tests as required
- Standard commands:
  - `uv run pytest` - Run all tests
  - `uv run pytest -v` - Verbose test output
  - `uv run pytest tests/unit/` - Run specific test directory

### Coverage Requirements
- Aim for 90%+ test coverage with `pytest-cov`
- Standard coverage commands:
  - `uv run pytest --cov=src` - Run tests with coverage
  - `uv run pytest --cov=src --cov-report=html` - Generate HTML coverage report
  - `uv run pytest --cov=src --cov-report=term-missing` - Show missing coverage

## Modern Python Features

**Target Python 3.11+ with Modern Patterns:**
- Structural pattern matching for complex control flow
- Union types with `|` syntax instead of `Optional[]`
- Enhanced error messages and debugging features
- Async/await patterns for I/O-bound operations
- Type hints using modern syntax (PEP 585, PEP 604)

## Code Organization Standards

**Style Guidelines:**
- Follow PEP 8 style guidelines religiously
- Use descriptive variable and function names
- Prefer composition over inheritance
- Implement proper error handling with custom exceptions
- Add comprehensive docstrings using Google or NumPy style

**Project Structure Template:**
```
project-name/
├── pyproject.toml
├── README.md
├── src/
│   └── project_name/
│       ├── __init__.py
│       └── main.py
├── tests/
│   ├── __init__.py
│   └── test_main.py
└── .gitignore
```

## Performance Optimization

**Best Practices:**
- Use generators and iterators for memory efficiency
- Profile code with `cProfile` or `py-spy` when optimization is needed
- Prefer built-in functions and standard library over third-party when possible
- Document performance assumptions and trade-offs in code comments
- Consider algorithmic complexity in data structure choices

## Type Safety Requirements

**Comprehensive Type Hints:**
- Add type hints to all function signatures, class attributes, and variables
- Use `typing` module features appropriately (Protocol, Generic, TypeVar)
- Configure mypy for strict checking with no untyped functions
- Use protocols and generics when appropriate for flexible, type-safe code
- Achieve 100% type annotation coverage

## Quality Standards Matrix

| Category | Tool | Requirement | Command |
|----------|------|-------------|---------|
| **Code Style** | ruff | Strict PEP 8 compliance | `uv run ruff format . && ruff check .` |
| **Type Coverage** | mypy | 100% type annotation | `uv run mypy .` |
| **Test Coverage** | pytest-cov | Minimum 90% line coverage | `uv run pytest --cov=src` |
| **Documentation** | Manual | Comprehensive docstrings | Code review |
| **Error Handling** | Manual | Explicit exception handling | Code review |

## Verification Requirements

**Mandatory Runtime Verification:**
- **Test the implementation** with real inputs before claiming completion
- **Save verification artifacts** to `.work/verification/` directory
- **Document verification evidence** in completion summaries
- **Never mark work complete** without providing runtime testing proof

**Verification Process:**
1. Run the complete quality pipeline (format, lint, type check, test)
2. Execute the implementation with real data or test mode
3. Verify functionality matches requirements
4. Save test output and artifacts for evidence
5. Include verification summary in completion report

**Example Verification Evidence:**
```
✅ Implementation complete and verified
- Quality: ruff format/check passed, mypy clean, 94% test coverage
- Runtime: uv run calendar-sync.py --morning --test
- Result: 4 events filtered correctly, platform detection working
- Config: YAML loading verified with real file
- Artifacts: .work/verification/calendar-sync-test.txt
```

## Integration with Quality Assurance

**Handoff Protocol:**
- Development agents implement functionality following these standards
- Quality assurance agents verify compliance using these same tools
- Consistent tooling ensures seamless verification workflow
- Evidence artifacts support assessment and review processes

---

**Usage**: Reference this context file in Python development and quality assurance agents to ensure consistent tooling, standards, and verification processes across all Python workflows.