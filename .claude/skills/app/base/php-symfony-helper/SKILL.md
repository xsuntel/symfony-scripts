---
name: php-symfony-helper
description: Use when analyzing the codebase structure, guiding external library usage, or reviewing code changes in this PHP 8.4 / Symfony 8 project. Covers the Symfony app layout, multi-EntityManager topology, Messenger message flow, Composer/importmap package management, and the PR review checklist. Triggered by architecture documentation, domain boundary mapping, dependency discovery, composer require, importmap:require, library compatibility checks, code review, bug identification, and Pull Request improvement requests.
---

# PHP / Symfony Helper

The unified entry point covering codebase analysis, library usage guidance, and code review.
Apply the relevant part depending on the nature of the request.

| Request type | Applicable section |
|---|---|
| Structure analysis, architecture documentation, domain boundary mapping | Part 1 — Codebase Analysis |
| Library install/config/usage, package recommendations | Part 2 — Library Usage Guide |
| Reviewing changes, identifying bugs, PR improvement suggestions | Part 3 — Code Review |

## Information Source (single source of truth: the rule files)

The coding standards, architecture, and per-layer detailed criteria are **all owned by the rule files
as the single source of truth (SoT)**. This skill does not restate the rules; it only provides the
analysis methodology, operational commands, and output format.

@see .claude/rules/app/base/php-symfony/00-overview-rule.md ~ 11-performance-rule.md — full PHP/Symfony standards (SoT)
@see .claude/rules/structure-rule.md — directory structure & architecture guide
@see CLAUDE.md — stack & out-of-scope policy

Base findings only on project files (sources, config, migrations, `composer.json`/`package.json`).
If unconfirmed, state "This information is not confirmed in the project files." and do not guess versions.

---

# Part 1 — Codebase Analysis

Map top-down. Do not assume directory existence — confirm with Glob.

1. **Repository layout** → read `CLAUDE.md` and `structure-rule.md` first (root wrapper + `app/` Symfony root).
2. **Application structure** → map `app/src/` by namespace segment (Controller/Entity/Repository/Service/MessageCommand/MessageQuery/MessageHandler/MessageEvent/EventSubscriber/Scheduler/Form/Twig/Security/Enum).
3. **EntityManager topology** → read `app/config/packages/doctrine.yaml` to confirm the EM ↔ DB ↔ domain mapping (SoT is the rule `database/base/postgresql-config-rule.md ## Multiple EntityManagers` table). No cross-manager associations.
4. **Message flow** → confirm the transport with `#[AsMessage('{transport}')]` + `messenger.yaml`:

```text
Scheduler(#[AsPeriodicTask]) → MessageBus → MessageCommand
  → MessageCommandHandler(RabbitMQ) → HttpClient/persistence(Entity json) → MessageEvent
    → EventSubscriber(downstream processing/Notifier)
```
The read path is `MessageQuery` + `MessageQueryHandler` (synchronous). RabbitMQ=async, Redis transport=synchronous in-process.

5. **Config file order** → `doctrine.yaml` → `messenger.yaml` → `cache.yaml` (+ per-environment) → `framework.yaml` (scoped HTTP client) → `services.yaml`.

## Output Format

- **Architecture summary**: describe per-domain in the order `EntityManager`/`Database` → Entities → Message Flow → External API → Cache.
- **Dependency map**: a directional list of `{Class} depends on → {Dep} (injection method)`. Do not generate UML without a request.
- **Gap report**: report undiscovered classes, unmapped EMs, and unconfigured transports at the end as `## Gaps Found` checkboxes.

---

# Part 2 — Library Usage Guide

## Checks Before Recommending

1. Already installed? → check `composer.json`/`package.json` (and `.lock`).
2. Compatible with PHP 8.4 / Symfony 8? → check the package constraints.
3. Project rule conflict? → cross-check against `.claude/rules/` and the CLAUDE.md out-of-scope policy (no Laravel/Vue/React).
4. Already abstracted? → e.g. Redis is accessed only through Symfony Cache pools.

If any check fails, report it before providing examples.

## Version Check & Install (Bash)

```bash
# Version: lock → json order. Do not assert a version without confirming
grep '"vendor/package"' app/composer.lock | head -1
grep '"vendor/package"' app/composer.json

# Install (production / dev)
cd app && composer require vendor/package
cd app && composer require --dev vendor/package
grep 'BundleClass' app/config/bundles.php    # confirm auto-registration

# JS is AssetMapper, not npm
cd app && php bin/console importmap:require package-name
grep 'package-name' app/importmap.php
```

## Prohibited/Replacement Libraries (rule-backed)

| Prohibited | Replacement / rule |
|---|---|
| `guzzlehttp/guzzle`, cURL, `file_get_contents` | `Symfony\Contracts\HttpClient\HttpClientInterface` |
| `ServiceEntityRepository` | Extend `EntityRepository` (`rules/database/base/postgresql-config-rule.md`) |
| Direct `\Redis` calls | `#[Target('cache_pool_{domain}')]` (`rules/cache/base/redis-config-rule.md`) |
| `react`/`vue`/Laravel packages | Out of scope (`CLAUDE.md`) |
| `knp-paginator`, manual LIMIT/OFFSET | `babdev/pagerfanta-bundle` |

For authentication, use `LexikJWTAuthenticationBundle` + `scheb/2fa-*`. When blocking, cite the underlying rule file.

---

# Part 3 — Code Review

## Procedure

```bash
git diff main...HEAD --name-only   # changed files
git diff main...HEAD               # full diff
```
Group the changed files by layer, and **apply the detailed judgment criteria for each layer based on the rule files below** —
the skill does not restate the criteria.

| Layer | Judgment criteria (SoT) |
|---|---|
| Architecture/messaging/scheduler | `rules/app/base/php-symfony/01-architecture-rule.md` |
| Controller/service/form | `03-controller-rule.md`, `04-service-rule.md`, `06-form-rule.md` |
| Doctrine / DB | `rules/database/base/postgresql-config-rule.md`, `05-doctrine-rule.md` |
| API Platform (inbound `ApiResource`/`State`) | `rules/api/base/api-platform-rule.md` |
| External API (outbound HttpClient) | per-provider rules |
| Cache / Redis | `rules/cache/base/redis-config-rule.md` |
| Security | `08-security-rule.md` |
| Performance | `11-performance-rule.md` |
| Templates/frontend | `07-template-rule.md`, `10-frontend-rule.md` |

## Cross-Cutting Key Checks (quickly, only for rule violations)

- Is `Asia/Seoul` specified on Korean-business-time `\DateTimeImmutable`?
- Is the decrypted API key kept out of logs (masked prefix only)?
- Is fetch→persist (original JSON)→MessageEvent separated, with a rate-limit Lock guard?
- Did you inject the correct EM/cache pool/HTTP client with `#[Target]`?
- Do user-input DTOs have a Validator, and do state-changing forms have CSRF?

## Severity · Output

| Severity | When to use |
|---|---|
| `[MUST]` | Bug, security, rule violation, data corruption (blocks merge) |
| `[SHOULD]` | Performance, maintainability, convention deviation |
| `[CONSIDER]` | Optional improvement, style |

Output order: **Summary → [MUST] → [SHOULD] → [CONSIDER] → positive feedback (at least 1, with file:line citation)**.
