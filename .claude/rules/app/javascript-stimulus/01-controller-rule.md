---
paths:
  - "app/assets/controllers/**/*.js"
  - "app/templates/**/*.twig"
---

# JavaScript / Stimulus Rules — Controllers

@see .claude/docs/app/javascript-stimulus-docs.md — §3~§5
@see https://stimulus.hotwired.dev/

## Controller Structure

- Declare `static targets` / `static values` / `static classes` / `static outlets` at the very top of the class.
- Do not override `constructor()` — perform initialization in `initialize()`/`connect()`.
- Event listeners, intervals, and observers registered in `connect()` must be cleaned up in `disconnect()`.
- Access the DOM only via `this.*Target`/`this.*Targets` — no querySelector (see 00-overview).

## Registration and Loading

- Place controllers in `app/assets/controllers/` and StimulusBundle registers them automatically — no manual `application.register()`.
- Manage third-party Symfony UX controllers in `assets/controllers.json` (`fetch: eager|lazy`).
- Lazy-loading criteria:
  - Controllers not used on every page → add a `/* stimulusFetch: 'lazy' */` comment at the top of the file
  - App-wide UI (modals, toasts, dropdowns) → `eager`
  - Heavy external SDK dependencies (maps, charts) → `lazy`
- When using TypeScript, verify that `removeComments: true` does not strip the lazy comment.

## Twig Helpers (required)

Do not write `data-*` attribute strings by hand — use the StimulusBundle Twig helpers:

```twig
<div {{ stimulus_controller('column', { 'status': 'todo' }, { 'active': 'ring-2 ring-blue-500' }) }}>
  <span {{ stimulus_target('column', 'counter') }}>0</span>
  <button {{ stimulus_action('board', 'removeCard', 'click', { 'id': card.id }) }}>Delete</button>
</div>

{# Pass to forms with .toArray() #}
{{ form_row(form.title, { attr: stimulus_action('card', 'validateTitle', 'input').toArray() }) }}
```

- Combine multiple controllers/actions/targets by chaining the `|stimulus_*` filters.

## Controller-to-Controller Communication

- Child → parent: custom event `this.dispatch('updated', { detail: {...}, bubbles: true })` → received in HTML with `data-action="card:updated->board#save"`.
- Parent → child direct call: use an Outlet (`static outlets`).
- For cancelable flows, use `this.dispatch('deleting', { cancelable: true })` then check `event.defaultPrevented`.
- Do not call `application.getControllerForElementAndIdentifier()` directly.
