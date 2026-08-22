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

- Role: Review (quality gate, read-only) · upstream: main routing / the `api-platform-rest-build-skill` ·
  `api-platform-oauth2-build-skill` build skills / `api-platform-tester` (gating its TDD output)
- Downstream: `[MUST]` fixes return to whoever authored — `api-platform-tester` for a test-first cycle,
  otherwise the main agent under the build skill; regression → `api-platform-tester`; structural debt →
  `api-platform-analyzer`; domain logic behind a State → `app-php-symfony-reviewer`
- **No `api-platform-author` exists** (dissolved 2026-08-17 when it was renamed to
  `api-platform-analyzer` and became the read-only Analyze axis). Never name it as a fix target.
- Orchestrator: `agent-team` agent / `/api-platform-review` command (single reviews route directly from main)
- Design SoT: .claude/docs/agent-team-docs.md

## SoT

- .claude/rules/api-platform-rule.md
- .claude/rules/app-php-symfony-08-security-rule.md (security, CSRF, rate limiting)
