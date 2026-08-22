# Claude Code Hooks (`.claude/hooks/**`)

This directory holds this project's **Claude Code hook scripts**, organized by event. A hook is a shell
command that Claude Code **runs automatically** at a specific point (before/after a tool runs, at
session start/end, when a response finishes, and so on).

## Convention (how hooks are wired)

A hook's **behavior (logic)** lives in a per-event `*.sh` script in this directory, and its
**registration (wiring)** references that script from `hooks.<EventName>` in `.claude/settings.json`.
Do not write an inline shell command directly into `settings.json` — separating the logic into a script
makes it easy to version, review, and test, and keeps `settings.json` thin.

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

- Write the script path as a **path relative to the repository root**, the same way `settings.json`
  writes `statusLine`.
- Scripts need the execute permission: `chmod +x .claude/hooks/<event>/<name>.sh`.
  This requirement applies to **every** script `settings.json` references via `command` — not only
  hooks, but also the `.claude/scripts/**` that `statusLine` points at. Without the permission Claude
  Code does not fail quietly: the whole feature dies with `Permission denied`.

## Directory → Event Mapping

Directory names are kebab-case and mirror Claude Code's PascalCase hook events. The 18 scaffolds below
exist. `[Verified]` [WebFetch: https://code.claude.com/docs/en/hooks]

| Directory | Event | When it fires |
| --- | --- | --- |
| `config-change/` | `ConfigChange` | A config file changes mid-session (exit 2 = block the change) |
| `instructions-loaded/` | `InstructionsLoaded` | CLAUDE.md and `.claude/rules/*.md` are loaded (exit code ignored) |
| `notification/` | `Notification` | Claude Code sends a notification |
| `permission-request/` | `PermissionRequest` | A tool call needs a permission decision (exit 2 = deny) |
| `post-tool-use/` | `PostToolUse` | After a tool call succeeds |
| `post-tool-use-failure/` | `PostToolUseFailure` | After a tool call fails |
| `pre-compact/` | `PreCompact` | Just before context compaction (exit 2 = block compaction) |
| `pre-tool-use/` | `PreToolUse` | Just before a tool call executes (exit 2 = block the tool) |
| `session-end/` | `SessionEnd` | At session end |
| `session-start/` | `SessionStart` | At session start/resume (stdout is injected into context) |
| `stop/` | `Stop` | When Claude finishes a response (exit 2 = prevent stopping and continue the conversation) |
| `sub-agent-start/` | `SubagentStart` | When a subagent is spawned |
| `sub-agent-stop/` | `SubagentStop` | When a subagent terminates (exit 2 = prevent termination) |
| `task-completed/` | `TaskCompleted` | When a task is marked complete (exit 2 = prevent completion) |
| `teammate-idle/` | `TeammateIdle` | Just before an agent-team teammate goes idle (exit 2 = keep working) |
| `user-prompt-submit/` | `UserPromptSubmit` | On prompt submission, before processing (exit 2 = block the prompt) |
| `worktree-create/` | `WorktreeCreate` | When a worktree is created (**any non-zero exit = creation fails**) |
| `worktree-remove/` | `WorktreeRemove` | When a worktree is removed, e.g. at session end |

> Claude Code supports further events beyond these (`Setup` · `PostCompact` · `TaskCreated` ·
> `FileChanged`, etc.). If the event you need is not above, create a new kebab-case directory named
> after its PascalCase event.

## Execution Contract (stdin · exit code)

- Every hook receives a **JSON payload on stdin**. Parse the edited file path and similar fields with
  `jq` (e.g. `.tool_input.file_path // .tool_response.filePath`).
  `[Verified]` [WebFetch: https://code.claude.com/docs/en/hooks]
- **exit 0** = success. For `SessionStart` and `UserPromptSubmit`, stdout is injected into Claude's
  context; for every other event, stdout goes only to the debug log.
- **exit 2** = a per-event block (see the table above). stderr is passed to Claude as an error.
- **Any other exit** = a non-blocking error. Execution continues and the first line of stderr is shown.
  (Exception: `WorktreeCreate` treats any non-zero code as a failure.)

A hook that **must not block the workflow**, such as a formatter or a notifier, always ends with
`exit 0`.

### The Two Faces of exit 2 — Choosing a Feedback Path

`[Verified]` [WebFetch: https://code.claude.com/docs/en/hooks]

- exit 2 on `PostToolUse` **blocks nothing** — the tool has already run, and stderr is merely shown to
  Claude. That makes it a **safe feedback path** for getting an error in an edited file corrected
  within the same turn.
- exit 2 on `Stop` **prevents Claude from stopping and continues the conversation**. The official
  documentation describes no loop guard, so do not use it for a heavy gate.
- **`asyncRewake: true`** runs in the background and wakes Claude only on exit 2, showing stderr
  (or stdout when stderr is empty) as a system reminder. It implies `async`. A Stop gate that must
  deliver a result without delaying the turn uses this.

## Script Style

Hook scripts are **standalone utilities**, unrelated to the `source`-based deployment architecture.
Follow the project's shell-script SoT for shell style — shebang, quoting, guards — but do not use
`_abstract.sh`, the lifecycle functions, or the `select` menu.

@see .claude/output-styles/utility-shell-script-style.md — shell style SoT (shebang · quoting · `rm -rf` guard · `set -euo pipefail` permitted for standalone utilities)
@see .claude/rules/utility-shell-script-rule.md — shell safety · quality gate

> Note: the shell-script rule's `paths` is `scripts/**`, so it is not auto-applied to
> `.claude/hooks/**/*.sh`. Apply the same SoT to hook scripts when reviewing them.

## Currently Active Hooks

| Event | Script | Purpose |
| --- | --- | --- |
| `SessionStart` (no matcher) | `session-start/node.sh` | Injects Node toolchain environment variables (`NODE_ENV`, `app/node_modules/.bin` on PATH) via `CLAUDE_ENV_FILE` |
| `SessionStart` (no matcher) | `session-start/toolchain-status.sh` | Warns into context when `app/vendor`, `app/assets/vendor`, or `jq` is missing — surfaces a quality gate that is silently inert |
| `PostToolUse` (`Edit\|Write`) | `post-tool-use/php-lint.sh` | Syntax-checks edited `*.php` with `php -l` — feeds back to Claude via exit 2 on failure |
| `PostToolUse` (`Edit\|Write`) | `post-tool-use/php-cs-fixer.sh` | Auto-formats edited PHP files under `app/{src,tests,config,public,migrations}` with php-cs-fixer |
| `PostToolUse` (`Edit\|Write`) | `post-tool-use/twig-lint.sh` | Checks edited `*.twig` with `lint:twig` — feeds back to Claude via exit 2 on failure |
| `PostToolUse` (`Edit\|Write`) | `post-tool-use/js-guard.sh` | Greps edited `app/assets/**/*.js` against JS quality rules (innerHTML, eval, `require()`, `console.log`, etc.) — exit 2 on a violation |
| `Stop` (async) | `stop/notify-complete.sh` | Plays a completion sound when the response ends |
| `Stop` (`asyncRewake`, `timeout: 600`) | `stop/php-symfony-clear.sh` | Refreshes the dev Symfony app after the turn (php-cs-fixer → composer install → cache:clear → asset-map:compile), then runs the quality gate (PHPStan on the changed set → lint:twig → lint:container → lint:yaml) — wakes Claude via exit 2 on a gate failure |

> The four PostToolUse hooks run in the array order given in `settings.json`. `php-lint.sh` must come
> **before** `php-cs-fixer.sh` — on a file with broken syntax the fixer is a silent no-op, so lint is
> the only thing that can report the cause. Each script filters by extension itself, so a single
> `Edit|Write` matcher suffices for all four.

> `js-guard.sh` has no dependencies — no JS linter or formatter is installed in the project and the
> decision was made not to introduce a new dependency, so it uses grep only and **does not rewrite
> files**. The SoT for JS formatting is `app/.prettierrc.json` (4 spaces, semicolons), which
> `app/.editorconfig` and `.claude/output-styles/app-javascript-stimulus-style.md` follow — never
> change just one of the three.

> `twig-lint.sh` **does not use** `--show-deprecations`. Symfony promotes a deprecation to a lint
> error, so attaching the flag at edit time makes every unrelated template edit fire on one
> pre-existing deprecation. Use the flag only in a full sweep (the gate stage of `php-symfony-clear.sh`).

> The `CLAUDE_ENV_FILE` that `node.sh` uses is injected only for `SessionStart`, `Setup`, `CwdChanged`,
> and `FileChanged`, and that file **runs as a script preamble** on every Bash command. To preserve
> variables set by another hook, append with `>>` rather than `>`.
> `[Verified]` [WebFetch: https://code.claude.com/docs/en/hooks#persist-environment-variables]

> `php-symfony-clear.sh` fires every turn, and async hooks are **not deduplicated**
> `[Verified]` [WebFetch: https://code.claude.com/docs/en/hooks#limitations]. If the previous turn's run
> has not finished, `flock -n` skips this turn to avoid contention on the `app/var/cache` and vendor trees.

> `php-cs-fixer.sh` only does real work when `jq` and `app/vendor/bin/php-cs-fixer` are present. If
> either is missing the script degrades silently to `exit 0` (non-blocking). Install vendor with
> `composer install`, and `jq` must be present on the system.

## Adding a New Hook

1. Write `.claude/hooks/<event>/<name>.sh` (parse the stdin JSON, use an appropriate exit code,
   `exit 0` if non-blocking).
2. Grant the execute permission with `chmod +x`.
3. Register the script path under `hooks.<EventName>` in `.claude/settings.json` — using the
   `update-config` skill is the safe way.
4. Confirm `shellcheck .claude/hooks/<event>/<name>.sh` passes, then verify with a mock payload:
   `printf '%s' '{"tool_input":{"file_path":"..."}}' | .claude/hooks/<event>/<name>.sh; echo "exit=$?"`
