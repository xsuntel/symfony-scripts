# Tools - AI

## Google - Gemini CLI

### Config

* /chat
* /memory
* /clear
* /stats
* /theme

#### Settings

* Global Context

```text
vi  ~/.gemini/GEMINI.md
```

* Project Context

```text
vi  ~/{project_folder}/.gemini/GEMINI.md
```

* Settings : settings.json

```text
vi  ~/.gemini/settings.json


{
  "hasSeenIdeIntegrationNudge": true,
  "ideMode": true,
  "selectedAuthType": "oauth-personal",
    "mcpServers": {
      "context7": {
        "httpUrl": "https://mcp.context7.com/mcp",
        "headers": {
          "CONTEXT7_API_KEY": "YOUR_API_KEY",
          "Accept": "application/json, text/event-stream"
      }
    }
  },
}
```

* Environment : .env

```text
vi  ~/.gemini/.env
```

## Reference

* AI - Google
  * [Gemini](https://code.visualstudio.com/docs/languages/php)
* MCP
  * [context7](https://context7.com/websites/symfony_com-doc-current)
