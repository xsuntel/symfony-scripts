# App Multi Team Composition — Draft

> Status: **Draft** — design document. This document proposes a collaboration structure that groups
> the existing agents along a workflow-role axis. Actual skill/agent file creation proceeds only after
> separate approval.
> Written: 2026-07-11 · Updated: 2026-08-01
>
> 🔄 **2026-08-01 — analyzer role incorporated:** the per-domain `*-code-analyzer` agents of `app/base`
> (PHP, JS, Twig) had their bodies written for the **static structure/architecture analysis** role
> (previously empty stubs whose descriptions were identical to the debugger's). An **Analyze team** was
> newly added to the workflow-role axis, and the inventory and model distribution were brought current.
> `[Verified]`
>
> - **Agent total 33 → 36** — the three `*-code-analyzer` agents were missing from the previous inventory
>   (Analyze row added to the section 2 matrix; Analyze team added in section 3.2).
> - **Model distribution opus 21 → 24** — all three analyzers are `opus` (app-domain criticality axis).
>   The 12 `sonnet` agents are unchanged.
> - **Tool distribution 16 → 19 inherit all tools** — the three analyzers are the "All tools" type that
>   omits `tools` (the 17 narrow-toolset agents are unchanged).
> - **Role axis 6 → 7 kinds** — the analyzer is a **static structural health** analyst, distinct from the
>   debugger (runtime root cause) and the reviewer (rule compliance) (handoff: `analyzer → reviewer → tester`,
>   `analyzer → debugger` on failure).
>
> 🔄 **2026-07-24 — fact re-verification:** the document's `[Verified]` claims were re-checked against the
> current `.claude/` assets and tools, and mismatched facts were corrected. The main corrections are below.
> `[Verified]`
>
> - **Agent total 32 → 33** — `message/base/rabbitmq-config-reviewer` was missing from the inventory
>   (incorporated in sections 2 and 3.1).
> - **Model-distribution claim corrected (key)** — all 33 agents **explicitly set `model:`, so zero inherit
>   the default**. The measured split is `opus` 21 / `sonnet` 12; the previous "inherit 15 / sonnet 17"
>   statement was an error (restated in section 2).
> - **The provider, API Platform author, and reviewer are `opus`, not `sonnet`** — the premise "lightweight
>   model because it is called repeatedly" did not match reality (corrected in section 3.5 and section 6 #8).
> - **Brought current:** the `deploy-gate-helper` creation date, the helper-skill naming, and the
>   settings.json citation line numbers.
>
> 🔄 **2026-07-18 — full revision:** since the draft was first written, the `.claude/` assets have expanded
> and been reorganized significantly, so this document's factual basis was brought current. The key changes
> are below and have been reflected in each section.
>
> - **Agents grew 14 → 33** (added: 3 Twig agents, 10 provider author/reviewers, 4 Claude Code / Shell Script
>   author/reviewers, API Platform Author/Reviewer, RabbitMQ Reviewer, AWS ECS Reviewer). `[Verified]`
> - **The rule tree was reorganized into the `base/`·`cloud/` taxonomy** — the old paths the draft cited,
>   such as `server/nginx-rule.md`, `cache/redis-rule.md`, `api/api-platform-rule.md`, are all invalid. `[Verified]`
> - **The author→reviewer verification loop is no longer the sole case but a repository-standard pattern** —
>   many build/helper skills orchestrate with this pattern (section 4). `[Verified]`
> - Most of the section 6 diagnostic items were **resolved/retired** (see each row). Only #5 (duplicate rule
>   paths) remains valid.

@see .claude/rules/structure-rule.md — rule index (SoT)
@see .claude/skills/utility/git/commit-message-helper/SKILL.md — orchestration reference standard
@see .claude/output-styles/korean-output-style.md — document style (ADR, trade-offs, citations)

---

## 1. Overview & premises

### Purpose

`.claude/` already has domain-specific agents, skills, and rules neatly in place, but **there is no
document that groups them into "teams" and defines the collaboration flow.** This draft proposes a
composition that reorganizes the 36 agents along a **workflow-role** axis
(Review / Analyze / Debug / Test / Build / Commit / Deploy).

### Premise facts (verified)

- The agent-team experimental feature is already enabled — `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS: "1"`.
  `[Verified]` [Read: .claude/settings.json:12]
- The default permission mode is `plan`, the output style is `korean-output-style`, and effort is `high`.
  `[Verified]` [Read: .claude/settings.json:7,8,53]
- Multi-agent orchestration is **no longer a single case** — `commit-message-helper` was the first case,
  and now `utility/claude/code-config-helper`, `utility/shell-script/code-config-helper`, and many
  provider/API build skills operate with the same author→reviewer verification loop. `commit-message-helper`
  remains the **reference standard** among them. `[Verified]`
  [Read: .claude/skills/utility/git/commit-message-helper/SKILL.md]

### Three-layer collaboration principle

The existing assets separate roles into the three layers below, and the team composition inherits this
principle as-is.

```text
rules/       = the single source of truth (SoT) for judgment. Auto-applied via a paths glob; no natural-language trigger.
agents/      = the executor. Loads rules/docs/output-style via Read to perform the work.
skills/      = the orchestrator/entry point. Calls agents in sequence and bundles the artifacts.
```

- A rule is a **passive, auto-applied** artifact that has only `paths` and no `description` (except that the
  index-like `structure-rule.md` intentionally has no frontmatter and is loaded only via an explicit reference
  from CLAUDE.md). Agents are triggered by a natural-language `description`. `[Verified]`
- An agent does not carry the criteria itself; it references the rule (SoT), docs, and output-style via `@see`.
  `[Verified]` [Read: .claude/agents/app/base/php-code-reviewer.md:16-19]

---

## 2. Agent inventory (role × domain matrix)

The current **36** agents are organized by **workflow role (rows) × technology domain (columns)**. `[Verified]`
(36 files in the agents/ tree)

| Workflow role | Backend (PHP) | Frontend (JS·Twig) | Infra·Data | Integration (API·Provider) | Ops·Config |
|---|---|---|---|---|---|
| **Analyze** (static structure·architecture) | PHP Code Analyzer | Javascript Code Analyzer · Twig Code Analyzer | — | — | — |
| **Debug** | PHP Debug Reviewer | Javascript Debug Reviewer · Twig Debug Reviewer | — | — | — |
| **Review** (standalone judgment) | PHP Code Reviewer | Javascript Code Reviewer · Twig Code Reviewer | Postgresql Reviewer · Redis Reviewer · RabbitMQ Reviewer · Nginx Reviewer · GCP Cloud Run Reviewer · AWS ECS Reviewer | API Platform Reviewer | — |
| **Test** | PHP Test Writer | Javascript Test Writer · Twig Test Writer | — | — | — |
| **Build** (author→reviewer generate-verify) | — | — | — | API Platform Author(+Reviewer) · UPbit REST·WS (Author+Reviewer) · KoreaInvestment OAuth2·REST·WS (Author+Reviewer) | Claude Code Author+Reviewer · Shell Script Author+Reviewer |
| **Commit** | — | — | — | — | Git Commit Author+Reviewer |
| **Deploy** | — | — | (deploy gate: reuse Nginx·GCP·AWS·Shell Reviewer) | — | — |

> **The Build role was newly added in this revision.** At the time of the draft, only Commit (git) had an
> author→reviewer pair; now the API, provider, and config domains broadly operate on the same pattern (section 4).
>
> **The Analyze role was incorporated on 2026-08-01.** The formerly empty-stub `*-code-analyzer` agents (the
> app-domain PHP·JS·Twig trio) were filled for the static-structure-analysis role, becoming a third analysis
> axis distinct from Review (rule compliance) and Debug (runtime cause) (section 3.2).

### Model·tool distribution status (re-verified)

**Important:** all 36 agents **explicitly set `model:`, and none inherit the default** (the previous revision's
"inherit" statement was an error). The model splits into two values, `opus` / `sonnet`. `[Verified]`

- **`opus` — 24.** The generate/judge/analyze layer of the app/API/provider domains: the code/analyze/debug/test
  agents (PHP·JS·Twig, 12), **API Platform Author·Reviewer (both opus, symmetric)**, and the 10 provider
  author/reviewers (UPbit·KoreaInvestment). `[Verified]`
  [Read: .claude/agents/app/base/php-code-reviewer.md:4]
- **`sonnet` — 12.** The 6 infra-config reviewers (Postgresql·Redis·**RabbitMQ**·Nginx·GCP·AWS) and the 6
  meta/utility config author/reviewers (Claude Code·Shell Script·Git, each author+reviewer). `[Verified]`
  [Read: .claude/agents/cache/base/redis-config-reviewer.md:4]

Tools (`tools`) are a **separate axis** from the model: **19** omit `tools` and inherit all tools (mostly the
"All tools" type reviewers/analyzers), and **17** declare a narrow toolset (Bash·Read·Write, etc.) (the author
family and config author/reviewers). `[Verified]`

The implication of this distribution differs from the draft's "loop vs standalone" hypothesis — the actual
convention is a **domain criticality/complexity axis**: **the layer where application-code correctness is
directly at stake (generation/judgment/analysis of app·API·provider) is `opus`**, and **infra-config reviews and
meta/config tools (config·git·shell) are `sonnet`**. In other words, the provider's author→reviewer loop is also
opus (not lightweight despite being called repeatedly), while an infra reviewer is a standalone judgment yet
sonnet. For API Platform, the Author and Reviewer are **both opus, symmetric**.

---

## 3. Team definitions (per workflow role)

Each team is defined in ADR style (Context / Decision / Consequences). The composition axis is the **workflow
role**, and domain agents are reused across several teams.

### 3.1 Review team

#### Context
Compares the quality of changed files against the domain criteria (SoT) and flags them by MUST/SHOULD/CONSIDER
severity. There are currently 10 standalone-judgment reviewers, but the routing rule for which reviewer to call
when is not documented.

#### Decision
- **Members:** PHP Code Reviewer, Javascript Code Reviewer, Twig Code Reviewer, Postgresql Reviewer, Redis
  Reviewer, RabbitMQ Reviewer, Nginx Reviewer, GCP Cloud Run Reviewer, AWS ECS Reviewer, API Platform Reviewer.
- **Trigger:** after a code change (the global CLAUDE.md section 7 convention "after a code change → run code-reviewer automatically").
- **Routing basis:** select the responsible reviewer by matching the changed file path against the rule's `paths`
  glob. The rule paths in the table below reflect the current tree (`base/`·`cloud/` taxonomy). `[Verified]`

  | Changed-path pattern | Responsible reviewer | Basis rule (paths) |
  |---|---|---|
  | `app/src/**/*.php` | PHP Code Reviewer | `app/base/php-symfony/00~11-*-rule.md` |
  | `app/src/{Entity,EntityRepository,Repository}/**/*.php` | Postgresql Reviewer | `database/base/postgresql-config-rule.md` |
  | `app/assets/**/*.js` | Javascript Code Reviewer | `app/base/javascript-stimulus/00~02-*-rule.md` |
  | `app/templates/**/*.twig` | Twig Code Reviewer | `app/base/twig-symfony/00-overview-rule.md` |
  | `app/src/{ApiResource,State}/**/*.php` | API Platform Reviewer | `api/base/api-platform-rule.md` |
  | `app/config/packages/cache.yaml`, `app/src/**/*.php` | Redis Reviewer | `cache/base/redis-config-rule.md` |
  | `app/src/Message*/**/*.php`, `app/config/packages/messenger.yaml` | RabbitMQ Reviewer | `message/base/rabbitmq-config-rule.md` |
  | `scripts/**/nginx/**` | Nginx Reviewer | `server/base/nginx-config-rule.md` |
  | `scripts/containers/prod/**`, `**/*.tf`, `**/cloudbuild.yaml`, `**/Dockerfile` | GCP Cloud Run Reviewer | `server/cloud/gcp/cloudrun-config-rule.md` |
  | (AWS ECS deployment assets) | AWS ECS Reviewer | `server/cloud/aws/ecs-config-rule.md` |
  | `scripts/**/*.sh`, `scripts/**/entrypoint.sh` | Shell Script Reviewer | `utility/shell-script/code-config-rule.md` |

- **I/O:** input = changed file paths + rules (SoT). Output = a severity-classified report (only `[MUST]` blocks the merge).
  `[Verified]` [Read: .claude/agents/app/base/php-code-reviewer.md] — "only `[MUST]` blocks the merge".

#### Consequences
- (+) The per-domain judgment always tracks the latest rule (SoT) — because a reviewer does not carry the criteria itself.
- (−) One file can match several reviewers. In particular, because the **Redis rule paths are broad (`app/src/**/*.php`)**,
  effectively every PHP change matches PHP · Redis · (Postgresql if an Entity) at once. The orchestrator must manage a
  **duplicate-finding merge rule**. See section 6 #5·#8.

### 3.2 Analyze team (new)

#### Context
Statically evaluates the **structural health** of the code. Where the Review team looks at "does the code obey
the rules" (standalone judgment) and the Debug team at "why doesn't it work" (runtime cause), the Analyze team
looks at **"is the structure healthy"** (layer boundaries, dependency direction, cohesion, complexity, refactoring
opportunities) — the three analysis axes each have a different purpose. At the time of the draft, `*-code-analyzer`
was an empty stub whose description was identical to the debugger's; on 2026-08-01 its body was written for the
static-structure-analysis role. `[Verified]`

#### Decision
- **Members:** PHP Code Analyzer (layer-boundary violation, circular dependency, God Service, MessageBus coupling,
  structural N+1), Javascript Code Analyzer (controller single-responsibility, outlet coupling, target-bypass DOM,
  importmap dependency graph), Twig Code Analyzer (inheritance depth, partial/macro reuse, logic-presentation
  separation, componentization opportunities). All `opus`. `[Verified]`
- **Trigger:** not a specific bug, but when structural improvement, refactoring, or an architecture review is needed.
  Natural-language requests ("is the structure OK", "room to refactor", "clean up the dependencies").
- **Output:** using the korean-output-style "Architecture Design & Analysis" section as the SoT — an ADR
  (Context/Decision/Consequences) + the three trade-off axes (scalability, maintainability, performance) + a
  dependency-direction arrow (`→`) + a pattern proposal that includes an alternative. `[Verified]`
  [Read: .claude/agents/app/base/php-code-analyzer.md]
- **Role boundary (handoff):** `Analyze (diagnose & propose) → Review (quality gate) → Test (regression prevention)`;
  on discovering a runtime failure, `Analyze → Debug`.

#### Consequences
- (+) Refactoring judgment (structure), rule judgment (quality), and cause tracing (runtime) are separated, so each
  agent's prompt focus is single.
- (−) The infra/integration domains (nginx/gcp/aws/redis/api/provider) have no dedicated Analyze agent — only the
  app (PHP·JS·Twig) trio exists. Structural review of those domains is handled by the domain Reviewer as a side duty.

### 3.3 Debug team

#### Context
Traces the **root cause** of a bug. Where the Review team looks at "does the code obey the rules", the Debug team
looks at "why doesn't it work" — different purposes.

#### Decision
- **Members:** PHP Debug Reviewer (handler not running, N+1 / detached entity, migration mismatch, transport routing,
  locking/idempotency, DI miswiring), Javascript Debug Reviewer (controller not registered, target mismatch, Turbo
  update failure, memory leak, importmap resolution failure), Twig Debug Reviewer (undefined variable, double/missing
  escaping, block not inherited, include/macro path error, form theme not applied). `[Verified]`
- **Trigger:** on bug reproduction / symptom report. Natural-language requests ("why doesn't it work", "the handler isn't running", etc.).
- **Boundary with the Analyze·Review teams (handoff):** `Debug (cause & fix) → Review (quality) → (if needed) Test
  (regression prevention)`. If the cause is a structural defect, hand off to `Debug → Analyze` to design the refactor
  (separating runtime cause from structural health).

#### Consequences
- (+) Separating diagnosis from quality judgment makes each agent's prompt focus clear.
- (−) The infra/integration domains (nginx/gcp/aws/redis/api/provider) have no dedicated Debug agent — those bugs are
  handled by the domain Reviewer as a side duty, or diagnosed procedurally with the provider's test skill. See section 6.

### 3.4 Test team

#### Context
Writes tests that prevent regressions of the changed code. Must always observe the test rule (SoT).

#### Decision
- **Members:** PHP Test Writer (PHPUnit Unit/Integration/Functional), Javascript Test Writer, and Twig Test Writer
  (Symfony Functional / WebTestCase, `lint:twig`). `[Verified]`
- **Mandatory observances** (`app/base/php-symfony/09-testing-rule.md` SoT):
  - Unit tests must not touch the filesystem, DB, cache, or network.
  - Integration tests use **real PostgreSQL/Redis instances** — no DB/Redis mocking.
  - Functional tests verify the HTTP response, redirect, and rendered HTML; they must not verify internal service state directly.
  `[Verified]` [Read: .claude/rules/app/base/php-symfony/09-testing-rule.md]
- **Trigger:** after writing a new class, or after a Debug-team fix when regression prevention is requested.

#### Consequences
- (+) The test-layer (Unit/Integration/Functional) boundary is enforced by the rule (`09-testing-rule.md`).
- (−) Infra config (nginx/gcp/aws/shell) has no corresponding Test Writer — that layer relies on procedural tests (the
  provider/API `*-test` skills) or manual verification.

### 3.5 Build team (new)

#### Context
**Generates** API·provider·config code and immediately **verifies** it with a dedicated reviewer. A role that did
not exist at the time of the draft, it now makes up much of the repository's orchestration.

#### Decision
- **Members (author→reviewer pairs):** API Platform (Author+Reviewer), UPbit REST·WebSocket, KoreaInvestment
  OAuth2·REST·WebSocket, Claude Code, Shell Script. `[Verified]`
- **Orchestrator:** each domain's `*-build`/`*-helper` skill calls the author to produce a draft and the reviewer
  judges PASS/REDO (section 4 verification loop). `[Verified]`
- **Model:** follows the domain criticality axis (section 2) — the author·reviewer of provider·API Platform builds are
  **`opus`** (the layer where code correctness is at stake), while only utility config builds such as Claude Code·Shell
  Script are **`sonnet`**. The author family all declare a narrow toolset (Bash·Read·Write, etc.). `[Verified]`

#### Consequences
- (+) Generate-verify is closed within a single skill, so retries and artifact management are consistent.
- (−) Each domain must maintain three artifacts (author·reviewer·skill), so the file count grows quickly.

### 3.6 Commit·Deploy team

#### Context
Commits and deploys the change. Commit has a **completed orchestration standard** (commit-message-helper); the Deploy
gate is defined for the first time by this draft.

#### Decision
- **Commit sub-team (implemented · reference standard):** the `commit-message-helper` skill, as orchestrator, calls
  `Git Commit Author` → `Git Commit Reviewer` in sequence, runs `git commit -F` on PASS, and retries up to 2 times on
  REDO. `[Verified]`
  [Read: .claude/skills/utility/git/commit-message-helper/SKILL.md]
- **Deploy sub-team (proposed):** **reuse** the domain reviewers as a pre-deploy security/config gate.
  - Nginx Reviewer → server config (security headers, TTL, FastCGI).
  - GCP Cloud Run Reviewer / AWS ECS Reviewer → runtime, secrets, IAM least privilege.
  - Shell Script Reviewer → deploy-script safety (`rm -rf` guards, etc.).
  - Consistent with the global CLAUDE.md section 7 conventions "before deploy → run security-auditor" and "before a
    destructive action → request user approval".

#### Consequences
- (+) The Commit flow reuses an already-verified pattern as-is (no rework).
- (+) The Deploy gate was newly created on 2026-07-23 as the `deploy-gate-helper` skill — after fanning out to the
  domain reviewers, the actual deploy is handed off to `cloudrun-config-helper`/`ecs-config-helper` (section 7).
- (!) `git push` is set to `ask` in `settings.json`, so it always goes through user confirmation. `[Verified]`
  [Read: .claude/settings.json:54]

---

## 4. Orchestration reference pattern

Generalizes `commit-message-helper` into a **reusable team-orchestration template**. Since the draft, this pattern
has already spread to many build/helper skills and become the de-facto repository standard. `[Verified]`

### Verification-loop template (author→reviewer pattern)

```text
Skill (orchestrator)
  ├─ 1. Precondition check (e.g. git diff --cached --quiet)
  ├─ 2. Call the Author agent   → ./.claude/tmp/<task>-draft.md
  ├─ 3. Call the Reviewer agent → ./.claude/tmp/<task>-review.md (PASS/REDO)
  ├─ 4. Branch on the judgment
  │      PASS → run the final action
  │      REDO → include the review instructions in a re-call of the Author, repeat from step 2
  └─ 5. On exceeding the retry limit (max 2) → stop the automatic run + recommend manual review
```

- Intermediate artifacts are exchanged as files under `./.claude/tmp/` (gitignored). `[Verified]`
  [Read: .claude/skills/utility/git/commit-message-helper/SKILL.md]
- This pattern can be transplanted to **any team with a "write → verify → judge" structure**, such as the Deploy gate
  or large-scale review consolidation — the entire Build team (3.5) has already adopted it.

### Alternatives compared: orchestrator skill vs. direct routing by the main agent

| Approach | Pros | Cons | Selection criteria |
|---|---|---|---|
| **Orchestrator skill** (build/commit style) | Explicit control of retry, artifact management, and the judgment loop | Requires creating and maintaining a skill file | Teams that need multi-stage / retry / a gate (Build, Commit, Deploy) |
| **Direct routing by the main agent** | No file creation needed; works immediately via `paths` matching | Retry / consolidated-report logic is improvised each time | A one-off single review (one item of Review·Analyze·Debug·Test) |

**Recommendation:** Review/Analyze/Debug/Test are sufficient with direct routing, while Build·Commit·Deploy already
have orchestrator skills (the Deploy gate was newly created on 2026-07-23, section 7). Note that the Deploy gate is not
an author→reviewer loop but a **multi-reviewer fan-out** variant. `[Inferred]` — the actual operational load should be
re-examined after adoption.

---

## 5. Trade-offs (adopting the workflow-role axis)

A three-axis analysis of the decision to choose the **workflow-role axis** rather than the **domain axis** as the
team-composition axis.

- **Scalability:** even when a new technology domain (e.g. a new provider) is added, the role teams
  (Review/Analyze/Debug/Test/Build) stay put, and only the domain agent is incorporated into the relevant team. Since
  the draft, the Twig·provider·config domains were added, yet the role axis was stable (only each domain agent was
  incorporated), and on 2026-08-01 the Analyze role was added, taking the role axis from 6 → 7 kinds. `[Verified]`
- **Maintainability:** each role gives its agents a single-focus prompt, lowering cognitive load (a reviewer judges only,
  a debugger traces cause only, an author generates only). However, because one domain agent belongs to several teams,
  the membership relation becomes **1:N**, requiring maintenance of the mapping table (section 2).
- **Performance:** a role team calls only the agents it needs, avoiding starting unnecessary domain reviewers. The
  opposite risk is that, when one file matches many rules in the Review team (especially the broad Redis paths),
  duplicate calls arise — mitigated by the orchestrator's merge logic (section 6).

**Comparison with the domain axis:** the domain axis (e.g. a "Backend team" handling review, debug, and test all at once)
has high domain cohesion, but roles get mixed, prompts bloat, and roles must be redefined per domain. The repository
already separates the 4-role (code/analyze/debug/test) agents across PHP·JS·Twig, so **the role axis is more consistent
with the existing structure**. `[Verified]` (composition of the 12 files under agents/app/base/)

---

## 6. Current gaps & follow-up tasks

The following are facts confirmed during exploration, kept as a **diagnostic record** (this draft is a design document,
so it is not a direct edit target). Each item is recommended for handling as separate future work.

| # | Finding | Basis | Status·recommendation |
|---|---|---|---|
| 1 | ~~`git-commit-reviewer` name is `Git Commit Reviewr` (typo)~~ | agents/utility/git/commit-message-reviewer.md | ✅ **Resolved** — name is `Git Commit Reviewer`, and the file was moved to `utility/git/commit-message-reviewer.md` |
| 2 | ~~`paths` mismatch of the shared rule `api/rest-client-rule.md`~~ | — | ⛔ **Retired** — that rule file no longer exists. Provider-integration rules were split out into `app/providers/finance/**/api-*-rule.md` |
| 3 | ~~No provider-specific agents (UPbit/KoreaInvestment)~~ | agents/app/providers/finance/** | ✅ **Resolved** — 10 author/reviewers newly created |
| 4 | ~~No shell·git domain rule (SoT)~~ | rules/ tree | 🔸 **Partly resolved** — a shell rule was created (`utility/shell-script/code-config-rule.md`, `paths: scripts/**/*.sh`). git still has no rule → explicitly substituted by a skill (commit-message-helper) |
| 5 | `05-doctrine-rule.md` and `database/base/postgresql-config-rule.md` are applied to the **same paths** (`Entity`·`EntityRepository`·`Repository`) redundantly | frontmatter of both rules `[Verified]` | ⚠️ **Valid** — need to define a Review-team merge rule (remove duplicate findings) |
| 6 | ~~No frontmatter on `server/nginx-rule.md`·`structure-rule.md`~~ | rules/server/base/nginx-config-rule.md | ✅ **Resolved** — nginx `paths: scripts/**/nginx/**`. structure is an index, so intentionally no frontmatter |
| 7 | ~~api/cache/database/server/utility under `docs/` are empty `.gitkeep`~~ | docs/ tree `[Verified]` | ✅ **Resolved** — filled per domain with `-docs.md` (api-platform-docs·redis-config-docs·postgresql-config-docs·nginx-config-docs·code-config-docs, etc.) |
| 8 | The `paths` of `cache/base/redis-config-rule.md` are **broad** (`app/src/**/*.php`) → the Redis Reviewer matches every PHP change | rule frontmatter `[Verified]` | ⚠️ **Valid** — need to consider narrowing the Redis paths (with #5, refine Review-team merging/routing) |
| 9 | ~~API Platform is asymmetric with the provider (Author=sonnet / Reviewer=inherit)~~ | agent frontmatter `[Verified]` | ⛔ **Retired (error corrected)** — measured, the API Platform Author·Reviewer are **both opus, symmetric**, and the provider is likewise both opus. The model policy is consistent along the "domain criticality axis" (restated in section 2) |

---

## 7. Next steps (reference for implementation)

Review/Analyze/Debug/Test already work via direct routing, and Build/Commit via the existing skills. The last gap, the
**Deploy gate**, was newly created on 2026-07-23. `[Verified]`

```text
.claude/skills/server/deploy-gate-helper/SKILL.md   ← Deploy-gate orchestrator (creation complete)
```

- `deploy-gate-helper` is not a single author→reviewer loop but a gate that **fans out the changed deployment assets to
  the domain reviewers (Nginx·GCP Cloud Run·AWS ECS·Shell Script)**, collects MUST/SHOULD/CONSIDER, and judges go/no-go
  (PASS/BLOCK). On PASS, the actual deploy is handed off to `cloudrun-config-helper`/`ecs-config-helper`; the gate itself
  does not execute deploy/rollback.
- BLOCK (= one or more MUST) → re-run after fixing, up to 2 times. Intermediate artifacts under `./.claude/tmp/` (gitignored).
- Remaining improvement tasks: section 6 #5 (merge the duplicate doctrine↔postgresql rule), #8 (narrow the Redis paths).

---

## Appendix: reference assets

| Asset | Path | Role |
|---|---|---|
| Orchestration standard | `.claude/skills/utility/git/commit-message-helper/SKILL.md` | Verification-loop reference pattern |
| Agent-body pattern | `.claude/agents/app/base/php-code-reviewer.md` | Role·SoT-reference·quality-gate structure |
| Rule index | `.claude/rules/structure-rule.md` | Domain-rule SoT index |
| Output style | `.claude/output-styles/korean-output-style.md` | ADR·trade-off·citation format |
| Team-feature enablement | `.claude/settings.json:12` | `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` |
