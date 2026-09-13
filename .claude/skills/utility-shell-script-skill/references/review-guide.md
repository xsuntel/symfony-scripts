# Shell Script Review Guide

The **Review mode** of `utility-shell-script-skill` — holds the authoring conventions and the quality
judgment procedure for shell scripts. `SKILL.md` dispatches here via its `## Modes` table; the
operational patterns (bootstrap, global variables, menus, idempotent installs) stay in `SKILL.md`.

**This is not judgment criteria** — `output-styles/utility-shell-script-style.md` (style) and
`rules/utility-shell-script-rule.md` (operations/architecture) are SoT. This guide holds only the
authoring conventions summary, the review procedure and the two output formats.

> Until 2026-09-10 this was the slash command `/utility-shell-script-review`. It now runs as the review
> mode of `/utility-shell-script-skill`; `$ARGUMENTS` still carries the target path. The two judgment
> modes below (A — existing file review, B — draft self-verification) are unchanged.

Analyze the following shell script file:

**`$ARGUMENTS`**

> **When the argument is empty**, review the contents of @.claude/hooks/**/*.sh and @scripts/**/*.sh and
> fix/supplement them against the official docs.
> Do not blindly scan all of `scripts/**` or guess a target.
> **Scope caution:** `.claude/hooks/**` holds standalone hook scripts, so apply only the **universal
> safety · portability · style criteria** (shebang, variable quoting, `rm -rf` guard, `set -e` judgment,
> ShellCheck). Do not apply the `scripts/**`-specific module-architecture clauses (bootstrap,
> `_abstract.sh` sourcing, lifecycle, taxonomy).

The single source of truth (SoT) for the judgment criteria is **`utility-shell-script-style.md` for
shell style, and `utility-shell-script-rule.md` for operations/architecture** (bootstrap, global
variables, sourcing, idempotency, taxonomy). Read the references below at the start, cross-check each clause against the
target code, flag violations with the **exact line number**, and provide concrete fixes (improved code
snippets).

> **Caution:** this project deliberately differs from general Bash best practice — `set -euo pipefail`
> being **commented out** is correct (control flows through `setExit`/`setEnd`), the shebang is
> `#!/bin/bash` (only a container entrypoint uses `#!/bin/sh`), and unrecoverable errors use `setExit`
> (SIGKILL). Do not flag these as "violations" on general grounds — judge only against the SoT documents.

@see .claude/output-styles/utility-shell-script-style.md — judgment criteria (SoT: shebang · strict mode · naming · source guard · `rm -rf` guard)
@see .claude/rules/utility-shell-script-rule.md — judgment criteria (SoT: bootstrap · global variables · sourcing · idempotency · taxonomy · safety)
@see .claude/docs/utility-shell-script-docs.md — global variable catalog · ShellCheck · idempotent install · detailed anti-pattern examples
@see .claude/skills/utility-shell-script-skill/SKILL.md — bootstrap · global variables · menu · idempotent install patterns
@see scripts/base/\_abstract.sh — the origin of the global variables and bootstrap · scripts/.shellcheckrc — disabled ShellCheck rules
@see <https://www.gnu.org/software/bash/manual/bash.html> — GNU Bash reference manual (general Bash semantics only; the project SoT above overrides generic best-practice advice)

## Judgment Modes

This guide **holds both the authoring conventions and the judgment criteria**. The mode is determined
by what the target is.

| Mode | Target | Procedure | Output | Who runs it |
| --- | --- | --- | --- | --- |
| **A. Existing file review** (default) | the real `.sh` file given as `$ARGUMENTS` | `## Review Procedure` | `[MUST]` / `[SHOULD]` / `[CONSIDER]` | the skill's **Review** mode, in-session |
| **B. Draft verification** | `./.claude/tmp/utility/shell-script/script-draft.md` | `## Authoring Conventions` → `## Review Procedure` | `PASS` / `REDO` + correction instructions | the **agent pair**, through the skill's Author mode |

Mode B is the loop the `utility-shell-script-skill` skill runs when authoring a new script:
`utility-shell-script-author` produces a draft per `## Authoring Conventions`,
`utility-shell-script-reviewer` judges it via `## Review Procedure`, and the skill writes it to the
target path on `PASS` — or on `REDO` re-calls the author with only the correction instructions
(**at most 2 retries**, counted by the skill; beyond that, stop and recommend manual review).

> **This guide is the criteria both halves read, not the procedure either one owns.** Its two sections
> are split across the pair: the author writes against `## Authoring Conventions`, the reviewer judges
> against `## Review Procedure`. Neither holds a copy.
>
> **History.** A `utility-shell-script-author` / `utility-shell-script-reviewer` pair owned this loop
> until 2026-08-16, when it was converted to command-based self-verification on the reasoning that the
> criteria converge on this single file — the same shape as the Claude Code config (2026-08-08) and
> provider (2026-08-15) domains. On 2026-09-10 that command became this guide. **On 2026-09-11 the pair
> was restored and the loop handed back to it**, so Mode B is no longer self-verification; the criteria
> have stayed in this file throughout.

## Authoring Conventions (Mode B — drafting)

Before writing, read the shell style SoT and **1–2 existing scripts of the same kind**, and follow their
bootstrap, naming, and structure exactly. The list below is a summary of the SoT; the output style is
the source for the details and templates.

- **Shebang:** entry-point scripts use `#!/bin/bash`, a container entrypoint uses `#!/bin/sh`. `#!/usr/bin/env bash` is forbidden.
- **Strict mode:** `set -euo pipefail` is **commented out** (`#set -euo pipefail`) — the intended design of the source-based module architecture.
- **Bootstrap:** a directly executed entry point follows the order `find_project_root` → `cd "${PROJECT_PATH}"` → source `_abstract.sh`. Sourced helpers (`_*.sh`) do not repeat the bootstrap.
- **Source guard:** place an `if [ -f ... ]` existence check before every `source` (no bare source).
- **Naming:** lifecycle-phase functions are `camelCase` (`setStart` · `setPhp` · `setEnd`), reusable helpers are `snake_case` (`find_project_root` · `log_error`). Always expand variables as `"${VAR}"`.
- **Destructive commands:** `rm -rf` uses the `rm -rf "${VAR:?}/path"` guard. Inside a sourced file, use `setExit` (SIGKILL) / `setEnd` (normal termination) instead of `exit 1`.
- **Menus · platforms:** interactive selection uses `select` + `PS3` + `${REPLY}`. Platform branching covers Linux/Darwin/Windows plus an `else` → `setExit`.
- **Idempotent install:** install packages behind a `dpkg -l` (or `brew list` on macOS) check guard.

**Authoring principles**

- **Comment language: English** (comment only the why/constraint, omit the what) — the project shell style convention.
- Mirror the bootstrap, section banner (111 chars), and function order of an existing script of the same kind — do not invent new conventions.
- Use only the global variable names defined in `_abstract.sh`, and do not invent non-existent globals, helpers, or paths.
- Unless explicitly requested, leave no placeholders like `# TODO` — write a **complete, runnable script** starting from the shebang.
- Record the draft at `./.claude/tmp/utility/shell-script/script-draft.md` (when writing via Bash, run `mkdir -p .claude/tmp/utility/shell-script` first).

## Review Procedure

Cross-check each SoT item: shebang · strict mode (confirm it is commented out) · variable quoting
(`"${VAR}"`) · `local` · function naming (lifecycle = `camelCase`, helper = `snake_case`) · source guard
(source only after an existence check) · path handling (`find_project_root` · `PROJECT_PATH`) · platform
branching (Linux/Darwin/Windows + `else setExit`) · logging format (`[ LABEL ]` · separators) · security
(input validation, command injection, the `rm -rf "${VAR:?}"` guard) · duplication (shared logic belongs
in `_abstract.sh`).

Additionally, confirm the following:

- **No repeated bootstrap** — does a sourced helper (`_*.sh`) avoid repeating the `find_project_root` · `_abstract.sh` sourcing block?
- **Exit handling** — inside a sourced file, does it use `setExit` (unrecoverable) / `setEnd` (normal termination) rather than a bare `exit`?
- **Idempotent install** — does package installation have a `dpkg -l` (or `brew list` on macOS) check guard?
- **ShellCheck gate** — respecting the disabled rules in `scripts/.shellcheckrc`, are there no other warnings left (mandatory before merge)?
- **Reference factuality** — do the findings and fixes reference only real global variables, functions, and paths (the `_abstract.sh` catalog)?

## Output Format — Mode A (existing file review)

### Summary

| Category | Status | Issue count |
| --- | --- | --- |
| Safety & error handling | ✅ / ⚠️ / ❌ | N |
| Variable declaration | ✅ / ⚠️ / ❌ | N |
| Function design | ✅ / ⚠️ / ❌ | N |
| Sourcing guards | ✅ / ⚠️ / ❌ | N |
| Path handling | ✅ / ⚠️ / ❌ | N |
| Portability | ✅ / ⚠️ / ❌ | N |
| Logging & output | ✅ / ⚠️ / ❌ | N |
| Security | ✅ / ⚠️ / ❌ | N |
| Code duplication | ✅ / ⚠️ / ❌ | N |

### Critical Issues (must fix)

For each issue: **[Line N]** `[MUST]` description → recommended fix including a code snippet.

### Improvement Suggestions (recommended)

For each suggestion: **[Line N]** `[SHOULD]` description → recommended approach.

### Refactoring Suggestions

Mark structural changes (function extraction, consolidating shared utilities, etc.) as `[CONSIDER]` and
describe them with before/after code examples. Only `[MUST]` blocks a merge.

## Output Format — Mode B (draft verification)

Record the result at `./.claude/tmp/utility/shell-script/script-review.md`.

- **Line 1 is exactly `Verdict: PASS` or `Verdict: REDO`** — no prefix, no markdown, nothing else on the
  line. The skill branches on that token alone, and anything else is read as malformed and treated as
  REDO.
- **Append each round** as a `## Round N` block; rewrite line 1 to the current round's verdict. Round 2
  needs round 1's instructions in order to apply the anti-thrash rule.
- **Reason:** specific rationale, each item quoting pasted check output or naming a line number.
- **Correction instructions:** only on REDO — specific enough to apply directly in the rewrite.

`utility-shell-script-reviewer.md` carries the full I/O contract and a worked example; this is the
summary.

**Verdict principles**

- Use **only the objective criteria** in `## Review Procedure`, not subjective writing quality.
- Issue a REDO only when a rewrite is actually needed — convention deviation, a safety defect (missing guard, destructive command), or a non-existent reference.
- When the verdict is uncertain, choose REDO over PASS — a miss costs more than a false alarm.
- When applying a REDO, **do not arbitrarily change anything outside the correction instructions.**
