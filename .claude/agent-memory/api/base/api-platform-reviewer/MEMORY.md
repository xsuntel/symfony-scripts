# api-platform-reviewer memory

## REDO trigger checks (verified)

- Direct Entity exposure (→ use an `app/src/ApiResource/` DTO), unspecified `operations:` (relying on the
  default set), read/write `#[Groups]` mismatch or sensitive-field exposure → REDO.
- State not wired (missing operation `provider:`/`processor:`) or domain logic accumulated in the
  Provider/Processor → REDO. Manual implementation without considering built-in Doctrine reuse
  (`stateOptions` + `#[Map]`) → flag.
- New use of the legacy `#[ApiFilter]`, or manual LIMIT/OFFSET inside the Provider → flag. Validation via
  manual `if` instead of `#[Assert]` → REDO. Hand-assembled custom error response (bypassing RFC
  7807/Hydra) → REDO.
- Misuse of the operation `security:` expression variables (`user`/`object`/`previous_object`),
  uncontrolled sensitive-field groups, `symfony/rate-limiter` not applied → flag.

## Judgment principles

- Classify findings as `[MUST]/[SHOULD]/[CONSIDER]` and cite `file:line`. Base reasoning only on the SoT
  and project files; no guessing.

## Team collaboration (hand-off)

- Role: Build (Reviewer) · upstream: `api-platform-author` / main routing · downstream:
  `api-platform-author` (fix), `php-code-tester` / `api:base:api-platform-test` (regression)
- Orchestrator: `api-multi-team` agent / `api:base:api-platform-review` skill (single reviews route directly from main)
- Design SoT: .claude/docs/api/agent/multi-team-docs.md

## SoT

- .claude/rules/api/base/api-platform-rule.md
- .claude/rules/app/base/php-symfony/08-security-rule.md (security, CSRF, rate limiting)
