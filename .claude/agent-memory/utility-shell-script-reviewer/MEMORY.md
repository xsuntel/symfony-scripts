# utility-shell-script-reviewer memory

Standing context for judging a Bash draft. The SoT is `output-styles/utility-shell-script-style.md`
(style) + `rules/utility-shell-script-rule.md` (operations/architecture); the checks in the agent prompt
are *executions* of those clauses, and where the two disagree the SoT wins.

> **Restored 2026-09-11.** This pair was retired on 2026-08-16 in favour of skill-side
> self-verification. A claim that "no shell-script reviewer agent exists" is stale text from that period
> — it appears in `docs/tools-agent-team-docs.md` and older memories.

## Artifact paths

- Read: `./.claude/tmp/utility/shell-script/script-draft.md` + sidecar `script-meta.txt`
  (`round` · `target` · `kind`).
- Write: `./.claude/tmp/utility/shell-script/script-review.md`, **line 1 exactly** `Verdict: PASS` or
  `Verdict: REDO` — the orchestrator reads that line and nothing else.
- **Append each round** via read-modify-write (no `Edit` held): line 1 = this round's verdict, then every
  previous `## Round N` block unchanged, then this round's.

## Freshness gate — before anything else

Absent draft or sidecar, a `round` that differs from the one stated, or a `target`/`kind` mismatch →
`Verdict: REDO`, reason `stale-or-missing-draft`, stop. `.claude/tmp/` is never cleaned
(`Bash(rm:*)` denied, `cleanupPeriodDays: 30`), so a leftover draft is otherwise indistinguishable from
a fresh one.

## `kind` selects the clauses — getting it wrong invalidates the review

- `sourced-helper` — must **not** carry a bootstrap block.
- `container-entrypoint` — the only kind allowed `#!/bin/sh`.
- `hook` — universal safety/portability/style **only**. Raising the `scripts/**` module-architecture
  clauses (bootstrap, `_abstract.sh` sourcing, lifecycle taxonomy) against a standalone hook is a
  **false finding**.

## False findings — the main way this reviewer wastes a retry

This project deliberately differs from general Bash advice. Never flag:

- `set -euo pipefail` being **commented out** (control flows through `setExit` / `setEnd`);
- `#!/bin/bash` rather than `#!/usr/bin/env bash`;
- `setExit` / `setEnd` instead of `exit 1` inside a sourced file;
- a ShellCheck warning for **SC2034, SC2168, SC1091, SC2155, SC2225 or SC2024** — all six are disabled
  project-wide in `scripts/.shellcheckrc`.

Carried-over content from the file being refactored is `[SHOULD]`, not a REDO — **unless it is a safety
defect**, which is never downgraded.

## Never downgrade these

A missing `rm -rf "${VAR:?}"` guard, a bare `source` with no `[ -f ]` test, or a reference to a global
or helper that does not resolve in `scripts/base/_abstract.sh`. All are `[MUST]` / REDO.

## Boundaries

- **Never execute the draft**; `Bash` is for `bash -n` and `shellcheck -x`.
- **Never modify the draft** — `disallowedTools: Edit` enforces it, and rewriting it with `Write` is
  working around the boundary, not respecting it.
- **Anti-thrash:** round 1 must be complete. A finding visible in round 1 but unreported is `[SHOULD]`
  on round 2 and must not be escalated. The budget is **2**, owned by the skill, not by this agent.
- If shellcheck is not installed, record **"unchecked"** — an absent tool is never a pass.
