---
name: server-nginx-skill
description: Use when authoring, validating, or troubleshooting this Symfony project's Nginx configuration. Triggered by questions about nginx.conf, location blocks, fastcgi_pass, try_files, server_tokens, gzip, add_header, fastcgi_read_timeout, sendfile, php-fpm connections, virtual hosts, or static asset caching, security headers, and the dev/prod config file structure. Also assesses the quality of an existing config file and returns structured improvement recommendations — say "review <path>" to run that mode.
argument-hint: '[path to the Nginx config file to review (nginx.conf, symfony.conf, www.conf) — omit for guidance]'
---

# Nginx Skill

This is the entry point for implementing and reviewing this project's Nginx configuration work.

## Modes

| Request | Mode | Read |
| --- | --- | --- |
| Config authoring, routing, security headers, PHP-FPM, performance tuning | Guide | this file |
| "review `<path>`", quality check of an existing config file | **Review** | [`references/review-guide.md`](references/review-guide.md) |

> The Review mode was the slash command `/server-nginx-review` until 2026-09-10, when
> `.claude/commands/` was folded into `.claude/skills/`. `$ARGUMENTS` carries the target path.
> `tools-app-deploy-skill` dispatches into this mode as part of its pre-deploy fan-out.

## Information Source (single source of truth: the rule file)

**All detailed configuration criteria** — the 4-file config structure, the Symfony 3-stage location
pattern, PHP-FPM connection, static asset caching, security directives, TLS, gzip, FastCGI buffering,
health check, SSE/WebSocket — are in the rule file. This skill does not duplicate the rules; it only
provides guidance on which target to edit and the verification procedure.

@see .claude/rules/server-nginx-rule.md — full config file structure/location/security/performance/deployment standards (SoT)
@see https://symfony.com/doc/current/setup/web_server_configuration.html#nginx

## Deciding What to Edit

Two environments are covered by four files. **Never modify the config inside a running container** —
edit the source under `scripts/` and rebuild the image. See the rule's `## Directory Structure` table for the file mapping.

- Keep the location blocks of base/dev and prod in sync — only the `fastcgi_pass` socket path and `listen` address differ per environment.
- The production Dockerfile copies only `http.d/www.conf` (line 128). When changing `nginx.conf`, uncomment line 127 and rebuild.

## Validation & Reload (Bash)

Always validate before reloading — reloading with a syntax error stops all request handling.

```bash
# Validate the config on the host
nginx -t

# Validate inside a Docker container
docker exec <container> nginx -t

# Zero-downtime reload (only after nginx -t succeeds)
nginx -s reload

# Reload in Docker (HUP signal to PID 1)
kill -HUP 1

# Health check
curl -f http://localhost:8080/healthcheck.php || exit 1
```

## Checklist (common to implementation & review)

- [ ] Did you edit the source under `scripts/` (no direct modification inside the container)?
- [ ] Are the base/dev ↔ prod location blocks in sync?
- [ ] Does every `server {}` have `server_tokens off;` + the three security headers?
- [ ] Does the PHP location have `internal;` and `fastcgi_hide_header X-Powered-By;`?
- [ ] Did you use `$realpath_root` (not `$document_root`)?
- [ ] Is `fastcgi_read_timeout` shorter than php-fpm's `request_terminate_timeout`?
- [ ] Did you set `1y` + `immutable` on `/assets/`?
- [ ] Did you scope `fastcgi_buffering` to the PHP location (no `proxy_buffering` misuse)?
- [ ] Did you reload after `nginx -t` validation?

When a review is requested, report severity as MUST (critical) / SHOULD (recommended) / CONSIDER (optional).
