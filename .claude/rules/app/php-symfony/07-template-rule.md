---
paths:
  - "app/templates/**/*.html.twig"
---

# Twig Template Rules

@see https://symfony.com/doc/current/templates.html

## Naming Conventions

- Template file names and directories: **snake_case**.
  - Correct: `user_profile.html.twig`, `product/edit_form.html.twig`
  - Wrong: `UserProfile.html.twig`, `Product/EditForm.html.twig`
- Template variable names: **snake_case**.
- Template paths must mirror the Controller path exactly:
  - `PostController::show` → `templates/post/show.html.twig`

## Partial Templates (Fragments)

Use an **underscore prefix** (`_`) for reusable partial templates:

```
templates/post/_post_card.html.twig
templates/shared/_caution_message.html.twig
templates/shared/_user_metadata.html.twig
```

Include them with `{{ include('post/_post_card.html.twig') }}`.

## Template Inheritance

- Define shared layouts in `base.html.twig`.
- Use `{% extends %}` + `{% block %}` — never duplicate the HTML structure.
- Limit inheritance to **at most 3 levels**: `base.html.twig` → `layout.html.twig` → `page.html.twig`.

```twig
{# templates/post/show.html.twig #}
{% extends 'base.html.twig' %}

{% block title %}{{ post.title }}{% endblock %}

{% block body %}
    <article>
        <h1>{{ post.title }}</h1>
        {{ post.content | nl2br }}
    </article>
{% endblock %}
```

## Security — XSS Prevention

- Twig auto-escaping is **always enabled** — never disable it.
- Never use `{{ variable|raw }}` on user input or values from the database.
- User-generated Markdown: render it with `league/commonmark` HTML sanitization applied, then output with `|raw`.

## Twig Components (Symfony UX)

Use Twig Components for reusable, self-contained UI elements:

```php
#[AsTwigComponent]
final class Alert
{
    public string $type = 'info';
    public string $message = '';
}
```

```twig
{# Usage #}
<twig:Alert type="success" message="Post saved!" />
```

Prefer Twig Components over macros for anything backed by a PHP class or requiring PHP logic.

@see https://symfony.com/doc/current/best_practices.html#templates
@see https://symfony.com/bundles/TwigComponent/current/index.html

## Twig Function Reference

| Function | Purpose | Notes |
|---|---|---|
| `{{ variable }}` | Output with automatic HTML escaping | Always prefer this |
| `{{ variable\|raw }}` | Output without escaping | Trusted HTML only — minimize use |
| `{{ is_granted('ROLE_ADMIN') }}` | Permission check | Use in conditionals |
| `{{ csrf_token('delete-post') }}` | Generate a CSRF token | Required for custom POST actions |
| `{{ path('route_name', {id: post.id}) }}` | Generate a URL | Preferred over hardcoded URLs |
| `{{ asset('images/logo.png') }}` | Generate an asset URL | Handles versioning automatically |
| `{{ dump(variable) }}` | Inspect a variable | dev environment only |
| `{{ include('_partial.html.twig') }}` | Insert a partial template | Use underscore-prefixed partials |

@see https://symfony.com/doc/current/templates.html
