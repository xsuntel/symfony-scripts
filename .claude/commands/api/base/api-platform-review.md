---
description: "Assesses the quality of API Platform (Symfony) resource/State code and provides structured improvement recommendations."
argument-hint: "[path to the PHP file to analyze (ApiResource/State, etc.; defaults to all of app/src/ApiResource)]"
---

Analyze the following API Platform file:

**`$1`**

If no argument is given, review all of `app/src/ApiResource/` (and the related `app/src/State/`).
The single source of truth (SoT) for the criteria is the rule file. At the start, read the rules,
check each clause against the target code, flag violations with the **exact line number**, and
propose concrete fixes.

@see .claude/rules/api/base/api-platform-rule.md — API Platform rules (SoT)
@see .claude/docs/api/base/api-platform-docs.md — resource addition procedure
@see https://api-platform.com/docs/symfony/ — official docs

## Review Procedure

Check each section of the rules: resource declaration (#[ApiResource]·DTO·explicit operations) ·
serialization groups (normalization/denormalizationContext·#[Groups]) · State Provider/Processor (wiring·domain delegation·result return·decorating the default Processor) ·
validation (#[Assert]·per-operation validationContext groups·RFC 7807/Hydra) · security (operation security·securityPostDenormalize·stateless·rate-limiter·collection filtering in the Provider) ·
pagination & filters (#[QueryParameter] first, recommend migrating legacy #[ApiFilter] to the new equivalent) · error handling (exceptionToStatus·#[ErrorResource]) ·
Messenger & custom operations (messenger:·#[AsMessageHandler]·controller:+#[AsController] with State first) ·
OpenAPI documentation (#[ApiProperty]·openapi·OpenApiFactory) · testing (ApiTestCase).

## Output Format

### Summary

| Category | Status (OK / WARN / FAIL) | Issue count |
| --- | --- | --- |
| Resource declaration (#[ApiResource]/DTO) | | |
| Operation configuration | | |
| Serialization groups | | |
| State Provider/Processor | | |
| Validation (#[Assert]/validationContext groups) | | |
| Security & rate limiting | | |
| Messenger & custom operations | | |
| Pagination & filters (#[QueryParameter]/legacy #[ApiFilter]) | | |
| Error handling (RFC 7807/exceptionToStatus) | | |
| OpenAPI documentation (ApiProperty/openapi) | | |
| Testing (ApiTestCase) | | |

### Critical Issues (must fix)

For each issue: **[Line N]** description → recommended fix including a code snippet.

### Improvement Suggestions (fix recommended)

For each suggestion: **[Line N]** description → recommended approach.

### Refactoring Suggestions

Describe structural changes (direct Entity exposure → DTO separation, controller logic → State
Processor, domain logic → Service delegation, group redesign, etc.) with before/after code examples.
