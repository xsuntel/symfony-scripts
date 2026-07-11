---
paths:
  - "app/src/**/*.php"
---

# Symfony Project — Claude Rules Overview

## Reference Documentation
- Official docs: https://symfony.com/doc/current
- Best Practices: https://symfony.com/doc/current/best_practices.html
- Symfony version: 8.0

## Rule Files

| File | Area of responsibility |
|------|----------------|
| 01-architecture-rule.md | Directory structure, bundle policy |
| 02-configuration-rule.md | Environment variables, parameters, secrets |
| 03-controller-rule.md | Routing, controller design |
| 04-service-rule.md | Dependency injection, autowiring, service container |
| 05-doctrine-rule.md | Entity mapping, Repository, migrations |
| 06-form-rule.md | Form classes, validation, DTO pattern |
| 07-template-rule.md | Twig naming, template inheritance, components |
| 08-security-rule.md | Firewalls, Voters, password hashing |
| 09-testing-rule.md | Unit / Integration / Functional testing strategy |
| 10-frontend-rule.md | AssetMapper, Stimulus, Symfony UX |
| 11-performance-rule.md | Caching, HTTP Cache, deployment |

## Absolute Prohibitions

- Do not call `$container->get()` directly — use constructor injection.
- Do not write business logic inside controllers — delegate to a Service.
- Do not create a Bundle just to organize application logic — use PHP namespaces instead.
- Do not use YAML/XML for Doctrine mapping or routing — use only PHP Attributes.
- Do not store secrets in committed files — use `.env.local` locally and Symfony Secrets in production.


## PHP & Symfony Version Constraints

- Target **PHP 8.4** — use property hooks, asymmetric visibility (`public private(set)`), and `#[\Deprecated]` where appropriate.
- Target **Symfony 8.0** — do not use APIs marked `@deprecated` in Symfony 7.x or earlier.
- Target **Doctrine ORM 3.x** — use `EntityRepository` (not `ServiceEntityRepository`) unless DI is required, and require typed properties.

## Class Design

- Mark every class `final` unless it is explicitly designed for extension.
- Mark properties `readonly` when they are promoted in the constructor and never change afterward.
- Do not use `abstract` classes unless unavoidable — prefer interfaces + composition.
- Do not use `static` methods unless they are pure functions (no state, no I/O).

## Dependency Injection

- Use constructor injection only.
- Use `#[Autowire(param: 'kernel.debug')]` for environment flags.
- Use `#[Target('monolog.logger.{channel}')]` for named loggers.
- Use `#[Autowire(service: 'service.id')]` for services that cannot be autowired.
- Do not fetch from `$container` or use `ContainerAware`.

## Routing & Controllers

- Use the `#[Route]` attribute on the class (prefix) and on each action method.
- Return `$this->render('template.html.twig', $data)` — never use `#[Template]` (legacy from SensioFrameworkExtraBundle, removed in Symfony 7+).
- Route names follow the `{domain}_{subdomain}_{action}` (snake_case) pattern.
- For any state-changing action: use only POST/PUT/PATCH/DELETE — never GET.
- Apply CSRF protection with `#[IsCsrfTokenValid]` on every POST form submission.

## Messenger / CQRS

- Write operations → `MessageCommand` + `MessageCommandHandler`.
- Read operations → `MessageQuery` + `MessageQueryHandler`.
- Events (side effects) → `MessageEvent` + `MessageEventHandler`.
- Specify a message class's transport with `#[AsMessage('{transport}')]`.
- Register handlers with `#[AsMessageHandler]` on the handler class.
- Dispatch via `MessageBusInterface` — do not call handlers directly.

## Workflow

- Perform entity state transitions only via `WorkflowInterface::apply()`.
- Handle transition guards with Workflow guard events — not `if/else` inside a Service.
- Do not set state properties directly in a Service or Controller.

## Logging

- Use named channels (`monolog.logger.{module}`) — not the global `logger`.
- Guard all debug logs: `if ($this->isDebug) { $this->logger->info(...); }`.
- Use structured context arrays in log messages, not string interpolation.

## Pagination

- Always use Pagerfanta with the Doctrine ORM adapter.
- Do not write manual `LIMIT`/`OFFSET` pagination in a Repository.
- Default page size: 20. Maximum: 100.

## API Platform

- Place resource classes in `app/src/ApiResource/` — do not use Entity classes directly.
- Use `#[ApiResource]` with an explicit `operations` array — do not rely on defaults.
- Use DTO-based input/output via the `input:` and `output:` resource settings.
- Apply rate limiting to every API endpoint with `symfony/rate-limiter`.
