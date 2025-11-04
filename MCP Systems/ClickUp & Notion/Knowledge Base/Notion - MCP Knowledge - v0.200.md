# Notion - MCP Knowledge - v0.201

Technical reference for Notion MCP server capabilities and integration for workspace, database, and content management operations.

**Purpose:** Document Notion-specific features, supported operations, API specifications, and technical constraints. Conversation flows and thinking methodology are in Interactive Intelligence v0.200 and ClickUp & Notion - Thinking Framework v0.200 respectively.

---

## 📋 TABLE OF CONTENTS

1. [🔌 SERVER OVERVIEW](#1-server-overview)
2. [🛠️ CORE CAPABILITIES](#2-core-capabilities)
3. [📊 FORMAT SUPPORT](#3-format-support)
4. [🗄️ DATABASE OPERATIONS](#4-database-operations)
5. [📄 PAGE & CONTENT OPERATIONS](#5-page-content-operations)
6. [🔍 SEARCH & COLLABORATION](#6-search-collaboration)
7. [⚠️ LIMITATIONS](#7-limitations)
8. [🏎️ QUICK REFERENCE](#8-quick-reference)

---

<a id="1-server-overview"></a>

## 1. 🔌 SERVER OVERVIEW

### MCP Server Details

The Notion MCP Server (`@makenotion/notion-mcp-server`) provides native integration with Notion's API v1 for workspace, database, and content management operations. It uses internal integration tokens for authentication and enables direct API access without custom code generation.

**Key Information:**
- **Repository:** https://github.com/makenotion/notion-mcp-server
- **NPM Package:** `@makenotion/notion-mcp-server`
- **Protocol:** Model Context Protocol (MCP)
- **Node Requirement:** Node.js latest LTS
- **Authentication:** Integration token (Bearer ntn_****)
- **Setup:** https://www.notion.so/profile/integrations

**Deployment Options:**
- **Recommended:** NPM with NOTION_TOKEN environment variable
- **Alternative:** Docker containerized deployment

**Important:** This server provides direct API access only. Custom code generation is not applicable (N/A) - all operations use native Notion API calls exclusively.

### System Architecture

The Notion MCP workflow follows a strict sequence to ensure proper connectivity and API access:

**Operation Sequence:**
1. **Connection Check** (ALWAYS FIRST) - Verify MCP server is active
2. **User Request** - Receive and parse user intent
3. **Intent Recognition** - Determine operation type needed
4. **Operation Selection** - Choose between Database/Page/Search operations
5. **Native API Call** - Execute using official Notion API (NO custom code)
6. **Feedback & Confirmation** - Return results to user

**Deployment Architecture:**

*NPM Deployment (Recommended):*
- Direct API token management in environment
- Simple configuration with NOTION_TOKEN
- Workspace-level access with granular page/database sharing
- Uses stdio transport (default MCP connection)

*Docker Deployment (Alternative):*
- Containerized with environment variables
- Requires Docker runtime
- Token passed via environment configuration

**API Routing:**
- **Workspace Operations:** Requires integration token with proper workspace access (pages, databases, blocks, search)
- **Content Operations:** Requires explicit page/database sharing with the integration (CRUD on connected content only)

### Core Principle

**ABSOLUTE RULE:** Only native Notion API calls are allowed. Custom integrations, workspace manipulation outside the API, and permission overrides are not applicable.

**✅ Allowed Operations:**
- Native Notion API calls exclusively
- `notion:API_post_page()` - Create pages
- `notion:API_create_a_database()` - Database creation
- `notion:API_patch_block_children()` - Content updates
- All official Notion API endpoints

**❌ Forbidden Operations:**
- Custom integration generation (N/A)
- Workspace manipulation outside API (N/A)
- Permission override attempts (N/A)
- Any non-API operations

This policy has **ABSOLUTE enforcement with no exceptions**.

### Connection Verification

**Reference:** Connection verification logic is in Interactive Intelligence v0.200. Thinking methodology phases in ClickUp & Notion - Thinking Framework v0.200.

Connection verification must be the **first action before all operations**. Use the `API_get_self` tool to test connectivity and authentication.

**Status Messages:**
- ✅ **Connected:** "Notion MCP Connected - All APIs available"
- ❌ **Disconnected:** "Notion MCP Not Connected - Setup required"
- ⚠️ **Auth Failed:** "Authentication Issue - Token invalid or expired"
- ⚠️ **Not Shared:** "Access Issue - Content not shared with integration"

**Connection Protocol:**
1. Check MCP server status
2. Run test query (`API_get_self`)
3. Verify token authentication
4. Check workspace access
5. Proceed with operations only if all checks pass

**Example Implementation:**
```javascript
async function verifyConnection() {
    try {
        await notion:API_get_self();
        return { 
            connected: true, 
            apis: 'ready'
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
- **Auth Failed:** Token issue → Regenerate integration token
- **Not Shared:** Content not accessible → Share page/database with integration

---

<a id="2-core-capabilities"></a>

## 2. 🛠️ CORE CAPABILITIES

### Available Operations

**Note:** Thinking methodology (Survey → Yield → Navigate → Create analog) and conversation flows are defined in ClickUp & Notion - Thinking Framework v0.200 and Interactive Intelligence v0.200.

```yaml
workspace_operations:
  user_management:
    tools:
      - API_get_user
      - API_get_users
      - API_get_self
    method: "Native API only"
    requires: "Integration token"
  
  search_operations:
    tools:
      - API_post_search
    method: "Native API only"
    requires: "Integration token"
  
  database_system:
    tools:
      - API_create_a_database
      - API_post_database_query
    method: "Native API only"
    requires: "Integration token"

page_operations:
  page_management:
    tools:
      - API_post_page
      - API_patch_page
      - API_retrieve_a_page
    method: "Native API only"
    requires: "Page sharing"
  
  content_operations:
    tools:
      - API_get_block_children
      - API_patch_block_children
    method: "Native API only"
    requires: "Page sharing"
  
  collaboration:
    tools:
      - API_create_a_comment
    method: "Native API only"
    requires: "Page sharing"
```

### What You CAN Do ✅

**Workspace and Content Operations (Native API Only):**

The Notion MCP server enables comprehensive workspace management using native Notion APIs:
- Create databases with any property types
- Build page hierarchies programmatically
- Manage content with rich text blocks
- Search across entire workspace
- Handle comments and collaboration
- Query databases with complex filters

**Content Management (Native API Only):**

Rich content and structural operations are fully supported:
- Create pages with nested structures
- Add all block types (paragraph, heading, list, code, etc.)
- Manage database properties and relations
- Handle relationships between databases
- Organize hierarchical content
- Execute complex queries with filters and sorts

All operations use **native API calls only**. Custom code generation is not applicable (N/A).

### What You CANNOT Do ❌

**Permission Restrictions:**
- Cannot access content not shared with the integration
- Cannot access private pages without explicit permission
- Cannot access other workspaces
- Cannot access archived content (unless explicitly requested)
- All restrictions enforced at API-level

**Media Upload Limitation:**
- Direct file upload is not supported by Notion API
- **Workaround:** Use external URLs for images and files
- Recommended services: Cloudinary, Amazon S3, Imgur

**Connection Requirements:**
- Cannot work without MCP connection verification
- Connection check must ALWAYS be performed first
- All operations require active MCP session

**Integration Setup:**
- Internal integration must be created in Notion
- Pages/databases must be explicitly shared with integration
- Applies to all operations

**Rate Limits:**
- 3 requests per second average (Notion API limit)
- Safe operating zone: 2.5 requests per second
- Warning threshold: 2.8 requests per second
- Cooldown period: Automatic by Notion API

**Access Control:**
- Only shared or public resources accessible
- Cannot modify locked properties
- Cannot access other workspaces
- Respects Notion's permission hierarchy

---

<a id="3-format-support"></a>

## 3. 📊 FORMAT SUPPORT

### Property Types Available

```yaml
property_types:
  text_properties:
    title:
      description: "Page/database title (required)"
      use_case: "Primary identifier for all pages"
      native: true
      required: "Every page/database"
    
    rich_text:
      description: "Multi-line formatted text"
      use_case: "Descriptions, notes, formatted content"
      native: true
      annotations: "bold, italic, strikethrough, underline, code, color"
    
    email:
      description: "Email address validation"
      use_case: "Contact information"
      native: true
    
    phone_number:
      description: "Phone number field"
      use_case: "Contact information"
      native: true
    
    url:
      description: "Web link validation"
      use_case: "External references, resources"
      native: true
  
  numeric_properties:
    number:
      description: "Numeric values with formatting"
      use_case: "Prices, quantities, ratings, calculations"
      native: true
      formats: "number, number_with_commas, percent, dollar, etc."
    
    formula:
      description: "Calculated values from other properties"
      use_case: "Computed fields, aggregations"
      native: true
      expression_based: true
  
  date_time:
    date:
      description: "Date and optional time values"
      use_case: "Deadlines, events, timestamps"
      native: true
      supports: "start/end date ranges"
  
  selection:
    select:
      description: "Single choice from predefined options"
      use_case: "Status, category, priority"
      native: true
      features: "color-coded options"
    
    multi_select:
      description: "Multiple choices from options"
      use_case: "Tags, labels, categories"
      native: true
      features: "color-coded, multiple values"
    
    checkbox:
      description: "Boolean toggle field"
      use_case: "Completion, flags, binary states"
      native: true
  
  media:
    files:
      description: "File attachment URLs"
      use_case: "Documents, downloads (URL only - no direct upload)"
      native: true
      limitation: "External URL required"
  
  relationships:
    relation:
      description: "Link to database items"
      use_case: "Connections between databases"
      native: true
      features: "bi-directional, synced properties"
    
    rollup:
      description: "Aggregate data from relations"
      use_case: "Summaries, counts, calculations from related items"
      native: true
      depends_on: "relation property"
  
  people:
    people:
      description: "User references from workspace"
      use_case: "Assignees, collaborators, owners"
      native: true
      supports: "multiple users per property"
```

### Block Types Available

```yaml
block_types:
  text_blocks:
    paragraph:
      description: "Standard text block"
      use_case: "Body content, descriptions"
      supported: true
      rich_text: true
    
    heading_1:
      description: "Top-level heading"
      use_case: "Main sections"
      supported: true
      rich_text: true
    
    heading_2:
      description: "Second-level heading"
      use_case: "Subsections"
      supported: true
      rich_text: true
    
    heading_3:
      description: "Third-level heading"
      use_case: "Sub-subsections"
      supported: true
      rich_text: true
    
    quote:
      description: "Blockquote styling"
      use_case: "Citations, highlights"
      supported: true
      rich_text: true
    
    callout:
      description: "Highlighted information box"
      use_case: "Warnings, tips, important notes"
      supported: true
      rich_text: true
      features: "icon, background color"
  
  list_blocks:
    bulleted_list_item:
      description: "Unordered list item"
      use_case: "Lists, outlines"
      supported: true
      nestable: true
    
    numbered_list_item:
      description: "Ordered list item"
      use_case: "Steps, sequences"
      supported: true
      nestable: true
    
    to_do:
      description: "Checkbox item"
      use_case: "Tasks, checklists"
      supported: true
      checkable: true
  
  interactive_blocks:
    toggle:
      description: "Collapsible content block"
      use_case: "FAQ, expandable sections"
      supported: true
      nestable: true
  
  code_blocks:
    code:
      description: "Syntax-highlighted code"
      use_case: "Code snippets, scripts"
      supported: true
      features: "language selection, line numbers"
  
  media_blocks:
    image:
      description: "Image display"
      use_case: "Visual content (URL only)"
      supported: true
      limitation: "External URL required"
    
    video:
      description: "Video embed"
      use_case: "Media content (URL only)"
      supported: true
      limitation: "External URL or embed"
    
    file:
      description: "File attachment"
      use_case: "Downloads (URL only)"
      supported: true
      limitation: "External URL required"
    
    embed:
      description: "Web embed (iframe)"
      use_case: "External content integration"
      supported: true
  
  structural_blocks:
    divider:
      description: "Horizontal separator"
      use_case: "Section separation"
      supported: true
    
    table:
      description: "Simple data table"
      use_case: "Structured data display"
      supported: true
      note: "Different from database"
```

### Rich Text Formatting

```yaml
rich_text_features:
  annotations:
    bold: "Bold text weight"
    italic: "Italic text style"
    strikethrough: "Strikethrough decoration"
    underline: "Underline decoration"
    code: "Inline code styling"
    color: "Text and background colors"
  
  colors:
    text: ["default", "gray", "brown", "orange", "yellow", "green", "blue", "purple", "pink", "red"]
    background: ["gray_background", "brown_background", "orange_background", "yellow_background", "green_background", "blue_background", "purple_background", "pink_background", "red_background"]
  
  links:
    url: "Inline hyperlinks"
    mention: "User mentions with @"
    page: "Internal page references"
  
  equation:
    support: "KaTeX mathematical equations"
    format: "Inline or block-level"
```

---

<a id="4-database-operations"></a>

## 4. 🗄️ DATABASE OPERATIONS

### Native Database Management

```yaml
API_create_a_database:
  description: "Create new database via native API"
  parameters:
    parent:
      type: object
      required: true
      description: "Parent page ID"
      format: "{ page_id: string }"
    
    title:
      type: array
      required: true
      description: "Database title"
      format: "[{ text: { content: string } }]"
    
    properties:
      type: object
      required: true
      description: "Property definitions"
  
  performance:
    small: "2-3 seconds"
    medium: "3-5 seconds"
    large: "5-8 seconds"
  pre_check: "Connection verified ✓"
  method: "Native API"

API_post_database_query:
  description: "Query database with filters via native API"
  parameters:
    database_id:
      type: string
      required: true
      description: "Database UUID"
    
    filter:
      type: object
      optional: true
      description: "Filter conditions"
    
    sorts:
      type: array
      optional: true
      description: "Sort configuration"
    
    page_size:
      type: integer
      optional: true
      description: "Results per page (max 100)"
  
  performance:
    small: "< 1 second"
    medium: "1-2 seconds"
    large: "2-4 seconds (paginated)"
  pre_check: "Connection verified ✓"
  method: "Native API"
```

### Property Configuration

```yaml
property_setup:
  title_required:
    Name:
      type: "title"
      required: true
      description: "Every database must have title property"
  
  common_patterns:
    task_management:
      Status:
        type: "select"
        options: ["To Do", "In Progress", "Done"]
      Priority:
        type: "select"
        options: ["High", "Medium", "Low"]
      Assignee:
        type: "people"
      Due:
        type: "date"
    
    content_calendar:
      Title:
        type: "title"
      PublishDate:
        type: "date"
      Author:
        type: "people"
      Category:
        type: "multi_select"
      Status:
        type: "select"
    
    crm_contacts:
      Name:
        type: "title"
      Email:
        type: "email"
      Phone:
        type: "phone_number"
      Company:
        type: "relation"
      LastContact:
        type: "date"
    
    project_tracker:
      Project:
        type: "title"
      Status:
        type: "select"
        options: ["Planning", "Active", "On Hold", "Complete"]
      Owner:
        type: "people"
      StartDate:
        type: "date"
      EndDate:
        type: "date"
      Budget:
        type: "number"
        format: "dollar"
```

### Database Filtering

```yaml
filter_operators:
  text_filters:
    equals: "Exact match"
    does_not_equal: "Not equal"
    contains: "Substring match"
    does_not_contain: "Does not include"
    starts_with: "Prefix match"
    ends_with: "Suffix match"
    is_empty: "No value"
    is_not_empty: "Has value"
  
  number_filters:
    equals: "Exact value"
    does_not_equal: "Not equal"
    greater_than: ">"
    less_than: "<"
    greater_than_or_equal_to: ">="
    less_than_or_equal_to: "<="
    is_empty: "No value"
    is_not_empty: "Has value"
  
  date_filters:
    equals: "Exact date"
    before: "Earlier than"
    after: "Later than"
    on_or_before: "On or before"
    on_or_after: "On or after"
    is_empty: "No date"
    is_not_empty: "Has date"
    past_week: "Last 7 days"
    past_month: "Last 30 days"
    past_year: "Last 365 days"
    next_week: "Next 7 days"
    next_month: "Next 30 days"
    next_year: "Next 365 days"
  
  select_filters:
    equals: "Matches option"
    does_not_equal: "Not option"
    is_empty: "No selection"
    is_not_empty: "Has selection"
  
  relation_filters:
    contains: "Related to"
    does_not_contain: "Not related to"
    is_empty: "No relations"
    is_not_empty: "Has relations"
```

### Complex Queries

```yaml
query_patterns:
  compound_filter:
    description: "Multiple conditions with AND/OR logic"
    example: |
      {
        filter: {
          and: [
            { property: 'Status', select: { equals: 'In Progress' } },
            { property: 'Priority', select: { equals: 'High' } }
          ]
        }
      }
  
  nested_filter:
    description: "Complex logical grouping"
    example: |
      {
        filter: {
          or: [
            {
              and: [
                { property: 'Status', select: { equals: 'Done' } },
                { property: 'Due', date: { past_week: {} } }
              ]
            },
            { property: 'Priority', select: { equals: 'High' } }
          ]
        }
      }
  
  sorted_results:
    description: "Multiple sort criteria"
    example: |
      {
        sorts: [
          { property: 'Priority', direction: 'ascending' },
          { property: 'Due', direction: 'ascending' }
        ]
      }
  
  paginated_query:
    description: "Handle large result sets"
    example: |
      {
        page_size: 100,
        start_cursor: "previous_page_cursor"
      }
```

### Database Views

```yaml
view_types:
  table_view:
    description: "Spreadsheet-style grid"
    best_for: "Data analysis, bulk editing"
    features:
      - "Column sorting"
      - "Inline editing"
      - "Formula display"
      - "Resizable columns"
  
  board_view:
    description: "Kanban boards grouped by select property"
    best_for: "Workflow management, status tracking"
    features:
      - "Drag-and-drop cards"
      - "Group by any select property"
      - "Card previews"
      - "Quick status changes"
  
  timeline_view:
    description: "Gantt-style timeline by date ranges"
    best_for: "Project planning, scheduling"
    features:
      - "Visual timeline"
      - "Date range display"
      - "Dependencies visualization"
      - "Milestone tracking"
  
  calendar_view:
    description: "Month/week calendar by date property"
    best_for: "Event planning, content calendars"
    features:
      - "Monthly/weekly display"
      - "Drag-and-drop dates"
      - "Multiple calendars"
      - "Date property selection"
  
  list_view:
    description: "Simplified vertical list"
    best_for: "Simple overviews, mobile viewing"
    features:
      - "Clean layout"
      - "Property display control"
      - "Grouping options"
      - "Quick filters"
  
  gallery_view:
    description: "Card-based visual grid"
    best_for: "Image-heavy content, portfolios"
    features:
      - "Large previews"
      - "Cover images"
      - "Card size control"
      - "Visual browsing"

view_configuration:
  note: "Views are configured in Notion UI, not via API"
  api_support: "API returns database ready for view setup"
  customization: "Each view has independent filters, sorts, and property visibility"
```

### Relation and Rollup

```yaml
relation_properties:
  setup:
    type: "relation"
    database_id: "target_database_id"
    relationship: "one_to_many or many_to_many"
    synced_property: "optional_two_way_sync"
  
  example:
    Tasks_to_Projects:
      property: "Project"
      type: "relation"
      relates_to: "Projects database"
      allows: "Multiple projects per task"
  
  behavior:
    bi_directional: "Auto-creates reverse relation"
    cascade: "Deleting item removes relations"
    permissions: "Respects both database permissions"

rollup_properties:
  setup:
    type: "rollup"
    relation: "relation_property_name"
    rollup_property: "property_to_aggregate"
    function: "aggregation_function"
  
  functions:
    - "show_original: Display related values"
    - "count: Count related items"
    - "sum: Sum numeric values"
    - "average: Average numeric values"
    - "min: Minimum value"
    - "max: Maximum value"
    - "range: Max minus min"
    - "percent_empty: Percentage without value"
    - "percent_not_empty: Percentage with value"
  
  example:
    Task_Count_by_Project:
      type: "rollup"
      relation: "Tasks"
      rollup_property: "Name"
      function: "count"
      result: "Shows number of related tasks"
```

### Operation Prerequisites

```yaml
before_database_operation:
  checklist:
    - "MCP connection verified ✓"
    - "Test query successful (API_get_self) ✓"
    - "Parent page identified or created ✓"
    - "Properties schema defined ✓"
    - "Share permissions configured ✓"
    - "Using native API calls ✓"
  
  enforcement: "ALL must pass before proceeding"
```

---

<a id="5-page-content-operations"></a>

## 5. 📄 PAGE & CONTENT OPERATIONS

### Native Page Management

```yaml
API_post_page:
  description: "Create new page via native API"
  parameters:
    parent:
      type: object
      required: true
      description: "Parent page or database ID"
      format: "{ page_id: string } or { database_id: string }"
    
    properties:
      type: object
      required: true
      description: "Page properties (title for pages, db fields for db pages)"
    
    children:
      type: array
      optional: true
      description: "Initial content blocks"
  
  performance:
    small: "1-2 seconds"
    medium: "2-4 seconds"
    large: "4-8 seconds"
  pre_check: "Connection verified ✓"
  method: "Native API"

API_patch_page:
  description: "Update page properties via native API"
  parameters:
    page_id:
      type: string
      required: true
      description: "Page UUID"
    
    properties:
      type: object
      optional: true
      description: "Properties to update"
    
    archived:
      type: boolean
      optional: true
      description: "Archive/unarchive page"
    
    icon:
      type: object
      optional: true
      description: "Page icon (emoji or external URL)"
    
    cover:
      type: object
      optional: true
      description: "Cover image (external URL)"
  
  performance: "< 1 second"
  pre_check: "Connection verified ✓"
  method: "Native API"

API_retrieve_a_page:
  description: "Get page details via native API"
  parameters:
    page_id:
      type: string
      required: true
      description: "Page UUID"
  
  performance: "< 1 second"
  pre_check: "Connection verified ✓"
  method: "Native API"
```

### Native Content Operations

```yaml
API_get_block_children:
  description: "Get blocks within page/block via native API"
  parameters:
    block_id:
      type: string
      required: true
      description: "Page or block UUID"
    
    page_size:
      type: integer
      optional: true
      description: "Results per page (max 100)"
    
    start_cursor:
      type: string
      optional: true
      description: "Pagination cursor"
  
  performance: "< 1 second"
  pre_check: "Connection verified ✓"
  method: "Native API"

API_patch_block_children:
  description: "Append blocks to page/block via native API"
  parameters:
    block_id:
      type: string
      required: true
      description: "Parent page or block UUID"
    
    children:
      type: array
      required: true
      description: "Array of block objects to append"
  
  performance:
    small: "1-2 seconds"
    medium: "2-4 seconds"
    large: "4-8 seconds"
  pre_check: "Connection verified ✓"
  method: "Native API"
```

### Content Block Patterns

```yaml
common_block_structures:
  documentation_page:
    structure:
      - "heading_1: Page title"
      - "paragraph: Introduction"
      - "heading_2: Section 1"
      - "bulleted_list_item: Key point 1"
      - "bulleted_list_item: Key point 2"
      - "heading_2: Section 2"
      - "code: Code example"
      - "paragraph: Explanation"
  
  meeting_notes:
    structure:
      - "heading_1: Meeting Title"
      - "paragraph: Date, attendees, purpose"
      - "heading_2: Agenda Items"
      - "to_do: Action item 1"
      - "to_do: Action item 2"
      - "heading_2: Decisions"
      - "callout: Important decision or note"
  
  project_spec:
    structure:
      - "heading_1: Project Name"
      - "callout: Project overview"
      - "heading_2: Requirements"
      - "numbered_list_item: Requirement 1"
      - "numbered_list_item: Requirement 2"
      - "heading_2: Technical Stack"
      - "table: Technologies and versions"
      - "heading_2: Timeline"
      - "paragraph: Milestone details"
  
  knowledge_base_article:
    structure:
      - "heading_1: Article Title"
      - "paragraph: Summary"
      - "toggle: Background Information"
      - "heading_2: How It Works"
      - "paragraph: Explanation"
      - "code: Example code"
      - "heading_2: Common Issues"
      - "toggle: Issue 1"
      - "toggle: Issue 2"
```

### Page Hierarchy

```yaml
hierarchy_management:
  nesting:
    depth: "Unlimited nesting levels"
    structure: "Parent → Child → Grandchild → ..."
    navigation: "Breadcrumb trail in UI"
  
  organization_patterns:
    workspace_root:
      level_1: "Main areas (Projects, Docs, Resources)"
      level_2: "Categories within areas"
      level_3: "Individual items or pages"
      level_4: "Sub-pages and details"
    
    project_structure:
      level_1: "Project page"
      level_2: "Documentation, Planning, Tasks"
      level_3: "Specific documents or task lists"
      level_4: "Meeting notes, specifications"
  
  database_pages:
    behavior: "Database pages are regular pages with properties"
    children: "Can contain content blocks like any page"
    templates: "Can have templates for new database items"
```

### Templates

```yaml
template_usage:
  creation:
    method: "Create template in database"
    access: "New button → Template selection"
    benefit: "Consistent structure for new pages"
  
  common_templates:
    task_template:
      properties: "Pre-filled status, priority defaults"
      content: "Standard task description format"
    
    meeting_template:
      properties: "Date, attendees fields"
      content: "Agenda, notes, action items structure"
    
    project_template:
      properties: "Status, owner, timeline fields"
      content: "Overview, requirements, resources structure"
  
  api_support:
    note: "Templates created via UI, not API"
    usage: "API creates pages that can use templates"
```

### Icons and Covers

```yaml
page_customization:
  icons:
    emoji:
      format: "{ emoji: '📘' }"
      support: "Any Unicode emoji"
    
    external:
      format: "{ external: { url: 'https://...' } }"
      requirement: "Public image URL"
  
  covers:
    external:
      format: "{ external: { url: 'https://...' } }"
      requirement: "Public image URL"
      recommended_size: "1500x600 pixels"
  
  note: "Direct file upload not supported - use external URLs"
```

---

<a id="6-search-collaboration"></a>

## 6. 🔍 SEARCH & COLLABORATION

### Native Search Operations

```yaml
API_post_search:
  description: "Search workspace content via native API"
  parameters:
    query:
      type: string
      optional: true
      description: "Search term (empty for all)"
    
    filter:
      type: object
      optional: true
      description: "Object type filter"
      options: "{ property: 'object', value: 'page' or 'database' }"
    
    sort:
      type: object
      optional: true
      description: "Sort order"
      options: "{ direction: 'ascending' or 'descending', timestamp: 'last_edited_time' }"
    
    page_size:
      type: integer
      optional: true
      description: "Results per page (max 100)"
  
  performance:
    small: "< 1 second"
    medium: "1-2 seconds"
    large: "2-3 seconds"
  pre_check: "Connection verified ✓"
  method: "Native API"
```

### Search Capabilities

```yaml
search_features:
  scope:
    pages: "All pages shared with integration"
    databases: "All databases shared with integration"
    content: "Searches titles and page content"
    results: "Ranked by relevance"
  
  filtering:
    by_type:
      pages_only: "{ property: 'object', value: 'page' }"
      databases_only: "{ property: 'object', value: 'database' }"
      all: "No filter applied"
    
    by_time:
      most_recent: "{ timestamp: 'last_edited_time', direction: 'descending' }"
      oldest_first: "{ timestamp: 'last_edited_time', direction: 'ascending' }"
  
  pagination:
    page_size: "Up to 100 results per query"
    cursor: "Use start_cursor for next page"
    handling: "Iterate through all results for large sets"
  
  limitations:
    - "Only searches content shared with integration"
    - "Cannot search archived pages (unless explicitly requested)"
    - "Search is case-insensitive"
    - "Results respect permission hierarchy"
```

### Search Patterns

```yaml
search_use_cases:
  find_page_by_title:
    query: "exact page title"
    filter: "{ property: 'object', value: 'page' }"
    expected: "Specific page match"
  
  find_database:
    query: "database name"
    filter: "{ property: 'object', value: 'database' }"
    expected: "Database match"
  
  keyword_search:
    query: "keyword or phrase"
    filter: "none (search all)"
    expected: "All matching content"
  
  recent_changes:
    query: ""  # empty for all
    sort: "{ timestamp: 'last_edited_time', direction: 'descending' }"
    expected: "Recently edited content"
```

### Native Comment Operations

```yaml
API_create_a_comment:
  description: "Add comment to page via native API"
  parameters:
    parent:
      type: object
      required: true
      description: "Page to comment on"
      format: "{ page_id: string }"
    
    rich_text:
      type: array
      required: true
      description: "Comment content"
      format: "[{ text: { content: string } }]"
  
  performance: "< 1 second"
  pre_check: "Connection verified ✓"
  method: "Native API"
```

### Comment Features

```yaml
comment_capabilities:
  threading:
    support: "Comments create discussion threads"
    replies: "Thread replies supported"
    notifications: "Mentioned users get notified"
  
  mentions:
    format: "@username"
    behavior: "User receives notification"
    requirement: "User must have page access"
  
  rich_text:
    formatting: "Bold, italic, code, links"
    links: "Hyperlinks to external resources"
    inline_code: "Code snippets in comments"
  
  resolution:
    status: "Threads can be resolved/unresolved"
    api_support: "Via Notion UI, not API"
    visibility: "Resolved threads collapsed by default"
```

### Native User Operations

```yaml
API_get_user:
  description: "Get user details via native API"
  parameters:
    user_id:
      type: string
      required: true
      description: "User UUID"
  
  performance: "< 1 second"
  pre_check: "Connection verified ✓"
  method: "Native API"

API_get_users:
  description: "List workspace users via native API"
  parameters:
    page_size:
      type: integer
      optional: true
      description: "Results per page (max 100)"
    
    start_cursor:
      type: string
      optional: true
      description: "Pagination cursor"
  
  performance: "< 1 second"
  pre_check: "Connection verified ✓"
  method: "Native API"

API_get_self:
  description: "Get bot user info via native API"
  parameters: {}
  
  performance: "< 1 second"
  pre_check: "Connection verified ✓"
  method: "Native API"
  note: "Used for connection verification"
```

### User Management

```yaml
user_types:
  person:
    description: "Human workspace members"
    properties:
      - "Name"
      - "Avatar"
      - "Email"
      - "Permissions"
    usage: "Assignees, collaborators, mentions"
  
  bot:
    description: "Integration users (like this MCP)"
    properties:
      - "Name"
      - "Owner (person who created integration)"
      - "Permissions (defined in integration)"
    usage: "API operations, automated tasks"
  
  permissions:
    workspace_level: "Full, editor, commenter, reader"
    page_level: "Inherit or custom"
    inheritance: "Children inherit parent permissions"
```

### Collaboration Workflows

```yaml
collaboration_patterns:
  document_review:
    sequence:
      - "Create review page"
      - "Add content for review"
      - "Mention reviewers in comments"
      - "Reviewers add feedback comments"
      - "Update content based on feedback"
      - "Resolve comment threads"
  
  team_wiki:
    sequence:
      - "Create knowledge base structure"
      - "Add team members to pages"
      - "Enable commenting on all pages"
      - "Team adds and updates content"
      - "Use search to find information"
  
  project_tracking:
    sequence:
      - "Create project database"
      - "Add tasks with assignees"
      - "Team updates task status"
      - "Comment on tasks for discussions"
      - "Query database for reporting"
```

---

<a id="7-limitations"></a>

## 7. ⚠️ LIMITATIONS

### Critical Limitations

```yaml
permission_model:
  restriction: "ABSOLUTE - Respects Notion's permissions"
  enforcement: "API-level permission checks"
  
  problem_scenarios:
    - "Content not shared with integration"
    - "Private pages without explicit access"
    - "Other workspaces (cannot access)"
    - "Archived content (unless specifically requested)"
  
  solution: "Share pages/databases with integration"
  
  sharing_methods:
    workspace_level:
      location: "Integration settings → Access tab"
      benefit: "Grant bulk access to pages"
    
    page_level:
      location: "Page menu → Connections → Add integration"
      benefit: "Fine-grained control"
  
  verification: "API_get_self to check bot permissions"

media_handling:
  problem: "Cannot upload files directly to Notion"
  solution: "Use external hosting services with URL references"
  
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
  
  workaround:
    images: "Use external URL in image blocks"
    files: "Use external URL in file blocks"
    covers: "Use external URL for page covers"

connection_requirements:
  dependencies:
    - "MCP server must be connected"
    - "Integration token must be valid"
    - "Test query must pass (API_get_self)"
    - "Content must be shared with integration"
    - "Rate limits must be respected"
  
  enforcement: "Cannot proceed without these"

rate_limiting:
  limits:
    per_second: 3  # average
    burst: "Slightly higher for short periods"
    safe_operating: 2.5
    warning_threshold: 2.8
    cooldown_period: "Automatic by Notion API"
    requires_connection: true
  
  enforcement: "Automatic throttling by Notion"
  handling: "Exponential backoff on rate limit errors"

workspace_isolation:
  restriction: "Single workspace per integration"
  cannot_access:
    - "Other workspaces"
    - "Personal pages outside workspace"
    - "Guest access pages (unless explicitly shared)"
  
  enforcement: "Token scoped to one workspace"

api_limitations:
  view_configuration:
    limitation: "Cannot create/modify database views via API"
    workaround: "Create database via API, configure views in UI"
  
  template_creation:
    limitation: "Cannot create templates via API"
    workaround: "Create template structure manually in UI"
  
  permission_management:
    limitation: "Cannot modify permissions via API"
    workaround: "Manage permissions in Notion UI"
  
  workspace_settings:
    limitation: "Cannot access/modify workspace settings"
    workaround: "Settings managed by workspace owner in UI"
```

### Error Handling

```yaml
common_errors:
  connection_lost:
    cause: "MCP server crashed or network issue"
    solution: "Restart Claude Desktop / Check network"
    fallback: "Verify MCP configuration"
  
  invalid_token:
    cause: "Token expired, revoked, or incorrect"
    solution: "Regenerate integration token"
    fallback: "Recreate integration if needed"
  
  not_shared:
    cause: "Page/database not shared with integration"
    solution: "Share content with integration"
    fallback: "Check integration has proper access"
  
  rate_limited:
    cause: "Too many requests in short period"
    solution: "Wait and retry with exponential backoff"
    fallback: "Batch operations to reduce request count"
  
  parent_not_found:
    cause: "Invalid parent page/database ID"
    solution: "Verify parent exists and is accessible"
    fallback: "Create parent first, then child"
  
  invalid_property:
    cause: "Property type mismatch or invalid value"
    solution: "Check property schema and value format"
    fallback: "Use correct property type and format"
  
  archived_page:
    cause: "Attempting to modify archived page"
    solution: "Unarchive page first"
    fallback: "Find active version or create new page"

error_recovery_protocol:
  REPAIR_sequence:
    R: "Recognize: Identify error type from API response"
    E: "Evaluate: Assess impact and recovery options"
    P: "Plan: Choose best recovery strategy"
    A: "Apply: Execute recovery action"
    I: "Inspect: Verify recovery successful"
    R: "Report: Communicate status to user"
  
  implementation: |
    async function handleNotionError(error) {
        // R - Recognize
        const errorType = classifyError(error);
        
        // E - Evaluate
        const severity = assessImpact(errorType);
        
        // P - Plan
        const strategy = selectStrategy(errorType);
        
        // A - Apply
        try {
            const result = await executeRecovery(strategy);
            
            // I - Inspect
            if (await verifyRecovery(result)) {
                // R - Report success
                return { success: true, result };
            }
        } catch (recoveryError) {
            // R - Report failure
            return { 
                success: false, 
                error: recoveryError,
                fallback: getFallbackOptions(errorType)
            };
        }
    }
```

### Performance Characteristics

```yaml
performance:
  engine: "Notion REST API v1"
  characteristics:
    - "Integration token authentication"
    - "Rate limited (3/second)"
    - "Paginated responses (100 max)"
    - "Native operations only"
  
  benchmarks:
    connection_check: "< 1 second"
    database_create: "2-3 seconds"
    page_create: "1-2 seconds"
    query_database: "< 1 second (small), 2-4 seconds (large/paginated)"
    search: "< 1 second (small), 2-3 seconds (large)"
    block_append: "1-2 seconds (few blocks), 4-8 seconds (many blocks)"
    comment_create: "< 1 second"
```

---

<a id="8-quick-reference"></a>

## 8. 🏎️ QUICK REFERENCE

### MCP Tools Summary

**Complete tool list:** See [GitHub repository](https://github.com/makenotion/notion-mcp-server) for all available tools and parameters.

**Key tools:**

```yaml
tools:
  # Connection & Users
  API_get_self:
    purpose: "Connection check, get bot user info"
    parameters: []
    category: "Connection verification"
  
  API_get_user:
    purpose: "Get user details"
    key_params: [user_id]
    category: "User management"
  
  API_get_users:
    purpose: "List workspace users"
    key_params: [page_size, start_cursor]
    category: "User management"
  
  # Search
  API_post_search:
    purpose: "Search workspace"
    key_params: [query, filter, sort]
    category: "Search"
  
  # Pages
  API_post_page:
    purpose: "Create new page"
    key_params: [parent, properties, children]
    category: "Page management"
  
  API_patch_page:
    purpose: "Update page"
    key_params: [page_id, properties, archived]
    category: "Page management"
  
  API_retrieve_a_page:
    purpose: "Get page details"
    key_params: [page_id]
    category: "Page management"
  
  # Databases
  API_create_a_database:
    purpose: "Create new database"
    key_params: [parent, title, properties]
    category: "Database management"
  
  API_post_database_query:
    purpose: "Query database"
    key_params: [database_id, filter, sorts]
    category: "Database management"
  
  # Blocks
  API_get_block_children:
    purpose: "Get blocks in page/block"
    key_params: [block_id, page_size]
    category: "Content management"
  
  API_patch_block_children:
    purpose: "Append blocks"
    key_params: [block_id, children]
    category: "Content management"
  
  # Comments
  API_create_a_comment:
    purpose: "Add comment"
    key_params: [parent, rich_text]
    category: "Collaboration"

tool_categories:
  workspace:
    - "User management"
    - "Search operations"
    - "Connection verification"
  
  structure:
    - "Database creation and querying"
    - "Page creation and updates"
  
  content:
    - "Block operations"
    - "Rich text formatting"
  
  collaboration:
    - "Comments"
    - "User mentions"
```

### Integration References

```yaml
official_documentation:
  notion_mcp_github:
    url: "https://github.com/makenotion/notion-mcp-server"
    description: "Official Notion MCP server repository"
  
  npm_package:
    url: "https://www.npmjs.com/package/@makenotion/notion-mcp-server"
    description: "NPM package page"
  
  notion_api_docs:
    url: "https://developers.notion.com/reference/intro"
    description: "Official Notion API documentation"
  
  integration_setup:
    url: "https://www.notion.so/profile/integrations"
    description: "Create and manage integrations"

related_documents:
  thinking_framework:
    file: "ClickUp & Notion - Thinking Framework - v0.200"
    purpose: "Methodology and cognitive framework"
    sections:
      - "Decision-making processes"
      - "Operation sequencing"
      - "Quality assurance"
    key_concepts:
      - "Survey: Context assessment and operation identification"
      - "Yield: Native pattern selection and optimization"
      - "Navigate: Sequential API operations"
      - "Create: Quality validation + integration delivery"
  
  interactive_intelligence:
    file: "ClickUp & Notion - Interactive Intelligence - v0.200"
    purpose: "Conversation flows and interaction patterns"
    sections:
      - "Conversation Architecture"
      - "Response Templates"
      - "Error Recovery (REPAIR protocol)"
    integration: "Works with Thinking Framework for complete workflow"
  
  error_handling:
    reference: "Section 7: LIMITATIONS"
    includes:
      - "Connection diagnostics"
      - "REPAIR protocol application"
      - "Recovery workflows"
```

### Decision Tree

```
Request received
    ↓
Verify MCP connection → Failed → Apply REPAIR
    ↓ Success
Check permissions → Not shared → Share with integration
    ↓ Shared
Need database? → Yes → Database operations
    ↓ No
Need pages? → Yes → Page operations
    ↓ No
Need search? → Yes → Search operations
    ↓ No
Ask for clarification
```

### Capability Check

```python
can_do = {
    'connection_required': True,  # ALWAYS
    'databases': True,
    'pages': True,
    'blocks': True,
    'search': True,
    'comments': True,
    'users': True,
    'relations': True,
    'rich_text': True,
    'file_upload': False,  # URLs only
    'custom_code': False,  # N/A
    'native_operations': True  # ALWAYS
}
```

### Pre-Operation Protocol

```markdown
Every Operation Requires:

1. Connection verification ✓
2. Test query successful (API_get_self) ✓
3. Content shared with integration ✓
4. Native approach confirmed ✓
5. Rate limits respected ✓
6. Ready to execute ✓
```

### Critical Rules Summary

```markdown
THE FIVE ABSOLUTES:

1. Connection verified before EVERY operation
2. Native APIs ONLY - no custom code (N/A)
3. Test query must pass before proceeding
4. Content must be shared with integration
5. REPAIR protocol for all errors
```

### Quick Command Reference

```yaml
common_operations:
  create_database:
    command: "API_create_a_database"
    required: "[parent, title, properties]"
    example: "Create task database in Projects page"
  
  query_data:
    command: "API_post_database_query"
    required: "[database_id]"
    optional: "[filter, sorts, page_size]"
    example: "Get all In Progress tasks"
  
  create_page:
    command: "API_post_page"
    required: "[parent, properties]"
    optional: "[children]"
    example: "Create meeting notes with initial content"
  
  add_content:
    command: "API_patch_block_children"
    required: "[block_id, children]"
    example: "Add paragraphs and headings to page"
  
  search_workspace:
    command: "API_post_search"
    optional: "[query, filter, sort]"
    example: "Find all pages about API documentation"
  
  add_comment:
    command: "API_create_a_comment"
    required: "[parent, rich_text]"
    example: "Comment on project review page"
```

### Performance Status Display

```markdown
📊 Notion Performance

Connection: Active
Response time: 145ms
API calls: 8/180 per minute (3/sec rate)
Queue: 0 operations

Operating normally
```

### Integration with ClickUp & Notion Helper

```yaml
helper_integration:
  workflow:
    1: "Helper verifies Notion connection"
    2: "Receives natural language request"
    3: "Identifies Notion as best platform for content/knowledge"
    4: "Routes to Notion MCP"
    5: "Applies smart defaults based on use case"
    6: "Executes operation with progress tracking"
    7: "Returns organized workspace with next steps"
  
  use_case_routing:
    knowledge_management: "Route to Notion (wikis, docs, knowledge bases)"
    task_management: "Route to ClickUp (tasks, projects, workflows)"
    documentation: "Route to Notion (specs, guides, references)"
    project_tracking: "Route to ClickUp (milestones, sprints, deliverables)"
    content_calendar: "Route to Notion (publishing, content planning)"
    team_collaboration: "Both (Notion for docs, ClickUp for execution)"
  
  example_conversation:
    input: "Set up a knowledge base for our team"
    process: |
      Helper: [Checking Notion connection...]
      → Connection verified ✔
      → Notion best for knowledge management
      → Creating hierarchical structure
      → Adding templates for consistency
      → Result: Knowledge base ready with 5 sections
```

---

*This document focuses exclusively on Notion MCP server capabilities and technical specifications. For thinking methodology and cognitive framework, see ClickUp & Notion - Thinking Framework v0.200. For conversation flows and error handling (REPAIR protocol), see ClickUp & Notion - Interactive Intelligence v0.200.*
