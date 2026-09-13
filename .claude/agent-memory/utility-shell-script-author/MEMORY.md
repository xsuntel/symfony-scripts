# utility-shell-script-author memory

Standing context for drafting Bash under `scripts/**` and `.claude/hooks/**`. The SoT for the criteria
is `output-styles/utility-shell-script-style.md` (style) + `rules/utility-shell-script-rule.md`
(operations/architecture); where they conflict with anything here, they win.

> **Restored 2026-09-11.** This pair was retired on 2026-08-16 in favour of skill-side
> self-verification, and `utility-shell-script-skill` has now handed the loop back to it. A claim that
> "no shell-script author agent exists" is stale text from that period.

## Artifact paths

- Draft: `./.claude/tmp/utility/shell-script/script-draft.md` — **the script verbatim**, line 1 = the
  shebang. Never write to `scripts/**` or `.claude/hooks/**`; the skill applies the draft on PASS.
- Sidecar: `./.claude/tmp/utility/shell-script/script-meta.txt` — `round` · `target` · `kind`. Rewrite
  it every round, including a REDO. A missing sidecar is `stale-or-missing-draft`, rejected before any
  check runs.
- Review: `./.claude/tmp/utility/shell-script/script-review.md` — from round 2 on, **read it** and apply
  its latest `## Round N` block verbatim rather than the prompt's paraphrase.
- Overwrite draft and sidecar in full every round: `Bash(rm:*)` is denied, so a partial write leaves the
  previous run's content mixed into this one's.

## Why there is no header line (unlike the drawio author)

Line 1 of the draft must be the shebang — a shebang that is not the first two bytes of the file is not a
shebang, and the script silently runs under whatever shell invoked it. So provenance lives in the
sidecar, the same shape `utility-git-commit-author` uses for the same reason.

## Conventions that are deliberately not general Bash practice

Do not "fix" any of these; the reviewer will REDO the fix, not the original.

- `set -euo pipefail` stays **commented out** — control flows through `setExit` / `setEnd`.
- `#!/bin/bash`, never `#!/usr/bin/env bash`. `#!/bin/sh` only for a container entrypoint.
- A **sourced helper (`_*.sh`) never repeats the bootstrap**; only a directly executed entry point runs
  `find_project_root` → `cd "${PROJECT_PATH}"` → source `_abstract.sh`.
- Every `source` sits behind an `if [ -f ... ]` existence test.
- Lifecycle phases `camelCase` (`setStart`, `setPhp`), reusable helpers `snake_case` (`log_error`).
- `rm -rf "${VAR:?}/path"` — never an unguarded expansion.
- Inside a sourced file use `setExit` / `setEnd`, never a bare `exit 1`.

## `kind` decides which clauses apply

`entrypoint` · `sourced-helper` · `container-entrypoint` · `hook`. **A `.claude/hooks/**` target takes
the universal safety/portability/style criteria only** — the `scripts/**` module-architecture clauses
(bootstrap, `_abstract.sh` sourcing, lifecycle taxonomy) do not apply to a standalone hook, and
importing them there is a defect, not thoroughness.

## Reference factuality — the most common REDO

Read `scripts/base/_abstract.sh` **before writing a line**. Every `${VAR}` and every function call must
resolve there or in the script itself. The reviewer greps for unresolved globals mechanically.

## Gates

- `bash -n` and `head -1` (shebang) are the cheap self-check; run both before handing off.
- `shellcheck -x` follows sourced files. `scripts/.shellcheckrc` disables **SC2034, SC2168, SC1091,
  SC2155, SC2225, SC2024** project-wide — a warning for one of those is not a finding.
- **If shellcheck is not installed, say "unchecked"** — never report an absent tool as a pass.

## Boundaries

- **Never execute the draft**, and never run an installer, a deployment, or anything under
  `scripts/deploy/**`. `Bash` is for linting and syntax-checking.
- The retry budget (**2**) belongs to `utility-shell-script-skill`, not to this agent.
- On a REDO, change only what the instruction raised.
