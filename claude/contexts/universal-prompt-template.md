# Universal Prompt Template
 
This is the standard template for crafting all prompts when creating content or starting research. Use this structure for consistent, effective prompts.
 
## Template Structure
 
```markdown
# ROLE
You are a [specific role/expertise] trained to [primary capability].
 
# TASK
[Clear, specific instruction of what you want accomplished]
 
# CONTEXT
[Background information, constraints, or relevant details about the input/situation]

# ASSUMPTIONS (omit if none)
- [Key assumptions about input/context]
- [Domain knowledge presumed]
- [Environmental constraints]

# TOOLS/DEPENDENCIES (omit if none)
- Required: [essential tools/access needed]
- Optional: [helpful but not required tools]
- Constraints: [tool limitations to consider]
 
# OUTPUT FORMAT
Return:
- "[field1]": [description]
- "[field2]": [description]
- "[field3]": [description]
 
# CONSTRAINTS
- [Specific limitation 1]
- [Specific limitation 2]
- [Word/length limits if applicable]

# VERIFICATION
- [How to validate the output meets requirements]
- [Specific tests or checks to perform]
- [Success criteria definition]
```
 
## Example Usage
 
```markdown
# ROLE
You are a technical writing assistant trained to turn product requirement drafts into user documentation.
 
# TASK
Rewrite the input as a structured user guide. Highlight important steps, group related actions, and remove internal notes.
 
# CONTEXT
Input text may include engineering lingo, development constraints, or partial sentences.

# ASSUMPTIONS (omit if none)
- Target audience has basic technical literacy
 
# OUTPUT FORMAT
Return:
- "title": inferred title
- "steps": ordered list of instructions
- "warnings": optional list of any cautionary notes
 
# CONSTRAINTS
- Avoid using terms like "internal tool"
- Output must not exceed 500 words

# VERIFICATION
- Count total words to confirm under 500 word limit
- Scan output for "internal tool" or similar prohibited terms
- Check that each step has a clear action verb
```
 
## Key Principles
 
1. **ROLE**: Define the specific expertise/perspective needed
2. **TASK**: Be explicit about the desired outcome
3. **CONTEXT**: Provide relevant background for better results
4. **ASSUMPTIONS**: Document key assumptions (omit if none - prefer asking for clarification)
5. **TOOLS/DEPENDENCIES**: List required access or capabilities (omit if none)
6. **OUTPUT FORMAT**: Specify exactly how you want the response structured
7. **CONSTRAINTS**: Set clear boundaries and limitations
8. **VERIFICATION**: Define Claude-actionable validation steps (always required)
 
## Best Practices
 
- Keep each section focused and concise
- Use specific rather than vague language
- Include output format even for simple requests
- Add constraints to prevent unwanted behaviors
- Test prompts and refine based on results
 
---
 
**Usage**: Copy the template structure above and customize each section for your specific needs. This ensures consistent, high-quality prompt construction across all content creation and research tasks.
