---
paths:
  - "app/src/**/*.php"
---

# Architecture Rules

@see https://symfony.com/doc/current/best_practices.html#use-the-default-directory-structure

## Directory Structure

Always follow the standard Symfony directory layout. The Symfony application root is `app/`.

```text
xsun-app/                             ← Repository root
└── app/
    └── src/                                 # PHP source code (namespace: App\)
        ├── ApiResource/                     # API Platform resource classes
        ├── Command/                         # Symfony Console commands
        ├── Controller/                      # HTTP controllers (thin glue code only)
        ├── DataFixtures/                    # DoctrineFixturesBundle fixture classes
        ├── Entity/                          # Doctrine entities (PostgreSQL)
        ├── EntityRepository/                # Doctrine Repository classes
        ├── EventListener/                   # Single-event listeners (#[AsEventListener])
        ├── EventSubscriber/                 # Multi-event subscribers (getSubscribedEvents)
        ├── Form/                            # Symfony Form types
        ├── MessageCommand/                  # Messenger write-side messages (Command)
        ├── MessageCommandHandler/           # Handlers for MessageCommand classes
        ├── MessageEvent/                    # Messenger domain events
        ├── MessageEventHandler/             # Handlers for MessageEvent classes
        ├── MessageQuery/                    # Messenger read-side messages (Query)
        ├── MessageQueryHandler/             # Handlers for MessageQuery classes
        ├── Messenger/                       # Shared Messenger middleware / stamps
        ├── Scheduler/                       # Symfony Scheduler periodic tasks
        ├── Serializer/                      # Custom Symfony Serializer normalizers
        ├── Service/                         # Application and domain services
        ├── Twig/                            # Twig extensions and components
        ├── CLAUDE.md
        ├── Kernel.php
        └── Schedule.php
```

## Environments

- Three built-in environments: `dev`, `prod`, `test`.
- Per-environment configuration: the `config/packages/{env}/` directory or the `when@{env}:` key in YAML.
- The active environment is determined by the `APP_ENV` environment variable.

@see https://symfony.com/doc/current/configuration.html#configuration-environments

## Kernel

- `src/Kernel.php` is the application entry point.
- `HttpKernel` handles the full Request → Response conversion cycle.
- Always consult the official documentation first before modifying the Kernel.

@see https://symfony.com/doc/current/components/http_kernel.html

## Bundle Policy

- **Prohibited**: creating a Bundle to separate application logic.
- **Allowed**: extracting a genuinely reusable, cross-project shared package as a Bundle (private repository).
- Organize code logically with PHP namespaces, not Bundles.

@see https://symfony.com/doc/current/best_practices.html#don-t-create-any-bundle-to-organize-your-application-logic

## Listener vs. Subscriber

- Use an `EventListener` + `#[AsEventListener]` when a class handles **exactly one** kernel or domain event.
- Use an `EventSubscriber` + `getSubscribedEvents()` when a class handles **multiple** events.

This distinction keeps the single-responsibility principle clear and avoids unnecessary boilerplate.

## Domain Layering

This project is divided into the following top-level domains. Every subdirectory under `app/src/` mirrors this layering exactly.

| Domain               | Purpose                                                      |
| -------------------- | ------------------------------------------------------------ |
| `Abstract`           | Shared base logic (Users, Base, Connect) — no business logic |
| `Company`            | Company introduction pages and content                       |
| `Partners`           | Partner/store management                                     |
| `Products`           | Product catalog                                              |
| `Resources`          | Content resources (Blog, Developers, YouTube)                |
| `Team`               | Internal team tools (Agents, Support)                        |
| `Tools`              | Application tools (Chat, Email)                              |

## Namespace → Directory Mapping

Every PHP class namespace maps 1:1 to a filesystem path under `app/src/`:

```
App\{Layer}\{Domain}\{Name}
→ app/src/{Layer}/{Domain}/{Name}.php
```

For deeply nested provider entities, the full provider path is preserved as-is:

```
App\Entity\Providers\Finance\App\Securities\KoreaInvestment\Domestic\Stock\API\REST\Enterprise\ChkHoliday
→ app/src/Entity/Providers/Finance/App/Securities/KoreaInvestment/Domestic/Stock/API/REST/Enterprise/ChkHoliday.php
```

- **Never flatten** deeply nested provider namespaces for convenience — these paths mirror the hierarchy of the external provider API.
- **Never create** files directly in `app/src/` without a domain subdirectory — every class belongs to a domain.

## Cross-Domain Rules

- Domain classes may depend on `Abstract` classes.
- Domain classes must **not** depend on the internal classes of another domain (e.g. `Company` must not import from `Partners`).
- Cross-domain data sharing must go through a shared Entity or a MessageQuery dispatch — never direct cross-domain Service injection.

Use an `EventSubscriber` when a class subscribes to multiple events via `getSubscribedEvents()`.
Use an `EventListener` with `#[AsEventListener]` when a class handles exactly one event — it is simpler and avoids boilerplate.

## Naming Conventions

- **Class**: PascalCase, no suffix except the conventionally required layer suffix:
  - Repository: `{Name}Repository`
  - Handler: same class name as the message it handles (distinguished at the handler-layer folder level)
  - EventSubscriber: `{Name}Subscriber`
  - EventListener: `{Name}Listener`
  - Form type: `{Name}Type`
  - Twig component: `{Name}` (no suffix)
- **Enum**: `{DescriptiveName}Enum` (e.g. `OrdersStatusEnum`, `TwoFactorTypeEnum`).
- **Route**: `{domain}_{subdomain}_{action}` in snake_case (e.g. `providers_finance_korea_investment_list`).
- **Twig template**: mirrors the controller path exactly — `templates/{domain}/{subdomain}/{action}.html.twig`.

## Abstract Domain

The `Abstract` subdomain holds shared infrastructure for cross-domain concerns:

- `Abstract/Base` — base Controller, base EventSubscriber, base Fixture setup
- `Abstract/Connect` — OAuth2 connection flow shared across multiple providers
- `Abstract/Users` — user account handling shared application-wide

Classes in `Abstract` must be interfaces or abstract classes — `final` concrete implementations are not allowed.
