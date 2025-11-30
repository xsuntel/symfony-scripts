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
    * Modern Twig                              (Stanislav Romanov)
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
    * Run in Terminal                          (kortina)
    * Draw.io Integration                      (Henning Dieterichs)
    * GitLens -- Git superchaged               (GitKraken)
  * AI (Options)
    * Gemni Code Assist                        (Google)
    * Gemini CLI Companion                     (Google)

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
