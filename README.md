# README

This project includes some shell-scripts for Full-Stack developers building web applications with the [Symfony Framework](https://symfony.com)

## Environment

* Dev
  * App : PHP - Symfony Framework
  * Cache : Redis
  * Database : PostgreSQL
  * Message : RabbitMQ, Redis
  * Server : Nginx
  * Utility : Git, Docker
  * Tools : PhpStorm, VSCode

* Prod
  * AWS (Amazon Web Services)
  * GCP (Google Cloud Platform)
  * NCloud (Naver Cloud Platform)

## Platform

* Linux - Ubuntu
* Mac - OS
* Windows - WSL2 (Ubuntu)

  ```text
  # WSL2
  # Windows Explorer:
  \\wsl.localhost\Ubuntu\home\[username]\
  # (legacy form, still valid)
  \\wsl$\Ubuntu\home\[username]\
  ```

  ```text
  # VSCode
  Ctrl + Shift + P
  → Select "Terminal: Select Default Profile"
  → Select "Ubuntu (WSL)" or "WSL"
  ```

## Project

* Directory Structure

```text
./                                    ← Repository root
├── app/                              ← Symfony Framework
├── diagram/                          ← draw.io diagrams
│   ├── base/
│   ├── containers/
│   └── deploy/
├── scripts/                          ← Shell scripts
│   ├── base/
│   ├── containers/
│   └── deploy/
├── tools/                            ← Tooling docs (AI assistants, IDEs)
│   ├── ai/                           ← anthropic / google / microsoft
│   └── ide/                          ← phpstorm / vscode
├── .claude/                          ← Claude Code config
├── .github/                          ← GitHub config (PR template, Actions)
├── .idea/                            ← JetBrains IDE workspace config
├── .vscode/                          ← VSCode workspace config
├── .env.app
├── .env.dev
├── .env.prod
├── .gitattributes
├── .gitignore
├── .mcp.json
├── CLAUDE.md
├── GEMINI.md
├── LICENSE
├── README.md
├── REVIEW.md
└── TODO.md
```

### Dev Environment

#### Requirement

* Update your name and email for Git

  ```bash
  git config --global user.name "{Your Name}"
  ```

  ```bash
  git config --global user.email "{Your Email}"
  ```

  ```bash
  git config --global init.defaultBranch main
  git config --global credential.helper store

  git config --global --list
  ```

#### Work Directory

* Create a folder (example)

  ```bash
  mkdir -p ~/Repositories
  mkdir -p ~/Repositories/GitHub

  cd ~/Repositories/GitHub
  ```

* Download this project

  ```bash
  git clone https://github.com/xsuntel/symfony-scripts.git
  ```

  ```bash
  cd symfony-scripts && find ./scripts/ -type f -name "*.sh" -exec chmod 775 {} \;
  ```

* Update default
  variables : [TimeZone](https://www.php.net/manual/en/timezones.php) / [Symfony Releases](https://symfony.com/releases)

  ```text
  vi .env.app

  # >>>> Platform
  PLATFORM_TIMEZONE="{Your TimeZone}"

  # >>>> Project
  PROJECT_DOMAIN="{Your Web domain}"

  # >>>> PHP
  SYMFONY_VERSION="{Symfony Releases}"
  ```

* Create a new webapp : [Installing & Setting up the Symfony Framework](https://symfony.com/doc/current/setup.html)

  ```bash
  ./tools/ide/tutorial.sh
  ```

#### Deployment

* Linux - [Document](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/deploy/dev/linux/ubuntu/_ABSTRACT.md)
* Mac - OS - [Document](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/deploy/dev/mac/os/_ABSTRACT.md)
* Windows - [Document](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/deploy/dev/windows/wsl/_ABSTRACT.md)

#### MCP Servers

* GitHub - Settings / Developer settings / Personal access tokens / Tokens (classic) - repo (only)

  ```bash
  claude mcp add -s user --transport http github https://api.githubcopilot.com/mcp --header "Authorization: Bearer YOUR_GITHUB_PAT"
  ```

  ```bash
  vi ~/.claude.json
  ```

  ```json
  {
    "mcpServers": {
      "github": {
        "type": "http",
        "url": "https://api.githubcopilot.com/mcp",
        "headers": {
          "Authorization": "Bearer YOUR_GITHUB_PAT"
        }
      }
    }
  }
  ```

### Prod Environment

#### Public Cloud

* [AWS (Amazon Web Services)](https://aws.amazon.com) - ECS
* [GCP (Google Cloud Platform)](https://cloud.google.com) - Cloud Run
* [NCloud (Naver Cloud Platform)](https://www.ncloud.com) - VM

## Tools

* AI
  * Anthropic - [Claude Code](https://claude.com)
  * Google - [Gemini Code Assist](https://codeassist.google/)
  * GitHub - [Copilot](https://copilot.microsoft.com)
* IDE
  * [PhpStorm](https://www.jetbrains.com/phpstorm)    - [Document](https://github.com/xsuntel/symfony-scripts/blob/main/tools/ide/phpstorm/_ABSTRACT.md)
  * [Visual Studio Code](https://code.visualstudio.com)      - [Document](https://github.com/xsuntel/symfony-scripts/blob/main/tools/ide/vscode/_ABSTRACT.md)
    * Extension - [symfony-extention](https://github.com/xsuntel/symfony-extention)

## Reference

* [PHP](https://www.php.net)
  * [Symfony Framework](https://symfony.com)
    * [SymfonyCasts](https://symfonycasts.com)

## License

This is available under the MIT License.
