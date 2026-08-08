---
paths:
  - "app/assets/**/*.js"
---

# JavaScript / Stimulus Rules — Security, Performance, Quality

@see .claude/docs/app/base/javascript-stimulus-docs.md — §6, §9

## Security

| Dangerous pattern | Replacement pattern |
| --- | --- |
| `element.innerHTML = userInput` | `element.textContent = userInput` |
| `innerHTML = serverHtml` | Insert after DOMPurify sanitization |
| `eval()` / `new Function(str)` | Never allowed |
| Storing tokens/passwords in localStorage | Use HttpOnly cookies |

- Always render user-originated text (titles, descriptions, etc.) with `textContent`.

## Async Handling

- Always wrap async event handlers in `try/catch` — unhandled rejections are silently swallowed. In the catch, call `console.error` with structured context, then re-throw if needed.
- Check `response.ok` on `fetch` responses and, on failure, escalate with `throw new Error(...)`.
- Always wrap `JSON.parse` in `try/catch` — invalid JSON throws synchronously.
- Use localStorage-restored data only after schema validation (require a `version` field, enforce upper bounds, ignore unknown fields).

## Performance

- Manage event listener registration/removal in pairs — keep the bound reference in a private field and remove it with the same reference in `disconnect()`:

```javascript
connect() {
  this.#boundOnResize = this.#onResize.bind(this)
  window.addEventListener('resize', this.#boundOnResize)
}

disconnect() {
  window.removeEventListener('resize', this.#boundOnResize)
}
```

- Do not start `setInterval`/`setTimeout` without keeping the reference — guarantee `clearInterval`/`clearTimeout` in `disconnect()`.
- Prevent layout thrashing — batch DOM reads (offsetHeight, etc.) first, then batch writes.

## Verification Checklist

Check after finishing a controller implementation (review with the `app:javascript-stimulus-review` command):

```text
[ ] ES Modules only — no require()
[ ] static targets/values/classes/outlets declared at the top of the class
[ ] No constructor() override
[ ] Event listeners / intervals / observers cleaned up in disconnect()
[ ] No document.querySelector() — this.*Target only
[ ] No innerHTML — textContent or DOMPurify
[ ] try/catch on async handlers
[ ] try/catch on JSON.parse
[ ] No console.log (production code)
[ ] No commented-out code
[ ] No magic numbers — UPPER_SNAKE_CASE const
[ ] Private fields #camelCase (no _prefix)
[ ] stimulus_controller() / stimulus_action() / stimulus_target() used in Twig
[ ] /* stimulusFetch: 'lazy' */ applied to heavy controllers
[ ] Lazy controllers checked for TypeScript removeComments conflict
```
