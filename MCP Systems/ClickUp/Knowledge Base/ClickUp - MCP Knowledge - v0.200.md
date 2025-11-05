# ClickUp - MCP Knowledge - v0.201

Complete technical reference for the ClickUp Model Context Protocol server integration. This document provides comprehensive specifications for task management, project tracking, time tracking, and agile workflow operations through native MCP capabilities.

---

## Table of Contents

1. [🔌 SERVER OVERVIEW](#1-server-overview)
2. [🎯 CORE CAPABILITIES](#2-core-capabilities)
3. [📋 FORMAT SUPPORT](#3-format-support)
4. [✅ TASK & PROJECT OPERATIONS](#4-task-project-operations)
5. [📊 WORKSPACE & HIERARCHY OPERATIONS](#5-workspace-hierarchy-operations)
6. [⏱️ TIME TRACKING & COLLABORATION](#6-time-tracking-collaboration)
7. [⚠️ LIMITATIONS & CONSTRAINTS](#7-limitations-constraints)
8. [⚡ QUICK REFERENCE](#8-quick-reference)

---

<a id="1-server-overview"></a>

## 1. 🔌 SERVER OVERVIEW

### Server Details

The ClickUp MCP Server (`@clickup/mcp-server-clickup`) provides native Model Context Protocol integration for task management and project tracking operations. It enables agile workflows, sprint management, time tracking, and collaboration features directly through MCP.

**Key Information:**
- **Repository:** https://github.com/clickup/mcp-server-clickup
- **Integration Type:** Native MCP Server
- **Primary Use Cases:** Agile workflows, sprints, time tracking
- **Complementary System:** Works alongside Notion MCP for documentation

**Core Functions:**
- Task creation and management
- Project hierarchy (Spaces/Folders/Lists)
- Time tracking and reporting
- Custom fields and bulk operations
- Document and comment management
- Tag and assignee management

### Connection Verification

**⚠️ CRITICAL:** Always verify ClickUp MCP connection before performing any operation.

Before executing any ClickUp operation, you must verify the connection is active. Use the `get_workspace_hierarchy` operation to test connectivity and retrieve workspace structure. This ensures the MCP server is properly configured and authenticated.

**Connection Check Procedure:**
1. Execute `get_workspace_hierarchy` operation
2. Verify response contains spaces, folders, and lists arrays
3. If connection fails, display setup instructions to user
4. Do not proceed with operations until connection is confirmed

**Error Messages:**
- ❌ **No Connection:** "ClickUp MCP not connected. Please setup server."
- ⚠️ **Setup Required:** Display Installation & Setup guide (see below)
- 🔄 **Retry Logic:** Attempt reconnection after user confirms configuration

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

## 2. 🎯 CORE CAPABILITIES

### Available Operations

The ClickUp MCP server provides **13 operations** organized into four main categories:

**Task Management (4 operations):**
- `create_task` - Create individual tasks with full configuration
- `update_task` - Modify existing task properties
- `create_bulk_tasks` - Create multiple tasks efficiently
- `get_workspace_tasks` - Search and filter tasks with pagination

**Hierarchy Management (6 operations):**
- `create_list` - Create lists within spaces
- `create_folder` - Create organizational folders
- `create_list_in_folder` - Add lists to specific folders
- `update_list` - Modify list settings and properties
- `delete_list` - Remove lists from workspace
- `get_workspace_hierarchy` - Retrieve complete workspace structure

**Time Tracking (5 operations):**
- `start_time_tracking` - Begin timer on a task
- `stop_time_tracking` - End active timer
- `add_time_entry` - Manually log time entries
- `get_task_time_entries` - Retrieve time logs for tasks
- `get_current_time_entry` - Check currently running timer

**Collaboration:**
- `create_task_comment` / `get_task_comments` - Task discussion management
- `attach_task_file` - Upload files to tasks
- `add_tag_to_task` / `remove_tag_from_task` - Tag management
- `get_space_tags` - List available tags in a space

**Document Operations:**
- `create_document` / `create_document_page` / `update_document_page` / `list_documents`

All operations use native MCP tools with direct invocation via MCP protocol, returning structured JSON responses. Authentication uses API key via environment variable.

### Operation Summary Table

| Operation | Category | Purpose | Key Parameters |
|-----------|----------|---------|----------------|
| `create_task` | Tasks | Create single task | name, listId, assignees, priority |
| `update_task` | Tasks | Update task properties | taskId, fields to update |
| `create_bulk_tasks` | Tasks | Create multiple tasks | listId, tasks array |
| `get_workspace_tasks` | Tasks | Search/filter tasks | filters, pagination |
| `create_list` | Hierarchy | Create list in space | name, spaceId, settings |
| `create_folder` | Hierarchy | Create folder | name, spaceId |
| `create_list_in_folder` | Hierarchy | List within folder | name, folderId |
| `get_workspace_hierarchy` | Hierarchy | Full workspace structure | (no parameters) |
| `start_time_tracking` | Time | Start timer on task | taskId, description |
| `stop_time_tracking` | Time | Stop running timer | description, tags |
| `add_time_entry` | Time | Manual time entry | taskId, start, duration |
| `create_task_comment` | Collaboration | Add comment | taskId, commentText |
| `attach_task_file` | Collaboration | Upload attachment | taskId, file_url or file_data |

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

<a id="7-limitations-constraints"></a>

## 7. ⚠️ LIMITATIONS & CONSTRAINTS

### API Rate Limits

```yaml
rate_limiting:
  requests_per_minute: 100
  applies_to: "All API operations"
  throttling_behavior: "429 error returned"
  
handling_rate_limits:
  automatic_retry:
    enabled: true
    backoff: "Exponential"
    max_retries: 3
  
  bulk_operations:
    use_batching: true
    recommended_batch_size: 10
    concurrent_limit: 3
  
  best_practices:
    - "Use bulk operations when possible"
    - "Implement exponential backoff"
    - "Cache workspace hierarchy"
    - "Group related operations"
```

### Connection Requirements

```yaml
mandatory_verification:
  required_before: "ALL operations"
  method: "get_workspace_hierarchy"
  failure_result: "Operation blocked with error message"
  
connection_dependencies:
  api_key: "Valid ClickUp API token"
  network: "Internet connectivity"
  mcp_server: "Server running and accessible"
  
setup_requirements:
  - "NPM package installed"
  - "Configuration file updated"
  - "Claude Desktop restarted"
  - "API key generated in ClickUp"

error_when_not_connected:
  message: "❌ ClickUp MCP not connected"
  user_action: "Please setup ClickUp MCP server"
  documentation: "See Installation & Setup section"
```

### Operation Constraints

```yaml
task_operations:
  custom_fields:
    limitation: "Must exist in list first"
    no_creation: "Cannot create custom fields via MCP"
    workaround: "Create in ClickUp UI, then reference by ID"
  
  task_id_formats:
    uuid: "Standard ClickUp UUID"
    custom: "Custom task IDs like 'DEV-123'"
    limitation: "Custom IDs require proper workspace setup"
  
  assignees:
    format: "User ID array"
    limitation: "Users must exist in workspace"
    no_creation: "Cannot invite users via MCP"

list_operations:
  deletion:
    permanent: true
    no_undo: true
    tasks_impact: "Moved to trash"
    recommendation: "Archive instead of delete"
  
  status_configuration:
    limitation: "Statuses are list-specific"
    customization: "Set in ClickUp UI"
    api_access: "Read-only via MCP"

time_tracking:
  active_timer:
    limit: "One per user"
    auto_stop: "Starting new timer stops previous"
  
  manual_entries:
    past_entries: "Fully supported"
    future_entries: "Not allowed"
    duration_format: "Must be valid format"

document_operations:
  creation:
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

## 8. ⚡ QUICK REFERENCE

### Common Operation Patterns

```yaml
task_creation_workflow:
  step_1: "Verify connection: get_workspace_hierarchy()"
  step_2: "Get list ID from hierarchy"
  step_3: "Create task: create_task(name, listId, options)"
  step_4: "Verify creation: check returned task object"

project_setup_workflow:
  step_1: "Verify connection"
  step_2: "Get workspace hierarchy"
  step_3: "Create folder: create_folder(name, spaceId)"
  step_4: "Create lists: create_list_in_folder(name, folderId)"
  step_5: "Add initial tasks: create_bulk_tasks(listId, tasks)"

time_tracking_workflow:
  step_1: "Verify connection"
  step_2: "Start timer: start_time_tracking(taskId)"
  step_3: "Work on task..."
  step_4: "Stop timer: stop_time_tracking()"
  step_5: "Verify: get_task_time_entries(taskId)"
```

### Error Handling Patterns

```yaml
connection_error:
  error_code: "ECONNREFUSED"
  check: "Server not running or not configured"
  solution: "Restart Claude Desktop, verify configuration"

authentication_error:
  error_code: "UNAUTHORIZED"
  check: "Invalid or expired API key"
  solution: "Generate new API key, update configuration"

not_found_error:
  error_code: "NOT_FOUND"
  check: "Invalid ID or resource doesn't exist"
  solution: "Verify ID with get_workspace_hierarchy()"

rate_limit_error:
  error_code: "RATE_LIMITED"
  check: "Too many requests"
  solution: "Wait 60s, use bulk operations, implement backoff"

permission_error:
  error_code: "PERMISSION_DENIED"
  check: "Insufficient access rights"
  solution: "Check workspace permissions, use different resource"

error_recovery_strategy:
  - "Always check connection first"
  - "Verify IDs before operations"
  - "Implement exponential backoff for retries"
  - "Log errors for debugging"
  - "Provide clear user feedback"
```

### Status Display Templates

```markdown
# Task Operation Status
📊 ClickUp Task Management

Operation: Creating sprint tasks
Status: In progress
Progress: 15/20 tasks created

Connection: Active ✓
API calls: 45/100 per minute
Queue: 5 operations pending

# Time Tracking Status
⏱️ Time Tracking Active

Task: Implement authentication
Started: 10:30 AM
Duration: 1h 23m
Billable: Yes

Timer: Running ✓

# Workspace Status
🏢 Workspace Structure

Spaces: 3
Folders: 12
Lists: 45
Tasks: 1,247

Last sync: 2 minutes ago
Connection: Active ✓
```

### Integration Examples

```yaml
sprint_setup_complete:
  """
  async function setupSprint(sprintName, teamId) {
    // 1. Verify connection
    const connection = await clickup.get_workspace_hierarchy();
    if (!connection.spaces) throw new Error("Not connected");
    
    // 2. Create folder
    const folder = await clickup.create_folder({
      name: sprintName,
      spaceId: connection.spaces[0].id,
      override_statuses: true
    });
    
    // 3. Create workflow lists
    const lists = await Promise.all([
      'Backlog', 'To Do', 'In Progress', 'Review', 'Done'
    ].map(name => clickup.create_list_in_folder({
      name, folderId: folder.id
    })));
    
    // 4. Create initial tasks
    await clickup.create_bulk_tasks({
      listId: lists[0].id,
      tasks: [
        { name: '🎯 Sprint Planning', priority: 1, assignees: [teamId] },
        { name: '📊 Sprint Review', dueDate: '2 weeks', priority: 2 },
        { name: '🔄 Retrospective', dueDate: '2 weeks', priority: 2 }
      ]
    });
    
    return { folder, lists };
  }
  """

natural_language_routing:
  """
  User: "Set up a sprint for next week"
  
  System:
  → Checking ClickUp connection... ✓
  → ClickUp optimal for sprint management
  → Creating sprint folder structure
  → Adding workflow lists (5)
  → Creating initial tasks (3)
  → Result: Sprint ready with complete workflow
  """
```

### Companion Documents

```yaml
related_documents:
  interactive_intelligence:
    file: "ClickUp & Notion - Interactive Intelligence - v0.200.md"
    purpose: "Conversational interface and example interactions"
    
  thinking_framework:
    file: "ClickUp & Notion - SYNC Thinking Framework - v0.200.md"
    purpose: "Cognitive methodology for ClickUp & Notion operations"
    
  agent_specification:
    file: "Agent - MCP - ClickUp & Notion - v0.101.md"
    purpose: "Agent configuration and routing logic"

recommended_reading_order:
  - "This Knowledge document (technical reference)"
  - "SYNC Thinking Framework (methodology)"
  - "Interactive Intelligence (usage patterns)"
```

### Key Differences from Generic Task Tools

```yaml
clickup_mcp_specific:
  - "Connection verification mandatory before all operations"
  - "Custom fields must be pre-configured in lists"
  - "Time tracking native to ClickUp (one timer per user)"
  - "Workspace hierarchy (Space → Folder → List → Task)"
  - "Custom task IDs support (e.g., 'DEV-123')"
  - "Billable time tracking built-in"
  - "Document and page management within tasks"
  - "Tag management at space level"

not_supported:
  - "Custom field creation via MCP"
  - "User invitation or management"
  - "Workspace creation"
  - "Custom status creation"
  - "Webhook configuration"
  - "Automation rules"
  - "Template management"
```

### Performance Benchmarks

```yaml
operation_timing:
  single_task_create: "< 1s"
  bulk_10_tasks: "2-5s"
  bulk_50_tasks: "5-15s"
  bulk_100_tasks: "15-30s"
  
  update_task: "< 1s"
  search_tasks: "< 2s (simple)"
  search_tasks_complex: "2-4s"
  
  get_hierarchy: "1-3s"
  create_list: "< 1s"
  create_folder: "< 1s"
  
  start_timer: "< 1s"
  stop_timer: "< 1s"
  add_time_entry: "< 1s"
  get_time_entries: "1-2s"

optimization_tips:
  - "Use bulk operations for > 5 tasks"
  - "Cache workspace hierarchy"
  - "Batch related operations"
  - "Use concurrent operations (max 3-5)"
  - "Implement request queuing for large batches"
```

---

## Notes

- **Native MCP Operations Only**: All operations use official ClickUp MCP server tools. No API wrappers or external dependencies.
- **Connection Verification Required**: Every workflow begins with connection verification via `get_workspace_hierarchy()`.
- **Custom Fields Pre-Configuration**: Custom fields must be created in ClickUp UI before use via MCP.
- **Complementary to Notion**: ClickUp handles tasks/projects/time, Notion handles documentation/knowledge bases.
- **Real Documentation**: All specifications based on actual ClickUp MCP server implementation and ClickUp API capabilities.

---

*This knowledge document serves as the authoritative technical reference for all ClickUp MCP operations. It reflects actual server capabilities, required patterns, and real-world constraints. Always verify connection before operations. Reference companion documents for methodology (SYNC Thinking Framework v0.200) and interaction patterns (Interactive Intelligence v0.200).*
