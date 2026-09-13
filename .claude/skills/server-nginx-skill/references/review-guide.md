# Nginx Review Guide

The **Review mode** of `server-nginx-skill` — assesses the quality of an Nginx configuration file and
returns structured improvement recommendations. `SKILL.md` dispatches here via its `## Modes` table.

**This is not judgment criteria** — `rules/server-nginx-rule.md` is SoT. This guide holds only the
target selection, the review procedure and the output format.

> Until 2026-09-10 this was the slash command `/server-nginx-review`. It now runs as the review mode of
> `/server-nginx-skill`; `$ARGUMENTS` still carries the target path.

Analyze the following Nginx configuration file:

**`$ARGUMENTS`**

> **When the argument is empty**, review the four config files listed in the rule's directory-structure
> table as a single set (cross-checking them together to verify base ↔ prod location sync):
>
> - `scripts/base/server/nginx/nginx.conf`
> - `scripts/base/server/nginx/conf.d/symfony.conf`
> - `scripts/containers/prod/server/nginx/etc/nginx/nginx.conf`
> - `scripts/containers/prod/server/nginx/etc/nginx/http.d/www.conf`
>
> Do not blindly scan the rest of `scripts/**` or guess a target beyond this list.

The single source of truth (SoT) for the judgment criteria is the rule file. At the start, read the
rule below, cross-check each provision against the target configuration, flag violations with the
**exact line number**, and provide concrete fixes (improved config snippets). Do not restate the
criteria in this guide.

@see .claude/rules/server-nginx-rule.md — judgment criteria (SoT: structure, routing, security, performance, deployment)
@see <https://symfony.com/doc/current/setup/web_server_configuration.html#nginx> — Symfony web server config
@see <https://nginx.org/en/docs/> — Nginx official docs (general directive semantics; the project SoT above overrides generic best-practice advice)

> **Note:** this project intentionally differs from some generic Nginx advice — `sendfile off;` in
> `http.d/www.conf` is a deliberate Docker-volume override (keep it `on` only on bare-metal), the
> Ratchet/Pawl WebSocket connections are **outbound** from PHP workers (no nginx WebSocket proxy is
> required), and **CSP is intentionally not set in nginx** (managed in Symfony/NelmioSecurityBundle).
> Do not flag these against general best-practice advice — judge only against the SoT rule.

## Review Procedure

Cross-check each section of the rule in order: general rules (run user, `server_tokens`, cross-environment
sync, `proxy_buffering` misuse), Symfony 3-stage routing, PHP-FPM connection, static asset delivery,
security directives, performance tuning, health check, WebSocket/Turbo, deployment rules. In particular,
check the base/dev ↔ prod location sync and the `fastcgi_read_timeout` < `request_terminate_timeout` relationship.

## Output Format

### Summary

| Category | Status (OK / WARN / FAIL) | Issue count |
| --- | --- | --- |
| General rules | | |
| File layout / environment sync | | |
| Symfony routing | | |
| PHP-FPM connection | | |
| Static asset delivery | | |
| Security directives | | |
| Performance tuning | | |
| Health check | | |
| WebSocket & Turbo Streams | | |
| Deployment rules | | |

### Critical Issues (must fix)

For each issue: **[Line N]** `[MUST]` description → recommended fix including a config snippet.

### Improvement Suggestions (recommended)

For each suggestion: **[Line N]** `[SHOULD]` description → recommended approach.

### Refactoring Suggestions

Mark structural changes (restructuring location blocks, cross-environment sync, consolidating security
headers, etc.) as `[CONSIDER]` and describe them with before/after config examples. Only `[MUST]` blocks
a merge.
