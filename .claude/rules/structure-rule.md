# Directory Structure & Path Context

This rule defines the repository's physical structure and path conventions, and serves as the entry
point into the domain rule files. The **detailed standards for architecture and code style are owned
by each domain rule file as the single source of truth (SoT)**; this document does not duplicate them,
keeping only the path context and rule index.

@see CLAUDE.md — role, technology stack, security, testing, and response guidelines (global standard)

## Directory Structure

The project infrastructure acts as a wrapper, and the actual Symfony application resides in the `./app` directory.

```text
./                                           ← Repository root
└── app/                                     ← Symfony application root
    ├── assets/                              ← Symfony AssetMapper (Stimulus/Tailwind)
    ├── bin/                                 ← Symfony console
    ├── config/                              ← Symfony configuration (packages/ services/ parameters/)
    ├── migrations/                          ← Doctrine migrations (per EntityManager)
    ├── public/                              ← Web root (index.php, healthcheck.php, assets/)
    ├── src/                                 ← PHP source code (namespace: App\)
    ├── templates/                           ← Twig templates
    ├── tests/                               ← PHPUnit tests (Unit / Integration / Functional)
    ├── translations/                        ← Symfony translations
    ├── var/                                 ← Runtime artifacts (cache/ log/ sessions/ tailwind/)
    └── vendor/                              ← Composer dependencies
```

Main namespaces under `src/`: `Controller`, `Entity`, `EntityRepository`/`Repository`, `Service`,
`MessageCommand`/`MessageQuery`/`MessageCommandHandler`/`MessageEvent`, `EventSubscriber`,
`Scheduler`, `Command`, `Form`, `Twig`, `Security`, `Enum`.


## Project Rules (index)

Domain rules live in `.claude/rules/` and are applied automatically when editing files matched by the
`paths` frontmatter. Each rule is the single source of truth (SoT) for its topic, and the helper skills
in `.claude/skills/` reference it.

| Rule file | Scope |
|---|---|
| `api/rest-rule.md` | Common external API integration (HttpClient, key management, token lifecycle, response persistence, rate limiting) |
| `app/php-symfony/00~11-*-rule.md` | PHP/Symfony standards (overview, architecture, configuration, controller, service, Doctrine, form, template, security, testing, frontend, performance) |
| `app/javascript-stimulus/00~02-*-rule.md` | JavaScript/Stimulus (modules & naming, controllers, security/performance/quality) |
| `cache/redis-rule.md` | Redis caching, locks, sessions, transport |
| `database/postgresql-rule.md` | Entity mapping, Repository, migrations, PostgreSQL features |
| `server/nginx-rule.md` | Nginx configuration (dev/prod, security, performance, deployment) |
| `utility/gcp/cloudrun-rule.md` | GCP / Cloud Run deployment, secrets, IAM, cost, IaC |
| `structure-rule.md` | This document — directory structure, path context, rule index |
