# php-code-reviewer memory

## Environment constants (verified)

- **Multi-EntityManager environment** — confirm each service/handler injects and uses the correct EM.
- Transport selection: `async_default` (RabbitMQ, external integration/retry/DLQ, KoreaInvestment/UPbit API) / `async_redis` (lightweight internal tasks) / `sync` (tests, or must complete before the response).
- Logger uses a named channel `#[Target('monolog.logger.{channel}')]` + an `if ($this->isDebug)` guard. Global `logger` and unguarded debug logs are findings.

## Standing review checks

- Acquire `symfony/lock` before an idempotency-critical write (and confirm the lock TTL is not shorter than the processing time).
- Repository N+1 (`JOIN FETCH`), `readonly` promoted injection, `final` class, `declare(strict_types=1)` as the first statement.
- Only `[MUST]` blocks the merge; `[SHOULD]`/`[CONSIDER]` are recommendations.

## SoT

- .claude/rules/app/base/php-symfony/00~11-*-rule.md (standards & architecture)
- .claude/docs/app/base/php-symfony-docs.md (per-layer templates)
