---
name: api-platform-rest-build-skill
argument-hint: '[build: implementation target · review: path to the ApiResource/State file]'
description: 'Use when writing, reviewing, or troubleshooting the code by which this Symfony project builds (inbound) its own REST API with API Platform. Runs in one of three modes — Guide, Build (writes resource/State code) or Review (judges existing code) — and a caller must name which. Triggered by questions about #[ApiResource] resource DTOs in app/src/ApiResource/, operations (Get/GetCollection/Post/Patch/Delete), serialization groups (normalization/denormalizationContext), Providers/Processors in app/src/State/, validation (#[Assert]), security (operation security·Voter·collection filtering), parameter-based filters (#[QueryParameter]) & pagination, RFC 7807/Hydra errors, OpenAPI customization, and ApiTestCase tests. For generating a frontend client that consumes your API use api-platform-rest-client-skill, and for authentication configuration use api-platform-oauth2-build-skill.'
---

# API Platform REST Build Skill

This is the entry point for implementing/reviewing the code by which this project **builds (inbound)
its own REST API with API Platform**. Generating a frontend client that **consumes** your API is out
of scope for this skill (→ `api-platform-rest-client-skill`).

## Modes

**This skill absorbed two slash commands on 2026-09-10**, so an invocation must name its mode.

| Request | Mode | Read |
| --- | --- | --- |
| Resource/State guidance, troubleshooting, "how do I expose…" | Guide | this file |
| "build/implement `<target>`" — write or modify resource and State code | **Build** | [`references/build-guide.md`](references/build-guide.md) |
| "review `<path>`" — judge existing resource/State code | **Review** | [`references/review-guide.md`](references/review-guide.md) |

> Build was `/api-platform-rest-build` and Review was `/api-platform-review` until 2026-09-10, when
> `.claude/commands/` was folded into `.claude/skills/`. **This is the one place the merge collapsed two
> invocations into one**, so a caller that does not name the mode must be asked which it wants rather
> than defaulting to Build — Build writes to `app/src/**`, Review does not write at all.

## Information Source (single source of truth: the rule file)

**All criteria** — from resource declaration, operations, serialization, State, validation, security,
filters, errors, and OpenAPI through testing — are owned by the rule file as the single source of
truth (SoT). This skill does not restate the rules; it only provides the entry decision and the
verification procedure.

@see .claude/rules/api-platform-rule.md — full API Platform (Symfony) criteria (SoT)
@see .claude/docs/api-platform-docs.md — resource addition procedure (step-by-step)
@see .claude/rules/app-php-symfony-08-security-rule.md — security & rate limiting
@see https://api-platform.com/docs/symfony/ — official docs
@see .claude/skills/api-platform-rest-client-skill/SKILL.md — use this instead when the goal is generating a frontend client (create-client) that consumes your API
@see .claude/skills/api-platform-oauth2-build-skill/SKILL.md — use this instead when the goal is configuring the authentication (JWT/OAuth2) server

## Entry Decision

- Declare resources as `#[ApiResource]` **DTOs** in `app/src/ApiResource/` — do not attach
  `#[ApiResource]` directly to a Doctrine `Entity`.
- Place State in `app/src/State/`, and wire reads to the operation with `ProviderInterface` (Read
  stage) and writes with `ProcessorInterface` (Write stage) — delegate domain logic to a `Service`.
- If the Doctrine default Provider/Processor is sufficient, do not create a custom one.

## Core Checks (common to implementation & review)

- [ ] Is the resource a DTO in `app/src/ApiResource/` (no direct Entity exposure)
- [ ] Are `operations:` specified explicitly (no implicit reliance on the default set)
- [ ] Are the `normalizationContext`/`denormalizationContext` groups consistent with the property-level `#[Groups]` (read/write separation, sensitive-field exposure control)
- [ ] Are read=Provider, write=Processor wired to the operation via `provider:`/`processor:`
- [ ] Does the Processor `return` the result (DTO) explicitly and delegate the save by decorating the default Processor
- [ ] Is input validation declared with `#[Assert\...]` (not manual `if` checks inside the Provider/Processor), with per-operation constraints separated into `validationContext` groups
- [ ] Is async work dispatched via operation `messenger:` (`output: false`+`status: 202`) with `#[AsMessageHandler]` delegating domain logic to a Service
- [ ] Is custom behavior expressed with State first, and if a controller is needed connected only via operation `controller:`+`#[AsController]` rather than a raw route
- [ ] Is operation `security:`/Voter applied, and **collection row filtering done in the Provider/query extension** (a collection cannot filter items with a Voter)
- [ ] Is search/sort/pagination declared with parameter-based filters (`parameters:` + `#[QueryParameter]`) and pagination options (legacy `#[ApiFilter]` for existing-code compatibility only, no manual LIMIT/OFFSET or query parsing)
- [ ] Are errors in the RFC 7807/Hydra auto-format (422 on validation failure, domain exceptions via `exceptionToStatus`/`#[ErrorResource]`)
- [ ] Is it `stateless: true` token authentication (rationale for CSRF exemption), with `symfony/rate-limiter` applied to public endpoints
- [ ] Are success/validation-failure/authorization-denied cases tested on `ApiPlatform\Symfony\Bundle\Test\ApiTestCase`

## Verification (Bash)

```bash
# Inspect resource metadata & operations
cd app && php bin/console debug:api-resource "App\\ApiResource\\Company\\BookResource"

# Export the auto-generated OpenAPI spec
cd app && php bin/console api:openapi:export --yaml

# Static analysis & style (merge condition)
cd app && vendor/bin/phpstan analyse
cd app && vendor/bin/php-cs-fixer fix --dry-run

# Functional tests (ApiTestCase)
cd app && vendor/bin/phpunit --testsuite Functional
```

On a review request, classify severity as `[MUST]` (critical) / `[SHOULD]` (recommended) /
`[CONSIDER]` (optional) and report citing file:line.
