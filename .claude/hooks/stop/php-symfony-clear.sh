#!/bin/bash

set -euo pipefail
# ----------------------------------------------------------------------------------------------------------------------
# Hooks - Stop - PHP Symfony Clear
# ----------------------------------------------------------------------------------------------------------------------
# Registered in: .claude/settings.json → hooks.Stop (asyncRewake, timeout 600).
# Contract: once Claude finishes a turn, refresh the dev Symfony app — php-cs-fixer, composer install,
#           cache:clear, asset-map:compile — and then run the merge-blocking quality gates (PHPStan,
#           lint:twig, lint:container, lint:yaml). Runs in the background so the conversation is never
#           stalled; stdout goes to the debug log only.
# Two classes of step, two failure policies:
#   - housekeeping  → warn_step, never surfaced. A broken composer must not nag once per turn.
#   - quality gate  → collected into GATE_REPORT and reported at the end via exit 2.
# asyncRewake is what makes exit 2 usable here: it wakes Claude with stderr as a system reminder instead of
# blocking the stop. A plain Stop exit 2 would prevent Claude from stopping at all, and Claude Code
# documents no loop-prevention mechanism for that path.
# Concurrency: Stop fires on every turn and Claude Code does NOT de-duplicate async hook executions, so
# an flock guard stops overlapping runs from racing on app/var/cache and the composer vendor tree.
# ----------------------------------------------------------------------------------------------------------------------

find_project_root() {
  local PROJECT_DIR
  PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  while [[ "${PROJECT_DIR}" != "/" ]]; do
    if [[ -d "${PROJECT_DIR}/.git" ]] || [[ -f "${PROJECT_DIR}/.env.app" ]]; then
      echo "${PROJECT_DIR}"
      return 0
    fi
    PROJECT_DIR="$(dirname "${PROJECT_DIR}")"
  done
  return 1
}

# CLAUDE_PROJECT_DIR is exported onto the hook process by Claude Code; fall back to the walk-up search.
PROJECT_PATH="${CLAUDE_PROJECT_DIR:-$(find_project_root || true)}"

# Every precondition below degrades to exit 0 — a Stop hook must never report an error for a state
# that simply means "nothing to do here".
[ -n "${PROJECT_PATH}" ] || exit 0
[ -d "${PROJECT_PATH}/app" ] || exit 0
cd "${PROJECT_PATH}/app" || exit 0
[ -f bin/console ] || exit 0

# ----------------------------------------------------------------------------------------------------------------------
# Lock
# ----------------------------------------------------------------------------------------------------------------------

# Skip this turn entirely if the previous turn's run is still in flight. -n (non-blocking) is deliberate:
# queueing would pile up one pending pipeline per turn.
if command -v flock >/dev/null 2>&1 && [ -w "${PROJECT_PATH}/app/var" ]; then
  exec 9>"${PROJECT_PATH}/app/var/.claude-stop-php-symfony-clear.lock"
  flock -n 9 || exit 0
fi

# ----------------------------------------------------------------------------------------------------------------------
# Project
# ----------------------------------------------------------------------------------------------------------------------

# Report a failed step and keep going — one broken tool must not skip the steps behind it.
warn_step() {
  echo "[ WARN ] step failed (continuing): $1" >&2
}

# --------------------------------------------------------------------------------------------------------------------
# App - Symfony Framework - Deployment - Other Things                  https://symfony.com/doc/current/deployment.html
# --------------------------------------------------------------------------------------------------------------------
if [ -x ./vendor/bin/php-cs-fixer ]; then
  echo ">>>> PHP - Symfony Framework - Bundles - PHP-CS-Fixer"
  ./vendor/bin/php-cs-fixer fix ./src || warn_step "php-cs-fixer fix ./src"
  echo
fi

# --------------------------------------------------------------------------------------------------------------------
# C) Install/Update your Vendors
# --------------------------------------------------------------------------------------------------------------------
if command -v composer >/dev/null 2>&1; then
  echo ">>>> PHP - Symfony Framework - Deployment - C) Install/Update your Vendors"
  APP_ENV=dev APP_DEBUG=1 composer install \
    --ignore-platform-req=ext-redis \
    --ignore-platform-req=ext-amqp \
    --ignore-platform-req=ext-pdo_pgsql || warn_step "composer install"
  echo
fi

# --------------------------------------------------------------------------------------------------------------------
# D) Clear your Symfony Cache
# --------------------------------------------------------------------------------------------------------------------
echo ">>>> PHP - Symfony Framework - Deployment - D) Clear your Symfony Cache"
APP_ENV=dev APP_DEBUG=1 php bin/console cache:clear || warn_step "cache:clear"
echo

# --------------------------------------------------------------------------------------------------------------------
# H) Other Things - Webpack Encore or AssetMapper
# --------------------------------------------------------------------------------------------------------------------
# php bin/console, not `symfony console` — the Symfony CLI binary is an unguarded external dependency and
# the steps above already invoke the console directly with an explicit APP_ENV.
echo ">>>> PHP - Symfony Framework - Deployment - H) Other Things - Webpack Encore or AssetMapper"
APP_ENV=dev APP_DEBUG=1 php bin/console asset-map:compile || warn_step "asset-map:compile"
echo

# ----------------------------------------------------------------------------------------------------------------------
# Gate
# ----------------------------------------------------------------------------------------------------------------------

# Gates run last: they need the vendor tree composer install just refreshed and the container cache:clear
# just rebuilt. Everything here degrades to "skipped" when the toolchain is absent — an uninstalled project
# must not be reported as a quality failure.
GATE_REPORT=""

gate_fail() {
  GATE_REPORT="${GATE_REPORT}--- $1"$'\n'"$2"$'\n'
}

# --------------------------------------------------------------------------------------------------------------------
# PHPStan (level 8) — working-tree changes only
# --------------------------------------------------------------------------------------------------------------------
# Analysing only what changed keeps the gate to seconds instead of minutes on 2000+ files. Explicit paths
# override the `paths:` key but not `ignoreErrors:` or the 13k-line baseline, so pre-existing debt stays
# suppressed and only newly introduced violations are reported.
if [ -x ./vendor/bin/phpstan ]; then
  PHPSTAN_TARGETS=()
  while IFS= read -r CHANGED_FILE; do
    case "${CHANGED_FILE}" in *.php) ;; *) continue ;; esac
    [ -f "${PROJECT_PATH}/${CHANGED_FILE}" ] || continue
    PHPSTAN_TARGETS+=("${PROJECT_PATH}/${CHANGED_FILE}")
  done <<< "$({
    git -C "${PROJECT_PATH}" diff --name-only HEAD -- app/src app/tests 2>/dev/null
    git -C "${PROJECT_PATH}" ls-files --others --exclude-standard -- app/src app/tests 2>/dev/null
  } || true)"

  if [ ${#PHPSTAN_TARGETS[@]} -gt 0 ]; then
    echo ">>>> PHP - Symfony Framework - Quality Gate - PHPStan (${#PHPSTAN_TARGETS[@]} changed files)"
    PHPSTAN_OUTPUT="$(./vendor/bin/phpstan analyse --no-progress --error-format=raw --memory-limit=1G \
      "${PHPSTAN_TARGETS[@]}" 2>&1)" || gate_fail "PHPStan (level 8)" "${PHPSTAN_OUTPUT}"
    echo
  fi
fi

# --------------------------------------------------------------------------------------------------------------------
# Console linters
# --------------------------------------------------------------------------------------------------------------------
# --show-deprecations lives here rather than in the per-edit twig-lint.sh hook: Symfony promotes deprecations
# to lint errors, so at edit time a single pre-existing one would fire on every unrelated template.
echo ">>>> PHP - Symfony Framework - Quality Gate - lint:twig / lint:container / lint:yaml"

LINT_OUTPUT="$(APP_ENV=dev php bin/console lint:twig --show-deprecations templates/ 2>&1)" \
  || gate_fail "lint:twig templates/" "${LINT_OUTPUT}"

LINT_OUTPUT="$(APP_ENV=dev php bin/console lint:container 2>&1)" \
  || gate_fail "lint:container" "${LINT_OUTPUT}"

LINT_OUTPUT="$(APP_ENV=dev php bin/console lint:yaml config/ 2>&1)" \
  || gate_fail "lint:yaml config/" "${LINT_OUTPUT}"
echo

# stderr, not stdout: asyncRewake shows stderr to Claude as a system reminder and falls back to stdout only
# when stderr is empty — and stdout here is full of housekeeping chatter.
if [ -n "${GATE_REPORT}" ]; then
  {
    echo "[ GATE ] Quality gates failed after the last turn — fix these before the change can merge:"
    printf '%s' "${GATE_REPORT}"
  } >&2
  exit 2
fi

exit 0
