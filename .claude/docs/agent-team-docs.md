# Agent Team Composition

> Status: **design document (SoT)** — defines the collaboration structure that groups every specialist
> agent in the repository along the workflow-role axis, and the rationale for the routing, handoffs,
> and verification loops of the single orchestrator `agent-team`.
> Written: 2026-07-11 · Last updated: 2026-08-20

@see .claude/rules/api-platform-rule.md — API Platform (Symfony) resource · State judgment SoT
@see .claude/docs/api-platform-docs.md — API Platform resource-addition procedure (step by step)
@see .claude/rules/abstract-structure-rule.md — rule index (SoT)
@see .claude/skills/utility-git-commit-skill/SKILL.md — orchestration reference standard
@see .claude/output-styles/abstract-english-style.md — document style (ADR · trade-offs · citations)

---

## 1. Overview and Premises

### Purpose

`.claude/` already holds a well-ordered set of per-domain agents, skills, and rules, but **no document
grouped them into a "team" and defined the collaboration flow.** This document defines a composition
that reorganizes the agents along the **workflow-role** axis (Review / Analyze / Debug / Test / Build /
Commit / Deploy).

The **API Platform domain** (resource DTOs, operations, and serialization in `app/src/ApiResource/`;
Providers/Processors, validation, security, and filters in `app/src/State/`) used to be a separate
document; it was absorbed into this one on 2026-08-16.

### Premises (verified)

- The agent-team experimental feature is already enabled — `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS: "1"`.
  `[Verified]` [Read: .claude/settings.json:12]
- The default permission mode is `plan`, the output style is `abstract-english-style`, and effort is
  `high`. `[Verified]` [Read: .claude/settings.json:7,8]
- Multi-agent orchestration is **no longer a single case** — `utility-git-commit-skill` was the first,
  and today `utility-shell-script-skill`, `utility-drawio-diagram-skill`, and several provider/API build
  skills run the same author→reviewer verification loop (`utility-claude-code-skill` has used a
  **command-based self-verification** loop instead of an agent pair since 2026-08-08).
  `utility-git-commit-skill` remains the **reference standard** among them. `[Verified]`
  [Read: .claude/skills/utility-git-commit-skill/SKILL.md]

### The Three-Layer Collaboration Principle

The existing assets separate responsibilities across the three layers below, and the team composition
inherits that principle unchanged.

```text
rules/      = the single source of truth (SoT) for judgment. Auto-applied via a paths glob, no natural-language trigger.
agents/     = executors. Load rules, docs, and output styles with Read, then do the work.
skills/     = orchestrators / entry points. Control retries, gates, and artifacts.
commands/   = holders of procedure and judgment criteria. Read by a skill as self-verification criteria, or invoked directly by the user.
```

- A rule is a **passively auto-applied** artifact carrying `paths` and no `description` (except the
  index-natured `abstract-structure-rule.md`, which deliberately has no frontmatter and is loaded only
  by an explicit reference from CLAUDE.md). An agent is triggered by its natural-language
  `description`. `[Verified]`
- An agent does not hold criteria itself; it references the rule (SoT), docs, and output style via
  `@see`. `[Verified]` [Read: .claude/agents/app-php-symfony-reviewer.md:16-19]
- **A skill does not necessarily call an agent** — since 2026-08-08 some domains **self-verify against
  the criteria in a command body**, with no agent pair (template ② in section 4). In that case the three
  layers run rule → command → skill and the agent layer is empty. `[Verified]`

---

## 2. Agent Inventory (Role × Domain Matrix)

The current **26** agents, organized by **workflow role (rows) × technical domain (columns)**.
`[Verified]` (27 files in the `agents/` tree, minus the single orchestrator `agent-team.md`)

| Workflow role | Backend (PHP) | Frontend (JS · Twig) | Infrastructure · Data | Integration (API · Provider) | Operations · Config |
| --- | --- | --- | --- | --- | --- |
| **Analyze** (static structure · architecture) | PHP Code Analyzer | Javascript Code Analyzer · Twig Code Analyzer | — | API Platform Analyzer | — |
| **Debug** | PHP Debug Reviewer | Javascript Debug Reviewer · Twig Debug Reviewer | — | API Platform Debugger | — |
| **Review** (standalone verdict) | PHP Code Reviewer | Javascript Code Reviewer · Twig Code Reviewer | Postgresql Reviewer · Redis Reviewer · RabbitMQ Reviewer · Nginx Reviewer · GCP Cloud Run Reviewer · AWS ECS Reviewer | API Platform Reviewer | — |
| **Test** | PHP Test Writer | Javascript Test Writer · Twig Test Writer | — | API Platform Tester | — |
| **Build** (author-verify) | — | — | — | — (providers such as UPbit and KoreaInvestment self-verify against a `*-build` command, not an agent) | Drawio Diagram Author+Reviewer (Shell Script self-verifies against the `/utility-shell-script-review` command) |
| **Commit** | — | — | — | — | Git Commit Author+Reviewer |
| **Deploy** | — | — | (deploy gate: reuses the Nginx · GCP · AWS Reviewers plus the `/utility-shell-script-review` command) | — | — |

> **The Build role was introduced in this revision.** At draft time only Commit (git) had an
> author→reviewer pair; today the pattern runs across the API, provider, and config domains (section 4).
>
> **Claude Code config artifacts have not been Build-team members since 2026-08-08** — the author and
> reviewer agents were merged into the slash command `/utility-claude-code-review`, and the
> `utility-claude-code-skill` skill self-verifies against it (section 3.5).
>
> **Providers (UPbit, KoreaInvestment) have not been Build-team members since 2026-08-15** — 10 author
> and reviewer agents were merged into 5 `*-build` commands, and 5 `*-build-skill` skills self-verify
> against them (section 3.5).
>
> **Shell Script has not been a Build-team member since 2026-08-16** — the two author and reviewer
> agents were merged into the slash command `/utility-shell-script-review`, and the
> `utility-shell-script-skill` skill drafts against its `## Authoring Conventions` and then
> self-verifies against its `## Review Procedure` (section 3.5).
>
> **The Analyze role was introduced on 2026-08-01.** The previously empty `*-code-analyzer` stubs (the
> three app-domain agents for PHP, JS, and Twig) were filled in as a static-structure analysis role,
> becoming a third analysis axis distinct from Review (rule compliance) and Debug (runtime cause)
> (section 3.2).

### API Platform Sub-inventory (four-role quartet)

Since 2026-08-17 this is **the same analyzer/debugger/reviewer/tester quartet as the app domains**.
`[Verified]`

| Workflow role | Agent | Model | Tools | Output |
| --- | --- | --- | --- | --- |
| **Analyze** | `api-platform-analyzer` | opus | Read · Grep · Glob · Bash | An ADR on the structural health of the exposure layer (resource granularity · State↔Service boundary · serialization-group sprawl · N+1-prone Provider queries) |
| **Debug** | `api-platform-debugger` | opus | Read · Grep · Glob · Bash · Edit · Write · WebFetch · WebSearch | Root cause and minimal fix for a runtime failure in the exposure layer |
| **Review** | `api-platform-reviewer` | opus | Read · Grep · Glob · Bash · WebFetch · WebSearch | A `[MUST]/[SHOULD]/[CONSIDER]` PASS/REDO verdict against the SoT |
| **Test** | `api-platform-tester` | opus | Read · Grep · Glob · Bash · Edit · Write · WebFetch · WebSearch | An `ApiTestCase`-based operation × case test file, plus the `ApiResource/` and `State/` code that test requires |

- **All four are symmetrically `opus`** — this layer is where application API correctness is directly at
  stake, so it follows the "domain criticality axis" below (a lightweight model is not chosen just
  because the agent is called repeatedly). `maxTurns: 30`.
- **Debug and Test were added on 2026-08-17.** Until then both files were 10-line stubs whose
  `description` had been copied from the reviewer, giving the harness no basis to route Debug/Test
  intent. Their tools satisfy the union of the role axis (debugger and tester carry `Edit`/`Write`) and
  the domain axis (every `api-platform-*` agent carries `WebFetch`/`WebSearch` for official docs
  lookups). `[Verified]`
- **The Analyze axis was created on 2026-08-17** — the user renamed `api-platform-author` to
  `api-platform-analyzer`, and the body was converted from Build (Author) to **read-only static
  structure analysis** to match (isomorphic with `app-php-symfony-analyzer`). The structure of the
  domain logic that State delegates to (`app/src/Service/**`) remains the concern of
  `app-php-symfony-analyzer`; this agent looks at the exposure layer itself (resources, operations,
  groups, State).
- **The Build/Author axis disappeared.** The rename dissolved the author→reviewer agent pair, so no code
  domain now has an author agent (the out-of-roster `utility-git-commit-*` and
  `utility-drawio-diagram-*` pairs are the exceptions). To create or modify a resource, either
  `api-platform-tester` carries it through Green and Refactor when working test-first, or it is written
  by the `api-platform-rest-build-skill` procedure and gated by `api-platform-reviewer`.
- **`isolation: worktree` is present on the three agents that touch `app/**` sources** (analyzer,
  debugger, tester). `[Verified]` (frontmatter checked directly on 2026-08-17). It is absent from
  `api-platform-reviewer`, which only issues verdicts. The criterion is not "does it write" but **the
  agent's domain scope** — the read-only analyzer carries `worktree` too.

  > This item was corrected on 2026-08-17. Until then this document asserted, with a `[Verified]` tag,
  > that "`isolation: worktree` was removed wholesale from Author and Reviewer on 2026-08-15 and the two
  > new Debug/Test agents will not carry it either", but all three files did in fact carry
  > `isolation: worktree`. It was a stale verification claim.

### Model and Tool Distribution (re-verified)

**Important:** all 27 agents **specify `model:` explicitly; none inherits the default** (the "inherits"
description in an earlier revision was an error). The model splits between two values, `opus` and
`sonnet`. `[Verified]`

- **`opus` — 17 domain agents.** The authoring, verdict, and analysis layers of the app and API
  domains: the code/analyze/debug/test agents (12 for PHP, JS, and Twig), the four API Platform agents
  (all opus, symmetric), and `utility-drawio-diagram-author`. The single orchestrator (`agent-team`) is
  also opus and is excluded from this count (18 files carry `model: opus`).
  `[Verified]` [Bash: grep -l '^model: opus' .claude/agents/*.md]
- **`sonnet` — 9.** The six infrastructure-config reviewers (Postgresql · Redis · **RabbitMQ** · Nginx ·
  GCP · AWS), the two Git commit agents (author and reviewer), and
  `utility-drawio-diagram-reviewer`. The two Shell Script author/reviewer agents were removed on
  2026-08-16 when they were merged into a command.
  `[Verified]` [Read: .claude/agents/cache-redis-reviewer.md:4]

Tools (`tools`) are an **axis independent of the model**: **since 2026-08-15 every agent specifies a
narrow tool set and none inherits the full set.** The role sets the axis — a reviewer or analyzer that
only issues verdicts is read-only with `Read, Grep, Glob, Bash`, while a debugger performing a minimal
fix, a tester writing tests, and the author family add `Edit`/`Write`. `[Verified]`
[Read: .claude/agents/app-php-symfony-reviewer.md] [Read: .claude/agents/app-php-symfony-tester.md]

The implication of this distribution differs from the draft's "loop vs. standalone" hypothesis — the
actual convention is a **domain-criticality and complexity axis**: layers where application-code
correctness is directly at stake (authoring, verdicts, and analysis for app, API, and provider) are
fixed at **`opus`**, while infrastructure-config reviews and meta/config tooling (config, git, shell,
diagram review) are fixed at **`sonnet`**. A provider's author-verify loop is therefore opus too (being
called repeatedly does not make it lightweight), while an infrastructure reviewer issues a standalone
verdict yet runs on sonnet.

---

## 3. Team Definitions (by workflow role)

Each team is defined in ADR style (Context / Decision / Consequences). The composition axis is the
**workflow role**, and domain agents are reused across several teams.

### 3.1 Review Team

#### Context

Compares the quality of changed files against the domain criteria (SoT) and reports findings at
MUST/SHOULD/CONSIDER severity. Ten standalone-verdict reviewers exist today, but no routing rule
documents which reviewer to call when.

#### Decision

- **Members:** PHP Code Reviewer, Javascript Code Reviewer, Twig Code Reviewer, Postgresql Reviewer,
  Redis Reviewer, RabbitMQ Reviewer, Nginx Reviewer, GCP Cloud Run Reviewer, AWS ECS Reviewer,
  API Platform Reviewer.
- **Trigger:** after a code change (the global CLAUDE.md `Agent usage rules` convention, "after a code
  change → run code-reviewer automatically").
- **Routing basis:** match the changed file path against each rule's `paths` glob to select the
  responsible reviewer. The rule paths in the table below reflect the current rule tree. `[Verified]`

  | Changed-path pattern | Responsible reviewer | Basis rule (paths) |
  | --- | --- | --- |
  | `app/src/**/*.php` | PHP Code Reviewer | `app-php-symfony-00~15-*-rule.md` |
  | `app/src/{Entity,Repository}/**/*.php` | Postgresql Reviewer | `database-postgresql-rule.md` |
  | `app/assets/**/*.js` | Javascript Code Reviewer | `app-javascript-stimulus-00~03-*-rule.md` |
  | `app/templates/**/*.twig` | Twig Code Reviewer | `app-twig-symfony-00-overview-rule.md` |
  | `app/src/{ApiResource,State}/**/*.php` | API Platform Reviewer | `api-platform-rule.md` |
  | `app/src/**/API/**/*.php` (provider integration) | (no agent — the per-provider `*-build-skill`) | `api/providers/finance/**/api-*-rule.md` |
  | `app/config/packages/cache.yaml`, `app/src/**/*.php` | Redis Reviewer | `cache-redis-rule.md` |
  | `app/src/Message*/**/*.php`, `app/config/packages/messenger.yaml` | RabbitMQ Reviewer | `message-rabbitmq-rule.md` |
  | `scripts/**/nginx/**` | Nginx Reviewer | `server-nginx-rule.md` |
  | `scripts/containers/prod/**`, `**/*.tf`, `**/cloudbuild.yaml`, `**/Dockerfile` | GCP Cloud Run Reviewer | `tools-gcp-cloudrun-rule.md` |
  | (AWS ECS deploy assets) | AWS ECS Reviewer | `tools-aws-ecs-rule.md` |
  | `scripts/**/*.sh`, `scripts/**/entrypoint.sh` | (no agent — the `/utility-shell-script-review` command) | `utility-shell-script-rule.md` |
  | `diagram/**/*.drawio` | (no standalone reviewer agent — the `/utility-drawio-diagram-review` command) | `utility-drawio-diagram-rule.md` |

- **Input/output:** input = changed file paths + the rule (SoT). Output = a severity-classified report
  (only `[MUST]` blocks a merge). `[Verified]` [Read: .claude/agents/app-php-symfony-reviewer.md] —
  "only `[MUST]` blocks a merge".

#### Consequences

- (+) Per-domain verdicts always track the latest rule (SoT), because a reviewer holds no criteria itself.
- (−) One file can span several reviewers. In particular, **the Redis rule's paths is as broad as
  `app/src/**/*.php`**, so effectively every PHP change matches PHP, Redis, and (for an Entity)
  Postgresql simultaneously. The orchestrator must manage a **duplicate-finding merge rule**. See
  section 6, items #5 and #8.

### 3.2 Analyze Team (new)

#### Context

Statically assesses the **structural health** of code. Where the Review team asks "does the code follow
the rules?" (a standalone verdict) and the Debug team asks "why doesn't it work?" (runtime cause), the
Analyze team asks **"is the structure healthy?"** (layer boundaries, dependency direction, cohesion,
complexity, refactoring opportunities) — three analysis axes with distinct purposes. At draft time the
`*-code-analyzer` agents were empty stubs whose description duplicated the debugger's; their bodies were
written as a static-structure analysis role on 2026-08-01. `[Verified]`

#### Decision

- **Members:** PHP Code Analyzer (layer-boundary violations · circular dependencies · God Services ·
  MessageBus coupling · structural N+1), Javascript Code Analyzer (controller single responsibility ·
  outlet coupling · DOM access bypassing targets · the importmap dependency graph), Twig Code Analyzer
  (inheritance depth · partial and macro reuse · logic-presentation separation · componentization
  opportunities). All `opus`. `[Verified]`
- **Trigger:** when structural improvement, refactoring, or an architecture check is needed — not a
  specific bug. Natural-language requests ("is the structure OK", "room to refactor", "clean up the
  dependencies").
- **Output:** using the active output style's "Architecture Design & Analysis" section as the SoT — an
  ADR (Context/Decision/Consequences) plus the three trade-off axes (scalability · maintainability ·
  performance) plus dependency-direction arrows (`→`) plus a pattern proposal that includes an
  alternative. `[Verified]` [Read: .claude/agents/app-php-symfony-analyzer.md]
- **Role boundary (handoff):** `Analyze (diagnose · propose) → Review (quality gate) → Test (regression
  prevention)`, and `Analyze → Debug` when a runtime failure is discovered.

#### Consequences

- (+) Refactoring judgment (structure) is separated from rule verdicts (quality) and cause tracing
  (runtime), so each agent prompt has a single focus.
- (−) The infrastructure and integration domains (nginx/gcp/aws/redis/api/provider) have no dedicated
  Analyze agent — only the three app agents (PHP, JS, Twig) exist. Structural checks in those domains
  are handled by the domain Reviewer as a secondary duty.

### 3.3 Debug Team

#### Context

Traces the **root cause** of a bug. Where the Review team asks "does the code follow the rules?", the
Debug team asks "why doesn't it work?" — distinct purposes.

#### Decision

- **Members:** PHP Debug Reviewer (handler not running, N+1 and detached entities, migration mismatch,
  transport routing, locking and idempotency, DI miswiring), Javascript Debug Reviewer (controller not
  registered, target mismatch, Turbo update failure, memory leaks, importmap resolution failure), Twig
  Debug Reviewer (undefined variable, double or missing escaping, block not inherited, include/macro
  path error, form theme not applied), and **API Platform Debugger** (property not exposed due to a
  serialization-group ↔ context mismatch, 404 from an undeclared operation, validation returning 500
  instead of 422, `security:` ↔ `securityPostDenormalize:` confusion, State unwired or not delegating,
  filter ignored). `[Verified]`
- **Trigger:** on a bug reproduction or symptom report. Natural-language requests ("why doesn't this
  work", "the handler isn't running").
- **Boundary with the Analyze and Review teams (handoff):** `Debug (cause · fix) → Review (quality) →
  (if needed) Test (regression prevention)`. When the cause is a structural defect, hand off
  `Debug → Analyze` to design the refactoring (separating runtime cause from structural health).

#### Consequences

- (+) Separating diagnosis from quality verdicts sharpens each agent's prompt focus.
- (−) The infrastructure and integration domains (nginx/gcp/aws/redis/provider) have no dedicated Debug
  agent — those bugs are handled by the domain Reviewer as a secondary duty, or diagnosed procedurally
  via the provider's test skill. See section 6.
  **API Platform left this gap on 2026-08-17 with the addition of `api-platform-debugger`.**

### 3.4 Test Team

#### Context

Writes tests that prevent regressions in changed code. The testing rule (SoT) must be observed without
exception.

#### Decision

- **Members:** PHP Test Writer (PHPUnit Unit/Integration/Functional), Javascript Test Writer and Twig
  Test Writer (Symfony Functional / WebTestCase, `lint:twig`), and **API Platform Tester** (an
  operation × case matrix based on `ApiPlatform\Symfony\Bundle\Test\ApiTestCase`). `[Verified]`
- **Mandatory constraints** (`app-php-symfony-09-testing-rule.md` SoT):
  - Unit tests must not touch the filesystem, DB, cache, or network.
  - Integration tests use **real PostgreSQL/Redis instances** — mocking the DB or Redis is forbidden.
  - Functional tests verify the HTTP response, redirects, and rendered HTML; directly verifying internal
    service state is forbidden.
  `[Verified]` [Read: .claude/rules/app-php-symfony-09-testing-rule.md]
- **Trigger:** after writing a new class, or on a request for regression prevention following a Debug
  team fix.

#### Consequences

- (+) The test-layer boundaries (Unit/Integration/Functional) are enforced by the rule
  (`09-testing-rule.md`).
- (−) Infrastructure config (nginx/gcp/aws/shell) has no corresponding Test Writer — that layer relies
  on manual verification. When `api-platform-tester` was added on 2026-08-17, API Platform briefly had a
  dual system of **command (canonical procedure) + agent (file authoring)**; the `/api-platform-test`
  command was deleted the same day, consolidating it into **sole agent ownership** — the per-operation
  case procedure is now canonically the `## Operation × case matrix` section of
  `agents/api-platform-tester.md`. This matches the three app-domain testers, which have no
  corresponding command.

### 3.5 Build Team (new)

#### Context

**Creates** API, provider, and config code and **verifies** it immediately with a dedicated reviewer. A
role that did not exist at draft time, it now accounts for most of the repository's orchestration.

In the API Platform domain in particular, anti-patterns such as **exposing an Entity directly,
hand-implementing filters, and assembling custom errors** must be blocked by the rule (SoT
`api-platform-rule.md`), which is the rationale for attaching a dedicated reviewer immediately after
generation.

#### Decision

- **Members (author→reviewer pairs):** Drawio Diagram (Author + Reviewer). `[Verified]`
- **API Platform routing:** changed paths `app/src/ApiResource/**` and `app/src/State/**` → the Build
  loop. Config changes (`config/packages/api_platform.yaml`, `config/routes/api_platform.yaml`) are
  handled by a **reviewer-only comparison**, skipping the unnecessary generation step. `[Verified]`
- **API Platform canonical owner:** the `api-platform-rest-build-skill` and
  `api-platform-oauth2-build-skill` build skills; the `agent-team` orchestrator can also run the same
  loop directly. `[Verified]`
- **Orchestrator:** each domain's orchestrator skill (such as `*-build-skill`) calls the author to
  produce a draft, and the reviewer issues a PASS/REDO verdict (the verification loop in section 4).
  `[Verified]`
- **Exception ① (agent-free variant — meta and config):** since 2026-08-08, Claude Code config
  artifacts have had **the slash command `/utility-claude-code-review` hold the judgment criteria**
  instead of author and reviewer agents, and the `utility-claude-code-skill` skill drafts, self-verifies
  against those criteria, and writes (the max-2-retry contract is unchanged). `[Verified]`
  [Read: .claude/commands/utility-claude-code-review.md]
- **Exception ② (agent-free variant — providers):** UPbit REST/WebSocket and KoreaInvestment
  OAuth2/REST/WebSocket have taken the same shape since 2026-08-15 — the **`*-build` commands under
  `commands/api/providers/**` hold the authoring conventions, verification checklist, and known gaps**,
  and 5 corresponding `*-build-skill` skills run a generate → self-verify loop (max 3 retries and the
  PHPStan gate as before). `[Verified]`
  [Read: .claude/commands/api/providers/finance/digitalasset/upbit/api-rest-build.md]
- **Exception ③ (agent-free variant — shell scripts):** `scripts/**` Bash scripts have taken the same
  shape since 2026-08-16 — the **slash command `/utility-shell-script-review` holds both the authoring
  conventions (mode B) and the judgment criteria**, and the `utility-shell-script-skill` skill drafts,
  self-verifies against those criteria, and writes (max 2 retries). `[Verified]`
  [Read: .claude/commands/utility-shell-script-review.md]
- **Model:** follows the domain-criticality axis (section 2) — the Drawio pair splits across it, with
  `utility-drawio-diagram-author` on `opus` (it composes XML whose structural correctness is at stake)
  and `utility-drawio-diagram-reviewer` on `sonnet` (a checklist-driven verdict). The utility config
  build (Shell Script) that used `sonnet` was merged into a command on 2026-08-16. Tool sets are
  narrowly specified for every author-family agent (Bash, Read, Write, and so on). `[Verified]`

#### Consequences

- (+) Generation and verification are closed inside a single skill, so retry and artifact management
  stay consistent.
- (−) Each domain must maintain three artifacts (author, reviewer, skill), so the file count grows fast.
- (+) The command variant, which gathers the judgment criteria into one file, reduces artifact count
  (3 → 2) and drift, but because verification runs in the main session context it **loses the isolation
  of an independent subagent** — adopt it only for meta/config domains where the criteria converge on a
  single document.
- (−) When one change spans State domain logic, a Doctrine Entity, and security, it can match
  cross-domain reviewers redundantly (see the boundary table below) — the orchestrator delegates and
  merges.

#### API Platform Cross-Domain Boundaries (outside api — delegated)

| Spanning concern | Delegate | Basis |
| --- | --- | --- |
| Structure of the domain logic State delegates to | `app-php-symfony-reviewer` (`app/src/Service/**`) | `app-php-symfony-*-rule.md` |
| DTO `stateOptions` (Entity reuse) · N+1 · migrations | `database-postgresql-reviewer` | `database-postgresql-rule.md` |
| operation `security:` · Voters · `stateless` tokens · rate limiter | (rule comparison) | `app-php-symfony-08-security-rule.md` |
| Regression-prevention tests | `api-platform-tester` (owns both the canonical procedure and file authoring). Only the domain-service and Doctrine layers go to `app-php-symfony-tester` | `api-platform-rule.md` · `app-php-symfony-09-testing-rule.md` |
| Runtime failure diagnosis | `api-platform-debugger`. If the cause is in a service, Doctrine, or Messenger that State delegated to, `app-php-symfony-debugger` | `api-platform-rule.md` |
| Commit / Deploy | `utility-git-commit-skill` / `tools-app-deploy-skill` | Sections 3.6 and 7 |

### 3.6 Commit and Deploy Teams

#### Context

Commits and deploys a change. Commit holds a **completed orchestration standard**
(`utility-git-commit-skill`); the Deploy gate is defined here for the first time.

#### Decision

- **Commit sub-team (implemented · reference standard):** the `utility-git-commit-skill` skill acts as
  orchestrator, calling `Git Commit Author` → `Git Commit Reviewer` in sequence, running
  `git commit -F` on PASS and retrying up to 2 times on REDO. `[Verified]`
  [Read: .claude/skills/utility-git-commit-skill/SKILL.md]
- **Deploy sub-team (proposed):** **reuse** the domain reviewers as a pre-deploy security and config gate.
  - Nginx Reviewer → server config (security headers · TTLs · FastCGI).
  - GCP Cloud Run Reviewer / AWS ECS Reviewer → runtime · secrets · least-privilege IAM.
  - The `/utility-shell-script-review` command → deploy-script safety (`rm -rf` guards and so on).
  - This aligns with the global CLAUDE.md `Agent usage rules` conventions, "before deploy → run
    security-auditor" and "before a destructive operation → get user approval".

#### Consequences

- (+) The Commit flow reuses an already-proven pattern (no rework needed).
- (+) The Deploy gate was created on 2026-07-23 as the `tools-app-deploy-skill` skill — after fanning
  out to the domain reviewers, it hands the actual deploy off to `tools-gcp-cloudrun-skill` /
  `tools-aws-ecs-skill` (section 7).
- (!) `git push` is set to `ask` in `settings.json`, so it always goes through user confirmation.
  `[Verified]` [Read: .claude/settings.json]

---

## 4. Orchestration Reference Patterns

`utility-git-commit-skill` generalized into a **reusable team orchestration template**. Since the draft
this pattern has already spread to many build and orchestrator skills and become the de facto repository
standard. `[Verified]`

### Verification Loop Template ① — author→reviewer pattern (agent pair)

```text
Skill (orchestrator)
  ├─ 1. Precondition check (e.g. git diff --cached --quiet)
  ├─ 2. Call the Author agent   → ./.claude/tmp/<task>-draft.md
  ├─ 3. Call the Reviewer agent → ./.claude/tmp/<task>-review.md (PASS/REDO)
  ├─ 4. Branch on the verdict
  │      PASS → run the final action
  │      REDO → include the review instructions when re-calling the Author, repeat from step 2
  └─ 5. On exceeding the retry limit (max 2) → stop automatic execution + recommend manual review
```

**Current example — the API Platform build→review loop** (the retry limit is 3, as a code domain). Since
the author agent disappeared on 2026-08-17, step 2 **branches by intent**:

```text
Skill / orchestrator
  ├─ 1. Fix the scope (changed ApiResource/State files · intent)
  ├─ 2. Choose the entry point
  │      Test-first → call api-platform-tester (runs Red→Green→Refactor itself)
  │      Otherwise  → write via the api-platform-rest-build-skill / -oauth2-build-skill procedure
  ├─ 3. Call api-platform-reviewer → ./.claude/tmp/api/api-platform-<variant>-review.md (PASS/REDO)
  ├─ 4. Branch on the verdict
  │      PASS → point at the static gates (phpstan, php-cs-fixer) and, if it was not test-first,
  │             recommend regression coverage via api-platform-tester
  │      REDO → carry the review instructions and re-call **the same entry point as step 2**, repeat from step 2
  └─ 5. On exceeding the retry limit (max 3) → stop with the source preserved + recommend manual review
```

- Intermediate artifacts are exchanged as files under `./.claude/tmp/` (gitignored); the variant is
  `rest` or `oauth2`.
- Secret values (tokens, credentials) never appear in any artifact or output.

- Intermediate artifacts are exchanged as files under `./.claude/tmp/` (gitignored). `[Verified]`
  [Read: .claude/skills/utility-git-commit-skill/SKILL.md]
- This pattern transplants to **any team with a "author → verify → verdict" structure**, such as the
  Deploy gate or a large-scale review consolidation. The teams that keep this shape as an **agent pair**
  today are Commit (Git) and Diagram (draw.io). `[Verified]`

### Verification Loop Template ② — command-based self-verification (no agent pair)

A domain whose judgment criteria converge on one file (a slash command) keeps no author or reviewer
agents and instead **generates and self-verifies within the same session**. Started with the Claude Code
config domain on 2026-08-08 and expanded to the 5 provider domains on 2026-08-15, **this is now the
majority shape** by artifact count. `[Verified]`

```text
Skill (orchestrator)
  ├─ 1. Precondition check (if the target is unclear, ask once and stop)
  ├─ 2. Generate    — edit (or draft) per the command's `## Authoring Conventions`
  ├─ 3. Self-verify — compare against the same command's `## Verification Checklist` → ./.claude/tmp/<task>-review.md
  ├─ 4. Branch      PASS → final action / REDO → apply only the instructions, repeat from step 2
  └─ 5. On exceeding the retry limit → stop + recommend manual review
```

| Aspect | ① Agent pair | ② Command self-verification |
| --- | --- | --- |
| Artifact count | 3 (author · reviewer · skill) | 2 (command · skill) |
| Location of judgment criteria | The reviewer body (authoring conventions scattered into the author) | One place, the command body |
| Verification isolation | An independent subagent context | The main session context (no isolation) |
| Retry limit | 2 (config) · 3 (code) | Same |
| Adopted by | Commit (Git), Diagram (draw.io) | Claude Code config, the 5 providers, Shell Script |

**Selection criterion:** use ② when the judgment criteria converge on a single document and drift is the
main risk; use ① when the output is large and the verifier's **independent context** (a view
uncontaminated by the generation process) is needed. `[Inferred]`

### Alternative Comparison: Orchestrator Skill vs. Direct Routing by the Main Agent

| Approach | Pros | Cons | Selection criterion |
| --- | --- | --- | --- |
| **Orchestrator skill** (the build/commit approach) | Explicitly controls retries, artifact management, and the verdict loop | Requires creating and maintaining a skill file | Teams needing multiple stages, retries, or a gate (Build, Commit, Deploy) |
| **Direct routing by the main agent** | No new file needed; works immediately via `paths` matching | Retry and consolidated-report logic is improvised each time | A one-off single review (one Review · Analyze · Debug · Test) |

**Recommendation:** direct routing is sufficient for Review/Analyze/Debug/Test, while Build, Commit, and
Deploy already have orchestrator skills (the Deploy gate was created on 2026-07-23, section 7). Note
that the Deploy gate is not an author→reviewer loop but a **multi-reviewer fan-out** variant.
`[Inferred]` — the real operational load needs re-examination after adoption.

---

## 5. Trade-offs (adopting the workflow-role axis)

A three-axis analysis of the decision to compose teams along the **workflow-role axis** rather than the
**domain axis**.

- **Scalability:** when a new technical domain is added (a new provider, say), the role teams
  (Review/Analyze/Debug/Test/Build) stay as they are and only the domain agent joins the relevant team.
  Since the draft, the Twig, provider, config, and diagram domains have been added while the role axis
  stayed stable (only the domain agents joined), and the Analyze role added on 2026-08-01 took the role
  axis from 6 to 7. `[Verified]`
- **Maintainability:** per role, each agent prompt has a single focus, keeping cognitive load low (a
  reviewer only judges, a debugger only finds causes, an author only generates). However, one domain
  agent belongs to several teams, making membership **1:N** and requiring the mapping table in
  section 2 to be maintained.
- **Performance:** a role team calls only the agents it needs, avoiding spinning up unnecessary domain
  reviewers. The opposite risk is duplicate calls when one file matches many rules in the Review team
  (particularly the broad Redis paths) — mitigated by the orchestrator's merge logic (section 6).

**Comparison with the domain axis:** a domain axis (a "Backend team" handling review, debug, and test
together) has high domain cohesion, but mixing roles bloats the prompt and forces every domain to define
the roles redundantly. The repository already separates four roles (code/analyze/debug/test) for PHP,
JS, and Twig, so **the role axis is more consistent with the existing structure**. `[Verified]`
(the 12 `agents/app-*` files = 3 domains × 4 roles. The orchestrator dropped its `app-*` prefix in the
2026-08-16 merge and became `agent-team`)

### 5.1 API Platform — From Build Consolidation to a Four-Role Quartet

The API Platform domain's initial roster was a single author→reviewer pair, so rather than replicating
the multi-role axis (Analyze/Debug/Test) it **consolidated into one Build verification loop**. Below is
the three-axis analysis behind that original decision; two subsequent revisions dissolved every premise
of the consolidation.

> **Revision 1 (2026-08-17):** the Debug and Test axes were added as `api-platform-debugger` and
> `api-platform-tester`. The premise of the consolidation decision — delegating to the app domain
> without dedicated agents — did not actually hold: diagnostic and testing knowledge such as
> serialization-group ↔ context mismatch, undeclared operations, the semantic difference between
> `security:` and `securityPostDenormalize:`, and `ApiTestCase` (≠ `WebTestCase`) / `findIriBy` does not
> overlap the SoT of `app-php-symfony-*` (Doctrine, Messenger, WebTestCase), so the delegate had no
> basis on which to judge. At that point **the Analyze axis was not added** — structural analysis was
> considered to target the domain logic State delegates to, and thus to overlap the SoT of
> `app-php-symfony-analyzer`.
>
> **Revision 2 (2026-08-17, the same day):** the user renamed `agents/api-platform-author.md` to
> `agents/api-platform-analyzer.md` (with the paired `agent-memory/` move), deleted
> `commands/api-platform-test.md`, and instructed that the api domain be brought into agreement with
> the rename. Two results followed.
>
> 1. **The Analyze axis was created** — reversing revision 1's judgment. The delegation premise did not
>    hold here either: what `app-php-symfony-analyzer` looks at is layer boundaries, the DI graph, and
>    Messenger coupling, whereas the exposure layer's structural debt (resource granularity,
>    serialization-group sprawl, hand-duplicated State instead of `stateOptions` reuse, the shape of a
>    Provider query relative to the relations a group embeds) is absent from that SoT. A dedicated lens
>    was needed, not a secondary duty.
> 2. **The Build/Author axis disappeared** — the author→reviewer agent pair dissolved, and no code
>    domain now has an author agent. TDD Green and Refactor are performed directly by
>    `api-platform-tester`, making it isomorphic with the three `app-*-tester` agents, and other
>    generation is handled by a build skill plus the reviewer gate. The deleted command's per-operation
>    case procedure was absorbed into the `api-platform-tester` body.
>
> The three-axis analysis below is therefore **a record of the rationale for that consolidation
> decision**, not a description of the current structure. For the current structure see the
> `### API Platform Sub-inventory (four-role quartet)` section.

- **Scalability:** the agent count is invariant as resources and operations grow — since the criteria
  live in the rule (SoT), the rule is extended without touching a prompt.
- **Maintainability:** generation, verdicts, diagnosis, and testing each have a single focus, keeping
  cognitive load low. Only structural analysis lacked a dedicated api agent and was delegated to the app
  domain (`app-php-symfony-analyzer`).
- **Performance:** a one-off review spawns only the reviewer, skipping the unnecessary generation step.
  Conversely, multiple matches across domains (the boundary table in section 3.5) create duplicate
  review load, which the orchestrator mitigates by merging and delegating.

---

## 6. Current Gaps and Follow-ups

The items below were confirmed during exploration and are kept as a **diagnostic record** (this document
is a design document, so they are not fixed directly here). Each is recommended for follow-up work.

| # | Finding | Basis | Status · recommendation |
| --- | --- | --- | --- |
| 1 | ~~`git-commit-reviewer`'s name reads `Git Commit Reviewr` (typo)~~ | agents/utility-git-commit-reviewer.md | ✅ **Resolved** — the current name is `utility-git-commit-reviewer` and the file is `agents/utility-git-commit-reviewer.md` |
| 2 | ~~`paths` mismatch in the shared rule `api/rest-client-rule.md`~~ | — | ⛔ **Withdrawn** — that rule file no longer exists. Provider integration rules were split into `api/providers/finance/**/api-*-rule.md` |
| 3 | ~~No dedicated agents for providers (UPbit/KoreaInvestment)~~ | commands/api/providers/finance/** | ✅ **Resolved, then reshaped** — 10 author and reviewer agents were created, then merged into 5 `*-build` commands on 2026-08-15. Generation and verification in the provider domain is handled by the build skills' self-verification loop |
| 4 | ~~No domain rule (SoT) for shell and git~~ | the rules/ tree | ✅ **Resolved** — the shell rule (`utility-shell-script-rule.md`, `paths: scripts/**/*.sh`) and the git rule (`utility-git-commit-rule.md`) were created |
| 5 | `05-doctrine-rule.md` and `database-postgresql-rule.md` apply redundantly to **identical paths** (`Entity`, `Repository`) | the two rules' frontmatter `[Verified]` | ⚠️ **Open** — a Review-team merge rule (removing duplicate findings) needs defining |
| 6 | ~~`server/nginx-rule.md` and `abstract-structure-rule.md` lack frontmatter~~ | rules/server-nginx-rule.md | ✅ **Resolved** — nginx has `paths: scripts/**/nginx/**`. The structure rule is an index and deliberately carries no frontmatter |
| 7 | ~~The api/cache/database/server/utility entries under `docs/` are empty `.gitkeep` files~~ | the docs/ tree `[Verified]` | ⚠️ **Partially resolved** — the flat single tier is populated with per-domain `-docs.md` files (`api-platform-docs.md`, `cache-redis-docs.md`, `database-postgresql-docs.md`, `server-nginx-docs.md`, `utility-shell-script-docs.md`, and so on). **`utility-claude-code-docs.md` and `utility-git-commit-docs.md` are still 0 bytes** — deliberate placeholders tracked in `TODO.md`, per `## Docs Layout` in `utility-claude-code-rule.md`. An earlier revision claimed both were complete (191 and 93 lines); that was an error |
| 8 | `cache-redis-rule.md`'s `paths` is as **broad** as `app/src/**/*.php` → the Redis Reviewer matches every PHP change | the rule frontmatter `[Verified]` | ⚠️ **Open** — narrowing the Redis paths needs review (together with #5, to refine Review-team merging and routing) |
| 9 | ~~API Platform is asymmetric with providers at Author=sonnet / Reviewer=inherited~~ | agent frontmatter `[Verified]` | ⛔ **Withdrawn (error corrected)** — measured, the API Platform agents are **all symmetrically opus**, as are the providers. The model policy is consistent along the "domain criticality axis" (restated in section 2) |
| 10 | The `utility-drawio-diagram-*` agents cite `agent-team-docs.md` as their **design SoT**, but this document defines no Diagram team | agents/utility-drawio-diagram-author.md · -reviewer.md | ⚠️ **Open** — on 2026-08-20 the agents' references were downgraded to point at the section 4 template ① instead. A full Diagram team section (3.7) in the ADR shape of the other teams is still unwritten |

---

## 7. Next Steps (reference during implementation)

Review/Analyze/Debug/Test work via direct routing, and Build/Commit already work via the existing
skills. The last remaining gap, the **Deploy gate**, was created on 2026-07-23. `[Verified]`

```text
.claude/skills/tools-app-deploy-skill/SKILL.md   ← Deploy gate orchestrator (created)
```

- `tools-app-deploy-skill` is not a single author→reviewer loop but a gate that **fans the changed
  deploy assets out to the domain reviewers (Nginx, GCP Cloud Run, AWS ECS) and the
  `/utility-shell-script-review` command**, collects the MUST/SHOULD/CONSIDER findings, and issues a
  go/no-go (PASS/BLOCK) verdict. On PASS it hands the actual deploy off to `tools-gcp-cloudrun-skill` /
  `tools-aws-ecs-skill`; the gate itself never performs a deploy or a rollback.
- BLOCK (one or more MUSTs) → fix and re-run, up to 2 times. Intermediate artifacts go under
  `./.claude/tmp/` (gitignored).
- The remaining improvement items are section 6 #5 (merge the duplicate doctrine ↔ postgresql rules),
  #8 (narrow the Redis paths), and #10 (write the Diagram team section).

---

## Appendix: Reference Assets

| Asset | Path | Role |
| --- | --- | --- |
| Orchestrator | `.claude/agents/agent-team.md` | The repository's single routing and handoff executor |
| Orchestration standard | `.claude/skills/utility-git-commit-skill/SKILL.md` | The verification-loop reference pattern |
| Agent body pattern | `.claude/agents/app-php-symfony-reviewer.md` | Role · SoT reference · quality-gate structure |
| Rule index | `.claude/rules/abstract-structure-rule.md` | The domain-rule SoT index |
| API Platform rule | `.claude/rules/api-platform-rule.md` | Resource · State · security judgment SoT |
| API Platform procedure | `.claude/docs/api-platform-docs.md` | Step-by-step resource-addition guide |
| Output style | `.claude/output-styles/abstract-english-style.md` | ADR · trade-off · citation format |
| Team feature enabled | `.claude/settings.json:12` | `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` |
