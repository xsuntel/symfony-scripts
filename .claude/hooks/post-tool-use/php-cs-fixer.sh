#!/bin/bash

#set -euo pipefail
# ----------------------------------------------------------------------------------------------------------------------
# Hooks - PostToolUse - PHP-CS-Fixer
# ----------------------------------------------------------------------------------------------------------------------
# Registered in: .claude/settings.json → hooks.PostToolUse (matcher "Edit|Write").
# Contract: Claude Code pipes the hook payload as JSON on stdin; format the just-edited file when it is
#           an app/src or app/tests PHP file, using the project php-cs-fixer.
# Strict mode is intentionally OFF and the script always exits 0 — PostToolUse must stay non-blocking so
# a formatter hiccup never disturbs the Edit/Write result (exit 2 would surface an error to Claude).
# ----------------------------------------------------------------------------------------------------------------------

# Resolve project root relative to this script (.claude/hooks/post-tool-use/ → three levels up).
PROJECT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

# jq parses the hook payload; skip silently if it is unavailable.
command -v jq >/dev/null 2>&1 || exit 0

# Edit exposes tool_input.file_path; Write's response uses tool_response.filePath.
FILE_PATH="$(jq -r '.tool_input.file_path // .tool_response.filePath // empty')"

case "${FILE_PATH}" in
  *app/src/*.php | *app/tests/*.php)
    if [ -x "${PROJECT_PATH}/app/vendor/bin/php-cs-fixer" ]; then
      (cd "${PROJECT_PATH}/app" && vendor/bin/php-cs-fixer fix "${FILE_PATH}" --quiet) 2>/dev/null || true
    fi
    ;;
esac

exit 0
