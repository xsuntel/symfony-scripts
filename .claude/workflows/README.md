# `.claude/workflows` — Workflow Playbooks (Draft)

> Status: **Draft** — defines this directory's purpose and conventions, and documents the
> repository's actual workflows as playbooks that people and Claude can reference. Written: 2026-07-24.
>
> ⚠️ **Scope note:** this directory is **not an official Claude Code auto-loaded artifact** (see §0).
> The files here are reference documents; they do not trigger or run on their own.

@see .claude/docs/app/agent/multi-team-docs.md — workflow-role team design (SoT, background & rationale)
@see .claude/agents/app/agent/multi-team.md — app-domain orchestrator agent (routing counterpart of the draft)
@see .claude/rules/structure-rule.md — rule index
@see .claude/skills/utility/git/commit-message-helper/SKILL.md — orchestration reference standard

---

## 0. Key fact — this directory is not an official feature

The extension artifacts Claude Code **auto-loads and triggers** are only: skills, hooks, MCP,
subagents, and plugins. **A file-based `workflow` artifact does not exist.** `[Verified]`
[WebFetch: https://code.claude.com/docs/en/common-workflows]

- `.claude/workflows/` is a **custom placeholder directory** created by this repository. It has no
  `paths` matching and no natural-language `description` trigger, so documents placed here are not
  auto-applied the way rules and skills are. When you need a real trigger, build a skill
  (`.claude/skills/`) or a subagent (`.claude/agents/`).
- In the official docs, "workflow" refers to two different things (§1). Neither requires a
  `.claude/workflows/` folder.

> On that premise, this document designates `.claude/workflows/` as a directory dedicated to
> **workflow playbooks (reference documents for people and Claude)** (see the §5 conventions).
>
> Two other repository-specific directories are custom in the same way and are not auto-loaded:
> `.claude/agent-memory/` (per-agent project memory, `agent-memory/<domain>/<agent>/MEMORY.md`,
> consumed by agents whose frontmatter sets `memory: project`) and this `.claude/workflows/`.

---

## 1. The two official "workflows" (reference)

### 1.1 Dynamic Workflows (runtime orchestration)

Claude takes a request, **dynamically writes an orchestration script**, and a separate runtime runs
it in the background — distributing and verifying the work across **tens to hundreds of parallel
subagents** before returning the result. `[Verified]`
[WebFetch: https://claude.com/blog/introducing-dynamic-workflows-in-claude-code]

- **Trigger:** ask directly ("Create a workflow"), or turn on the `ultracode` setting (raises effort
  to `xhigh` and lets Claude decide when to use a workflow). `[Verified]`
- **Availability:** generally available (GA) on Pro/Max/Team/Enterprise plans and the Claude API
  (as well as Bedrock, Vertex AI, and Foundry). `[Verified]`
- **Key point:** it is a **runtime script**, not a file — it is not defined by placing a file in this directory.
- The exact command/label of the in-progress monitoring UI (e.g. a `/workflows` view) may vary by
  version. `[Uncertain]` — confirm with `/help` or the official docs before use.

### 1.2 Common Workflows (everyday development recipes)

The official docs' "Common workflows" covers **prompt recipes** for code exploration, bug fixing,
refactoring, testing, PRs, and documentation, plus subagent delegation, parallel git-worktree
sessions, plan mode, and scheduled runs (routines, `/loop`, GitHub Actions). `[Verified]`
[WebFetch: https://code.claude.com/docs/en/common-workflows]

---

## 2. This repository's workflows = already implemented as skills + subagents

This repository realizes "workflows" as a 3-layer structure where an **orchestrator skill (entry
point)** calls **subagents (executors)** that reference the **rules (judgment SoT)**. The design
background's SoT is `docs/app/agent/multi-team-docs.md`.

```text
skills/       = orchestrator / entry point — calls agents sequentially or fans out, consolidates artifacts
agents/       = executor — loads rules/docs/output-style via Read to perform the work
rules/        = single source of truth (SoT) for judgment — auto-applied via a paths glob
```

Two execution shapes are standard. `[Verified]` (multi-team-docs §4)

| Shape | When | Example entry point |
|---|---|---|
| **Orchestrator skill** (author→reviewer verification loop, up to 2 retries) | Multi-stage / gate / retry needed | `commit-message-helper`, `*-build`, `code-config-helper`, `deploy-gate-helper` |
| **Direct routing** (select the responsible reviewer by changed `paths`) | One-off single review / debug / test | domain agents such as `php-code-reviewer` |

> The app domain also has a dedicated **orchestrator agent**, `app-multi-team`, that performs the
> direct-routing dispatch for the 12 app/base agents (PHP·JS·Twig × Analyze·Debug·Review·Test) —
> classifying by domain × role, fanning out, and consolidating findings (§3.1–3.3).

---

## 3. Workflow playbooks

Below is a playbook summarizing the repository's 6 workflow roles as **trigger → entry point →
procedure → output**. The detailed team definitions, trade-offs, and routing tables have their SoT in
`docs/app/agent/multi-team-docs.md` §3. `[Verified]`

### 3.1 Review — quality judgment after a code change
- **Trigger:** after a code change (the global CLAUDE.md convention "after a code change → code-reviewer").
- **Entry point:** select the responsible reviewer by changed `paths` (direct routing). e.g.
  `app/src/**/*.php` → PHP Code Reviewer, `app/templates/**/*.twig` → Twig Code Reviewer,
  `app/src/{Entity,Repository}/**` → Postgresql Reviewer. For app-domain changes, the `app-multi-team`
  agent can route this automatically.
- **Output:** a `[MUST]`/`[SHOULD]`/`[CONSIDER]` severity report — only `[MUST]` blocks the merge. `[Verified]`

### 3.2 Debug — trace a bug's root cause
- **Trigger:** symptom report / natural-language request ("why doesn't it work").
- **Entry point:** `php-code-debugger` / `javascript-code-debugger` / `twig-code-debugger`.
- **Hand-off:** `Debug (cause & fix) → Review (quality) → (if needed) Test (regression prevention)`.

### 3.3 Test — write regression-prevention tests
- **Trigger:** after writing a new class, or after a Debug fix.
- **Entry point:** `php-code-tester` / `javascript-code-tester` / `twig-code-tester`.
- **Mandatory:** `rules/app/base/php-symfony/09-testing-rule.md` (Unit/Integration/Functional boundaries). `[Verified]`

### 3.4 Build — generate then immediately verify (author→reviewer)
- **Trigger:** request to generate API / provider / config code.
- **Entry point:** a `*-build`/`*-helper` skill → author draft (`./.claude/tmp/*-draft.md`) → reviewer
  PASS/REDO (`*-review.md`) → record on PASS, re-invoke on REDO (up to 2 retries). `[Verified]`
- **Targets:** API Platform, Claude Code, Shell Script. (The draft's design SoT also lists provider
  builds — UPbit REST·WS, KoreaInvestment OAuth2·REST·WS — which are not yet present as agents in
  this tree.)

### 3.5 Commit — generate & verify a commit message (reference standard)
- **Trigger:** a commit request (`git diff --cached` present).
- **Entry point:** `commit-message-helper` → `git-commit-message-author` → `git-commit-message-reviewer`
  → `git commit -F` on PASS, up to 2 REDO retries. `[Verified]`

### 3.6 Deploy — pre-deploy security/config gate
- **Trigger:** after changing deployment assets (`scripts/containers/prod/**`, `**/*.tf`, `**/Dockerfile`, etc.), just before deploy.
- **Entry point:** `deploy-gate-helper` — **fans out** the deployment assets to the domain reviewers
  (Nginx · GCP Cloud Run · AWS ECS · Shell Script), consolidates, and judges go/no-go (PASS/BLOCK). On
  PASS, the actual deploy is handed off to `cloudrun-config-helper`/`ecs-config-helper`. The gate does
  not run deploy or rollback itself. `[Verified]`
- **Note:** `git push` is `ask` in `settings.json`, so it always requires user confirmation.
  Destructive actions proceed only after approval.

---

## 4. When to use a Dynamic Workflow (trade-offs)

| Situation | Recommended | Rationale |
|---|---|---|
| Single-domain one-off review / debug / test | Direct routing (§3.1–3.3) | No new skill needed; works immediately |
| Multi-stage / retry / gate (generate-verify-judge) | Orchestrator skill (§3.4–3.6) | Explicitly controls the retry / artifact / judgment loop |
| Fan-out over tens to hundreds of files, large-scale parallel search/verify | **Dynamic workflow** (§1.1) | The runtime manages parallel subagents and keeps the session responsive |

- **Scalability:** a dynamic workflow is strong for large fan-out, but it does not replace the
  repository's deterministic gate/retry conventions (max 2 retries, `tmp/` artifacts) — the two
  approaches are complementary.
- **Maintainability:** the repository standard (skill + subagent) is easy to version and review; a
  dynamic workflow is a runtime product and leaves nothing in the repository.
- **Performance:** large-scale parallelism favors the dynamic workflow, but it carries high overhead
  for one-off work.

---

## 5. This directory's conventions (what to place, what not to)

**Place here:** workflow playbooks (trigger→entry-point→procedure docs), team operating conventions,
dynamic-workflow usage notes. All are documents that people and Claude reference via `@`.

**Do not place here:**
- Logic that expects an automatic trigger — build that as a skill (`.claude/skills/`) or subagent (`.claude/agents/`).
- Judgment criteria (SoT) — those live in the rules (`.claude/rules/`). Do not restate rules here; reference them with `@see`.
- Attempts to have this folder load an execution script — it is not an official load target (§0).

**Authoring conventions:** language is **English** (project `.md` policy per CLAUDE.md); attach a
source and confidence label to verifiable facts; reference the design background via `@see` with
`docs/app/agent/multi-team-docs.md` as SoT.

---

## References

| Source | Link |
|---|---|
| Dynamic Workflows announcement (Anthropic) | https://claude.com/blog/introducing-dynamic-workflows-in-claude-code |
| Common Workflows (official docs) | https://code.claude.com/docs/en/common-workflows |
| Claude Code extensions overview (features overview) | https://code.claude.com/docs/en/features-overview |
| Repository workflow design (SoT) | `.claude/docs/app/agent/multi-team-docs.md` |
