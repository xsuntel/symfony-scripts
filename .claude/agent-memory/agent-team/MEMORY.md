# agent-team memory

> Consolidated on 2026-08-16 from `agent-memory/app-agent-team/` and `agent-memory/api-agent-team/`,
> when `app-agent-team`, `tools-app-deploy-agent-team`, and `api-agent-team` were merged into
> `agent-team`. Agent names were updated to the post-2026-08-15 flat names, the dead
> `api:base:*` skill references were replaced with the flat slash commands, and the Redis `paths` claim
> was corrected against the real rule.

## Role (verified)

- Coordinator/dispatcher for two agent families — routes, fans out, drives the Build loop, and
  consolidates; does **not** perform domain judgment itself (that belongs to the sub-agents).
- **App family — 12 agents:** `app-{php-symfony,javascript-stimulus,twig-symfony}-{analyzer,debugger,reviewer,tester}`.
- **API Platform family — 4 agents:** `api-platform-{analyzer,debugger,reviewer,tester}`, all operating
  on `app/src/ApiResource/**` and `app/src/State/**`. Since 2026-08-17 this is the **same four-role
  quartet as each app domain** — `api-platform-author` was renamed to `api-platform-analyzer` and
  converted to the read-only Analyze axis, so **no author agent exists in any code domain**.
- Agents resolve by frontmatter `name`, not filename.

## Routing constants

- **Domain fork first:** `app/src/{ApiResource,State}/**` or "add an endpoint" intent → API family
  (intent axis). Everything else under `app/**` → App family (path × role axis).
- **App — domain axis (by path):** `app/src/**/*.php` → `app-php-symfony-*`, `app/assets/**/*.js` →
  `app-javascript-stimulus-*`, `app/templates/**/*.twig` → `app-twig-symfony-*`.
- **App — role axis (by intent):** review/quality gate → `-reviewer`; structural health/refactor →
  `-analyzer`; bug/root cause → `-debugger`; regression tests → `-tester`. Resolved cell = domain family
  - role suffix.
- **API — role axis (same shape as App):** structural health/refactor → `api-platform-analyzer`; bug/root
  cause → `api-platform-debugger`; quality gate → `api-platform-reviewer`; test-first build or regression
  → `api-platform-tester` (which owns Green/Refactor itself, like every `app-*-tester`).
- **API — create/modify a resource:** test-first → `api-platform-tester`; otherwise delegate to
  `api-platform-rest-build-skill` / `api-platform-oauth2-build-skill`. Gate both with
  `api-platform-reviewer`. There is no author agent to spawn.
- **Fan out** on a multi-domain change (a page touching `.php` + `.twig` + `.js` → three agents of the
  same role, invoked in parallel in one turn).

## Build verification loop (API Platform)

- `build entry point → reviewer → PASS/REDO`; on REDO re-invoke **the same entry point** (the tester for a
  test-first cycle, otherwise the build skill) with **only the `[MUST]` items**; retry limit max 2, then
  stop and recommend manual review.
- Intermediate drafts under `./.claude/tmp/api/` (gitignored). Only `[MUST]` blocks the merge / forces a REDO.
- The provider Build loop (retry limit 3) is **planned, not runnable** — no per-provider build skill or
  agent exists. Route provider paths to `app-php-symfony-reviewer` and say so in the report.

## Hand-off flows

- `Analyze → Review → Test` (structural diagnosis → quality gate → regression prevention).
- `Analyze → Debug` (analysis surfaces a runtime failure); `Debug → Review → Test` (fix → gate → tests);
  `Debug → Analyze` (cause is a structural defect → design the refactor).
- Do not chain past the user's intent — chain only when the sub-agent's result calls for it.

## Consolidation & dedupe

- Merge findings grouped by family/domain then severity; keep `[MUST]/[SHOULD]/[CONSIDER]`; **only
  `[MUST]` blocks the merge**.
- Cross-domain overlap is **out of both rosters** — flag and hand off, do not silently drop:
  - A PHP change under `Entity`/`EntityRepository`/`Repository` also concerns the **Postgresql reviewer**,
    and caching PHP concerns the **Redis reviewer**. The Redis rule's `paths` are *not* `app/src/**/*.php`
    (a long-standing error in this file) — they are `cache.yaml`, `lock.yaml`, `app/src/Service/**`,
    `app/src/EntityRepository/**`, `app/src/Repository/**`, and `app/src/MessageQueryHandler/**`.
  - A State provider driving heavy Doctrine queries → **Postgresql reviewer** (N+1, JOIN FETCH); a
    resource behind token auth / sensitive `#[Groups]` → **PHP security review**
    (`app-php-symfony-08-security-rule.md`); `Service`/`Repository`/`Message*` domain logic → app family
    (`app-php-symfony-*`).
- Collapse duplicates and attribute the strictest severity (draft §6 #5/#8).
- Report which agents ran and how many loop iterations occurred, so routing is auditable.

## Team collaboration (hand-off)

- Role: cross-domain orchestrator · downstream: the 12 `app-*` and 4 `api-platform-*` sub-agents.
- Deploy is **not** this agent's job — `tools-app-deploy-skill` owns the gate, and the deploy skills
  own the rollout.
- Design SoT: .claude/docs/agent-team-docs.md · .claude/docs/agent-team-docs.md

## SoT

- .claude/docs/agent-team-docs.md (app team composition & workflow-role axis)
- .claude/docs/agent-team-docs.md (API team composition & Build-loop axis)
- .claude/rules/api-platform-rule.md (API Platform judgment criteria)
- .claude/rules/abstract-structure-rule.md (rule index & path context)
