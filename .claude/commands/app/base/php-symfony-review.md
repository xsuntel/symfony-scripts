---
description: "Assesses the quality of a PHP file and provides structured improvement recommendations."
argument-hint: "[path to the PHP file to analyze]"
---

Analyze the following PHP file:

**`$1`**

The single source of truth (SoT) for the judgment criteria is the rule files. At the start, read the
rules below, cross-check each provision against the target code, flag violations with the **exact line
number**, and provide concrete fixes (improved code snippets). Do not restate the criteria in this
command — when the rules are updated, this review follows automatically.

@see .claude/rules/app/base/php-symfony/00-overview-rule.md ~ 11-performance-rule.md — judgment criteria (SoT)
@see .claude/output-styles/app/base/php-symfony-style.md — code style (PSR-12, headers, formatting)
@see .claude/rules/database/base/postgresql-config-rule.md — Doctrine-related
@see .claude/rules/api/base/api-platform-rule.md — API Platform (inbound REST) related

## Review Procedure

Identify the target file's layer and cross-check the corresponding rules: file header/standards (00, 02),
PHP 8.4 features, type safety / PHPStan level 8, class design (01), DI/Symfony conventions (04),
Doctrine (05, postgresql-rule), Messenger/CQRS (01), security (08), error handling/logging, domain
structure (01, structure-rule), performance (11).

## Output Format

### Summary

| Category | Status (OK / WARN / FAIL) | Issue count |
| --- | --- | --- |
| File header & standards | | |
| PHP 8.4 modern features | | |
| Type safety & static analysis | | |
| Class design & architecture | | |
| Dependency injection | | |
| Doctrine ORM | | |
| Messenger / CQRS | | |
| Security | | |
| Error handling & logging | | |
| Domain structure | | |

### Critical Issues (must fix)

For each issue: **[Line N]** description → recommended fix including a code snippet.

### Improvement Suggestions (recommended)

For each suggestion: **[Line N]** description → recommended approach.

### Refactoring Suggestions

Describe structural changes (class extraction, layer rearrangement, CQRS separation, etc.) with before/after code examples.
