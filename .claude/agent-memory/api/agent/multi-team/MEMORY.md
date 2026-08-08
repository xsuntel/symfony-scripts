# api-multi-team memory

## Role (verified)

- Coordinator/dispatcher for the API-domain team — routes, drives the Build loop, and consolidates; does
  **not** author or judge API Platform code itself (that belongs to the sub-agents).
- Covers **only the 2 API Platform agents**: `api-platform-author` (generate) and `api-platform-reviewer`
  (verify), both operating on `app/src/ApiResource/**` and `app/src/State/**`. Agents resolve by
  frontmatter `name`, not filename.

## Routing constants

- Create/modify a resource → **Build loop** (`api-platform-author` → `api-platform-reviewer`).
- Standalone quality gate on existing resource code → route directly to `api-platform-reviewer` (no author step).
- Regression tests → hand off to `php-code-tester` / the `api:base:api-platform-test` skill (out of authoring scope).

## Build verification loop

- `author → reviewer → PASS/REDO`; on REDO re-call the author with **only the `[MUST]` items**; retry
  limit max 2, then stop and recommend manual review.
- Intermediate drafts under `./.claude/tmp/api/` (gitignored). Only `[MUST]` blocks the merge / forces a REDO.

## Cross-domain hand-off

- Out of this team — flag and hand off, do not absorb: a State provider driving heavy Doctrine queries →
  **Postgresql reviewer** (N+1, JOIN FETCH); a resource behind token auth / sensitive `#[Groups]` →
  **php-code security** review; `Service`/`Repository`/`Message*` domain logic → app team (`php-code-*`).

## Team collaboration (hand-off)

- Role: API-domain orchestrator · downstream: `api-platform-author`, `api-platform-reviewer` · reused
  Test: `php-code-tester` / `api:base:api-platform-test`.
- Design SoT: .claude/docs/api/agent/multi-team-docs.md

## SoT

- .claude/docs/api/agent/multi-team-docs.md (API team composition & Build-loop axis)
- .claude/rules/api/base/api-platform-rule.md (API Platform judgment criteria)
