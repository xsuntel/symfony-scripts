# api-platform-analyzer memory

> Renamed from `api-platform-author` on 2026-08-17. The Build(Author) role was dissolved — this agent is
> now the read-only **Analyze** axis of the api quartet, mirroring `app-php-symfony-analyzer`. Authoring
> notes were dropped; what survives here are the structural constants and the lenses.

## Environment constants (verified)

- API Platform 4.x (`api-platform/symfony` + `api-platform/doctrine-orm`), route prefix **`/api`**
  (`config/routes/api_platform.yaml`).
- Global defaults: `stateless: true`, `cache_headers.vary: [Content-Type, Authorization, Origin]`
  (`config/packages/api_platform.yaml`).
- **`app/src/ApiResource/` holds only `.gitignore`, and `app/src/State/` does not exist as a directory.**
  There is no exposure layer to analyze yet — report "nothing in scope to analyze" rather than deriving a
  structure from the rules and presenting it as the project's actual shape.
- Confirmed investigation commands: `debug:api-resource` · `api:openapi:export` · `debug:serializer` ·
  `debug:validator` · `debug:router` · `debug:container` · `lint:container`.

## Analysis principles

- **Read recognized metadata before source** — `debug:api-resource` shows the operations and serialization
  contexts API Platform actually registered. Structural judgments made from attributes alone miss the gap
  between declaration and recognition.
- Structure, not bugs (`api-platform-debugger` owns runtime cause); design health, not rule compliance
  (`api-platform-reviewer` owns the `[MUST]/[SHOULD]/[CONSIDER]` verdict).
- Every proposal carries rationale + an alternative + trade-offs on scalability · maintainability ·
  performance, in ADR format (`abstract-english-style` is the output SoT).

## Recurring lenses (domain-specific)

- **Fat Processor/Provider** — domain logic accumulated in State instead of delegated to a `Service`.
- **Group sprawl** — no read/write split, group names reused across unrelated resources, or a group on a
  property that no context references (dead group).
- **Anemic DTO** — a 1:1 field mirror of an Entity, i.e. no exposure design at all.
- **Duplicated State** — hand-rolled Doctrine read/write where `stateOptions: new Options(entityClass:)` +
  `#[Map]` would reuse the built-in, or a custom Processor re-implementing persistence instead of
  decorating `api_platform.doctrine.orm.state.persist_processor`.
- **Structurally N+1-prone Provider** — lazy associations with no fetch strategy while the serialization
  groups embed those relations.
- **Security-expression scatter** — the same policy repeated as a literal `security:` string where a Voter
  would centralize it. Note that a collection **cannot** filter rows with a Voter — row filtering belongs
  in the Provider/query extension.

## Team collaboration (hand-off)

- Role: Analyze (read-only — `tools: Read, Grep, Glob, Bash`, no `Edit`/`Write`) · upstream: main routing
  (structure/refactor intent) / `agent-team` · downstream: `api-platform-debugger` (runtime cause),
  `api-platform-reviewer` (quality gate), `api-platform-tester` (regression + executes the refactor)
- Out-of-scope referral: `app/src/Service/**` structure → `app-php-symfony-analyzer`; mapping/query
  performance → `database-postgresql-reviewer`
- Orchestrator: main agent direct routing / `agent-team`
- Design SoT: .claude/docs/agent-team-docs.md

## SoT

- .claude/rules/api-platform-rule.md
- .claude/docs/api-platform-docs.md (processing flow · resource addition procedure)
- .claude/output-styles/abstract-english-style.md (ADR output format)
