---
description: "Assess the quality of a Twig file and provide structured improvement recommendations."
argument-hint: "[path to the Twig file to analyze]"
---

Analyze the following Twig template:

**`$1`**

## Judgment Criteria (SoT)

@see .claude/rules/app/base/twig-symfony/00-overview-rule.md — Twig standards, escaping, security (SoT)
@see .claude/rules/app/base/php-symfony/07-template-rule.md — naming, inheritance, components
@see .claude/rules/app/base/php-symfony/10-frontend-rule.md — AssetMapper, Stimulus, UX
@see .claude/rules/app/base/php-symfony/08-security-rule.md — XSS, CSRF
@see .claude/docs/app/base/twig-symfony-docs.md — syntax/function details

Follow Part 3 of the `twig-symfony-helper` skill for the review methodology, cross-checks, and output format.

## Review Procedure

1. Determine the target template's role (layout / page / `_partial` / macro / form theme / component).
2. Check it against the SoT rules above. Core checks:
   - Auto-escaping preserved — no `|raw`/`{% autoescape false %}` on user/DB input.
   - URLs/assets referenced via `path()`/`url()`/`asset()` (no hardcoding).
   - CSRF (`_token`/`csrf_token()`) on state-changing forms; permission UI wrapped in `is_granted()`.
   - No Repository/DB calls or business logic in the template (data prepared in the controller/Extension).
   - Constants/enums referenced via `enum()`/`enum_cases()`/`constant()` instead of magic strings.
   - No `render(controller())` fragment overuse (simple reuse via `include`/component); global values injected via `twig.yaml globals`.
   - Duplicated markup removed with inheritance/partials/macros; no leftover `{{ dump() }}`; accessibility (alt/label).
3. Statically validate syntax/deprecations with `cd app && php bin/console lint:twig {path}`.

## Output

Classify by severity `[MUST]` (XSS, CSRF, render exception, rule violation — blocks merge) / `[SHOULD]`
(duplication, performance, accessibility) / `[CONSIDER]` (style). Output order: **summary → [MUST] →
[SHOULD] → [CONSIDER] → positive feedback (at least 1, cite file:line)**.
