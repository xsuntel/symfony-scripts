---
description: "Assesses spec and convention compliance of Claude Code config artifacts (agents, skills, commands, rules, output styles, settings, CLAUDE.md) and provides structured improvement recommendations."
argument-hint: "[path to the .claude config file to analyze]"
---

Analyze the following Claude Code config artifact:

**`$1`**

If `$1` is empty, do not guess a target: ask the user which `.claude/**` file to review, then stop
until they answer.

First determine the target file's **artifact type** from its path, cross-check it against the per-type
criteria below and the official spec, flag violations with the **exact line number**, and provide
concrete fixes (improved snippets). Before starting, read **1–2 existing files of the same kind** under
`.claude/**` to establish the baseline for frontmatter, tone, and section structure — do not invent new
conventions.

If the path matches none of the types below (e.g. `.claude/docs/**`, `.claude/agent-memory/**`,
`.claude/workflows/**`, `.claude/scripts/**`, `.claude/hooks/README.md`), report that it is out of
scope and stop — do not improvise criteria for it.

> **Note — responsibility split:** the **structural** criteria (directory taxonomy, path depth, file
> placement, and the flattening/move/rename prohibitions) are owned by
> `.claude/rules/utility/claude/code-config-rule.md`. Everything else — the **per-type frontmatter and
> body criteria** — is owned by **this command body + the official docs below**; this domain has no
> `output-styles/` SoT file (unlike the shell-script domain). Do not flag anything outside those two
> sources as a "violation" on the basis of general advice.

@see .claude/rules/utility/claude/code-config-rule.md — `.claude/**` structure immutability & allowed changes (SoT)
@see .claude/skills/utility/claude/code-config-helper/SKILL.md — artifact authoring & self-verification entry point
@see https://code.claude.com/docs/en/sub-agents — sub-agent frontmatter spec
@see https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview — skill SKILL.md structure
@see https://platform.claude.com/docs/en/api/skills-guide — skill name/description constraints

## Per-type Judgment Criteria

| Type | Target path | Required frontmatter | Body |
| --- | --- | --- | --- |
| Sub-agent | `.claude/agents/**/*.md` | `name`, `description` (optional: `model`, `tools`, `memory`, `permissionMode`, `effort`, `skills`, `color`) | role · procedure · I/O protocol · role boundaries |
| Skill | `.claude/skills/**/SKILL.md` | `name` (lowercase·hyphen, matches the directory name), `description` (what + when/trigger) | operating guide |
| Slash command | `.claude/commands/**/*.md` | `description` (optional: `argument-hint`, `allowed-tools`, `model`) | instructions using the positional argument (`$1`) or the full-argument variable (`$ARGUMENTS`) |
| Rule | `.claude/rules/**/*.md` | `paths` (glob list) | judgment criteria (SoT) |
| Output style | `.claude/output-styles/**/*.md` | `name`, `description` (optional: `keep-coding-instructions`) | domain output & code-style guide |
| settings/hook | `.claude/settings.json`, `.claude/settings.local.json`, `.claude/hooks/**/*.sh` | (JSON) hook schema — n/a for a hook script | hook script: apply `.claude/output-styles/utility/shell-script/code-config-style.md` manually (its `paths` scope is `scripts/**`, so it does not auto-apply here) |
| CLAUDE.md | `CLAUDE.md` or a subordinate one | — | higher-level context & guidance |

### Frontmatter Detail Rules (official spec)

- **Agent `model`**: one of `sonnet` | `opus` | `haiku` | `fable` | `inherit`, or a full model ID (e.g. `claude-opus-5`). Defaults to `inherit` when omitted. `tools` is comma-separated; list **only the least privilege** (inherits all when omitted).
- **Agent `memory`**: `user` | `project` | `local`. This project uses `memory: project`, which pairs the agent with `.claude/agent-memory/<domain>/<tier>/<agent>/MEMORY.md`. Do not flag it as an unknown key.
- **Skill `name`**: lowercase/digits/hyphen only, ≤ 64 chars, matches the directory name; be careful with the reserved words (`anthropic`, `claude`).
- **Skill `description`**: ≤ 1024 chars, stating "what it does + when it triggers" in the third person (include the natural-language trigger phrasing).
- **Command `allowed-tools`**: hyphen notation. Do not include a tool name that does not exist.
- **Output style `name`**: matches the file slug. To avoid overriding the coding instructions, set `keep-coding-instructions: true` (the existing-style convention).

## Review Procedure

Cross-check the items below in order.

- **Frontmatter validity** — is it valid YAML wrapped in `---`, with the required keys present per type? For settings/hooks, is it valid JSON conforming to the hook schema?
- **Naming & path** — do the filename and directory conventions match the same-kind file (skill `name` = directory name, command invocation name = path slug)?
- **Tool minimality** — no unnecessarily broad `tools`/`allowed-tools`, and **no non-existent tool name**?
- **Convention agreement** — does it follow the documentation language (**English**, per `CLAUDE.md`; Korean is the chat language only), the `@see` SoT reference style, and the tone/section structure of the same-kind file? Does it avoid drift by duplicating or restating criteria owned by an SoT?
- **Factuality** — does the body avoid referencing non-existent rules, paths, agents, skills, commands, or tools (verify that referenced paths actually exist)?
- **Role boundaries** — for an agent or skill, are the upstream/downstream, orchestrator, and output paths stated, and do they match the actual caller?
- **Structure immutability** — does the file sit at its taxonomy-conforming path (`<kind>/<domain>/<tier>/…`), with no flattening, move, rename, merge, or split relative to its siblings of the same kind? See the structure SoT referenced above.

## Output Format

### Summary

| Category | Status (OK / WARN / FAIL) | Issue count |
| --- | --- | --- |
| Frontmatter validity | | |
| Per-type required keys | | |
| Naming & path conventions | | |
| Tool minimality | | |
| Project convention agreement | | |
| Reference factuality | | |
| Role boundaries & hand-off | | |
| Structure immutability | | |

### Critical Issues (must fix)

For each issue: **[Line N]** `[MUST]` description → recommended fix including a code snippet.

### Improvement Suggestions (recommended)

For each suggestion: **[Line N]** `[SHOULD]` description → recommended approach.

### Refactoring Suggestions

Mark structural changes (section reordering, moving duplicated criteria to their SoT, converting the
artifact type, etc.) as `[CONSIDER]` and describe them with before/after examples. Only `[MUST]` blocks a merge.

A `[CONSIDER]` note is a **suggestion, never an authorization**: relocating, renaming, merging, or
flattening any file or directory under `.claude/**` requires an explicit user instruction. Report the
before/after paths and stop there — do not perform the move as part of the review.
