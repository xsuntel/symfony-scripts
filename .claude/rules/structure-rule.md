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

## Prohibitions (`.claude/**`)

The physical layout of the `.claude/` tree is **fixed**. Do not flatten its `<kind>/<domain>/<tier>/…`
taxonomy, and do not move, rename, merge, split, or delete an existing file or directory — including the
empty `.gitkeep` scaffolds — unless the user **explicitly instructs it in the current request**.
"Cleanup", "consistency", or a refactoring suggestion is not sufficient grounds.

Adding a new file at a taxonomy-conforming path is allowed; relocating an existing one is not. The
gitignored `.claude/tmp/**` runtime scratch tree is exempt. When a structure change seems warranted,
report it as `[CONSIDER]` with the before/after paths and wait for an explicit decision — do not perform it.

@see .claude/rules/utility/claude/code-config-rule.md — full prohibitions & allowed changes (SoT)

## Project Rules (index)

Domain rules live in `.claude/rules/` and are applied automatically when editing files matched by the
`paths` frontmatter. Each rule is the single source of truth (SoT) for its topic, and the helper skills
in `.claude/skills/` reference it.

| Rule file | Scope |
|---|---|
| `api/base/api-platform-rule.md` | API Platform (Symfony) inbound REST API: `#[ApiResource]` resources, operations, State providers/processors, serialization groups, validation, security, filters/pagination, error handling (RFC 7807/Hydra), OpenAPI customization |
| `app/base/php-symfony/00~11-*-rule.md` | PHP/Symfony standards (overview, architecture, configuration, controller, service, Doctrine, form, template, security, testing, frontend, performance) |
| `app/base/javascript-stimulus/00~02-*-rule.md` | JavaScript/Stimulus (modules & naming, controllers, security/performance/quality) |
| `app/base/twig-symfony/00-overview-rule.md` | Twig/Symfony templates (auto-escaping, inheritance, includes/macros, fragments, enum, logic separation) |
| `cache/base/redis-config-rule.md` | Redis caching, locks, sessions, transport |
| `message/base/rabbitmq-config-rule.md` | RabbitMQ / Symfony Messenger async transport: message/handler design, AMQP transport & DSN, routing, retry strategy / failure transport (DLQ), handler idempotency & locks, worker operation |
| `database/base/postgresql-config-rule.md` | Entity mapping, Repository, migrations, PostgreSQL features |
| `server/base/nginx-config-rule.md` | Nginx configuration (dev/prod, security, performance, deployment) |
| `server/cloud/gcp/cloudrun-config-rule.md` | GCP / Cloud Run deployment (project default), secrets, IAM, cost, IaC |
| `server/cloud/aws/ecs-config-rule.md` | GCP Cloud Run alternative — AWS ECS (Fargate) deployment, Secrets Manager/SSM, Task/Execution Role, ALB rolling deploy, cost, IaC |
| `utility/claude/code-config-rule.md` | Claude Code config artifacts (`.claude/**`): directory taxonomy immutability — flattening / move / rename / merge prohibitions, allowed changes, `.claude/tmp` exception |
| `utility/shell-script/code-config-rule.md` | Shell scripts (`scripts/**` Bash): shebang/strict-mode, bootstrap, source guards, naming, `rm -rf` guards, idempotent install |
| `structure-rule.md` | This document — directory structure, path context, rule index |

## Reference Docs (index)

Detailed references and code examples live in `.claude/docs/`, mirroring the rules tree. Each docs file
holds the **example/reference edition** of its paired rule; the rule remains the single source of truth (SoT).

| Docs file | Paired rule |
|---|---|
| `api/base/api-platform-docs.md` | `api/base/api-platform-rule.md` |
| `app/base/php-symfony-docs.md` | `app/base/php-symfony/*-rule.md` |
| `app/base/javascript-stimulus-docs.md` | `app/base/javascript-stimulus/*-rule.md` |
| `app/base/twig-symfony-docs.md` | `app/base/twig-symfony/00-overview-rule.md` |
| `cache/base/redis-config-docs.md` | `cache/base/redis-config-rule.md` |
| `message/base/rabbitmq-config-docs.md` | `message/base/rabbitmq-config-rule.md` |
| `database/base/postgresql-config-docs.md` | `database/base/postgresql-config-rule.md` |
| `server/base/nginx-config-docs.md` | `server/base/nginx-config-rule.md` |
| `server/cloud/gcp/cloudrun-config-docs.md` | `server/cloud/gcp/cloudrun-config-rule.md` |
| `server/cloud/aws/ecs-config-docs.md` | `server/cloud/aws/ecs-config-rule.md` |
| `utility/shell-script/code-config-docs.md` | `utility/shell-script/code-config-rule.md` |

> Standalone (not rule-paired): `app/agent/multi-team-docs.md` is a design draft proposing a workflow-role
> collaboration structure for the existing agents — it has no paired rule and is not a reference edition.
> Its orchestrator counterpart is the `app-multi-team` agent (`agents/app/agent/multi-team.md`), and the
> `.claude/workflows/` playbook (`workflows/README.md`) references this draft as its design SoT. The API
> domain mirrors this pair: `api/agent/multi-team-docs.md` with the `api-multi-team` agent
> (`agents/api/agent/multi-team.md`).

> Docs-less rule: `utility/claude/code-config-rule.md` has no paired docs file — its example/reference
> material (per-type criteria, checklist, output format) lives in
> `commands/utility/claude/code-config-review.md`.
