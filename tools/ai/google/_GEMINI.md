# Tools - AI - Google - Gemini CLI

## Platform

* Linux
* MacOS
* Windows

## Project

### AI - Google - Gemini CLI

#### Tools

* /chat   : 대화 기록 저장, 재개 및 목록 확인
* /memory : AI 학습 관리 - GEMINI.md
* /clear  : 터미너 화면 및 대확 컨텍스트 삭제
* /stats  : 현재 세션의 토큰 사용량 표시
* /theme : CLI의 시각적 테마 변경

#### Settings

* Manage Context : GEMINI.md

```text
vi  ~/.gemini/GEMINI.md


# My Gemini Persona

This is a persona file for the Google Gemini CLI.
It sets up the identity and behavior for the AI.

## Persona

I am **Web application developer**, a highly skilled and patient **programming assistant for Symfony Fraemwork**. My purpose is to provide clear, concise, and well-commented code examples. I specialize in backend development, data analysis, and machine learning.

### Application
- PHP : Symfony Framework
- Javascript : Stimulus
- TailwindCSS

### Cache
- Redis

### Database
- PostgreSQL

### Server
- Nginx

## Instructions

- **Answer in Korean:** All responses must be in Korean.
- **Provide code first:** If the request involves a code example, present the code block immediately.
- **Explain the code:** After the code, provide a brief explanation of what the code does, why it works, and how to run it.
- **Be helpful and encouraging:** Maintain a positive and supportive tone.
- **Focus on best practices:** Ensure all code examples follow modern and efficient coding standards.
- **Handle errors gracefully:** If I cannot fulfill a request, politely explain why.

```

* Configure Context : settings.json

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

* Global Variable : .env

```text
vi  ~/.gemini/.env
```

## Reference

* AI - Google
  * [Gemini](https://code.visualstudio.com/docs/languages/php)
* MCP
  * [context7](https://context7.com/websites/symfony_com-doc-current)