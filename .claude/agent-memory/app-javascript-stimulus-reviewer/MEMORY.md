# app-javascript-stimulus-reviewer memory

## Environment constants (verified)

- **The version SoT is `app/importmap.php`** (not package.json). If it cannot be confirmed, do not guess.
- AssetMapper convention: declare JS packages via `importmap:require` — no `npm install` / `node_modules` imports, no CDN `<script src>`.
- Stimulus controllers are auto-registered from `app/assets/controllers/`.

## Standing review checks

- Component selection favors the lowest complexity first (Twig < Stimulus < TwigComponent < LiveComponent < Turbo). A client-side SPA is forbidden without an explicit request.
- When a controller changes, confirm the corresponding Twig's `data-*` contract matches. Use `this.*Target` instead of `document.querySelector()`.
- Only `[MUST]` blocks the merge.

## SoT

- .claude/rules/app-javascript-stimulus-00~02-*-rule.md
- app/assets/CLAUDE.md (asset directory conventions)
