---
description: "Assesses the quality of external API integration code and provides structured improvement recommendations."
argument-hint: "[path to the PHP file to analyze (external API integration code)]"
---

Analyze the following external API integration file:

**`$1`**

The single source of truth (SoT) for the judgment criteria is the rule files. The common criteria are
`api/rest-rule.md`, and the per-provider details (endpoints, authentication, rate-limit values) are the
respective provider rule. At the start, read the relevant rules, cross-check each provision against the
target code, flag violations with the **exact line number**, and provide concrete fixes.

@see .claude/rules/api/rest-rule.md — common criteria (HttpClient, key management, token lifecycle, persistence, errors, rate limiting)

## Review Procedure

Cross-check each section of the common rules: HttpClient usage, API key management, authentication
token/key lifecycle, response persistence (fetch/transform separation), error handling (503/timeout
retry, 401/403 no-retry), holidays/business days, WebSocket, rate limiting, Scheduler integration. If
the target is a specific provider, also cross-check that provider rule's authentication, endpoint, and
rate-limit details.

## Output Format

### Summary

| Category | Status (OK / WARN / FAIL) | Issue count |
| --- | --- | --- |
| HttpClient usage | | |
| API key management | | |
| Authentication token/key lifecycle | | |
| Response persistence pattern | | |
| Error handling | | |
| Holiday & business-day handling | | |
| WebSocket | | |
| Rate-limit awareness | | |
| Scheduler integration | | |

### Critical Issues (must fix)

For each issue: **[Line N]** description → recommended fix including a code snippet.

### Improvement Suggestions (recommended)

For each suggestion: **[Line N]** description → recommended approach.

### Refactoring Suggestions

Describe structural changes (fetch/transform separation, moving the token-handling layer, introducing a
lock, etc.) with before/after code examples.
