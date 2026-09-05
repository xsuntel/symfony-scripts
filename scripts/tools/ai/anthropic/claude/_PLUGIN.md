# Claude Code

## Plugin

* Install Anthropic official - plugin : claude-md-management

  Run `claude`, then enter these slash commands at the prompt:

  ```text
  /plugin marketplace add anthropics/claude-plugins-official

  /plugin install claude-md-management@claude-plugins-official
  ```

  Two entry points are provided (use whichever fits):

  ```text
  # Incremental improvement of existing CLAUDE.md files
  /claude-md-management@claude-md-improver Please review the CLAUDE.md files and improve them
  ```

  ```text
  # Full revision / restructure of a CLAUDE.md file
  /claude-md-management@revise-claude-md Please review the CLAUDE.md files and improve them
  ```

* Prepare the PHP LSP (intelephense) — required by the php-lsp plugin

  ```bash
  # The php-lsp plugin drives the intelephense language server; install it globally first.
  sudo npm install -g intelephense
  ```
