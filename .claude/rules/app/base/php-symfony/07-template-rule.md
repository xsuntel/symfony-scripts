---
paths:
  - "app/templates/**/*.html.twig"
---

# Template Rules (PHP/Symfony ↔ Twig delegation)

Template concerns for this project — naming/placement, partial (`_`) conventions, 3-level inheritance,
auto-escaping/XSS, TwigComponent vs macro, and logic separation — are owned by the **Twig/Symfony domain
rule** as the single source of truth (SoT). This file exists only to keep the PHP/Symfony numbered rule
set complete and to delegate; it does not restate those criteria.

@see .claude/rules/app/base/twig-symfony/00-overview-rule.md — Twig template judgment criteria (SoT)
@see .claude/docs/app/base/twig-symfony-docs.md — annotated syntax/filter/function/inheritance examples
@see .claude/rules/app/base/php-symfony/03-controller-rule.md — controller-side render() and template-path mapping
@see .claude/rules/app/base/php-symfony/08-security-rule.md — XSS/CSRF criteria referenced by templates

## Controller ↔ Template Contract (PHP side)

- The controller prepares all view data; templates receive ready-to-render values and hold **no** business
  logic, aggregation, or Repository/DB calls (thin templates — enforced by the Twig rule).
- Template paths mirror the controller path exactly: `PostController::show` → `templates/post/show.html.twig`.
- Load associations in the controller/Repository before rendering a collection to avoid N+1 in the view.
