---
description: Create a new custom subagent for specialized tasks
argument-hint: [name] [description]
---

# Create Agent

Create new custom subagents for specialized tasks with proper configuration and system prompts.

---

## 1. 📋 INPUTS

### Required Inputs

**Agent Name**:
- **Format**: Lowercase, kebab-case
- **Example**: `code-reviewer`, `debugger`, `data-scientist`

**Description**:
- **Format**: Clear description of when to use this agent
- **Example**: "Expert code reviewer. Use proactively after code changes."

### Optional Inputs

**Location Flag**:
- **`--user`**: Create user-level agent in `~/.claude/agents/`
- **Default**: Project-level in `.claude/agents/`

**Tools List**:
- **`--tools`**: Comma-separated list of allowed tools
- **Example**: `--tools "Read,Grep,Glob,Bash"`
- **Default**: All tools available

**Model Selection**:
- **`--model`**: Model to use for this agent
- **Options**: `sonnet`, `opus`, `haiku`, `inherit`
- **Default**: `sonnet`

### User Arguments

```text
$ARGUMENTS
```

---

## 2. 🚀 WORKFLOW

### Step 1: Validate Inputs

**Purpose**: Ensure agent configuration is valid

**Actions**:
1. Check agent name format (lowercase, kebab-case only)
2. Verify description is non-empty and descriptive
3. If `--tools` specified, validate against available tools
4. If `--model` specified, validate it's one of: sonnet, opus, haiku, inherit

**Validation**: `inputs_validated`

### Step 2: Determine File Location

**Purpose**: Set correct path for agent file

**Logic**:
```
IF --user flag present:
  → ~/.claude/agents/{AGENT_NAME}.md
ELSE:
  → .claude/agents/{AGENT_NAME}.md
```

**Actions**:
- Create directory if it doesn't exist
- Set proper file permissions

**Validation**: `location_determined`

### Step 3: Check for Existing Agent

**Purpose**: Prevent overwriting existing agents

**Actions**:
1. Check if file exists at target path
2. If exists:
   - Output `STATUS=EXISTS PATH={path} AGENT={name}`
   - Recommend using `/agents` command to edit
   - Exit without changes

**Validation**: `existence_checked`

### Step 4: Generate Agent Content

**Purpose**: Create properly structured agent file

**Template Structure**:
```markdown
---
name: {AGENT_NAME}
description: {DESCRIPTION}
tools: {TOOLS}  # Optional - only if specified
model: {MODEL}  # Optional - only if specified
---

You are a specialized agent for {purpose based on description}.

When invoked:
1. Understand the specific task or problem
2. Analyze the relevant context
3. Execute your specialized function
4. Provide clear, actionable results

Key responsibilities:
- {Responsibility 1 based on description}
- {Responsibility 2 based on description}
- {Responsibility 3 based on description}

Best practices:
- Be focused and efficient
- Provide specific, actionable feedback
- Document your reasoning
- Follow established patterns and conventions

For each task:
- Explain your approach
- Show your work
- Highlight key findings or changes
- Suggest next steps if applicable
```

**Validation**: `content_generated`

### Step 5: Write Agent File

**Purpose**: Save agent to filesystem

**Actions**:
1. Write file with proper frontmatter
2. Ensure proper formatting and indentation
3. Set appropriate file permissions
4. Verify file was written successfully

**Validation**: `file_written`

### Step 6: Output Result

**Purpose**: Confirm creation and provide usage instructions

**Output Format**:
```
STATUS=CREATED PATH={path} AGENT={name}
```

**Usage Example**:
```
Use the {name} agent to...
```

**Validation**: `result_outputted`

---

## 3. 💡 EXAMPLES

### Example 1: Basic Project-Level Agent

```bash
/create-agent code-reviewer "Expert code review specialist. Use proactively after code changes."
```

**Output**:
```
STATUS=CREATED PATH=.claude/agents/code-reviewer.md AGENT=code-reviewer
Use the code-reviewer agent to review code changes and provide feedback.
```

### Example 2: User-Level Agent with Specific Tools

```bash
/create-agent debugger "Debugging specialist for errors and test failures" --user --tools "Read,Edit,Bash,Grep,Glob"
```

**Output**:
```
STATUS=CREATED PATH=~/.claude/agents/debugger.md AGENT=debugger
Use the debugger agent to investigate errors and test failures.
```

### Example 3: Agent with Specific Model

```bash
/create-agent data-scientist "Data analysis expert for SQL queries and insights" --tools "Bash,Read,Write" --model "sonnet"
```

**Output**:
```
STATUS=CREATED PATH=.claude/agents/data-scientist.md AGENT=data-scientist
Use the data-scientist agent to analyze data and generate insights.
```

---

## 4. 📖 RULES

### ALWAYS

- Validate agent name format (lowercase, kebab-case)
- Check for existing agents before creating
- Include proper YAML frontmatter
- Generate descriptive agent instructions
- Output clear status messages
- Provide usage examples

### NEVER

- Overwrite existing agent files
- Use invalid naming conventions
- Create agents without descriptions
- Skip validation steps
- Use network access

### ESCALATE IF

- Agent name format is invalid
- Description is unclear or too vague
- Tool names don't match available tools
- Model specification is invalid
- File permissions issues occur

---

## 5. 🎓 SUCCESS CRITERIA

**Agent is successfully created when**:
- ✅ Agent name follows naming conventions
- ✅ Description is clear and actionable
- ✅ File created at correct location
- ✅ YAML frontmatter is properly formatted
- ✅ Agent instructions are complete
- ✅ Status output is provided
- ✅ Usage example is given

**Quality Gates**:
- File is idempotent (won't overwrite existing)
- No network access required
- Tools list matches available tools (if specified)
- Model is valid alias or 'inherit' (if specified)

---

## 6. 🔗 INTEGRATION POINTS

### Related Commands

- **`/agents`**: Interactive interface for managing agents (recommended for editing)
- **Usage**: "Use the {name} agent to..."
- **Explicit invocation**: "Ask the {name} agent to investigate..."

### Best Practices

- Use descriptive, action-oriented descriptions
- Include "use PROACTIVELY" in description for automatic invocation
- Start with Claude-generated agents via `/agents` for complex cases
- Limit tools to only what the agent needs
- Design focused agents with single, clear responsibilities
- Add to version control for team collaboration

---

## 7. ⚠️ COMMON MISTAKES

**Invalid naming conventions**:
- **Problem**: Using spaces, uppercase, or underscores in agent name
- **Fix**: Use lowercase kebab-case only (e.g., `code-reviewer`)

**Vague descriptions**:
- **Problem**: "General helper agent"
- **Fix**: Be specific about when and how to use the agent

**Tool list errors**:
- **Problem**: Specifying non-existent tool names
- **Fix**: Use only valid Claude Code tool names

**Overwriting agents**:
- **Problem**: Trying to recreate existing agent
- **Fix**: Use `/agents` command to edit existing agents