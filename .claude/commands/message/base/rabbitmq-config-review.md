---
description: "Assesses the quality of Symfony Messenger / RabbitMQ code and provides structured improvement recommendations."
argument-hint: "[path to the file to analyze (messenger.yaml, a Message DTO, or a *Handler)]"
---

Analyze the following message-related file:

**`$1`**

The single source of truth (SoT) for the judgment criteria is the rule file. At the start, read the
rule below, cross-check each provision against the target code, flag violations with the **exact line
number**, and provide concrete fixes (improved code snippets). Do not restate the criteria in this command.

@see .claude/rules/message/base/rabbitmq-config-rule.md — judgment criteria (SoT: transports, routing, retry/DLQ, idempotency, workers)
@see https://symfony.com/doc/current/messenger.html

## Review Procedure

Cross-check each section of the rule in order: general rules (immutable DTO, `#[AsMessageHandler]`, no
entity in payload, idempotency), transport & DSN (AMQP env var, `async_*` naming, explicit exchange/queues),
routing (every message routed to exactly one transport), reliability (bounded `retry_strategy`, `failed`
failure transport / DLQ, `UnrecoverableMessageHandlingException`), handler idempotency & locks
(`#[Target('{domain}.lock')]`, stable dedupe key), consumer/worker operation (bounded `--time-limit`/
`--memory-limit`, graceful stop on deploy), serialization & security. In particular, check that no async
message is routed to the Redis transport and that every message has an explicit routing entry.

## Output Format

### Summary

| Category | Status (OK / WARN / FAIL) | Issue count |
| --- | --- | --- |
| General rules | | |
| Transport & DSN | | |
| Routing | | |
| Reliability (retry / DLQ) | | |
| Handler idempotency & locks | | |
| Consumer / worker operation | | |
| Serialization & security | | |

### Critical Issues (must fix)

For each issue: **[Line N]** description → recommended fix including a code snippet.

### Improvement Suggestions (recommended)

For each suggestion: **[Line N]** description → recommended approach.

### Refactoring Suggestions

Describe structural changes (splitting a transport, extracting a failure transport, adding idempotency
guards, bounding workers, etc.) with before/after code examples.
