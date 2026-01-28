# Tools - AI

## Antigravity

### Prompt Guide

PROMPT

* P : Persona
* R : Reference
* O : Objective
* M : Mode, Message format
* P : Point of View
* T : Tone

### Config

#### Extension

* App
  * CSS
    * Tailwind CSS IntelliSense                (Tailwind Labs)
  * Javascript
    * ESLint                                   (Microsoft)
    * Stimulus LSP                             (Marco Roth)
  * PHP
    * PHP Intelephense                         (Intelephense)
    * PHP Debug                                (Xdebug)
  * Symfony Framework
    * Twig Language 2                          (mblode)
* Tools
  * IDE
    * YAML                                     (RedHat)
    * DotENV                                   (mikestead)
    * Prettier - Code formatter                (Prettier)
    * Markdownlint                             (David Anson)
    * Material Icon Theme                      (Philipp Kief)
    * Run in Terminal                          (kortina)

### Agent

#### Customizations

##### Rules

```bash
vi  ~/.agent/rules/
```

##### Gemini

* Project Context

```bash
vi  ~/{project_folder}/.gemini/GEMINI.md
```

### MCP Servers

* Manage MCP Servers

```bash
vi  ~/{project_folder}/.mcp_config.json
```

```json
{
  "mcpServers": {

    "context7": {
      "serverUrl": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "YOUR_API_KEY"
      }
    },

    "github": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-github"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "<YOUR_TOKEN>"
      }
    }
  }
}

```

### Scheduler

## Reference

* IDE
  * [Antigravity](https://antigravity.google/)

* MCP Servers
  * [Context7](https://context7.com/)
