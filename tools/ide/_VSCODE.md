# Tools

## IDE - Visual Studio Code

### Config

#### Extension

* App
  * CSS
    * Tailwind CSS IntelliSense                (Tailwind Labs)
  * HTML
    * Auto Closing Tags                        (Codegyan)
  * Javascript
    * ESLint                                   (Microsoft)
    * Stimulus LSP                             (Marco Roth)
  * PHP
    * PHP Intelephense                         (Intelephense)
    * PHP Debug                                (Xdebug)
  * Symfony Framework
    * Symfony for VSCode (fixed)               (SplasHmiCH)
    * Symfony UX Twig Component                (Sander Verschoor)
    * Twig Language 2                          (mblode)
* Cache
  * Redis for VS Code                          (Redis)
* Database
  * PostgreSQL                                 (Microsoft)
* Tools
  * IDE
    * YAML                                     (RedHat)
    * DotENV                                   (mikestead)
    * Prettier - Code formatter                (Prettier)
    * Markdownlint                             (David Anson)
    * Material Icon Theme                      (Philipp Kief)
* Util
  * Draw.io Integration                        (Henning Dieterichs)

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

#### .vscode

* Tasks

```json
{
    "version": "2.0.0",
    "tasks": [
        // -------------------------------------------------------------------------------
        // App
        // -------------------------------------------------------------------------------
        {
            "label": "App - Deploy an application",
            "type": "shell",
            "command": "./scripts/deploy/dev/linux/ubuntu/deploy.sh",       // Select Platform
            "group": "build",
            "presentation": {
                "reveal": "always",
                "panel": "new"
            }
        },
        // -------------------------------------------------------------------------------
        // Cache
        // -------------------------------------------------------------------------------
        {
            "label": "Cache - Clear cache files",
            "type": "shell",
            "command": "./scripts/cachesh",
            "group": "build",
            "presentation": {
                "reveal": "always",
                "panel": "new"
            }
        },
        // -------------------------------------------------------------------------------
        // Database
        // -------------------------------------------------------------------------------
        {
            "label": "Database - Execute migrations",
            "type": "shell",
            "command": "./scripts/migrate.sh",
            "group": "build",
            "presentation": {
                "reveal": "always",
                "panel": "new"
            }
        },
        // -------------------------------------------------------------------------------
        // Server
        // -------------------------------------------------------------------------------
        {
            "label": "Server - Check status of the server",
            "type": "shell",
            "command": "./scripts/status.sh",
            "group": "build",
            "presentation": {
                "reveal": "always",
                "panel": "new"
            }
        }
    ]
}
```

## Reference

### IDE

* [VSCode](https://code.visualstudio.com/docs/languages/php)
