---
description: "Assesses the quality of an Nginx configuration file and provides structured improvement recommendations."
argument-hint: "[path to the Nginx config file to analyze (nginx.conf, symfony.conf, www.conf, etc.)]"
---

Analyze the following Nginx configuration file:

**`$1`**

The single source of truth (SoT) for the judgment criteria is the rule file. At the start, read the
rule below, cross-check each provision against the target configuration, flag violations with the
**exact line number**, and provide concrete fixes (improved config snippets). Do not restate the
criteria in this command.

@see .claude/rules/server/nginx-rule.md — judgment criteria (SoT: structure, routing, security, performance, deployment)
@see https://symfony.com/doc/current/setup/web_server_configuration.html#nginx

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
| Symfony routing | | |
| PHP-FPM connection | | |
| Static asset delivery | | |
| Security directives | | |
| Performance tuning | | |
| Health check | | |
| WebSocket & Turbo Streams | | |
| Deployment rules | | |

### Critical Issues (must fix)

For each issue: **[Line N]** description → recommended fix including a config snippet.

### Improvement Suggestions (recommended)

For each suggestion: **[Line N]** description → recommended approach.

### Refactoring Suggestions

Describe structural changes (restructuring location blocks, cross-environment sync, consolidating
security headers, etc.) with before/after config examples.
