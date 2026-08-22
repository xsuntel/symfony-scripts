# app-javascript-stimulus-analyzer memory

## Environment constants (verified)

- Stack: Stimulus 3 / Turbo 8 / AssetMapper. Controllers auto-register from `app/assets/controllers/` via `stimulus_bootstrap.js`.
- The dependency-graph SoT is `app/importmap.php` (not package.json). Do not invent controller identifiers, target names, or package versions.

## Structural smells to watch

- Single-responsibility violation (>10 methods / hundreds of lines), controller coupling (`static outlets`, global events/`window` state), target-bypass DOM access (`document.querySelector`/`getElementById` instead of `this.xTarget`).
- Hardcoded config instead of the `values` API, duplicated controllers with no extracted base/mixin, importmap smells (heavy lib imported per-controller, unused entries, circular imports), asymmetric `connect()`/`disconnect()` lifecycle.
- Scope this to structure — leave `[MUST]/[SHOULD]/[CONSIDER]` judgments to `app-javascript-stimulus-reviewer` and runtime failures to `app-javascript-stimulus-debugger`. Handoff: `analyzer → reviewer → tester`.

## Output

- ADR format (Context/Decision/Consequences) + trade-offs on three axes (scalability/maintainability/performance) + alternatives, per the abstract-english-style "Architecture Design & Analysis" section. Denote controller coupling with arrows.

## SoT

- .claude/rules/app-php-symfony-10-frontend-rule.md (AssetMapper, UX, importmap)
- .claude/output-styles/app-javascript-stimulus-style.md (JS/Stimulus style & structure)
- app/assets/CLAUDE.md (asset directory conventions)
- .claude/output-styles/abstract-english-style.md (ADR & trade-offs)
