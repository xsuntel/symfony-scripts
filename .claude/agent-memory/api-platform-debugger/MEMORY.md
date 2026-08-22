# api-platform-debugger memory

> Translated from Korean to English on 2026-08-17, per the CLAUDE.md `## Documentation Language` rule.
> Every verified fact below is carried over unchanged.

## Environment constants (verified)

- API Platform 4.x (`api-platform/symfony` + `api-platform/doctrine-orm`), route prefix **`/api`**
  (`config/routes/api_platform.yaml`).
- Global defaults: `stateless: true`, `cache_headers.vary: [Content-Type, Authorization, Origin]`
  (`config/packages/api_platform.yaml`). Token authentication is the premise, which is what exempts CSRF —
  mixing it with session authentication produces an "always anonymous" symptom.
- **`app/src/ApiResource/` holds only `.gitignore`, and `app/src/State/` does not exist as a directory.**
  Do not misdiagnose a "we're getting a 404" report that is really a *resource that was never written* →
  hand off to the creation axis (`api-platform-tester` for a test-first build, or the
  `api-platform-rest-build-skill` procedure). **There is no `api-platform-author`** — it was renamed to
  `api-platform-analyzer` on 2026-08-17 and became the read-only Analyze axis.
- Investigation commands confirmed to exist: `debug:api-resource` · `api:openapi:export` ·
  `debug:serializer` · `debug:validator` · `debug:router` · `debug:firewall` · `debug:container` ·
  `lint:container`.

## Diagnostic principles

- **Read the metadata before the source** — confirm with `debug:api-resource` which operations and
  serialization contexts were actually recognized. The gap between what was declared and what was
  recognized is the cause most of the time.
- Narrow by pipeline order:
  `routing → security → denormalization → securityPostDenormalize → validation → State → serialization`.
- Frequently seen root causes: `#[Groups]` ↔ `normalization/denormalizationContext` mismatch (property
  not exposed, write ignored); operation not declared (404); validation done with a manual `if` inside
  State instead of `#[Assert]` (500 instead of 422); `exceptionToStatus` not mapped (500); operation
  `provider:`/`processor:` not wired (State never invoked); a custom Processor that does not delegate to
  the built-in `api_platform.doctrine.orm.state.persist_processor` (nothing saved); legacy `#[ApiFilter]`
  mixed in or `parameters:` not wired (filter ignored).
- **`security:` vs. `securityPostDenormalize:`** — the former runs **before** denormalization, so `object`
  is the persisted state; the latter runs **after**, so `object` reflects the request and
  `previous_object` is the original. This is the classic source of a misjudged 403.
- Do not paper over a symptom with a workaround that breaks the RFC 7807/Hydra format (hand-assembling a
  custom error response). Never put secrets or `Authorization` values in the output.

## Team collaboration (hand-off)

- Role: Debug · upstream: main routing (symptom report) / `agent-team` · downstream:
  `api-platform-reviewer` (quality), `api-platform-tester` (regression, and creating the resource when it
  turns out never to have been written), `api-platform-analyzer` (cause is structural debt)
- Out-of-scope referral: cause in the domain service, Doctrine, or Messenger → `app-php-symfony-debugger`;
  entity mapping or query performance → `database-postgresql-reviewer`
- Orchestrator: main agent direct routing
- Design SoT: .claude/docs/agent-team-docs.md

## SoT

- .claude/rules/api-platform-rule.md
- .claude/rules/app-php-symfony-08-security-rule.md (operation security · Voter · rate limiter)
- .claude/docs/api-platform-docs.md (processing flow · resource addition procedure)
