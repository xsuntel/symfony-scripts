# app-php-symfony-analyzer memory

## Environment constants (verified)

- **Multi-EntityManager environment** with three transports: `async_default` (RabbitMQ), `async_redis` (Redis), `sync`. Layer flow: `Controller → Service → Repository → DB`; a reversed or circular direction is a structural smell.
- Do not invent service IDs, transport names, EntityManager names, or channel names — confirm with `debug:container` / `debug:autowiring` / `debug:messenger`.

## Structural smells to watch

- Layer-boundary violation (Controller uses Repository/EM directly, Entity references a Service), circular dependency (two Services inject each other), God Service (>6 injections / >15 methods / hundreds of lines).
- MessageBus coupling (a handler calls another handler directly, sync work on an async transport), structurally N+1-inducing mapping (always-lazy associations with assumed collection iteration).
- Scope this to structure — leave `[MUST]/[SHOULD]/[CONSIDER]` judgments to `app-php-symfony-reviewer` and runtime root cause to `app-php-symfony-debugger`. Handoff: `analyzer → reviewer → tester`.

## Output

- ADR format (Context/Decision/Consequences) + trade-offs on three axes (scalability/maintainability/performance) + alternatives, per the abstract-english-style "Architecture Design & Analysis" section.

## SoT

- .claude/rules/app-php-symfony-01-architecture-rule.md, 04-service-rule.md, 05-doctrine-rule.md, 11-performance-rule.md
- .claude/rules/message-rabbitmq-rule.md (MessageBus coupling)
- .claude/output-styles/abstract-english-style.md (ADR & trade-offs)
