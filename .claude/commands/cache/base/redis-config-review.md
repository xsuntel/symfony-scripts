---
description: "Assesses the quality of Symfony Cache / Redis usage code and provides structured improvement recommendations."
argument-hint: "[path to the file to analyze (PHP or cache.yaml)]"
---

Analyze the following cache-related file:

**`$1`**

The single source of truth (SoT) for the judgment criteria is the rule file. At the start, read the
rule below, cross-check each provision against the target code, flag violations with the **exact line
number**, and provide concrete fixes (improved code snippets). Do not restate the criteria in this command.

@see .claude/rules/cache/base/redis-config-rule.md — judgment criteria (SoT: pools, TTL, injection, locks, sessions, transports)
@see https://symfony.com/doc/current/cache.html

## Review Procedure

Cross-check each section of the rule in order: general rules (interface selection, `#[Target]` pool
injection, explicit TTL, no direct `\Redis` calls), Redis configuration, non-cache Redis uses
(sessions, locks, transports), cache pool conventions, injection patterns, TTL reference. In
particular, check environment-aware TTL (`kernel.debug` branching) and RabbitMQ routing for async messages.

## Output Format

### Summary

| Category | Status (OK / WARN / FAIL) | Issue count |
| --- | --- | --- |
| General rules | | |
| Redis configuration | | |
| Non-cache Redis uses | | |
| Cache pool conventions | | |
| Injection patterns | | |
| TTL reference | | |

### Critical Issues (must fix)

For each issue: **[Line N]** description → recommended fix including a code snippet.

### Improvement Suggestions (recommended)

For each suggestion: **[Line N]** description → recommended approach.

### Refactoring Suggestions

Describe structural changes (pool separation, introducing tags, applying environment-aware TTL, etc.) with before/after code examples.
