---
paths:
  - "app/src/**/*.php"
---

# Security Rules

@see https://symfony.com/doc/current/security.html

## Firewall Configuration

- Keep a **single `main` firewall** unless a separate authentication scheme is genuinely required.
- Concentrate all security logic in one firewall — do not split into `api` + `main` unless the authentication mechanisms differ.

## Password Hashing

- Always use the `auto` hasher — it automatically selects the best algorithm for the current PHP version.
- Do not specify a concrete algorithm (`bcrypt`, `argon2id`) — let Symfony choose.

```yaml
# config/packages/security.yaml
security:
    password_hashers:
        App\Entity\Abstract\Users\User:
            algorithm: auto
```

## Authorization (access control)

- Implement complex permission logic in a **Voter class** — not with `#[Security]` expressions or `isGranted()` calls using long strings.
- Use `#[IsGranted]` on controller actions for simple role checks.
- Use `#[Security("...")]` only for simple attribute expressions — long expressions are a code smell.

```php
// Correct — delegate to Voter
#[IsGranted('POST_EDIT', subject: 'post')]
#[Route('/post/{id}/edit', name: 'post_edit', methods: ['GET', 'POST'])]
public function edit(Post $post): Response { ... }
```

```php
// PostVoter.php
final class PostVoter extends Voter
{
    protected function supports(string $attribute, mixed $subject): bool
    {
        return in_array($attribute, ['POST_EDIT', 'POST_DELETE'], true)
            && $subject instanceof Post;
    }

    protected function voteOnAttribute(string $attribute, mixed $subject, TokenInterface $token): bool
    {
        $user = $token->getUser();
        if (!$user instanceof User) {
            return false;
        }

        return match ($attribute) {
            'POST_EDIT'   => $subject->isOwnedBy($user),
            'POST_DELETE' => $subject->isOwnedBy($user) || $this->isGranted('ROLE_ADMIN'),
            default       => false,
        };
    }
}
```

## Access Control Priority

Apply access control in the following priority order:

1. `access_control` (configuration) — global URL-pattern-based rules.
2. `#[IsGranted('ROLE_ADMIN')]` — controller attribute (preferred in most cases).
3. `$this->denyAccessUnlessGranted()` — inside conditional logic.
4. `{% if is_granted('ROLE_ADMIN') %}` — Twig templates for UI-only visibility.

```php
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class AdminController extends AbstractController {}

// With Voter
#[IsGranted('POST_EDIT', subject: 'post')]
public function edit(Post $post): Response {}
```

@see https://symfony.com/doc/current/security.html#access-control-authorization

## Role Hierarchy

Use a role hierarchy for permission management instead of simple string comparison. Configure `ROLE_ADMIN` to automatically include `ROLE_USER`.

```yaml
# config/packages/security.yaml
security:
    role_hierarchy:
        ROLE_MODERATOR: ROLE_USER
        ROLE_ADMIN:     [ROLE_MODERATOR, ROLE_USER]
        ROLE_SUPER_ADMIN: ROLE_ADMIN
```

@see https://symfony.com/doc/current/security.html#roles

## User Provider

Use a Doctrine entity-based provider. Specify the login identifier field with the `property` option. The `User` class must implement `UserInterface` (generate it with `make:user`).

```yaml
security:
    providers:
        app_user_provider:
            entity:
                class: App\Entity\Abstract\Users\User
                property: email
```

@see https://symfony.com/doc/current/security.html#the-user

## CSRF Protection

- Every state-changing HTML form submission must include `csrf_token()` in the template.
- The controller action that processes the form must use `#[IsCsrfTokenValid('intention', '_token')]`.
- HTML form submissions: rely on Symfony Form's built-in CSRF protection (enabled by default).
- Custom POST actions without a Form: use `#[IsCsrfTokenValid('intention', '_token')]` on the action.
- AJAX requests: generate the token with `csrf_token('intention')` in Twig, send it in a custom header, and validate it in the controller.
- JWT-authenticated API endpoints are **exempt** from CSRF (they do not use cookie-based sessions).

## Rate Limiting

Apply `symfony/rate-limiter` to login, registration, password reset, and all public POST endpoints.
On exceeding the limit, respond with HTTP 429 and a `Retry-After` header.

```php
#[RateLimiter('login')]
#[Route('/login', name: 'app_login', methods: ['POST'])]
public function login(): Response { ... }
```

## Input Handling

- **Never** access `$_POST`, `$_GET`, `$_REQUEST`, or `$request->get()` directly in a Controller.
- All user input must pass through a Symfony Form type or a DTO + Validator constraints.
- Validate at the boundary before calling a Service or Repository.

## XSS

- Twig auto-escaping is always enabled — never disable it.
- **Never** use `{{ variable|raw }}` on user input or values from the database.
- Markdown rendering: use `league/commonmark` with HTML sanitization enabled.

## SQL Injection

- DQL + QueryBuilder parameter binding is safe — always use `:param` binding.
- Native SQL: use `$conn->executeQuery($sql, $params)` — **never** use string interpolation.
- Do not place raw SQL in an Entity, Service, or Controller — only in a Repository.

## JWT

- Keep JWT signing and verification logic only in a dedicated Service class.
- Never log the JWT token value — log only the user identifier extracted from the token.
- Token expiry must be enforced — reject expired tokens at the EventSubscriber level.
- Refresh tokens must be rotated on every use.

## OAuth2 / Social Login

- State parameter validation is required — `knpuniversity/oauth2-client-bundle` handles this, so do not bypass it.
- Do not store OAuth access tokens in cookies — store them in a server-side session (Redis-backed).

## Sensitive Data

- Never log passwords, tokens, API keys, or PII.
- Store external provider (KoreaInvestment, UPbit) API keys in encrypted JSONB columns or environment variables — never in plaintext entity columns.
- Use the `#[Sensitive]` attribute on DTO properties that hold passwords or tokens (Symfony 6.2+).

## Security Headers

- Set them at the Nginx level in production.
- In development, verify them with the Security panel of `symfony/web-profiler-bundle`.

@see https://symfony.com/doc/current/security/voters.html
@see https://symfony.com/doc/current/security/csrf.html
@see https://symfony.com/doc/current/rate_limiter.html
