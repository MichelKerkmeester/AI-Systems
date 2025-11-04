# Webflow Agent - User Guide v0.501

A full-stack development assistant that creates and manages Webflow sites through natural language. With Designer and Data API integration, it builds complete structures, design components, and manages content - transforming ideas into functioning Webflow sites.

## 📋 Table of Contents

1. [🆕 WHAT'S NEW IN V0.501](#1-whats-new-in-v0501)
2. [✨ KEY FEATURES](#2-key-features)
3. [🌳 SYSTEM ARCHITECTURE](#3-system-architecture)
4. [🚀 QUICK SETUP](#4-quick-setup)
5. [🔧 INSTALLING WEBFLOW MCP](#5-installing-webflow-mcp)
6. [🎨 DESIGNER API SETUP](#6-designer-api-setup)
7. [🔌 CONNECTION VERIFICATION](#7-connection-verification)
8. [🧠 HOW IT WORKS](#8-how-it-works)
9. [💬 EXAMPLE INTERACTIONS](#9-example-interactions)
10. [📊 WHAT GETS CREATED](#10-what-gets-created)
11. [📦 VERSION HISTORY](#11-version-history)
12. [📚 RESOURCES](#12-resources)

---

<a id="1-whats-new-in-v0501"></a>

## 1. 🆕 WHAT'S NEW IN V0.501

### Major Update: Transparent ATLAS Processing
- **ATLAS Framework**: Intelligent 5-phase methodology (Assess → Transform → Layer → Apply → Synthesize) for optimal Webflow operations
- **Two-Layer Transparency**: Full cognitive rigor internally, concise progress updates externally
- **Smart API Coordination**: Automatic selection of optimal API strategy (Data first, Designer second, or parallel)

### Enhanced System Intelligence
- **Intelligent Context Assessment**: Extracts user intent from minimal information and suggests optimal native approaches
- **Native API Optimization**: Balance structure vs design automatically based on use case
- **Proactive Guidance**: Suggests improvements beyond immediate request
- **Reality Check**: Verifies MCP capabilities before promising features
- **Clean Interface**: No dividers rule - only bullets and headers for cleaner responses

### Core Capabilities Remain
- Full Designer API integration for visual development
- Complete Data API for structure and content
- Create collections, fields, and relationships
- Build components and design systems
- Manage responsive layouts and SEO

---

<a id="2-key-features"></a>

## 2. ✨ KEY FEATURES

### Complete Development Capabilities

**Designer API Features:**
- Build elements using native Webflow Designer API
- Apply styles through API calls only
- Create reusable components natively
- Manage breakpoints via API
- Use Webflow's design tokens
- Real-time preview in Designer

**Data API Features:**
- Build complete data structures
- Add any field type to collections
- Create references between collections
- Full CRUD on items
- Manage draft/live states
- SEO optimization

**Important**: The system NEVER writes custom JavaScript, CSS, or HTML code. All operations use native Webflow APIs exclusively.

### System Features
- **Connection First**: Always verifies MCP connection
- **ATLAS Processing**: Transparent 5-phase methodology
- **Interactive Mode**: Single comprehensive questions
- **Clear Feedback**: Visual progress for every operation

---

<a id="3-system-architecture"></a>

## 3. 🌳 SYSTEM ARCHITECTURE

```
AGENTS.md → Entry point with intelligent routing logic
    ↓
MCP System - Webflow - v0.501.md (System prompt with ATLAS integration)
    ↓
ATLAS Thinking Framework v0.301 (5-phase methodology with cognitive rigor)
    ↓
Interactive Intelligence v0.400 (Conversation flow with two-layer transparency)
    ↓
MCP Knowledge v0.400 (Designer & Data API specifications)
    ↓
Output → Native Webflow operations via MCP server
```

---

<a id="4-quick-setup"></a>

## 4. 🚀 QUICK SETUP

### Step 1: Create a Claude Project
1. Go to claude.ai
2. Click "Projects" in sidebar
3. Create new project named "Webflow Agent"

### Step 2: Add System Instructions
1. Click "Edit project details"
2. Find "Custom instructions" section
3. Copy and paste: `MCP System - Webflow.md` (v0.501)
4. Save the project

### Step 3: Upload Reference Documents
Add these documents to your project:
- `Webflow - MCP Knowledge.md` (v0.400)
- `Webflow - Interactive Intelligence.md` (v0.400)
- `Webflow - ATLAS Thinking Framework.md` (v0.301)

### Step 4: Continue to MCP Installation
Follow the installation guide in the next section

### Step 5: Start Building!
```
Create complete blog with categories
Build hero component with animations
Design responsive navigation
Setup e-commerce catalog
```

---

<a id="5-installing-webflow-mcp"></a>

## 5. 🔧 INSTALLING WEBFLOW MCP

### Recommended: OAuth Remote Setup

**Config Location:**
- Mac/Linux: `~/.config/claude/claude_desktop_config.json`
- Windows: `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "webflow": {
      "command": "npx",
      "args": ["mcp-remote", "https://mcp.webflow.com/sse"]
    }
  }
}
```

After saving:
1. Restart Claude Desktop (Cmd/Ctrl + R)
2. Browser opens for OAuth authorization
3. Authorize the sites you want to access
4. MCP Bridge App auto-installs to authorized sites
5. System verifies connection automatically

### Alternative: Token-Based Setup
```json
{
  "mcpServers": {
    "webflow": {
      "command": "npx",
      "args": ["-y", "@webflow/mcp-server"],
      "env": {
        "WEBFLOW_TOKEN": "your-api-token-here"
      }
    }
  }
}
```

Get your token from [Webflow API Settings](https://webflow.com/dashboard/account/apps).

---

<a id="6-designer-api-setup"></a>

## 6. 🎨 DESIGNER API SETUP

### Enabling Designer Operations

1. **Open Webflow Designer**
   - Navigate to your project
   - Open in Designer mode

2. **Launch MCP Bridge App**
   - Press 'E' to open Apps panel
   - Find "Webflow MCP Bridge App"
   - Click to launch
   - Keep open during session

3. **Verify Connection**
   - App shows "Connected" status
   - Agent confirms Designer access
   - Ready for native operations

### What Requires the App

**Needs App (Designer API):**
- Creating native elements
- Applying native styles
- Building native components
- Managing responsive design

**Works Without App (Data API):**
- Creating collections
- Adding fields
- Managing content
- Publishing items

---

<a id="7-connection-verification"></a>

## 7. 🔌 CONNECTION VERIFICATION

### Automatic Connection Check

The system automatically verifies MCP connection before operations:

```markdown
🔧 Webflow Connection Check

✔ MCP Server: Connected
✔ Data API: Ready
✔ Designer API: Ready (app required)
✔ Authentication: Valid
```

### Test Query Protocol
- Executes `webflow:sites_list()` to verify connection
- If successful: Proceeds with operations
- If failed: Provides setup guidance

---

<a id="8-how-it-works"></a>

## 8. 🧠 HOW IT WORKS

### ATLAS Processing Framework

The system uses intelligent 5-phase ATLAS methodology:

```markdown
📊 ATLAS Processing:

A - Assess: Understanding context and requirements
T - Transform: Converting to optimal native approach
L - Layer: Structuring operations intelligently
A - Apply: Executing through native APIs
S - Synthesize: Validating and delivering results

Internal: Full cognitive rigor (10 rounds optimization)
External: Concise progress updates only
```

### Native API Operations Only

```markdown
✅ CORRECT Approach:

• Uses webflow:components_create()
• Uses webflow:pages_update_static_content()
• Uses webflow:collections_items_create_item_live()
• All operations through MCP server

❌ NEVER Does This:

• Write custom JavaScript code
• Create CSS snippets
• Generate HTML templates
• Build code outside Webflow
```

### Execution Modes

The system provides two execution modes:

```markdown
📊 Standard Mode:

• Default for all operations
• Full ATLAS processing (5 phases)
• Best for complex tasks
• Shows concise progress updates
```

---

<a id="9-example-interactions"></a>

## 9. 💬 EXAMPLE INTERACTIONS

### Creating a Blog System
```
User: Create a blog system

System: 
🔧 Webflow Connection Check

✔ MCP Server: Connected
✔ Data API: Ready

I'll create a complete blog system for you!

📊 ATLAS Processing:

A - Assess: Blog system with scalable architecture
T - Transform: Collections + relationships structure
L - Layer: Posts → Authors → Categories
A - Apply: Creating via Data API...
S - Synthesize: Validating structure...

🔧 Webflow Operation

Operation: Blog structure creation

📂 Processing:
├── Creating collections ✔
├── Adding fields ✔
└── Setting relationships ✔

Progress: [████████████████] 100%
API calls: 15/60 🟢

✅ Operation Complete!

📊 Results:
├── Collections: 3 created
├── Fields: 18 added
└── Relationships: 2 configured

💡 Reference fields link your content!
```

---

<a id="10-what-gets-created"></a>

## 10. 📊 WHAT GETS CREATED

### Full Stack Example - Blog System

```javascript
// Data Structure (Created via Data API)
Collections: {
  BlogPosts: {
    fields: ['title', 'content', 'excerpt', 'featured_image',
             'author', 'categories', 'published_date']
  },
  Authors: {
    fields: ['name', 'bio', 'avatar']
  },
  Categories: {
    fields: ['name', 'slug', 'description']
  }
}

// Components (Created via Designer API)
Components: {
  BlogCard: 'Native Webflow component',
  AuthorBio: 'Native author block',
  CategoryFilter: 'Native filtering component'
}
```

---

<a id="11-version-history"></a>

## 11. 📦 VERSION HISTORY

### v0.501 (Current)
- Introduced transparent ATLAS processing framework (5-phase methodology)
- Enhanced MCP integration with mandatory connection verification
- Improved intelligent context assessment and solution finding
- Added two-layer transparency model (internal rigor + concise updates)
- Streamlined conversation architecture with comprehensive questions
- Updated all knowledge base files to latest versions
- Removed deprecated pattern learning system
- Enhanced native API coordination and optimization

### v0.415
- Simplified architecture removing complex thinking mechanisms
- Streamlined execution flow
- Cleaner codebase with direct operations
- Maintained all core Webflow capabilities

### v0.414
- Introduced automatic processing systems
- Enhanced connection verification
- Improved error handling

### v0.413
- Initial MCP integration
- Designer and Data API support
- Basic command structure

---

<a id="12-resources"></a>

## 12. 📚 RESOURCES

### Essential Links
- [Webflow MCP Server](https://github.com/webflow/mcp-server)
- [Designer API Docs](https://developers.webflow.com/designer/reference)
- [Data API Docs](https://developers.webflow.com/data/reference)
- [MCP Protocol](https://modelcontextprotocol.io/)

### Quick References
- [Get API Token](https://webflow.com/dashboard/account/apps)
- [Webflow Designer](https://webflow.com/designer)
- [Claude Desktop](https://claude.ai/download)
- [Cloudinary](https://cloudinary.com/) - Image hosting
