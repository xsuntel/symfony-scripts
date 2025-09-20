# Tools - AI - Google - Gemini CLI

## Environment - Dev/Prod

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
```

* Configure Context : settings.json

```text
vi  ~/.gemini/settings.json

{
	"mcpServers": {
		"context7": {
			"httpUrl": "https://symfony.com/doc/current/"
		}
	}
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