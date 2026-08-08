---
description: "Assesses the quality of a shell script file and provides structured improvement recommendations."
argument-hint: "[path to the shell script file to analyze]"
---

Analyze the following shell script file:

**`$1`**

The single source of truth (SoT) for the judgment criteria is the output-style. At the start, read the
following, cross-check each provision against the target code, flag violations with the **exact line
number**, and provide concrete fixes (improved code snippets).

> **Note:** this project intentionally differs from general Bash best practices — `set -euo pipefail`
> being **commented out** is correct (control via `setExit`/`setEnd`), the shebang is `#!/bin/bash`
> (only container entrypoints use `#!/bin/sh`), and unrecoverable errors use `setExit` (SIGKILL). Do
> not flag these as "violations" based on general advice — judge only against the SoT document.

@see .claude/output-styles/utility/shell-script/code-config-style.md — judgment criteria (SoT: shebang, strict mode, naming, source guard, `rm -rf` guard)
@see .claude/skills/utility/shell-script/code-config-helper/SKILL.md — bootstrap, global variables, menu, idempotent install patterns

## Review Procedure

Cross-check each item of the SoT: shebang, strict mode (confirm it is commented out), variable quoting
(`"${VAR}"`) and `local`, function naming (lifecycle=`setPascalCase`, helper=`snake_case`), source guard
(source after existence check), path handling (`find_project_root`, `PROJECT_PATH`), platform branching
(Linux/Darwin/Windows + `else setExit`), logging format (`[ LABEL ]`, separators), security (input
validation, command injection, `rm -rf "${VAR:?}"` guard), duplication (shared logic in `_abstract.sh`).

## Output Format

### Summary

| Category | Status | Issue count |
| --- | --- | --- |
| Safety & error handling | ✅ / ⚠️ / ❌ | N |
| Variable declarations | ✅ / ⚠️ / ❌ | N |
| Function design | ✅ / ⚠️ / ❌ | N |
| Sourcing guards | ✅ / ⚠️ / ❌ | N |
| Path handling | ✅ / ⚠️ / ❌ | N |
| Portability | ✅ / ⚠️ / ❌ | N |
| Logging & output | ✅ / ⚠️ / ❌ | N |
| Security | ✅ / ⚠️ / ❌ | N |
| Code duplication | ✅ / ⚠️ / ❌ | N |

### Critical Issues (must fix)

For each issue: **[Line N]** description → recommended fix including a code snippet.

### Improvement Suggestions (recommended)

For each suggestion: **[Line N]** description → recommended approach.

### Refactoring Suggestions

Describe structural changes (function extraction, consolidating shared utilities, etc.) with before/after code examples.
