---
paths:
  - "app/assets/**/*.js"
---

# JavaScript / Stimulus Rules — Overview, Modules, Naming

@see .claude/docs/app/javascript-stimulus-docs.md

## Rule Files

| File | Area of responsibility |
|------|----------------|
| 00-overview-rule.md | Module system, variable declarations, file naming, absolute prohibitions |
| 01-controller-rule.md | Stimulus controller structure, Twig helpers, lazy loading, controller-to-controller communication |
| 02-quality-rule.md | Security, performance, async handling, verification checklist |

## Absolute Prohibitions

- Do not use `eval()` / `new Function(str)`.
- Do not assign user input to `innerHTML` — use `textContent` or insert after DOMPurify sanitization.
- Do not use `document.querySelector()` / `this.element.querySelector()` — use `this.*Target`, Outlets, or custom events.
- Do not use `require()` / `module.exports` — ES Modules only.
- Do not leave `console.log` / `console.debug` in production code.
- Do not store tokens or passwords in localStorage — use HttpOnly cookies.

## Module System

- Use only `import`/`export`. Stimulus controllers use `export default class extends Controller`; utilities use named exports.
- Sort imports into two groups: (1) framework/third-party, (2) local modules — separated by a blank line.
- Do not leave unused imports.

```javascript
import { Controller } from '@hotwired/stimulus'

import { debounce } from '../utils/debounce'

export default class extends Controller { }
```

## Variable Declarations

- Use `const` by default, and `let` only when reassignment is needed — no `var`.
- Module-level constants use `UPPER_SNAKE_CASE` — magic numbers must always be named.
- Private fields use `#camelCase` — do not use the `_prefix` convention.

## File Naming and Identifiers

| File name | Stimulus identifier | `data-controller` |
| --- | --- | --- |
| `board_controller.js` | `board` | `data-controller="board"` |
| `users/list_item_controller.js` | `users--list-item` | `data-controller="users--list-item"` |

- File name: `snake_case_controller.js`, location: `app/assets/controllers/`.
- Identifier: `kebab-case` (multi-word) or `namespace--name` (subdirectory).
- The `data-controller` value and the file name must match for StimulusBundle auto-registration to work.

## Code Quality

- When a function exceeds 30 lines, split its responsibilities into private methods.
- Do not leave commented-out code blocks — rely on git history.
- Extract code duplicated across 3 or more lines into a utility module under `app/assets/utils/`.
