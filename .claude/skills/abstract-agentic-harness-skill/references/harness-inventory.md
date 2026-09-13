# Harness Inventory — this repository's measured status

Supplementary reference for `SKILL.md` Phase 0. **This is not judgment criteria** — artifact specs are
SoT in `skills/utility-claude-code-skill/references/artifact-spec-guide.md`, and structure and placement in
`rules/utility-claude-code-rule.md`. This document carries only the **status and premises** a design
decision needs.

> **Counts go stale.** The table below is measured as of 2026-09-06; re-run the counting commands in
> `SKILL.md` Phase 0 before designing. If the values differ, **the measurement is right**, not this
> document.

## Contents

1. [Verified premises — facts that overturn a design](#1-verified-premises--facts-that-overturn-a-design)
2. [Inventory of the 8 artifact kinds](#2-inventory-of-the-8-artifact-kinds)
3. [The four orchestrators' boundaries](#3-the-four-orchestrators-boundaries)
4. [The 5 role axes × domain matrix](#4-the-5-role-axes--domain-matrix)
5. [The three-layer collaboration principle](#5-the-three-layer-collaboration-principle)

---

## 1. Verified premises — facts that overturn a design

**These premises are the first thing a new harness design gets wrong.** What the general multi-agent
literature assumes and what is actually true here differ.

### 1-1. The agent-teams experiment is off

`[Verified]` [Read: .claude/settings.json:13] — `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS: "0"`.

**Read two things separately — a tool that no longer exists and a tool that is merely switched off.**

| Tool | State | Evidence |
| --- | --- | --- |
| `TeamCreate` · `TeamDelete` | **no longer exist** — removed in v2.1.178. Flipping the gate does not bring them back; team creation and cleanup now happen automatically on spawn and at session end | `[Verified]` [WebFetch: <https://code.claude.com/docs/en/agent-teams> — "Both tools no longer exist."] |
| `TaskCreate` · `TaskGet` · `TaskList` · `TaskUpdate` · the shared task list | **still exist but are unusable here** — with teams off no teammate is launched, so no shared task list forms | `settings.json:13` above |

So **a design that presumes team-based coordination (a shared task list, direct teammate-to-teammate
communication) cannot run in this repository.** But do not state the reason as "all four tools are
gone" — the four `Task*` tools are real; what is missing is `TeamCreate` / `TeamDelete` and **the teams
themselves**.

The reasons the gate is off, stated correctly:

- **No nested teams — teammates cannot spawn teammates of their own.** Decisive here: all three
  orchestrators exist to spawn, and `api-agent-team` additionally delegates to `app-agent-team`.
  Promoted to teammates, that whole routing layer stops working.
- **No background sub-agents from in-process teammates** — Claude Code errors when a teammate spawns an
  agent whose definition sets `background: true`.
- A teammate is a full Claude Code session, so it carries a **higher token cost** than orchestration that
  only needs a returned report.

> **Retired claim, do not repeat it:** that a teammate "returns an idle notification instead of its
> result", stalling a flow that waits on it. **Neither phrase appears on the live page**, which says the
> opposite — a finishing teammate notifies the lead and **includes its final answer in the
> notification**. The `"0"` verdict is unchanged; only the justification is. Repeating the retired claim
> produces a confident false positive.

> **Name trap:** `app-agent-team`, `api-agent-team` and `tools-agent-team` are **just the names of
> orchestrator agents** and have nothing to do with the harness's agent-teams feature. Do not infer from
> the names that teams are enabled.

Only two coordination mechanisms are actually used:

- **`Agent`** — sub-agent spawn (fan-out, generate-verify). Renamed from `Task` in CLI 2.1.63.
- **`SendMessage`** — resume a named agent or agent ID **with its prior history intact**. It does not
  require the teams feature.

### 1-2. Worktree isolation is used deliberately

`[Verified]` 2026-09-06 — **19 agents declare `isolation: worktree`**: the 15 `app-*` agents plus
`api-platform-author`, `-analyzer`, `-debugger` and `-tester`. The authoritative census is in
`skills/utility-claude-code-skill/references/artifact-spec-guide.md` (`Agent isolation / maxTurns`) and is deliberately not
duplicated here.

**The convention follows the agent's domain scope, not whether it writes** — a read-only analyzer scoped
to `app/**` is isolated too, and that is not an inconsistency. The deliberate omissions are the three
orchestrators, `api-platform-reviewer`, the six infrastructure reviewers and the four `utility-*` agents;
for the `utility-git-commit-*` pair, adding `isolation: worktree` is a **`[MUST]`** finding because they
must see the real working tree (`git diff --cached`).

A `git worktree` is cut from the **default branch, not the parent's `HEAD`**, so an isolated reviewer
sees none of the author's uncommitted edits to tracked files. `[Verified]` 2026-09-11 — `.claude/tmp/`
is no help either: absent, or present as a copy that never syncs back, depending on a doc claim that
keeps flipping. **The mitigation is inlining the author's full unified diff into the reviewer's
prompt, not removing isolation.** Details in
`docs/abstract-orchestrator-contract-docs.md` §2 and `loop-engineering-guide.md` §5-1.

### 1-3. Read-only is harness-enforced, not merely a norm

Declaring `memory: project` makes the harness grant **`Read`, `Write` and `Edit` automatically**,
regardless of the `tools` list — but **`disallowedTools` reverses that grant per tool**. So the two
halves have to be read together:

- **The 18 read-only agents (4 `*-analyzer` + 14 `*-reviewer`) declare `disallowedTools: Edit, Write`**
  and genuinely cannot write. An `Edit` call fails outright, and **assigning one a tmp output path
  guarantees failure** — ask for findings in the returned report instead.
- **The four `utility-*-reviewer` agents are the deliberate exception**: they list `Write` in `tools`
  with `disallowedTools: Edit`, because their verdict goes to a `.claude/tmp/` file. They are still
  counted read-only in role — they judge, they do not author.
- **Omitting `disallowedTools` is what leaves read-only as prose only.** If a new read-only agent is
  meant to be enforced, the `disallowedTools` line is the enforcement — do not rely on the body text.
- `autoMemoryEnabled: true` in `settings.json` is what keeps the auto-grant active in the first place.

`[Verified]` 2026-09-11 — **no agent declares `permissionMode: plan`.** The 16 write-path agents declare
`permissionMode: acceptEdits`; every other agent omits `permissionMode` entirely. Do not add `plan` to a
read-only agent on the theory that it hardens the role — `disallowedTools` already does that, and the
sources agree on it (`docs/abstract-orchestrator-contract-docs.md` §3,
`docs/tools-agent-team-docs.md`, `rules/tools-agent-team-rule.md`).

### 1-4. Intermediate output cannot be cleaned up

- Paths are `.claude/tmp/{app,api,tools,utility}/**` (registered in `.gitignore`).
- **`Bash(rm:*)` is `deny`** and deny beats allow. Retention is handled by `cleanupPeriodDays: 30` and
  `.gitignore`.
- A nested path needs **`mkdir -p` on the whole parent chain** — creating only the first segment makes
  the write fail.
- The four orchestrators' consolidated report paths are separate, so they cannot overwrite one another.

### 1-5. The Symfony application is not scaffolded yet

`[Verified]` 2026-09-06 — **`app/` contains only `.gitkeep`.** There is no `app/src/`, no `app/tests/`,
no `app/assets/`, no `app/templates/` and no `app/vendor/`.

This is the single largest gap between the harness and the code it governs, and it changes how several
things must be read:

- **Every `app/**` path in a rule's `paths`, an agent's target scope or a template in `examples/` is a
  target shape, not an existing tree.** A missing directory is not an environment error.
- **No vendor-dependent gate can run** — `phpstan`, `php-cs-fixer`, `phpunit` and `bin/console` are all
  unavailable, so those gates aggregate as **"not run"**, never as a pass (see
  `loop-engineering-guide.md` §2-2).
- **Dependency CVE checking is impossible**, so an analyzer reports it as unchecked rather than clean.
- **Do not report an artifact as verified against real code** when the code does not exist. The harness
  is being built ahead of the application, which is a legitimate order — but it means harness
  verification is currently limited to `.claude/**` itself.

### 1-6. Forked skills (`context: fork`) are available and entirely unused

`[Measured]` 2026-09-10 — **zero artifacts declare `context: fork`**, and until this date no file in this
bundle mentioned the field. It is a real lever of the harness, not a gap in it: a skill can run in an
isolated forked subagent, giving an uncontaminated verification context **without** a new `agents/` file,
roster entry, `agent-memory/` directory or hook case branch.

Two consequences for design work here:

- **There is no local precedent to cite.** Anything proposing it is a first adoption, which
  `harness-design-guide.md` Phase 7 requires be recorded with a date and a reason.
- **It interacts with the one thing this repository enforces mechanically.** `agent-roster-guard.sh` is
  registered with matcher `Agent|Task` and reads `tool_input.subagent_type`, but a fork picks its
  executor via the `agent:` frontmatter field — so `[Inferred]` the guard does not fire on that path.
  Verify it before putting a forked skill inside an orchestrator's scope.

The decision criteria are in `artifact-selection-guide.md` §2 (template ③), and the edge-enforcement
consequence in `graph-engineering-guide.md` §4-1. Neither is restated here.

### 1-7. The rest of the execution environment

| Item | Value | Effect on design |
| --- | --- | --- |
| `permissions.defaultMode` | `plan` | writing files needs user approval. Do not route around it. Separately, the **16 write-path agents** (8 `*-author`, 4 `*-tester`, 4 `*-debugger`) set `permissionMode: acceptEdits` to escape it; the four orchestrators deliberately do not, which makes their tmp report **best-effort** |
| `outputStyle` | `abstract-english-style` | **main conversation only** — it does not apply to sub-agents |
| `skillListingBudgetFraction` | **not set in project settings** — the documented knob exists, but neither `settings.json` nor `settings.local.json` carries it, so the default applies | do not cite a specific local percentage as measured |
| `autoMemoryEnabled` | `true` | the automatic tool grant in 1-3 is active |
| spawn budget | `maxTurns` — `app-agent-team` 50, `api-agent-team` 50, **`tools-agent-team` 40** | a spawn and its return each consume a turn. A smaller roster gets a smaller budget |
| fan-out width | **≤ 6 per batch** | split the excess into batches and report the remainder as **deferred** |
| nested spawn depth | 3 layers | at the cap the harness **withholds** the `Agent` tool rather than erroring |
| concurrent sub-agents | **20** | exceeding it fails the spawn with `Concurrent subagent limit reached` — unlike the depth cap, this one is loud |

---

## 2. Inventory of the 8 artifact kinds

`[Measured]` 2026-09-11 — **all nine rows re-counted on disk.** Only the reference-document row moved
(19 → 18), and not because a document was retired: the old figure had been silently counting
`docs/tools-agent-team-docs copy.md`, a git-tracked stray that was the Korean original of the English
`tools-agent-team-docs.md`. It broke the `<domain>-<name>-docs.md` naming rule and was a second
Hangul-bearing file where `CLAUDE.md` permits exactly one, so it was deleted by explicit user
instruction. **This is the second time a count here proved to be measuring the wrong set** — see the
skill-row note below. Re-count; do not trust.

> **The skill count had drifted before this measurement.** It was recorded as 22 while the tree actually
> held 28, because the six `app-src-service-api-*` skills were never added to the row. The 26 below is
> 28 minus the two directories the 2026-09-09 merge removed. **The lesson worth carrying:** the figures
> in this document are worth **re-measuring, not trusting**. The six provider transport skills that
> caused this drift also falsified the "provider domain is unimplemented / unroutable" claims that stood
> across §3 and §4 below, `graph-engineering-guide.md` §1–§3, `loop-engineering-guide.md` §1,
> `agents/app-agent-team.md` and `rules/app-agent-team-rule.md`. **All of those were corrected on
> 2026-09-09** — the root cause was searching for a **design-era name** (`api-providers-*-build-skill`)
> that the implementation never used, and concluding absence from a failed name match.

| Kind | Path | Count | Nature |
| --- | --- | --- | --- |
| sub-agent | `.claude/agents/*.md` | 38 | executor. Holds no criteria; loads the SoT via `@see` |
| skill | `.claude/skills/<name>/SKILL.md` | **26** | entry point / orchestrator. Controls retries, gates and output |
| ~~slash command~~ | ~~`.claude/commands/*.md`~~ | **0** | **Tree retired 2026-09-10** — all 13 folded into their paired skill as `references/*-guide.md`. Do not author a new one |
| skill reference guide | `.claude/skills/<name>/references/*.md` | **27** | holder of procedure. Loaded only when `SKILL.md`'s `## Modes` table points at it. **Holds no criteria, with one exception: `utility-claude-code-skill/references/artifact-spec-guide.md` is the artifact spec SoT** |
| rule | `.claude/rules/*.md` | 36 | **the verdict SoT.** Auto-applied by `paths` glob; no natural-language trigger |
| reference document | `.claude/docs/*.md` | **18** | background, account, examples. Loaded only via `@see`. The rule wins on conflict |
| output style | `.claude/output-styles/*.md` | 9 | response and code style. `settings.json`'s `outputStyle` names exactly one |
| hook script | `.claude/hooks/<event>/*.sh` | 13 | automatic gates. Logic in the script, registration in `settings.json` |
| agent memory | `.claude/agent-memory/<name>/MEMORY.md` | 38 | standing context auto-loaded when `memory:` is declared |

**Three non-artifact roots** fall outside the kinds above and are not held to the fixed-root rules —
`.claude/workflows/` (playbooks plus any saved dynamic-workflow `.js`), `.claude/scripts/` (statusLine)
and `.claude/tmp/` (intermediate output).

### Placement summary

- **Every kind is a flat single tier with a hyphenated taxonomy** (`{domain}-{subject}-{kind}`).
- **There is no nesting exception.** `[Verified]` 2026-09-06 — all seven artifact trees were flattened
  on 2026-08-15 and none has held a `<domain>/<tier>/` sub-tree since. In particular there is no
  provider taxonomy mirroring `app/src/Service/Providers/**` under `commands/`, `docs/` or `rules/`;
  those files were removed in the same flattening and never rebuilt.
- **`skills/` and `agent-memory/` are flat by harness constraint rather than convention** — nesting
  there means the artifact **fails to load, with no error.**
- **`abstract-` is the permitted non-domain prefix**, carried by `rules/abstract-structure-rule.md`, the
  two `abstract-*-style.md` bases, `docs/abstract-orchestrator-contract-docs.md` and the
  `abstract-agentic-harness-skill` directory.

The verdict SoT is `rules/utility-claude-code-rule.md`. This section is a summary, so do not use it to
judge a violation.

---

## 3. The four orchestrators' boundaries

The four orchestrators **never spawn one another.** Out-of-scope files are handed off with the owning
team named, and are never dropped silently. The one documented exception runs in a single direction:
`api-agent-team` delegates its non-exposure half to `app-agent-team` (Mode D), capped at one delegation
per invocation — see `rules/api-agent-team-rule.md`.

| Orchestrator | Owns | Delegation mechanism | tmp |
| --- | --- | --- | --- |
| `app-agent-team` | the app proper (PHP · JS · Twig) · **all external provider consumption** · operations and configuration | direct spawn of the 15 `app-*` agents + domain review modes + the deploy, commit and diagram skills | `.claude/tmp/app/` |
| `api-agent-team` | the API Platform exposure layer only (`ApiResource` · `State` · `api_platform.yaml`) | the 5 `api-platform-*` agents | `.claude/tmp/api/` |
| `tools-agent-team` | infrastructure · data · deployment | the reviewers behind five prefixes (`cache-`, `database-`, `server-`, `tools-aws-`, `tools-gcp-`) | `.claude/tmp/tools/` |
| `utility-agent-team` | the cross-cutting utility surface — `diagram/**` · commit messages · `scripts/**` · `.claude/**` | **no direct spawn** — every job goes to `utility-drawio-diagram-skill`, `utility-git-commit-skill`, `utility-shell-script-skill`, `utility-claude-code-skill` or `abstract-agentic-harness-skill`, each owning its own loop and retry budget | `.claude/tmp/utility/` |

**Three boundary cases that are often got wrong:**

1. **Provider consumption belongs to `app-`, not `api-`** (transferred 2026-08-29), and it is
   **routable**: `[Verified]` 2026-09-09, six skills exist —
   `app-src-service-api-{rest,oauth2,websocket}-{build,client}-skill`. This item previously said "the
   provider artifacts do not exist … therefore **unroutable**"; that was a **name mismatch** (it looked
   for `api-providers-*-build-skill`). Still genuinely absent: `rules/api/`,
   `commands/api/providers/`, and any `{integration}-api-*-rule.md`. The build skills fall back to the
   matching `*-client-skill` for criteria, so the gap is **reportable, not blocking**.
2. **`message-rabbitmq-reviewer` is outside the `tools-agent-team` roster** — it matches none of the
   five prefixes, so it continues to be handled by `app-agent-team`'s command.
3. **`tools-agent-team` does not own the deploy go/no-go** — that verdict belongs to
   `tools-app-deploy-skill`, which fans out to the reviewers internally.

**A roster is defined by prefix rather than a fixed list, and is resolved by preflight on every
invocation.** `hooks/pre-tool-use/agent-roster-guard.sh` blocks an out-of-roster spawn with `exit 2`, so
when a roster changes, fix that hook's `case` table in the same change.

---

## 4. The 5 role axes × domain matrix

`[Measured]` 2026-09-06. A `—` means the axis was deliberately not created; a blank is not a defect.

| Role | PHP backend | JS/Stimulus | Twig | API Platform | Infrastructure · data | Utility |
| --- | --- | --- | --- | --- | --- | --- |
| **author** | ✓ | ✓ | ✓ | ✓ | — | git-commit · drawio · claude-code · shell-script |
| **analyzer** (security) | ✓ | ✓ | ✓ | ✓ | — | — |
| **debugger** | ✓ | ✓ | ✓ | ✓ | — | — |
| **reviewer** | ✓ | ✓ | ✓ | ✓ | cache · database · message · server · aws · gcp | git-commit · drawio · claude-code · shell-script |
| **tester** | ✓ | ✓ | ✓ | ✓ | — | — |

**How to read it:**

- **The four code domains (PHP · JS · Twig · API Platform) are symmetric across five axes.** Use that
  symmetry as the reference when opening a new code domain, but **fill only the axes there are grounds
  to fill**.
- **Infrastructure and data are reviewer-only.** There is no generation axis because writing config
  files is not as repetitive as writing code, and criteria alone suffice.
- **Utility keeps only author+reviewer pairs, but now four of them** (`git-commit`, `drawio`,
  `claude-code`, `shell-script`) — the domain benefits from an **independent context uncontaminated by
  the generation step** when verifying structural integrity (id uniqueness and edge referential
  integrity in `.drawio` XML, frontmatter and naming in `.claude/**`, source guards and quoting in
  `scripts/**`). The three middle axes stay empty deliberately: there is nothing to security-analyze,
  debug or test in a commit message or a diagram.
- **The provider domain has no agents, deliberately** — the 10 were merged away, and the axis is served
  by **6 skills** instead (3 transport build + 3 transport client), which self-verify rather than
  spawning an author→reviewer pair. `[Verified]` 2026-09-09. The 5 per-provider `*-build` **commands**
  do not survive; see §3 above and `artifact-selection-guide.md` §3-2.

**The analyzer axis changed character on 2026-08-22** — from static structural analysis to **security
vulnerability diagnosis**. The grounds were a recorded gap: the security criteria
(`08-security-rule.md` and others) were already in place and **only an executor to check code against
them was missing.**

---

## 5. The three-layer collaboration principle

```text
rules/     = the single source of truth for verdicts. Auto-applied by paths glob; no natural-language trigger.
agents/    = executors. Load rules, docs and output styles with Read to do the work.
skills/    = orchestrators / entry points. Control retries, gates and output.
skills/<n>/references/ = holders of procedure. Reached only through the SKILL.md `## Modes` table. (commands/ was retired 2026-09-10 and is empty.)
```

- **Agents do not hold criteria of their own.** They reference the rule (SoT), docs and output style via
  `@see`. Copying criteria into an agent body adds one more source of drift.
- **A skill does not necessarily call an agent.** Some domains self-verify against a command body with
  no agent pair.
- **Sub-agents start from an empty context.** They inherit nothing from the orchestrator, and `@see` is
  a notation rather than an import, so **it only arrives if `Read`.** That is why duplication between an
  orchestrator prompt and a rule is **intentional** — when the two disagree the rule is SoT, and both
  are fixed in the same change.
