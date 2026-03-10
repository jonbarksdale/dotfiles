# Confluence MCP Reference

Complete reference for Atlassian Confluence operations via MCP.

## MCP Tool Reference

### Search Operations

#### `mcp__atlassian__searchConfluenceUsingCql`
Search Confluence using CQL (Confluence Query Language).

**Parameters:**
- `cql` (required): CQL query string
- `limit`: Maximum results (default: 25)
- `start`: Pagination offset

**Example:**
```
mcp__atlassian__searchConfluenceUsingCql(cql: "space = 'DOCS' AND label = 'adr'")
```

### Page Operations

#### `mcp__atlassian__getConfluencePage`
Retrieve full page content by ID.

**Parameters:**
- `pageId` (required): Numeric page ID
- `expand`: Additional data (body.storage, version, space, ancestors)

**Example:**
```
mcp__atlassian__getConfluencePage(pageId: "123456789")
```

#### `mcp__atlassian__getPagesInConfluenceSpace`
List all pages in a space.

**Parameters:**
- `spaceKey` (required): Space key (e.g., "DOCS")
- `limit`: Maximum results
- `start`: Pagination offset

#### `mcp__atlassian__getConfluencePageDescendants`
Get child pages of a parent page.

**Parameters:**
- `pageId` (required): Parent page ID
- `depth`: How deep to traverse (default: 1)

#### `mcp__atlassian__createConfluencePage`
Create a new page.

**Parameters:**
- `spaceKey` (required): Target space
- `title` (required): Page title
- `body` (required): Page content (storage format or markdown)
- `parentId`: Parent page ID (optional)

**Example:**
```
mcp__atlassian__createConfluencePage(
  spaceKey: "DOCS",
  title: "API Design Guide",
  body: "# Overview\n\nThis guide covers...",
  parentId: "123456789"
)
```

#### `mcp__atlassian__updateConfluencePage`
Update an existing page.

**Parameters:**
- `pageId` (required): Page to update
- `title` (required): Page title
- `body` (required): Updated content
- `version` (required): Current version number (for conflict detection)

**Important:** Always fetch the current version first with `getConfluencePage` to avoid conflicts.

### Comment Operations

#### `mcp__atlassian__getConfluencePageFooterComments`
Get footer comments on a page.

**Parameters:**
- `pageId` (required): Page ID

#### `mcp__atlassian__getConfluencePageInlineComments`
Get inline comments within page content.

**Parameters:**
- `pageId` (required): Page ID

#### `mcp__atlassian__createConfluenceFooterComment`
Add a footer comment to a page.

**Parameters:**
- `pageId` (required): Page ID
- `body` (required): Comment content

#### `mcp__atlassian__createConfluenceInlineComment`
Add an inline comment to specific content.

**Parameters:**
- `pageId` (required): Page ID
- `body` (required): Comment content
- `inlineMarker`: Content selection info

### Space Operations

#### `mcp__atlassian__getConfluenceSpaces`
List available Confluence spaces.

**Parameters:**
- `limit`: Maximum results
- `type`: Filter by space type (global, personal)

### Jira Integration

#### `mcp__atlassian__getJiraIssue`
Get Jira issue details for cross-referencing.

**Parameters:**
- `issueKey` (required): Issue key (e.g., "PROJ-123")

#### `mcp__atlassian__searchJiraIssuesUsingJql`
Search Jira issues with JQL.

**Parameters:**
- `jql` (required): JQL query string

---

## CQL (Confluence Query Language) Reference

### Basic Syntax

```
field operator value [AND|OR field operator value]
```

### Fields

| Field | Description | Example |
|-------|-------------|---------|
| `space` | Space key | `space = "TEAM"` |
| `title` | Page title | `title ~ "Design*"` |
| `text` | Full-text search | `text ~ "authentication"` |
| `type` | Content type | `type = "page"` |
| `label` | Labels | `label = "approved"` |
| `creator` | Author username | `creator = "jsmith"` |
| `contributor` | Any contributor | `contributor = "jsmith"` |
| `lastModified` | Modification date | `lastModified >= now("-30d")` |
| `created` | Creation date | `created >= "2024-01-01"` |
| `ancestor` | Parent page ID | `ancestor = 123456` |
| `parent` | Direct parent ID | `parent = 123456` |
| `id` | Page ID | `id = 123456` |

### Operators

| Operator | Meaning | Example |
|----------|---------|---------|
| `=` | Exact match | `space = "DOCS"` |
| `!=` | Not equal | `type != "blogpost"` |
| `~` | Contains (text match) | `title ~ "API*"` |
| `!~` | Does not contain | `title !~ "Draft"` |
| `>` `>=` `<` `<=` | Comparisons | `lastModified >= now("-7d")` |
| `IN` | Multiple values | `space IN ("DOCS", "ARCH")` |
| `NOT IN` | Exclude values | `label NOT IN ("archived", "draft")` |
| `IS` | Null check | `parent IS NULL` |
| `IS NOT` | Not null check | `label IS NOT NULL` |

### Logical Operators

```cql
# AND - both conditions must match
space = "DOCS" AND label = "approved"

# OR - either condition matches
title ~ "API" OR title ~ "Integration"

# Grouping with parentheses
(label = "adr" OR label = "rfc") AND space = "ARCHITECTURE"
```

### Date Functions

| Function | Description | Example |
|----------|-------------|---------|
| `now()` | Current time | `lastModified >= now()` |
| `now("-7d")` | Relative days | `created >= now("-7d")` |
| `now("-1M")` | Relative months | `lastModified >= now("-1M")` |
| `now("-1y")` | Relative years | `created >= now("-1y")` |
| `startOfDay()` | Midnight today | `created >= startOfDay()` |
| `startOfWeek()` | Monday | `created >= startOfWeek()` |
| `startOfMonth()` | First of month | `created >= startOfMonth()` |
| `startOfYear()` | January 1st | `created >= startOfYear()` |
| `endOfDay()` | End of today | `created <= endOfDay()` |

### Ordering

```cql
# Order by last modified, newest first
space = "DOCS" ORDER BY lastModified DESC

# Order by title alphabetically
type = "page" ORDER BY title ASC
```

### Complex Query Examples

```cql
# ADRs modified in last week
space = "ARCHITECTURE" AND label = "adr" AND lastModified >= now("-7d")

# Pages by specific author in multiple spaces
creator = "jsmith" AND space IN ("TEAM1", "TEAM2") AND type = "page"

# Full-text search in specific space, sorted by recency
text ~ "microservice migration" AND space = "PLATFORM" ORDER BY lastModified DESC

# Orphaned pages (no parent) - root level pages only
parent IS NULL AND space = "DOCS" AND type = "page"

# Pages with approved label, excluding archived
label = "approved" AND label != "archived"

# Recently created by current user
creator = currentUser() AND created >= now("-30d")

# Pages under a specific parent hierarchy
ancestor = 123456789 AND type = "page"
```

---

## Content Formatting

### Storage Format

Confluence uses XHTML-based storage format internally:

```xml
<p>Paragraph text with <strong>bold</strong> and <em>italic</em></p>

<h1>Heading 1</h1>
<h2>Heading 2</h2>

<ul>
  <li>List item</li>
</ul>

<ac:structured-macro ac:name="code">
  <ac:parameter ac:name="language">python</ac:parameter>
  <ac:plain-text-body><![CDATA[
def hello():
    print("Hello, World!")
  ]]></ac:plain-text-body>
</ac:structured-macro>
```

### Markdown Support

Many MCP implementations accept markdown input and convert automatically. Test with simple content first.

### Jira Macro

To embed Jira issue links in Confluence:

```xml
<ac:structured-macro ac:name="jira">
  <ac:parameter ac:name="key">PROJ-123</ac:parameter>
</ac:structured-macro>
```

---

## Error Handling

### Common Errors

| HTTP Code | Error | Cause | Resolution |
|-----------|-------|-------|------------|
| 401 | Unauthorized | Invalid or expired credentials | Re-authenticate MCP connection |
| 403 | Forbidden | Insufficient permissions | Check space/page permissions |
| 404 | Not Found | Page or space doesn't exist | Verify ID/key is correct |
| 409 | Conflict | Version mismatch on update | Re-fetch page, merge changes |
| 429 | Rate Limited | Too many requests | Add delays between calls |

### Authentication Issues

If MCP tools return authentication errors:
1. Run `/mcp` to check connection status
2. Reconnect the Atlassian MCP service if disconnected
3. Verify API token permissions in Atlassian settings

### Version Conflicts

When updating pages:
1. Always fetch current version first: `getConfluencePage`
2. Extract version number from response
3. Pass version to `updateConfluencePage`
4. If conflict occurs, re-fetch and retry

---

## Best Practices

### Search Before Create
Always search for existing content before creating new pages to avoid duplicates:
```cql
title ~ "Your Proposed Title" AND space = "TARGET_SPACE"
```

### Version Management
- Fetch current version before updates
- Include meaningful version comments
- Handle 409 conflicts gracefully

### Atomic Updates
- Make focused, single-purpose changes
- Don't combine unrelated edits in one update
- Document what changed in version comment

### Label Consistently
- Use standard labels for discoverability
- Common patterns: `adr`, `rfc`, `approved`, `draft`, `deprecated`
- Search by label to find related content

### Link Context
- Connect Confluence docs to Jira issues
- Use the Jira macro for issue references
- Cross-link related Confluence pages

### Space Organization
- Understand space hierarchy before creating pages
- Use parent pages to organize content
- Check space permissions before operations
