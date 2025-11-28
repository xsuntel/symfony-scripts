# Tools

## IDE - Visual Studio Code

### Config

#### .vscode

* Tasks

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Deploy Shell-Script for Linux",
            "type": "shell",
            "command": "./scripts/deploy/linux/ubuntu/deploy.sh",
            "group": "build",
            "presentation": {
                "reveal": "always",
                "panel": "new"
            }
        }
    ]
}
```

#### Extension

* App
  * CSS
    * Tailwind CSS IntelliSense
  * Javascript
    * JavaScript (ES6) code snippets
  * PHP
    * PHP Namespace Resolver
    * PHP Intelephense
    * PHP IntelliSenseCode-runner: Enable App Insights - false
    * PHP Debug          (Xdebug)
    * PHPDoc Comment
  * Symfony Framework
    * Symfony for VSCode (fixed)
    * Symfony UX Twig Component
    * Modern Twig

* Cache
  * Redis for VS Code  (Redis)

* Database
  * PostgreSQL (Microsoft)

* Tools
  * IDE
    * Draw.io Integration
    * Markdownlint
    * Material Icon Theme
    * Code Runner
  * AI
    * Gemni Code Assist (Google)
    * Gemini CLI Companion

#### Settings

* Application / Proxy

```text
Use Local Proxy Configuration - UnChecked
```

* Extensions / .ipynb Support

```text
Experimental: Serialization - UnChecked
```

#### Settings - Language

* PHP

```text
Manage / Settings / PHP Suggest Basic - false
```

#### Settings - Tools

* GitHub

```text
Chat: Disable AI Features - Disable (Checked)
Pgsql › Copilot: Enable   - UnChecked
```

* Code Runner

```text
Code-runner: Enable App Insights - false
Code-runner: Run In Terminal - true
```

* Copilot

```text
Chat: Disable AI Features - Disable (Checked)
Pgsql › Copilot: Enable   - UnChecked
```

## Reference

### Whale Browser

* Update apt-key

```bash
sudo apt-key export EF6C07F6 | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/whale-key.gpg
sudo apt update
```

### IDE

* [VSCode](https://code.visualstudio.com/docs/languages/php)
