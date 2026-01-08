---
name: confluence
description: Atlassian Confluence integration via MCP. Auto-triggers when working with Confluence wiki pages, documentation, or content management. Supports searching, reading, creating, updating pages, comments, and Jira linking.
context: fork
---

# Confluence Integration

Use Atlassian MCP tools for Confluence operations. This skill runs in a forked context to preserve the main conversation.

## Response Format

When returning results to the main conversation, provide:
1. Concise summary of findings (not raw page content)
2. Key metadata (title, space, last modified)
3. Relevant excerpts only (not full documents)
4. Action items or decisions if applicable

## Essential MCP Tools

| Operation | Tool | Use Case |
|-----------|------|----------|
| Search | `mcp__atlassian__searchConfluenceUsingCql` | Find pages by CQL query |
| Read | `mcp__atlassian__getConfluencePage` | Retrieve page content |
| List | `mcp__atlassian__getPagesInConfluenceSpace` | List pages in a space |
| Descendants | `mcp__atlassian__getConfluencePageDescendants` | Get child pages |
| Create | `mcp__atlassian__createConfluencePage` | Create new pages |
| Update | `mcp__atlassian__updateConfluencePage` | Modify existing pages |
| Comments | `mcp__atlassian__getConfluencePageFooterComments` | Read page comments |
| Add Comment | `mcp__atlassian__createConfluenceFooterComment` | Add footer comment |
| Jira | `mcp__atlassian__getJiraIssue` | Link related Jira issues |

## Quick CQL Patterns

```cql
# Find pages in a space
space = "TEAMSPACE" AND type = "page"

# Search by title pattern
title ~ "Architecture*" AND space = "DOCS"

# Recently modified
lastModified >= now("-7d") AND space = "TEAM"

# Pages with specific label
label = "adr" AND type = "page"

# Full-text search
text ~ "authentication flow" AND space = "PLATFORM"
```

## Workflow Guidance

1. **Search first**: Always search before creating to avoid duplicates
2. **Verify space access**: Check `mcp__atlassian__getConfluenceSpaces` for available spaces
3. **Check parent pages**: Use `mcp__atlassian__getConfluencePageDescendants` for hierarchy
4. **Atomic updates**: Make focused, single-purpose page updates
5. **Link context**: Connect Confluence docs to related Jira tickets

## Common Workflows

### Finding Documentation
1. Search with CQL: `mcp__atlassian__searchConfluenceUsingCql`
2. Get full page: `mcp__atlassian__getConfluencePage`
3. Summarize key points for main conversation

### Creating Documentation
1. Search for existing similar pages first
2. Identify parent page and space
3. Create with `mcp__atlassian__createConfluencePage`
4. Return confirmation with page URL

### Updating Pages
1. Fetch current content with `mcp__atlassian__getConfluencePage`
2. Note the version number for conflict prevention
3. Update with `mcp__atlassian__updateConfluencePage`

## Error Handling

If MCP tools return errors, inform the user with specific guidance:

| Error | User Message |
|-------|--------------|
| 401/403 Unauthorized | "Confluence authentication failed. Please run `/mcp` to reconnect the Atlassian service." |
| 404 Not Found | "Page or space not found. Please verify the ID/key is correct." |
| 409 Conflict | "Version conflict on update. I'll re-fetch the page and retry." |
| MCP unavailable | "Atlassian MCP is not connected. Please run `/mcp` to connect." |

Always surface authentication issues clearly so the user can resolve them.

See [reference.md](./reference.md) for complete CQL syntax and MCP tool documentation.
