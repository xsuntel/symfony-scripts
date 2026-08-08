# API Multi Team Composition — Draft

> Status: **Draft** — design document. This document proposes the collaboration structure for the
> **API domain** (API Platform inbound REST) sub-agents, along the workflow-role axis used by the
> app-domain draft. It is the design SoT for the `api-multi-team` orchestrator agent.
> Written: 2026-08-06

@see .claude/docs/app/agent/multi-team-docs.md — app-domain team draft (parent pattern; §4 orchestration template)
@see .claude/rules/structure-rule.md — rule index (SoT)
@see .claude/rules/api/base/api-platform-rule.md — API Platform standards (SoT)
@see .claude/output-styles/english-output-style.md — document style (ADR, trade-offs, citations)

---

## 1. Overview & premises

### Purpose

The API domain exposes **this project's own inbound REST API** through API Platform. Two agents already
exist — `api-platform-author` (generate) and `api-platform-reviewer` (verify) — but there is no document
that groups them into a team and defines the collaboration flow. This draft defines the **Build
(generate-verify) team** and its orchestration, scoped strictly to the inbound API.

### Premise facts (verified)

- The agent-team experimental feature is enabled — `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS: "1"`.
  `[Verified]` [Read: .claude/settings.json]
- Both API agents are `opus`, `memory: project`, `isolation: worktree` — the API build layer is the
  "code correctness at stake" criticality axis, so it is not a lightweight-model layer. `[Verified]`
  [Read: .claude/agents/api/base/api-platform-author.md, api-platform-reviewer.md]
- The author declares a narrow write toolset (`Bash, Read, Grep, Glob, Edit, Write`); the reviewer is
  read-only + web (`Read, Grep, Glob, Bash, WebFetch, WebSearch`). `[Verified]`

### Three-layer collaboration principle

The API domain inherits the repository's three-layer separation as-is:

```text
rules/       = the single source of truth (SoT) for judgment. Auto-applied via a paths glob; no natural-language trigger.
agents/      = the executor. Loads rules/docs via Read to perform the work.
skills/      = the orchestrator/entry point. Calls agents in sequence and bundles the artifacts.
```

- The API judgment SoT is `.claude/rules/api/base/api-platform-rule.md`; the reference/template edition
  is `.claude/docs/api/base/api-platform-docs.md`. An agent references these via `@see`, never carrying
  the criteria itself. `[Verified]`

---

## 2. Agent inventory (role × domain)

The API domain contributes to a single workflow role — **Build** (author→reviewer generate-verify). It
reuses the app-domain **Test** role (`php-code-tester`) rather than owning a dedicated API tester.

| Workflow role | API-domain member | Model | Tools |
|---|---|---|---|
| **Build** (generate) | `api-platform-author` | opus | narrow (Bash·Read·Grep·Glob·Edit·Write) |
| **Build** (verify) | `api-platform-reviewer` | opus | read-only + web |
| **Test** (reused) | `php-code-tester` / `api:base:api-platform-test` skill | — | — |

Both Build members operate on `app/src/ApiResource/**` and `app/src/State/**`.

---

## 3. Team definition — Build (author→reviewer)

Defined in ADR style (Context / Decision / Consequences).

### Context
Creating or modifying an API resource must (a) follow the api-platform-rule SoT (resource DTO not raw
Entity, explicit `operations:`, read/write `#[Groups]` symmetry, State provider/processor wiring,
`#[Assert]` validation, operation `security:`, Parameter-based filters, RFC 7807/Hydra errors) and
(b) be verified before merge. A single author pass with no gate risks silent standard drift.

### Decision
- **Members:** `api-platform-author` (generate/modify), `api-platform-reviewer` (PASS/REDO verify).
- **Orchestrator:** the `api-multi-team` agent drives the loop; a single standalone review routes
  directly to the reviewer. The `api:base:api-platform-review` skill provides the review entry point.
- **Trigger:** create/modify an API resource → Build loop; review existing resource code → reviewer only.
- **I/O:** input = the ApiResource/State change intent + the api-platform-rule SoT. Intermediate drafts
  are exchanged under `./.claude/tmp/api/` (gitignored). Output = final code + a severity-classified
  report; only `[MUST]` blocks the merge (and forces a REDO).

### Consequences
- (+) Generate-verify is closed in one loop, so the resource always tracks the latest rule (SoT).
- (−) A resource whose State provider drives heavy Doctrine queries, or that sits behind token auth,
  spills into the **Postgresql** / **php-code security** reviewers — a cross-domain hand-off the
  orchestrator must flag rather than absorb.

---

## 4. Orchestration reference pattern

The API Build loop reuses the repository-standard verification-loop template documented in the app draft
§4 (originating from `commit-message-helper`):

```text
Orchestrator (api-multi-team)
  ├─ 1. Precondition — confirm target ApiResource/State paths + change intent
  ├─ 2. Call api-platform-author   → ./.claude/tmp/api/<task>-draft.md
  ├─ 3. Call api-platform-reviewer → PASS / REDO (file:line findings)
  ├─ 4. PASS → surface final code + report ; REDO → re-call author with the [MUST] items, repeat from 2
  └─ 5. Retry limit (max 2) exceeded → stop the loop + recommend manual review
```

- Intermediate artifacts live under `./.claude/tmp/` (gitignored), matching every other build/helper skill.
- Test coverage is a **separate hand-off** (`php-code-tester` / `api:base:api-platform-test`), not part
  of the author→reviewer loop.

---

## 5. Trade-offs (adopting the Build-loop axis for the API domain)

- **Scalability:** adding a new resource type adds work items to the same two agents — the role team is
  stable; no new agent is needed per resource.
- **Maintainability:** author and reviewer each keep a single-focus prompt (generate only / judge only),
  lowering cognitive load; the shared api-platform-rule SoT keeps both in sync.
- **Performance:** the loop calls exactly two agents plus optional Test; the cost driver is the retry
  count, bounded at 2.

**Comparison with folding the API into the app team:** the API resource surface has its own SoT
(`api-platform-rule.md`) and its own generate-verify shape, distinct from the app code/analyze/debug/test
axis — so a dedicated Build pair is more consistent with the existing structure than overloading
`php-code-*`.

---

## Appendix: reference assets

| Asset | Path | Role |
|---|---|---|
| Orchestrator agent | `.claude/agents/api/agent/multi-team.md` | API Build-loop router |
| Author agent | `.claude/agents/api/base/api-platform-author.md` | Generate ApiResource/State code |
| Reviewer agent | `.claude/agents/api/base/api-platform-reviewer.md` | PASS/REDO quality gate |
| API rule (SoT) | `.claude/rules/api/base/api-platform-rule.md` | API Platform judgment criteria |
| API docs (reference) | `.claude/docs/api/base/api-platform-docs.md` | Resource-addition procedure & templates |
| Orchestration standard | `.claude/skills/utility/git/commit-message-helper/SKILL.md` | Verification-loop reference pattern |
| Parent team draft | `.claude/docs/app/agent/multi-team-docs.md` | App-domain workflow-role design |
