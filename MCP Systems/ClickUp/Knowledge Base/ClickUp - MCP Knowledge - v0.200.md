# ClickUp - MCP Knowledge - v0.200

Technical reference for ClickUp MCP server capabilities and integration for task management, project tracking, and agile workflow operations.

**Purpose:** Document ClickUp-specific features, supported operations, API specifications, and technical constraints. Conversation flows and thinking methodology are in Interactive Intelligence v0.200 and SYNC Thinking Framework v0.200 respectively.

---

## 📋 TABLE OF CONTENTS

1. [🔌 SERVER OVERVIEW](#1-server-overview)
2. [🛠️ CORE CAPABILITIES](#2-core-capabilities)
3. [📊 FORMAT SUPPORT](#3-format-support)
4. [✅ TASK & PROJECT OPERATIONS](#4-task-project-operations)
5. [📊 WORKSPACE & HIERARCHY OPERATIONS](#5-workspace-hierarchy-operations)
6. [⏱️ TIME TRACKING & COLLABORATION](#6-time-tracking-collaboration)
7. [⚠️ LIMITATIONS](#7-limitations)
8. [🏎️ QUICK REFERENCE](#8-quick-reference)

---

<a id="1-server-overview"></a>

## 1. 🔌 SERVER OVERVIEW

### MCP Server Details

The ClickUp MCP Server (`@clickup/mcp-server-clickup`) provides native Model Context Protocol integration for task management and project tracking operations. It enables agile workflows, sprint management, time tracking, and collaboration features directly through MCP.

**Key Information:**
- **Repository:** https://github.com/clickup/mcp-server-clickup
- **NPM Package:** `@clickup/mcp-server-clickup`
- **Protocol:** Model Context Protocol (MCP)
- **Authentication:** API Key (environment variable)
- **APIs:** Task, Hierarchy, Time Tracking, Collaboration (native)

**Important:** This server executes **ZERO custom code**. All operations use native ClickUp MCP operations exclusively. Custom scripts or external integrations are not applicable (N/A). The server provides direct MCP access to ClickUp workspace features.

### System Architecture

The ClickUp MCP workflow follows a strict sequence to ensure proper connectivity and API access:

**Operation Sequence:**
1. **Connection Check** (ALWAYS FIRST) - Verify MCP server is active
2. **User Request** - Receive and parse user intent
3. **Intent Recognition** - Determine operation type needed
4. **Operation Selection** - Choose between Hierarchy/Task/Tracking operations
5. **Native MCP Call** - Execute using official ClickUp MCP (NO custom code)
6. **Feedback & Confirmation** - Return results to user

**Deployment Architecture:**

*NPM Deployment (Standard):*
- Direct API key management in environment
- Configuration via Claude Desktop config file
- Workspace-level access with API key permissions
- Uses stdio transport (default MCP connection)

**MCP Routing:**
- **Hierarchy Operations:** Requires API key with workspace access (folders, lists, spaces)
- **Task Operations:** Requires API key with task management permissions (CRUD on tasks)
- **Time Tracking:** Requires API key with time tracking scope (timers, entries, reports)
- **Collaboration:** Requires API key with collaboration access (comments, tags, assignments)

### Core Principle

**ABSOLUTE RULE:** Only native ClickUp MCP operations are allowed. Custom scripts, external integrations, or non-MCP workflows are not applicable.

**✅ Allowed Operations:**
- Native ClickUp MCP operations exclusively
- `create_task()` - Task creation
- `create_bulk_tasks()` - Bulk task operations
- `start_time_tracking()` - Time tracking
- All official ClickUp MCP operations

**❌ Forbidden Operations:**
- Custom script generation (N/A)
- External integration setup (N/A)
- Non-MCP workflows (N/A)
- Any operations outside MCP scope

This policy has **ABSOLUTE enforcement with no exceptions**.

### Connection Verification

**Reference:** Connection verification logic is in Interactive Intelligence v0.200. SYNC methodology phases in SYNC Thinking Framework v0.200.

Connection verification must be the **first action before all operations** (ALWAYS FIRST). Use the `get_workspace_hierarchy` operation to test connectivity and authentication.

Connection verification must be the **first action before all operations** (ALWAYS FIRST). Use the `get_workspace_hierarchy` operation to test connectivity and authentication.

**Status Messages:**
- ✅ **Connected:** "ClickUp MCP Connected - All operations available"
- ❌ **Disconnected:** "ClickUp MCP Not Connected - Setup required"
- ⚠️ **Auth Failed:** "Authentication Issue - API key invalid or expired"
- ⚠️ **Access Denied:** "Permission Issue - Insufficient workspace access"

**Connection Protocol:**
1. Check MCP server status
2. Run test query (`get_workspace_hierarchy`)
3. Verify API key authentication
4. Check workspace access permissions
5. Proceed with operations only if all checks pass

**Example Implementation:**
```javascript
async function verifyConnection() {
    try {
        await clickup:get_workspace_hierarchy();
        return { 
            connected: true, 
            operations: 'ready'
        };
    } catch (error) {
        // Apply REPAIR protocol
        return { connected: false, error: error };
    }
}
```

**Connection States & Actions:**
- **Connected:** All systems operational → Proceed with operations
- **Disconnected:** No MCP access → Restart Claude Desktop / Check config
- **Auth Failed:** API key issue → Regenerate API key in ClickUp settings
- **Access Denied:** Permission issue → Verify workspace access rights

### Installation & Setup

The ClickUp MCP server can be installed globally via npm and requires an API key from your ClickUp account.

**Installation Commands:**
```bash
# Global installation (recommended)
npm install -g @clickup/mcp-server-clickup

# Or local project installation
npm install @clickup/mcp-server-clickup
```

**Configuration Steps:**

1. **Generate API Key:**
   - Open ClickUp Settings
   - Navigate to Apps section
   - Generate new API Token
   - Copy the token for configuration

2. **Configure Claude Desktop:**
   - Locate config file:
     - **macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`
     - **Windows:** `%APPDATA%\Claude\claude_desktop_config.json`
   
   - Add server configuration:
   ```json
   {
     "mcpServers": {
       "clickup": {
         "command": "clickup-mcp-server",
         "env": {
           "CLICKUP_API_KEY": "YOUR_API_KEY_HERE"
         }
       }
     }
   }
   ```

3. **Post-Installation Verification:**
   - Restart Claude Desktop application
   - Run `get_workspace_hierarchy` to verify connection
   - Test with a simple task creation to confirm full functionality

---

<a id="2-core-capabilities"></a>

## 2. 🛠️ CORE CAPABILITIES

### Available Operations

**Note:** SYNC thinking methodology (Survey → Yield → Navigate → Create) and conversation flows are defined in SYNC Thinking Framework v0.200 and Interactive Intelligence v0.200.

```yaml
task_operations:
  task_management:
    tools:
      - create_task
      - update_task
      - create_bulk_tasks
      - get_workspace_tasks
    method: "Native MCP only"
    requires: "API key"
  
hierarchy_operations:
  workspace_structure:
    tools:
      - create_list
      - create_folder
      - create_list_in_folder
      - update_list
      - delete_list
      - get_workspace_hierarchy
    method: "Native MCP only"
    requires: "API key"
  
time_tracking_operations:
  tracking_management:
    tools:
      - start_time_tracking
      - stop_time_tracking
      - add_time_entry
      - get_task_time_entries
      - get_current_time_entry
    method: "Native MCP only"
    requires: "API key"
  
collaboration_operations:
  team_features:
    tools:
      - create_task_comment
      - get_task_comments
      - attach_task_file
      - add_tag_to_task
      - remove_tag_from_task
      - get_space_tags
    method: "Native MCP only"
    requires: "API key"
  
document_operations:
  document_management:
    tools:
      - create_document
      - create_document_page
      - update_document_page
      - list_documents
    method: "Native MCP only"
    requires: "API key"
```

### What You CAN Do ✅

**Task Operations (Native MCP Only):**

Task management operations using native ClickUp MCP:
- Create individual tasks with full configuration
- Update existing task properties
- Create multiple tasks efficiently via bulk operations
- Search and filter tasks across workspace
- Manage priorities, statuses, and assignments
- Configure custom fields at list level

**Hierarchy Operations (Native MCP Only):**

Workspace organizational operations using native MCP:
- Create folders for project grouping
- Create lists within spaces or folders
- Build hierarchical structures (Space → Folder → List)
- Manage list configurations and settings
- Retrieve complete workspace structure
- Update and delete organizational elements

**Time Tracking Operations (Native MCP Only):**

Time management operations using native MCP:
- Start/stop timers on specific tasks
- Add manual time entries retroactively
- Retrieve time logs for tasks and reporting
- Track billable hours and descriptions
- Monitor currently running timers
- Generate time-based analytics

**Collaboration Operations (Native MCP Only):**

Team collaboration operations using native MCP:
- Add comments to tasks for discussions
- Attach files via URL or base64 encoding
- Manage tags for categorization
- Assign tasks to team members
- Retrieve space-level tag collections
- Handle team communication workflows

**IMPORTANT:** All operations use native MCP operations only. Custom scripts are **NOT applicable** (N/A).

### What You CANNOT Do ❌

**Custom Script Restriction (NOT APPLICABLE):**
- ❌ Custom automation scripts (N/A)
- ❌ External integration setup (N/A)
- ❌ Non-MCP workflows (N/A)
- **Enforcement:** MCP operations only

**File Upload Limitation:**
- Direct upload supported via base64 (10MB limit)
- **Alternative:** Use external URLs for larger files
- Recommended services: Cloudinary, Amazon S3, Imgur

**Connection Requirements:**
- Cannot work without MCP connection verification
- Connection check must ALWAYS be performed first (ALWAYS FIRST)
- All operations require active MCP session

**API Key Requirement:**
- Valid ClickUp API key required
- Workspace access permissions needed
- Test query must pass before operations

**Rate Limits:**
- Respect ClickUp API rate limits
- Optimize bulk operations for efficiency
- Use batch processing for large operations

**Access Control:**
- Only accessible workspaces/spaces available
- Cannot modify locked or archived items
- Respects ClickUp's permission system

---

<a id="3-format-support"></a>

## 3. 📋 FORMAT SUPPORT

### Custom Field Types

ClickUp supports multiple custom field types that can be attached to tasks. Each field type has a specific value format and use case.

**Drop Down (Single Selection)**
- Type: Single selection dropdown
- Value Format: option_id (UUID)
- Example: `{ id: 'field_id', value: 'option_uuid' }`

**Short Text**
- Type: Text input (single line)
- Value Format: String (max 255 characters)
- Example: `{ id: 'field_id', value: 'Feature description' }`

**Number**
- Type: Numeric value
- Value Format: Number
- Example: `{ id: 'field_id', value: 42 }`

**Checkbox**
- Type: Boolean toggle
- Value Format: Boolean
- Example: `{ id: 'field_id', value: true }`

**Date**
- Type: Date/timestamp
- Value Format: Unix timestamp (milliseconds)
- Example: `{ id: 'field_id', value: 1234567890000 }`

**User**
- Type: User assignment
- Value Format: user_id (number)
- Example: `{ id: 'field_id', value: 'user_id' }`

**URL**
- Type: Web link
- Value Format: Valid URL string
- Example: `{ id: 'field_id', value: 'https://example.com' }`

**Usage Notes:**
- Custom fields are configured at the list level
- All tasks in a list inherit the same custom field definitions
- The `field_id` must exist in the list before use
- Batch operations fully support custom fields

### Priority & Status Values

**Priority Levels:**
- `1` = Urgent (highest priority)
- `2` = High
- `3` = Normal (default)
- `4` = Low

**Status Values:**
- Type: String (case-sensitive)
- Scope: List-specific (each list has its own statuses)
- Common values: "open", "in progress", "review", "blocked", "done", "closed"
- Note: Exact status names vary by list configuration

**Assignee Format:**
- Type: Array of user IDs
- User ID Type: Number or string
- Multiple Allowed: Yes
- Example: `[183, 456, 789]`

### Date & Time Formats

**Due Dates:**
- Format: Natural language or ISO 8601
- Examples:
  - "tomorrow"
  - "next Friday"
  - "2025-01-15"
  - "2025-01-15T14:30:00Z"

**Time Entries:**
- Start Format: Natural language or Unix timestamp
- Duration Format: 'Xh Ym' or 'Xm'
- Examples:
  - Start: "9am today", Duration: "2h 30m"
  - Start: "1234567890000", Duration: "150m"

**Timestamps:**
- Type: Unix timestamp (milliseconds)
- Timezone: UTC or user timezone

### File Attachments

ClickUp supports two methods for attaching files to tasks:

**URL Upload:**
- Parameter: `file_url`
- Format: Valid HTTP/HTTPS URL
- Auth Support: Optional `auth_header` for protected URLs

**Base64 Upload:**
- Parameter: `file_data`
- Format: Base64 encoded string
- Required Additional: `file_name` parameter
- Size Limit: 10MB

**Supported File Types:**
- Images: JPEG, PNG, GIF, WebP
- Documents: PDF, DOCX, XLSX, PPTX
- Archives: ZIP, RAR
- Code files: All text formats

**Upload Constraints:**
- Max size (base64): 10MB
- Max size (URL): Depends on ClickUp plan
- Concurrent uploads: Use batch operations for efficiency

---

<a id="4-task-project-operations"></a>

## 4. ✅ TASK & PROJECT OPERATIONS

### Create Task

```yaml
operation: "create_task"
purpose: "Create a single task with full configuration"

required_parameters:
  name: "Task title"
  list_id_or_name:
    - "listId: string (UUID)"
    - "listName: string (with optional spaceName)"

optional_parameters:
  description: "Task description (Markdown supported)"
  assignees: "Array of user IDs [183, 456]"
  priority: "1-4 (1=urgent, 4=low)"
  due_date: "Natural language or timestamp"
  status: "List-specific status string"
  tags: "Array of tag names ['urgent', 'bug']"
  custom_fields: "Array of field objects"
  
custom_field_structure:
  - id: "field_id (required)"
    value: "Type-specific value"

examples:
  basic_task:
    name: "Implement login feature"
    listId: "abc123xyz"
    priority: 2
    
  full_task:
    name: "Fix authentication bug"
    listName: "Sprint 14"
    spaceName: "Engineering"
    description: "Users unable to login with 2FA"
    assignees: [183]
    priority: 1
    due_date: "tomorrow 5pm"
    tags: ["bug", "security"]
    custom_fields:
      - id: "story_points_field"
        value: 5
      - id: "sprint_field"
        value: "sprint_14_uuid"
```

### Update Task

```yaml
operation: "update_task"
purpose: "Modify existing task properties"

task_identification:
  method_1: "taskId: string (UUID or custom like 'DEV-123')"
  method_2: "taskName + listName combination"

updatable_fields:
  name: "New task title"
  description: "Updated description"
  status: "New status value"
  priority: "New priority (1-4)"
  due_date: "Updated due date"
  assignees: "New assignee array"
  custom_fields: "Updated custom fields"

update_behavior:
  - "Only specified fields are updated"
  - "Omitted fields remain unchanged"
  - "assignees array replaces (not appends)"
  - "custom_fields updates specified fields only"

example:
  taskId: "task_abc123"
  status: "in progress"
  assignees: [183, 456]
  custom_fields:
    - id: "progress_field"
      value: 50
```

### Bulk Task Creation

```yaml
operation: "create_bulk_tasks"
purpose: "Create multiple tasks efficiently"

required_parameters:
  list_identifier:
    - "listId: string"
    - "listName: string"
  tasks: "Array of task objects"

task_object_structure:
  name: "Task title (required)"
  description: "Task description"
  assignees: "User ID array"
  priority: "1-4"
  due_date: "Date string"
  custom_fields: "Custom field array"

batch_options:
  batch_size: "Tasks per batch (default: 10)"
  concurrency: "Parallel operations (default: 3)"
  continue_on_error: "Continue if one fails (default: true)"

performance_considerations:
  recommended_batch_size: 10
  max_concurrent: 5
  rate_limit_aware: true
  
example:
  listId: "list_xyz789"
  tasks:
    - name: "Task 1"
      priority: 1
      assignees: [183]
    - name: "Task 2"
      priority: 2
      due_date: "next Friday"
    - name: "Task 3"
      custom_fields:
        - id: "field_123"
          value: "value_abc"
  options:
    batch_size: 10
    concurrency: 3
    continue_on_error: true
```

### Task Search & Filtering

```yaml
operation: "get_workspace_tasks"
purpose: "Search and filter tasks across workspace"

filter_parameters:
  tags: "Filter by tag names ['urgent', 'bug']"
  list_ids: "Specific lists ['list1', 'list2']"
  statuses: "Status filter ['open', 'in progress']"
  assignees: "Assigned to users ['user_id']"
  due_date_gt: "Due after timestamp"
  due_date_lt: "Due before timestamp"
  include_closed: "Include completed tasks (boolean)"
  subtasks: "Include subtasks (boolean)"
  
pagination:
  page: "Page number (0-based)"
  order_by: "Sort field ('due_date', 'created', etc.)"

response_structure:
  tasks: "Array of task objects"
  total: "Total matching tasks"
  page_info: "Pagination metadata"

example_search:
  tags: ["urgent"]
  statuses: ["open", "in progress"]
  assignees: ["user_183"]
  due_date_lt: 1735689600000
  include_closed: false
  page: 0
  order_by: "due_date"
```

---

<a id="5-workspace-hierarchy-operations"></a>

## 5. 📊 WORKSPACE & HIERARCHY OPERATIONS

### Workspace Hierarchy

```yaml
operation: "get_workspace_hierarchy"
purpose: "Retrieve complete workspace structure"
parameters: "None (returns all)"

structure_returned:
  spaces:
    - id: "space_id"
      name: "Space name"
      folders:
        - id: "folder_id"
          name: "Folder name"
          lists:
            - id: "list_id"
              name: "List name"
              task_count: "Number of tasks"
      lists:
        - "Folderless lists in space"

use_cases:
  - "Navigation and discovery"
  - "Validating IDs before operations"
  - "Building UI representations"
  - "Workspace auditing"

caching_recommendation:
  - "Cache hierarchy for session"
  - "Refresh on structure changes"
  - "Use for ID resolution"
```

### Create List

```yaml
operation: "create_list"
purpose: "Create new list in space"

required_parameters:
  name: "List name"
  space_identifier:
    - "spaceId: string"
    - "spaceName: string"

optional_parameters:
  content: "List description"
  status: "Default status for tasks"
  priority: "Default priority for tasks"
  assignee: "Default assignee (user ID)"

list_configuration:
  - "Inherits space settings"
  - "Can override statuses"
  - "Custom fields added separately"

example:
  name: "Sprint 15 Backlog"
  spaceName: "Engineering"
  content: "User stories for Sprint 15"
  status: "backlog"
  priority: 3
```

### Create Folder

```yaml
operation: "create_folder"
purpose: "Organize lists within space"

required_parameters:
  name: "Folder name"
  space_identifier:
    - "spaceId: string"
    - "spaceName: string"

optional_parameters:
  override_statuses: "Use custom statuses (boolean)"

folder_behavior:
  - "Contains multiple lists"
  - "Provides organizational hierarchy"
  - "Can have custom status workflow"

example:
  name: "Q1 2025 Projects"
  spaceName: "Marketing"
  override_statuses: true
```

### Create List in Folder

```yaml
operation: "create_list_in_folder"
purpose: "Add list to existing folder"

required_parameters:
  name: "List name"
  folder_identifier:
    method_1: "folderId: string"
    method_2: "folderName + spaceName/spaceId"

optional_parameters:
  content: "List description"
  status: "Default task status"

hierarchy_note: "Lists inherit folder/space configuration"

example:
  name: "Content Calendar"
  folderName: "Q1 2025 Projects"
  spaceName: "Marketing"
  content: "Blog and social media schedule"
```

### List Management Operations

```yaml
update_list:
  operation: "update_list"
  parameters:
    list_identifier:
      - "listId: string"
      - "listName: string"
    name: "New list name"
    content: "New description"
    status: "New default status"

delete_list:
  operation: "delete_list"
  warning: "PERMANENT - Cannot be undone"
  parameters:
    list_identifier:
      - "listId: string"
      - "listName: string"
  confirmation_required: true
  
list_deletion_impact:
  - "All tasks moved to trash"
  - "Custom fields configuration lost"
  - "Time entries preserved in history"
  - "Cannot be recovered"
```

### Tag Management

```yaml
get_space_tags:
  operation: "get_space_tags"
  purpose: "List available tags in space"
  parameters:
    space_identifier:
      - "spaceId: string"
      - "spaceName: string"
  returns: "Array of tag objects with names and IDs"

add_tag_to_task:
  operation: "add_tag_to_task"
  parameters:
    task_identifier:
      - "taskId: string"
      - "taskName: string (with listName)"
    tag_name: "Exact tag name (must exist)"
  note: "Tag must exist in space first"

remove_tag_from_task:
  operation: "remove_tag_from_task"
  parameters:
    taskId: "Task identifier"
    tagName: "Tag to remove"

tag_usage_best_practices:
  - "Create tags at space level first"
  - "Use consistent naming conventions"
  - "Tags visible across all lists in space"
  - "Case-sensitive matching"
```

---

<a id="6-time-tracking-collaboration"></a>

## 6. ⏱️ TIME TRACKING & COLLABORATION

### Start Time Tracking

```yaml
operation: "start_time_tracking"
purpose: "Begin timer on task"
constraint: "Only one active timer per user"

required_parameters:
  task_identifier:
    - "taskId: string"
    - "taskName: string (with optional listName)"

optional_parameters:
  description: "What you're working on"
  billable: "Mark as billable time (boolean)"
  tags: "Array of time entry tags"

timer_behavior:
  - "Automatically stops previous timer"
  - "Tracks until manually stopped"
  - "Visible in time tracking reports"

example:
  taskId: "task_abc123"
  description: "Implementing authentication logic"
  billable: true
  tags: ["development", "backend"]
```

### Stop Time Tracking

```yaml
operation: "stop_time_tracking"
purpose: "Stop currently running timer"

optional_parameters:
  description: "Update entry description"
  tags: "Update or add tags"

response:
  - "Completed time entry object"
  - "Duration calculated automatically"
  - "Start and end timestamps included"

automatic_calculation:
  duration: "End time - Start time"
  rounding: "Based on workspace settings"
```

### Manual Time Entry

```yaml
operation: "add_time_entry"
purpose: "Add time entry without timer"

required_parameters:
  task_identifier:
    - "taskId: string"
    - "taskName: string"
  start: "Start time (natural language or timestamp)"
  duration: "Time duration"

duration_formats:
  format_1: "'Xh Ym' (e.g., '2h 30m')"
  format_2: "'Xm' (e.g., '150m')"

optional_parameters:
  description: "Work description"
  billable: "Billable flag (boolean)"
  tags: "Time entry tags array"

use_cases:
  - "Retroactive time logging"
  - "Bulk time entry import"
  - "Offline work tracking"

example:
  taskId: "task_xyz789"
  start: "yesterday 2pm"
  duration: "3h 45m"
  description: "Code review and testing"
  billable: true
```

### Time Entry Retrieval

```yaml
get_task_time_entries:
  operation: "get_task_time_entries"
  purpose: "Retrieve all time entries for task"
  parameters:
    task_identifier:
      - "taskId: string"
      - "taskName: string"
    start_date: "Filter from date"
    end_date: "Filter to date"
  returns: "Array of time entry objects"

get_current_time_entry:
  operation: "get_current_time_entry"
  purpose: "Get currently running timer"
  parameters: "None"
  returns: "Active time entry or null"

time_entry_object:
  id: "Entry ID"
  task: "Task object"
  user: "User object"
  start: "Start timestamp"
  end: "End timestamp (null if running)"
  duration: "Duration in milliseconds"
  description: "Entry description"
  billable: "Billable flag"
  tags: "Array of tag names"
```

### Document Operations

```yaml
create_document:
  operation: "create_document"
  purpose: "Create document in workspace"
  required:
    name: "Document name"
    parent:
      id: "Parent container ID"
      type: "Container type (4=space, 5=folder, 6=list)"
  optional:
    visibility: "'PUBLIC' or 'PRIVATE'"
    create_page: "Create initial page (boolean)"

create_document_page:
  operation: "create_document_page"
  purpose: "Add page to document"
  required:
    document_id: "Document ID"
    name: "Page title"
  optional:
    content: "Page content (Markdown)"
    parent_page_id: "Parent page for sub-pages"
    sub_title: "Page subtitle"

update_document_page:
  operation: "update_document_page"
  purpose: "Update page content"
  parameters:
    document_id: "Document ID"
    page_id: "Page ID"
    name: "New title"
    content: "New content"
    content_edit_mode: "'replace' | 'append' | 'prepend'"
    content_format: "'text/md' | 'text/plain'"

list_documents:
  operation: "list_documents"
  purpose: "List documents in container"
  parameters:
    parent_id: "Container ID"
    parent_type: "'SPACE' | 'FOLDER' | 'LIST'"
    archived: "Include archived (boolean)"
    deleted: "Include deleted (boolean)"
    limit: "Max results (number)"
```

### Comments & Attachments

```yaml
create_task_comment:
  operation: "create_task_comment"
  purpose: "Add comment to task"
  required:
    task_identifier:
      - "taskId: string"
      - "taskName: string (with listName)"
    comment_text: "Comment content"
  optional:
    notify_all: "Notify assignees (boolean)"
    assignee: "Assign comment to user (user ID)"

get_task_comments:
  operation: "get_task_comments"
  purpose: "Retrieve task comments"
  parameters:
    task_identifier:
      - "taskId: string"
      - "taskName: string"
    start: "Timestamp for pagination"
    start_id: "Comment ID for pagination"

attach_task_file:
  operation: "attach_task_file"
  purpose: "Upload file to task"
  required:
    task_identifier:
      - "taskId: string"
      - "taskName: string"
  file_methods:
    url_upload:
      file_url: "File URL"
      auth_header: "Optional authentication"
    data_upload:
      file_data: "Base64 encoded data"
      file_name: "Required filename"
  size_limit: "10MB for base64"
```

---

<a id="7-limitations"></a>

## 7. ⚠️ LIMITATIONS

### Critical Limitations

```yaml
custom_script_generation:
  restriction: "NOT APPLICABLE"
  note: "MCP operations only - no custom scripts"
  
  native_alternatives:
    task_operations: "Native MCP task management"
    hierarchy_operations: "Native MCP workspace structure"
    time_tracking: "Native MCP timers and entries"
    collaboration: "Native MCP comments and tags"
  
  custom_code_generated: "N/A (MCP operations only)"

file_handling:
  direct_upload:
    supported: true
    method: "Base64 encoding"
    size_limit: "10MB"
  
  url_upload:
    supported: true
    method: "External URL reference"
    size_limit: "Depends on ClickUp plan"
  
  recommended_services:
    cloudinary:
      free_tier: "25GB"
      api: true
      best_for: "General use"
    
    amazon_s3:
      free_tier: "5GB"
      api: true
      best_for: "Scale operations"
    
    imgur:
      free_tier: "Unlimited"
      api: true
      best_for: "Quick hosting"

connection_requirements:
  dependencies:
    - "MCP server must be connected"
    - "API key must be valid"
    - "Test query must pass (get_workspace_hierarchy)"
    - "Workspace access permissions required"
  
  enforcement: "Cannot proceed without these (ALWAYS FIRST)"

rate_limiting:
  limits:
    api_calls: "100 per minute (typical)"
    bulk_operations: "10 tasks per batch (recommended)"
    concurrent_operations: "3 parallel (recommended)"
  
  enforcement: "Automatic throttling and retry with exponential backoff"

access_requirements:
  connection:
    requirement: "Must verify first (ALWAYS FIRST)"
    protocol: "Connection check before all operations"
  
  authentication:
    type: "API Key"
    method: "Environment variable CLICKUP_API_KEY"
    scope: "Workspace-level permissions"
  
  permissions:
    requirement: "Workspace member or admin access"
    scope: "Space, folder, and list access"
  
  custom_scripts:
    allowed: "N/A (MCP operations only)"
    enforcement: "MCP operations exclusively"

custom_field_limitations:
  problem: "Cannot create custom fields via MCP"
  solution: "Create in ClickUp UI first, then reference by ID"
  
  workaround_steps:
    - "Open ClickUp list settings"
    - "Add custom field via UI"
    - "Note the field ID"
    - "Reference field ID in MCP operations"

task_id_formats:
  uuid_support: "Standard ClickUp UUIDs fully supported"
  custom_id_support: "Custom task IDs (e.g., 'DEV-123') require workspace setup"
  limitation: "Custom ID format must be configured in ClickUp first"

deletion_operations:
  list_deletion:
    permanent: true
    no_undo: true
    impact: "All tasks moved to trash"
    recommendation: "Archive instead of delete when possible"
```
    parent_required: true
    parent_types: "Space, Folder, or List only"
  
  content_format:
    supported: "Markdown and plain text"
    rich_formatting: "Limited to Markdown syntax"
```

### Search & Filtering

```yaml
workspace_search:
  scope: "Current workspace only"
  cross_workspace: false
  
  filter_combinations:
    supported: true
    logical_operator: "AND (all filters must match)"
    
  pagination:
    required_for: "Large result sets"
    page_size: "Configurable"
    max_results: "Depends on ClickUp plan"

tag_operations:
  tag_creation: "Not supported via MCP"
  tag_usage: "Must exist in space first"
  tag_matching: "Case-sensitive"
  
status_filtering:
  list_specific: true
  custom_statuses: "Exact name matching required"
  default_statuses: "May vary by list"
```

### Performance Considerations

```yaml
bulk_operations:
  recommended_usage: "10-50 tasks"
  batch_size_limit: "System dependent"
  concurrent_operations: "Max 3-5 recommended"
  
  performance_by_size:
    small: "< 10 items: 2-5s"
    medium: "10-50 items: 5-15s"
    large: "> 50 items: 15-30s"

hierarchy_operations:
  get_workspace_hierarchy:
    small_workspace: "1-2s"
    medium_workspace: "2-3s"
    large_workspace: "3-5s"
  recommendation: "Cache and reuse"

search_operations:
  response_time:
    simple_search: "< 2s"
    complex_filters: "2-4s"
    large_result_set: "4-8s"
  optimization: "Use specific filters to reduce results"
```

### Data Consistency

```yaml
real_time_updates:
  task_changes: "Reflect immediately"
  workspace_structure: "May have brief delay"
  time_entries: "Immediate recording"
  
sync_behavior:
  mcp_to_clickup: "Immediate"
  clickup_to_mcp: "Real-time for most operations"
  webhook_support: "Available for automation"

data_preservation:
  deleted_tasks: "Moved to trash, recoverable"
  deleted_lists: "Permanent deletion"
  time_entries: "Preserved in history even if task deleted"
  custom_fields: "Lost if list deleted"
```

---

<a id="8-quick-reference"></a>

## 8. 🏎️ QUICK REFERENCE

### MCP Operations Summary

**Complete operation list:** 13 core operations across task management, hierarchy, time tracking, and collaboration.

**Key operations:**

```yaml
operations:
  get_workspace_hierarchy:
    purpose: "Connection check, retrieve structure"
    parameters: []
    category: "Connection verification"
  
  create_task:
    purpose: "Create single task"
    key_params: [name, listId, assignees, priority]
    category: "Task Operations"
  
  create_bulk_tasks:
    purpose: "Create multiple tasks"
    key_params: [listId, tasks_array]
    category: "Task Operations"
  
  create_folder:
    purpose: "Create organizational folder"
    key_params: [name, spaceId]
    category: "Hierarchy Operations"
  
  create_list_in_folder:
    purpose: "Create list in folder"
    key_params: [name, folderId]
    category: "Hierarchy Operations"
  
  start_time_tracking:
    purpose: "Start timer on task"
    key_params: [taskId, description]
    category: "Time Tracking"
  
  create_task_comment:
    purpose: "Add comment to task"
    key_params: [taskId, commentText]
    category: "Collaboration"
  
  add_tag_to_task:
    purpose: "Add tag to task"
    key_params: [taskId, tagName]
    category: "Collaboration"

operation_categories:
  task_operations:
    - "create_task - Single task creation"
    - "update_task - Task property updates"
    - "create_bulk_tasks - Efficient multi-task creation"
    - "get_workspace_tasks - Search and filter tasks"
  
  hierarchy_operations:
    - "get_workspace_hierarchy - Structure retrieval"
    - "create_folder - Folder creation"
    - "create_list - List creation in space"
    - "create_list_in_folder - List creation in folder"
    - "update_list - List property updates"
    - "delete_list - List deletion (permanent)"
  
  time_tracking_operations:
    - "start_time_tracking - Start timer"
    - "stop_time_tracking - Stop active timer"
    - "add_time_entry - Manual time logging"
    - "get_task_time_entries - Retrieve time logs"
    - "get_current_time_entry - Check active timer"
  
  collaboration_operations:
    - "create_task_comment - Add comment"
    - "get_task_comments - Retrieve comments"
    - "attach_task_file - File attachment"
    - "add_tag_to_task - Add tag"
    - "remove_tag_from_task - Remove tag"
    - "get_space_tags - List space tags"
  
  document_operations:
    - "create_document - Document creation"
    - "create_document_page - Page creation"
    - "update_document_page - Page updates"
    - "list_documents - Document listing"
```

### Integration References

```yaml
official_documentation:
  clickup_mcp_github:
    url: "https://github.com/clickup/mcp-server-clickup"
    description: "Official ClickUp MCP server repository"
  
  npm_package:
    url: "https://www.npmjs.com/package/@clickup/mcp-server-clickup"
    description: "NPM package documentation"
  
  clickup_api_docs:
    url: "https://clickup.com/api"
    description: "ClickUp API reference documentation"

related_documents:
  sync_thinking_framework:
    file: "ClickUp - SYNC Thinking Framework - v0.200"
    purpose: "4-phase methodology (Survey → Yield → Navigate → Create)"
    sections:
      - "Section 2: SYNC Principles (4 phases)"
      - "Section 3: Cognitive Rigor Framework"
      - "Section 4: The SYNC Methodology"
      - "Section 6: RICCE-SYNC Integration"
    key_concepts:
      - "Survey: Context assessment and MCP identification"
      - "Yield: Native pattern selection and optimization"
      - "Navigate: Sequential MCP operations"
      - "Create: Quality validation + integration delivery"
  
  interactive_intelligence:
    file: "ClickUp - Interactive Intelligence - v0.200"
    purpose: "Conversation flows and interaction patterns"
    sections:
      - "Section 1: Conversation Architecture"
      - "Section 2: Response Templates"
      - "Section 5: Error Recovery (REPAIR protocol)"
    integration: "Works with SYNC framework for complete workflow"
```

### Decision Tree

```
Request received
    ↓
Verify MCP connection (ALWAYS FIRST) → Failed → Apply REPAIR
    ↓ Success
Check operation type:
    ↓
Needs task management? → Yes → Task Operations
    ↓ No
Needs workspace structure? → Yes → Hierarchy Operations
    ↓ No
Needs time tracking? → Yes → Time Tracking Operations
    ↓ No
Needs collaboration? → Yes → Collaboration Operations
    ↓ No
Ask for clarification
```

### Capability Check

```python
can_do = {
    'connection_required': True,  # ALWAYS FIRST
    'task_create': True,
    'task_update': True,
    'bulk_tasks': True,
    'folders': True,
    'lists': True,
    'time_tracking': True,
    'comments': True,
    'tags': True,
    'custom_fields': True,  # Must pre-exist
    'file_attachments': True,
    'direct_upload': True,  # Base64, 10MB limit
    'url_upload': True,
    'custom_scripts': False,  # N/A
    'native_operations': True  # ALWAYS
}
```

### Pre-Operation Protocol

```markdown
Every Operation Requires:

1. Connection verification ✓ (ALWAYS FIRST)
2. Test query successful ✓ (get_workspace_hierarchy)
3. Native approach confirmed ✓ (MCP operations only)
4. Workspace access verified ✓
5. APIs identified ✓
6. Ready to execute ✓
```

### Critical Rules Summary

```markdown
THE FIVE ABSOLUTES:

1. Connection verified before EVERY operation (ALWAYS FIRST)
2. Native MCP operations ONLY - no custom scripts (N/A)
3. Test query must pass before proceeding
4. API key must be valid and have proper permissions
5. REPAIR protocol for all errors
```

### Performance Characteristics

```yaml
performance:
  engine: "ClickUp REST APIs via MCP"
  characteristics:
    - "API key authentication"
    - "Rate limited (100/min typical)"
    - "Native MCP operations"
  
  benchmarks:
    connection_check: "1-3 seconds"
    task_create: "< 1 second"
    bulk_10_tasks: "2-5 seconds"
    bulk_50_tasks: "5-15 seconds"
    folder_create: "< 1 second"
    list_create: "< 1 second"
    time_tracking_start: "< 1 second"
    comment_create: "< 1 second"
```

---

*This document focuses exclusively on ClickUp MCP server capabilities and technical specifications. For SYNC thinking methodology (Survey → Yield → Navigate → Create), see ClickUp - SYNC Thinking Framework v0.200. For conversation flows and error handling (REPAIR protocol), see ClickUp - Interactive Intelligence v0.200.*

---

*This knowledge document serves as the authoritative technical reference for all ClickUp MCP operations. It reflects actual server capabilities, required patterns, and real-world constraints. Always verify connection before operations. Reference companion documents for methodology (SYNC Thinking Framework v0.200) and interaction patterns (Interactive Intelligence v0.200).*
