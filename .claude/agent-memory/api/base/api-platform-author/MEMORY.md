# api-platform-author memory

## Generation conventions (verified)

- Declare resources as `#[ApiResource]` DTOs under `app/src/ApiResource/` — no direct Entity exposure.
  Specify the `operations:` array; keep the `normalizationContext`/`denormalizationContext` groups
  consistent with the property `#[Groups]` (read/write separation).
- Wire State via a Provider (read) / Processor (write) under `app/src/State/`, and delegate domain logic
  to a `Service` (no accumulation inside the Provider/Processor). For a DTO, prefer reusing the built-in
  Doctrine provider/processor via `stateOptions: new Options(entityClass:)` + `#[Map]`.
- Filters are Parameter-based in the operation `parameters:` (`QueryParameter` +
  `ApiPlatform\Doctrine\Orm\Filter\*`) — avoid the legacy `#[ApiFilter]`. Express pagination through
  resource attributes (`paginationItemsPerPage`, etc.) — no manual LIMIT/OFFSET.
- Validation via `#[Assert\...]`; access control via operation `security:`/`securityPostDenormalize:`/a
  Voter; map domain exceptions with `exceptionToStatus`/`#[ErrorResource]` (no hand-assembled custom
  error response). Every file: `declare(strict_types=1)` · `final`/`readonly` · PHPStan level 8.

## Team collaboration (hand-off)

- Role: Build (Author) · upstream: work instruction / REDO fix instruction · downstream: `api-platform-reviewer`
- Orchestrator: `api-multi-team` agent / `api:base:api-platform-review` skill (generate-verify loop caller)
- Design SoT: .claude/docs/api/agent/multi-team-docs.md

## SoT

- .claude/rules/api/base/api-platform-rule.md
- .claude/docs/api/base/api-platform-docs.md (resource-addition procedure)
