# Claude Code Hooks (`.claude/hooks/**`)

This directory holds this project's **Claude Code hook scripts**, organized per event. A hook is a
shell command that Claude Code **runs automatically** at a specific point (before/after a tool call,
session start/end, response stop, etc.).

## Conventions (how hooks are wired)

Keep a hook's **behavior (logic)** in the per-event `*.sh` script in this directory, and keep its
**registration (wiring)** in `hooks.<EventName>` inside `.claude/settings.json`, referencing that
script. Do not inline shell commands directly into `settings.json` — separating the logic into a
script makes it easier to version, review, and test, and keeps `settings.json` thin.

```jsonc
// .claude/settings.json
"hooks": {
  "PostToolUse": [
    { "matcher": "Edit|Write",
      "hooks": [{ "type": "command", "command": ".claude/hooks/post-tool-use/php-cs-fixer.sh",
                  "timeout": 30, "statusMessage": "Running php-cs-fixer..." }] }
  ]
}
```

- Write the script path as a **repository-root-relative path**, the same as `statusLine` in `settings.json`.
- The script needs the execute bit: `chmod +x .claude/hooks/<event>/<name>.sh`.

## Directory → event mapping

Directory names are kebab-case and mirror Claude Code's PascalCase hook events. The 18 scaffolds
below exist. `[Verified]` [WebFetch: https://code.claude.com/docs/en/hooks]

| Directory | Event | When it fires |
| --- | --- | --- |
| `pre-tool-use/` | `PreToolUse` | Just before a tool call runs (exit 2 = block the tool) |
| `post-tool-use/` | `PostToolUse` | After a tool call succeeds |
| `post-tool-use-failure/` | `PostToolUseFailure` | After a tool call fails |
| `permission-request/` | `PermissionRequest` | When a tool call needs a permission decision (exit 2 = deny) |
| `user-prompt-submit/` | `UserPromptSubmit` | On prompt submit, before processing (exit 2 = block the prompt) |
| `notification/` | `Notification` | When Claude Code sends a notification |
| `stop/` | `Stop` | When Claude finishes a response (exit 2 = prevent stop and continue) |
| `session-start/` | `SessionStart` | On session start/resume (stdout is injected as context) |
| `session-end/` | `SessionEnd` | On session end |
| `pre-compact/` | `PreCompact` | Just before context compaction (exit 2 = block compaction) |
| `instructions-loaded/` | `InstructionsLoaded` | When CLAUDE.md / `.claude/rules/*.md` load (exit code ignored) |
| `config-change/` | `ConfigChange` | On a settings-file change mid-session (exit 2 = block the change) |
| `sub-agent-start/` | `SubagentStart` | On subagent creation |
| `sub-agent-stop/` | `SubagentStop` | On subagent stop (exit 2 = prevent stop) |
| `task-completed/` | `TaskCompleted` | When a task is marked complete (exit 2 = prevent completion) |
| `teammate-idle/` | `TeammateIdle` | Just before an agent-team teammate goes idle (exit 2 = keep working) |
| `worktree-create/` | `WorktreeCreate` | On worktree creation (**any non-zero exit = creation fails**) |
| `worktree-remove/` | `WorktreeRemove` | When a worktree is removed (e.g. at session end) |

> Claude Code supports more events than these (`Setup`, `PostCompact`, `TaskCreated`, `FileChanged`,
> etc.). If an event you need is not listed above, create a new kebab-case directory for that
> PascalCase name.

## Execution contract (stdin / exit code)

- Every hook receives a **JSON payload on stdin**. Parse fields such as the edited file path with `jq`
  (e.g. `.tool_input.file_path // .tool_response.filePath`). `[Verified]` [WebFetch: https://code.claude.com/docs/en/hooks]
- **exit 0** = success. For `SessionStart` and `UserPromptSubmit`, stdout is injected into Claude's
  context; for other events, stdout goes only to the debug log.
- **exit 2** = per-event block (see the table above). stderr is delivered to Claude as an error.
- **any other exit** = non-blocking error. Execution continues and the first line of stderr is shown.
  (Exception: `WorktreeCreate` treats any non-zero code as a failure.)

A hook that **must not block the workflow** — a formatter or a notification — should always end with `exit 0`.

## Script style

Hook scripts are **standalone utilities** unrelated to the `source`-based deployment architecture.
Follow the project's shell-script SoT for shell style (shebang, quoting, guards), but do not use
`_abstract.sh`, the lifecycle functions, or the `select` menu.

@see .claude/output-styles/utility/shell-script/code-config-style.md — shell-style SoT (shebang, quoting, `rm -rf` guard, `set -euo pipefail` allowed for standalone utilities)
@see .claude/rules/utility/shell-script/code-config-rule.md — shell safety & quality gates

> Note: the shell-script rule's `paths` is `scripts/**`, so it does not auto-apply to
> `.claude/hooks/**/*.sh`. Apply the same SoT when reviewing hook scripts.

## Currently active hooks

| Event | Script | Purpose |
| --- | --- | --- |
| `PostToolUse` (`Edit\|Write`) | `post-tool-use/php-cs-fixer.sh` | Auto-formats edited `app/src` / `app/tests` PHP files with php-cs-fixer |
| `Stop` (async) | `stop/notify-complete.sh` | Plays a completion sound when a response ends |

> `php-cs-fixer.sh` only works when `jq` and `app/vendor/bin/php-cs-fixer` are present. If either is
> missing, the script silently degrades to `exit 0` (non-blocking). Install vendor with
> `composer install`, and make sure `jq` is available on the system.

## How to add a new hook

1. Write `.claude/hooks/<event>/<name>.sh` (parse the stdin JSON, use the appropriate exit code, `exit 0` if non-blocking).
2. Grant execute permission with `chmod +x`.
3. Register the script path under `hooks.<EventName>` in `.claude/settings.json` — the
   `update-config` skill does this safely.
4. Confirm `shellcheck .claude/hooks/<event>/<name>.sh` passes, then verify with a mock payload:
   `printf '%s' '{"tool_input":{"file_path":"..."}}' | .claude/hooks/<event>/<name>.sh; echo "exit=$?"`
