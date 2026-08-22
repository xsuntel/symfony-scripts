# app-twig-symfony-reviewer memory

## Conventions (verified)

- Assets go through AssetMapper (importmap) — use `asset()`, no CDN `<script src>` / `node_modules` imports.
- Keep auto-escaping on at all times (`|raw` only on trusted server-generated HTML). URLs use `path()`/`url()` (no hardcoding).
- Component selection favors the lowest complexity first: static Twig → Stimulus → TwigComponent → LiveComponent → Turbo Frame/Stream. A client-side SPA is forbidden without an explicit request.

## Controller-template contract

- When a Stimulus controller changes, also confirm the corresponding Twig's `data-*` contract (target/value/action) matches.

## SoT

- .claude/rules/app-twig-symfony-00-overview-rule.md
- .claude/rules/app-php-symfony-07-template-rule.md, 10-frontend-rule.md
