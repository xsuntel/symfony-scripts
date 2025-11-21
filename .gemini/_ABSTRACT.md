# Tools

## Google - Gemini CLI

### Config

* /chat   : 대화 기록 저장, 재개 및 목록 확인
* /memory : AI manigement - GEMINI.md
* /clear  : 터미너 화면 및 대확 컨텍스트 삭제
* /stats  : 현재 세션의 토큰 사용량 표시
* /theme  : CLI의 시각적 테마 변경

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
