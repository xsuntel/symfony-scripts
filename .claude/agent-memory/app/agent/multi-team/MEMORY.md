# app-multi-team memory

## Role (verified)

- Coordinator/dispatcher for the app-domain team — routes, fans out, and consolidates; does **not**
  perform domain judgment itself (that belongs to the sub-agents).
- Covers **only the 12 app/base agents**: `{php,javascript,twig}-code-{analyzer,debugger,reviewer,tester}`.
  Agents resolve by frontmatter `name`, not filename.

## Routing constants

- **Domain axis (by path):** `app/src/**/*.php` → `php-code-*`, `app/assets/**/*.js` → `javascript-code-*`,
  `app/templates/**/*.twig` → `twig-code-*`.
- **Role axis (by intent):** review/quality gate → `-reviewer`; structural health/refactor → `-analyzer`;
  bug/root cause → `-debugger`; regression tests → `-tester`. Resolved cell = domain family + role suffix.
- **Fan out** on a multi-domain change (a page touching `.php` + `.twig` + `.js` → three agents of the
  same role, invoked in parallel in one turn).

## Hand-off flows

- `Analyze → Review → Test` (structural diagnosis → quality gate → regression prevention).
- `Analyze → Debug` (analysis surfaces a runtime failure); `Debug → Review → Test` (fix → gate → tests);
  `Debug → Analyze` (cause is a structural defect → design the refactor).
- Do not chain past the user's intent — chain only when the sub-agent's result calls for it.

## Consolidation & dedupe

- Merge findings grouped by domain then severity; keep `[MUST]/[SHOULD]/[CONSIDER]`; **only `[MUST]`
  blocks the merge**.
- Cross-domain overlap is **out of this team** — flag and hand off, do not silently drop: a PHP change
  under `Entity`/`EntityRepository`/`Repository` also concerns the **Postgresql reviewer**, and caching
  PHP concerns the **Redis reviewer**. Because the Redis rule paths are broad (`app/src/**/*.php`),
  effectively every PHP change can match PHP · Redis · (Postgresql if an Entity) — collapse duplicate
  findings and attribute the strictest severity (draft §6 #5/#8).

## Team collaboration (hand-off)

- Role: app-domain orchestrator · downstream: the 12 `{php,javascript,twig}-code-*` sub-agents.
- Design SoT: .claude/docs/app/agent/multi-team-docs.md

## SoT

- .claude/docs/app/agent/multi-team-docs.md (team composition & workflow-role axis)
- .claude/rules/structure-rule.md (rule index & path context)
