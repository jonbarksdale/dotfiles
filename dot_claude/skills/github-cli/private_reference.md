# GitHub CLI Context for PR Review

## Core PR Content Retrieval

### PR Overview and Details
```bash
# Get PR summary, description, and basic info
gh pr view <number>

# Get PR in JSON format for programmatic access
gh pr view <number> --json title,body,state,author,url,commits,reviews

# View PR with all comments and discussions
gh pr view <number> --comments
```

### File Changes and Diffs
```bash
# View all file changes in the PR
gh pr diff <number>

# View diff for specific files only
gh pr diff <number> -- path/to/file.js

# Get list of changed files
gh pr view <number> --json files
```

### CI/CD and Check Status
```bash
# View all checks and their status
gh pr checks <number>

# View detailed check information
gh pr checks <number> --watch
```

## Comment and Review Analysis

### Reading Comments
```bash
# View all comments (includes inline and general comments)
gh pr view <number> --comments

# Get inline comments on specific lines via API
gh api repos/{owner}/{repo}/pulls/{number}/comments

# Get review comments and approval status
gh api repos/{owner}/{repo}/pulls/{number}/reviews
```

### Review Status
```bash
# Check review approvals and requested changes
gh pr view <number> --json reviewRequests,reviews

# Get review timeline
gh pr view <number> --json timelineItems
```

## Commit Analysis

### PR Commits
```bash
# List all commits in the PR
gh pr view <number> --json commits

# Get detailed commit information
gh api repos/{owner}/{repo}/pulls/{number}/commits

# View individual commit details
gh api repos/{owner}/{repo}/commits/{sha}
```

### Commit Messages and Changes
```bash
# View commit history with messages
git log --oneline main..pr-branch

# After checking out PR locally
gh pr checkout <number>
git log --oneline main..HEAD
```

## Context Gathering Patterns

### Related Issues and Discussions
```bash
# Find linked issues
gh pr view <number> --json body | grep -o "#[0-9]*"

# View specific issue mentioned in PR
gh issue view <issue-number>

# Search for related PRs or issues
gh search prs --repo owner/repo "keyword"
```

### Branch and Merge Information
```bash
# Check merge status and conflicts
gh pr view <number> --json mergeable,mergeStateStatus

# View base and head branch info
gh pr view <number> --json baseRefName,headRefName

# Check if PR is up to date with base
gh pr view <number> --json behind
```

### Repository Context
```bash
# Get repo information for context
gh repo view owner/repo

# Check recent activity
gh api repos/{owner}/{repo}/events

# View project or milestone info
gh pr view <number> --json projectCards,milestone
```

## Integration Notes

- **Commit Standards**: Reference commit-message skill when reviewing commit messages
- **File Analysis**: Combine with local file reading tools to understand code changes
- **Review Process**: Focus on understanding changes rather than making modifications

## Common Workflows

### Understanding a PR Before Review
1. `gh pr view <number>` - Get overview
2. `gh pr diff <number>` - See what changed
3. `gh pr view <number> --comments` - Read discussions
4. `gh pr checks <number>` - Verify CI status

### Deep Dive Analysis
1. `gh pr checkout <number>` - Check out locally
2. `gh pr view <number> --json commits` - Analyze commit structure
3. Review individual files with Read tool
4. Check related issues/context

### Monitoring PR Progress
1. `gh pr checks <number> --watch` - Monitor CI
2. `gh pr view <number> --json reviews` - Track review status
3. `gh pr view <number> --comments` - Follow discussions
