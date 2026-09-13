# Utility Agent Team Composition

> Status: **Reference document (background and rationale)** — it defines the structure that binds this
> repository's **cross-cutting utility surface** into a single orchestrator, and the rationale behind
> `utility-agent-team`'s roster, delegation mechanism and sequencing.
>
> **It is not a verdict SoT.** Per `## Docs Layout` in `utility-claude-code-rule.md`, everything under
> `.claude/docs/**` is always a reference, and where it conflicts with a rule the rule wins. The verdict
> SoTs paired with this document are **`rules/utility-agent-team-rule.md`** (orchestration invariants)
> and the **four domain rules** plus the artifact spec guide (the criteria each delegated skill applies).
>
> Written: 2026-09-13
>
> **Created two days after the orchestrator itself.** `utility-agent-team` shipped on 2026-09-11 with
> neither a rule nor a paired document; both were recorded as a tracked follow-up in
> `agent-memory/utility-agent-team/MEMORY.md` `## Known gaps (2026-09-11)`, because creating them is
> authoring rather than the count correction that change was performing. The user approved both on
> 2026-09-13; the rule landed first and this document second.

@see .claude/agents/utility-agent-team.md — the orchestrator this document is paired with (execution directives)
@see .claude/rules/utility-agent-team-rule.md — orchestration invariants (verdict SoT)
@see .claude/docs/app-agent-team-docs.md — the repository-wide umbrella: role axis · loop templates · premises (SoT)
@see .claude/docs/api-agent-team-docs.md — API Platform exposure layer axis design (SoT)
@see .claude/docs/tools-agent-team-docs.md — infrastructure · data · deployment axis design (SoT)
@see .claude/docs/abstract-orchestrator-contract-docs.md — rationale and measured values for the contract all four teams share
@see .claude/rules/abstract-structure-rule.md — rule index (SoT)
@see .claude/output-styles/abstract-english-style.md — document style (ADR · trade-offs · citation)

---

## 1. Overview and Premises

### Purpose

This document defines the composition that binds the **four domains belonging to no application
layer** into one orchestrator. Unlike its three siblings this team has **no role axis and no agent
roster of its own**, so the team definition is short; the space goes instead to **why it delegates
loops rather than running them**, because every other property follows from that one decision.

| Domain | Target |
| --- | --- |
| draw.io diagrams | `diagram/**/*.drawio` |
| Commit messages | the staged set (`git diff --cached`) — **not a file** |
| Bash scripts | `scripts/**/*.sh` |
| Claude Code configuration artifacts | `.claude/**` and `CLAUDE.md` |

**Out of scope:** application code (PHP, Stimulus/JS, Twig) and provider integrations belong to
`app-agent-team`; the API Platform exposure layer to `api-agent-team`; infrastructure, data mapping and
deployment assets to `tools-agent-team`. Messenger and RabbitMQ belong to no roster at all.

### Why a fourth orchestrator, rather than leaving this with `app-agent-team`

Until 2026-09-11 these four domains sat under `app-agent-team` — the 2026-08-28 split had moved
infrastructure out to `tools-agent-team`, but the utility surface stayed behind for want of anywhere else
to go. That left one team directing **two kinds of work with nothing in common**: a five-role
generate-verify fan-out over 15 `app-*` specialists, and four self-contained skills that each already ran
their own loop and needed only to be called in the right order. The fourth team resolved both — the
utility surface got an entry point whose whole job is **routing and sequencing**, and `app-agent-team`'s
roster stayed closed at its 15 `app-*` agents.

### Inherited premises — stated once, in the umbrella

The session-level premises every orchestrator inherits (the agent-teams experiment flag, the default
permission mode, the active output style, the effort level) are established in `app-agent-team-docs.md`
`## 1. Overview and Premises` → *Established Premises (verified)*, and are **not restated here**.

> **One value in that list has since moved.** `[Verified]` 2026-09-13 [Read: .claude/settings.json:12] —
> `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` reads **`"0"`**, not the `"1"` the umbrella records. Nothing here
> depends on the flag; it is noted so the discrepancy is not re-discovered as a finding. `defaultMode:
> "plan"` still reads as stated, and it has a direct operational consequence — see §4.4.

### Verified premises specific to this team

`[Verified]` 2026-09-13, measured against `.claude/**`:

| Item | Value | Evidence |
| --- | --- | --- |
| Orchestrators in the repository | **4** | `agents/{app,api,tools,utility}-agent-team.md` |
| This team's anchor | **4 skills** (+ `abstract-agentic-harness-skill`) | `ls .claude/skills/utility-*-skill` |
| Agents it may spawn | **8** — `utility-{drawio-diagram,git-commit,shell-script,claude-code}-{author,reviewer}` | `ls .claude/agents/utility-*.md` |
| Orchestrator spec | `model: opus` · `maxTurns: 40` · `memory: project` · `disallowedTools: Edit` · `color: purple` · **no `permissionMode`** · **no `isolation`** | `agents/utility-agent-team.md` |
| Orchestrator tools | `Agent, Bash, Read, Grep, Glob, Write, Skill` **+ the three `mcp__drawio-tool__*` tools** | same |
| Sibling `maxTurns` | `app` **50** · `api` **50** · `tools` **40** | each `*-agent-team.md` |
| Roster-guard pattern | `^utility-(drawio-diagram\|git-commit\|shell-script\|claude-code)-(author\|reviewer)$` | `hooks/pre-tool-use/agent-roster-guard.sh` |

**The three MCP tools are the tell.** No sibling orchestrator carries `mcp__drawio-tool__set_page`; its
presence here is not a capability exercised on this team's judgment but the mechanical consequence of §3.3.

### The collaboration principle, with one layer inserted

The umbrella's *Three-Layer Collaboration Principle* (rules → agents → skills) becomes a **four**-layer
chain here, because the **skill** sits between the orchestrator and the agents and owns the loop, the
retry budget and the final action. The orchestrator holding no criteria is the point, as for the three
siblings; what differs is that middle layer — for `app` and `api` the orchestrator *is* the loop owner,
and `tools` has no loop at all.

---

## 2. Inventory

### 2.1 The anchor — four skills plus a design skill

| Domain | Skill | Modes | Final action it owns | Governing rule (SoT) |
| --- | --- | --- | --- | --- |
| draw.io diagrams | `utility-drawio-diagram-skill` | Author · Review | `set_page` / `Write` to `diagram/**` | `utility-drawio-diagram-rule.md` + `utility-drawio-diagram-style.md` |
| Commit messages | `utility-git-commit-skill` | **single (no `## Modes` table)** | `git commit -F` | `utility-git-commit-rule.md` |
| Bash scripts | `utility-shell-script-skill` | Guide · Author · Review | the script write | `utility-shell-script-rule.md` + `utility-shell-script-style.md` |
| One `.claude/**` artifact | `utility-claude-code-skill` | Author · Review | the artifact write | `artifact-spec-guide.md` (spec) + `utility-claude-code-rule.md` (structure) |
| The `.claude/**` artifact **system** | `abstract-agentic-harness-skill` | per its own dispatch table | none — it designs, then delegates each write back | holds no criteria; reaches the SoTs by `@see` |

`[Verified]` 2026-09-13 [Read: each `SKILL.md` · `ls .claude/skills/utility-*-skill/references/`]. Three
of the four carry a `## Modes` table and a `references/` guide; `utility-git-commit-skill` carries
neither, and that asymmetry is real rather than a reading error — see §6.1.

**`abstract-agentic-harness-skill` is on the anchor list but is not a fifth domain.** It carries no domain
prefix deliberately, holds no criteria, and its seven `references/*-guide.md` files cover the three design
axes plus supporting inventories. It is reached when a `.claude/**` decision spans several files, and
returns a design delegated back **per file**.

### 2.2 The eight agents the skills own

The naming is fully regular — each loop-skill owns an author and a reviewer on its own domain stem,
giving `utility-{drawio-diagram,git-commit,shell-script,claude-code}-{author,reviewer}`. All eight resolve
on disk with a matching `agent-memory/<name>/` directory `[Verified]` 2026-09-13
[`ls .claude/agents/utility-*.md .claude/agent-memory/utility-*`].

**Two of the four pairs are younger than this team's siblings, and older text disagrees.** The
shell-script pair was retired on 2026-08-16 and **restored** on 2026-09-11; the claude-code pair was
**created** on 2026-09-11, replacing the command-based self-verification that domain had run since
2026-08-08. Any claim that either domain "self-verifies in the main session" or that its agents "do not
exist" is stale — the umbrella records both retractions in its section 3.5 (*Exception ① is retired*,
*Exception ③ is retired too*), leaving only the provider axis agentless.

### 2.3 Model and tool axes

- **The author model is not uniform, deliberately.** `utility-drawio-diagram-author` and
  `utility-claude-code-author` are `opus`; the git-commit and shell-script authors are `sonnet`, as are
  **all four reviewers**. The two `opus` authors produce the structured output that is expensive to get
  wrong — an XML page `set_page` applies wholesale, and an artifact whose frontmatter parses silently.
- **All eight declare `maxTurns: 30` and `memory: project`**; every author adds
  `permissionMode: acceptEdits` and every reviewer `disallowedTools: Edit`.
- **The reviewers keep `Write`, a meaningful difference from `tools-agent-team`**, whose five reviewers
  declare `disallowedTools: Edit, Write` and so cannot be handed a tmp path at all
  (`tools-agent-team-docs.md` §4.4). Here each reviewer writes its own `*-review.md`, which is what makes
  the round-stamped draft/review pair a usable channel rather than an inline return.
- **None of the eight is worktree-isolated**, and none may become so — see
  `rules/utility-agent-team-rule.md` `## Shared Orchestration Contract` imperative 3.

---

## 3. Team Definition — delegation, not a role axis

### 3.1 There is one team, and its job is routing

- **Trigger:** a diagram, commit, shell or `.claude` request, or a change review whose diff touches any of
  the four target sets.
- **Entry point:** the `utility-agent-team` orchestrator (multi-domain or sequenced), or the domain skill
  invoked directly (single domain, no sequencing needed).
- **Output:** a `[MUST]`/`[SHOULD]`/`[CONSIDER]` consolidated report plus an `## Actions taken` section,
  because unlike the other three teams this one's delegations **apply real changes**.

### 3.2 The missing axes and what follows

| Axis | Status | Where it goes instead |
| --- | --- | --- |
| **Author** (generation) | present, **delegated** | the Author mode of the domain skill |
| **Review** (verdict) | present, **delegated** | the Review mode of the domain skill |
| **Security** (diagnosis) | none | each domain rule's safety section is judged inside Review |
| **Debug** (root cause) | none | a shell or diagram defect surfaces as a Review finding |
| **Test** (regression) | none | these four domains have no runnable test axis |

There is **no `utility-*` analyzer, debugger or tester**, by design rather than omission. Adding one is a
structural change, `[CONSIDER]`-severity in the paired rule.

### 3.3 What a delegation actually is — and why `Agent` is in the tool list

This is the most misread property of the team. **A skill is not a worker: `Skill` loads that skill's
instructions into the caller's own turn.** So when `utility-git-commit-skill/SKILL.md` step 2 says "Call
the `utility-git-commit-author` agent", the orchestrator is the process making that `Agent` call, and
without `Agent` it could not run any of the four loop-skills past their second step. The same mechanism
admits `mcp__drawio-tool__set_page`.

```text
Skill(utility-claude-code-skill, mode: Author)
  └─ the skill's instructions now execute in the orchestrator's turn
      ├─ Agent(utility-claude-code-author)    ← made by the orchestrator, as a step of the skill
      ├─ Agent(utility-claude-code-reviewer)  ← same
      └─ Write(.claude/<target>)              ← the skill's final action, gated on Verdict: PASS
```

The consequence is a discipline no hook can check: **every `Agent` call must be a step of the skill
currently running.** The imperative form and its `[MUST]` belong to `rules/utility-agent-team-rule.md`
`## Invariant — the roster is closed and skill-scoped`; the cost of that unverifiable half is §5.2.

---

## 4. Orchestration Reference Patterns

**Every imperative in this section is owned by `rules/utility-agent-team-rule.md`.** What follows is the
shape of each pattern and the reasoning behind it — read the rule for what is required, this section for
why. The eight-step procedure itself (preflight → scope → filter → route → sequence → delegate →
consolidate → report) is carried by `agents/utility-agent-team.md` `## Execution Procedure`.

### 4.1 Preflight — a mode is a routing target too

Step 0 is §8 of the shared contract (a routing target is unverified until checked) with one addition the
siblings do not need: **a mode is a routing target as much as a path is.** Naming a mode absent from a
skill's `## Modes` table leaves the skill to guess, and the guess is not caught during consolidation.

### 4.2 The three over-match collisions

Routing by target path over-selects in exactly three places — shell ↔ deployment assets,
`scripts/**/nginx/**` ↔ shell, and one artifact ↔ the artifact system. The authoritative globs belong to
the rule files, and the decision each forces is stated once in
@see .claude/rules/utility-agent-team-rule.md — `## Invariant — over-match suppression`.

The third is worth explaining here, because it is what the two-skill split exists to prevent.
`utility-claude-code-skill` authors one file well and **never sees** the orchestrator roster, the
`agent-roster-guard.sh` case table, or the `abstract-structure-rule.md` index row that had to move with
it — so a multi-artifact decision routed there yields a correct file and a silently inconsistent tree.
Hence the routing test is **how many files the decision spans**, never the request's wording.

### 4.3 The two irreversible actions, and why their gates are mechanical

@see .claude/rules/utility-agent-team-rule.md — `## Invariant — sequencing (Commit runs last)` and
`## Invariant — safety boundary and artifacts`.

**Commit runs last** because `utility-git-commit-skill`'s author records a `staged-stat` fingerprint in a
sidecar, and both its reviewer and the skill's pre-commit re-check compare that fingerprint against the
live index. Anything staged after the draft was written is caught as `stale-or-missing-draft` — correctly,
since the message would otherwise be committed against a diff nobody wrote it for. Sequencing Commit last
is what keeps that gate from firing on this team's own ordering.

**`set_page` replaces the target page wholesale**, so an omitted cell is a deletion with no error and no
confirmation, and the reviewer's cell count is a round old by the time the apply happens. This is the one
place where the orchestrator holds a destructive tool directly (§3.3), which is why the pre-apply
cell-count gate is carried by the rule rather than left to the skill that owns the tool.

### 4.4 tmp artifacts, and a write that is *expected* to be refused

| Purpose | Path | Owner |
| --- | --- | --- |
| Consolidated report (best-effort) | `./.claude/tmp/utility/agent-team-report.md` | the orchestrator |
| Diagram draft · review | `./.claude/tmp/utility/drawio/diagram-{draft.xml,review.md}` | `utility-drawio-diagram-skill` |
| Commit draft · sidecar · review | `./.claude/tmp/utility/git/commit-message-{draft.md,meta.txt,review.md}` | `utility-git-commit-skill` |
| Script draft · sidecar · review | `./.claude/tmp/utility/shell-script/script-{draft.md,meta.txt,review.md}` | `utility-shell-script-skill` |
| Artifact draft · sidecar · review | `./.claude/tmp/utility/claude-code/artifact-{draft.md,meta.txt,review.md}` | `utility-claude-code-skill` |

**The consolidated report's `Write` is denied whenever the session is still in plan mode**, because the
orchestrator declares no `permissionMode` and so inherits the read-only `defaultMode: "plan"`. Nothing in
this repository reads that file, so the returned response is the required channel and a refused write is a
non-event. The skills' own artifacts are unaffected: all four authors declare `permissionMode: acceptEdits`.

**The header/sidecar split across the four draft formats is deliberate, not an inconsistency.** A drawio
draft can carry a provenance line the skill strips before applying; the other three cannot, because line 1
must be the commit message, the shebang or `---`. Do not "harmonise" them.

---

## 5. Trade-offs

### 5.1 Delegating loops instead of running them (2026-09-11)

**Context.** Each of the four domains already had a skill owning an author→reviewer loop end to end —
template ① from the umbrella's section 4, two agents, **2 retries**, and its own final action. A new
orchestrator could either run a loop of its own over the eight agents (the `app`/`api` shape) or call the
skills. **Decision: delegate — the orchestrator runs no verification loop and owns no retry budget.**

- (+) **The retry budget stays with the domain that defined it.** Each skill's limit of 2 was chosen
  against its own failure modes; a fourth loop owner would have had to encode four retry policies and
  would drift from all four.
- (+) **One verdict owner per draft**, rather than two counters over one budget with no rule for which
  wins. And the same delegation works whether the caller is this team or a user typing the skill name.
- (−) **A skill that stops at its own limit cannot be rescued here.** "Auto-approval limit reached —
  manual review recommended" is relayed verbatim with the last draft; re-running would restart a budget
  already spent. That looks like inaction and must be reported as the terminal state it is.
- (−) The orchestrator cannot see *inside* a loop, so a per-round diagnosis is available only by reading
  the skill's tmp artifacts after the fact.

**Rejected:** running the loop over the eight agents directly (duplicates four retry policies and
bypasses each skill's freshness gate and final-action control), and leaving the four domains with
`app-agent-team` (preserves the mismatch §1 describes).

### 5.2 Holding `Agent` while spawning no specialist directly (2026-09-11)

A team that only calls skills would appear to need `Skill` and nothing more, but a skill executes in its
caller's context (§3.3). **Decision: grant `Agent`, scope it to the eight agents at the hook level, and
hold the "only as a skill step" half in the prompt.**

- (+) All four loop-skills are runnable here; without `Agent` each would halt at its author step. The
  harness blocks the high-consequence half — `agent-roster-guard.sh` exits 2 on a `subagent_type` outside
  the pattern, and on a name that does not resolve on disk, showing the reason.
- (−) **The guard checks *which* agent, never *why*.** An improvised spawn of the same eight — re-spawning
  a reviewer to re-litigate a recorded verdict, or spawning an author "to check something quickly" — is
  indistinguishable from a legitimate skill step. That half is self-held, and it is this team's largest
  unverifiable surface (§6.2).
- (−) The same reasoning admits a destructive MCP tool into an orchestrator that authors nothing; §4.4 is
  the compensating control.

### 5.3 The roster pattern is eight names, not a `utility-` prefix (2026-09-11)

`tools-agent-team` defines its roster by **five prefixes** resolved at preflight, and §5.2 of
`tools-agent-team-docs.md` records what that buys: a new agent under an existing prefix is enrolled
automatically. **The decision here was to enumerate the four domain stems and the two roles instead.**

- (+) **Self-spawning falls out at the pattern level.** `utility-agent-team` would match a bare prefix but
  does not match this pattern, so no separate "never spawn yourself" rule is needed — the mechanism
  `tools-` → `tools-aws-`/`tools-gcp-` relies on, reached differently. The role halves being explicit also
  means a hypothetical `utility-*-tester` is refused rather than enrolled into a team with no tester axis.
- (−) **A fifth utility domain requires editing the pattern**, the roster table and the routing table
  together; the prefix approach would have needed only the first. That is the deliberate trade — automatic
  enrolment is worth less to a team whose anchor is *skills*, because a new agent with no skill to spawn it
  from would be unreachable here anyway. The pattern was widened once already, on 2026-09-11.

### 5.4 `maxTurns: 40` rather than the siblings' 50 (2026-09-11)

`app-agent-team` and `api-agent-team` declare **50**; `tools-agent-team` and this team declare **40**
`[Verified]` 2026-09-13. The two numbers track **whether the orchestrator funds a loop out of its own
budget**, not team importance: 50 buys routing plus a five-role fan-out *plus* an author→reviewer loop the
orchestrator runs itself, while 40 buys routing, delegation and consolidation. This team has four loops,
but every one is spent inside a delegated skill's context, so **40 is not a deviation** from the
orchestrator convention in the artifact spec guide. The failure mode it does create is real: exhausting
`maxTurns` mid-consolidation ends the turn without an error and ships an unfinished report as the
verdict — which is why the report is built up incrementally.

### 5.5 The Commit carve-out — one seam in an otherwise clean boundary (2026-09-11)

The four orchestrators never spawn one another, but `app-agent-team` and `api-agent-team` each end a
change-review with a commit, and Commit is this team's domain. **Decision: let a sibling call
`utility-git-commit-skill` directly, as the terminal step of a change-review it ran itself**, documented
in the same words from both sides — `app-agent-team-rule.md` `## Invariant — delegation mechanism` carries
the other half of the sentence.

- (+) A reviewed change is not stranded; forcing a team switch merely to commit work the reviewing team
  just verified would cost a full hand-off for one `git commit -F`. Nor is it an exception to the
  never-spawn-one-another imperative — calling a **skill** is not spawning an **orchestrator**.
- (−) **Commit is the one domain with two legitimate callers**, so "who committed this" is no longer
  answerable from the team boundary alone. The mitigations are narrow and must stay narrow — the carve-out
  covers Commit only (never diagrams, shell or `.claude`), a request that *starts* with a commit is this
  team's, and a commit a sibling already made is neither re-run nor re-reviewed here.

---

## 6. Current Gaps and Follow-ups

### 6.1 `utility-git-commit-skill` is the one utility skill with no `## Modes` table

`[Verified]` 2026-09-13 [Read: `.claude/skills/utility-git-commit-skill/SKILL.md`] — it has no `## Modes`
section and no `references/` directory, while the other three have both. It is genuinely single-purpose,
so the absence is defensible, but it has two live consequences: **a `Skill` call to it cannot name a
mode**, making it the standing exception to the otherwise uniform "always name the mode" rule and the most
likely place for a caller to invent one; and it is **the repository's reference-standard loop** yet the
only one not reachable through a mode dispatch table, so a reader looking for the pattern finds it laid
out differently from the three that copied it. Adding a single-row table would be a structural change to
an established entry point — `[CONSIDER]`, requiring approval. Related: `docs/utility-git-commit-docs.md`
is still a 0-byte placeholder tracked in `TODO.md`, which is why this document cites the skill directly.

### 6.2 The roster guard cannot verify *why* a spawn happened

`agent-roster-guard.sh` blocks a `subagent_type` outside the pattern and a name that does not resolve. It
cannot distinguish a legitimate skill step from an improvised spawn of the same eight agents, because both
produce an identical `PreToolUse` payload and no hook event exposes which skill is currently loaded — a
limit of the mechanism, not a wiring gap a better matcher could close. §5.2 records it as accepted.

### 6.3 The guard's `utility-agent-team` branch — closed, not a follow-up

Kept as a numbered entry so a reader arriving from the paired rule's `## Companion Updates` list does not
re-open it. `[Verified]` 2026-09-13 [Read: `.claude/hooks/pre-tool-use/agent-roster-guard.sh:93-99`] — the
`utility-agent-team)` case already sets `RULE_PATH='.claude/rules/utility-agent-team-rule.md'` and
`RULE_SECTION='## Invariant — the roster is closed and skill-scoped'`, so a blocked caller is pointed at
the verdict SoT rather than at the agent prompt. The one limitation that remains is §6.2's, and it is a
property of the mechanism rather than of this branch.

### 6.4 The three-teams → four-teams heading sweep — closed, not a follow-up

Kept as a numbered entry for the same reason as §6.3. `[Verified]` 2026-09-13
[grep: `## Shared Orchestration Contract` across `.claude/rules/*-agent-team-rule.md`] — **all four rules
now read *identical across the four teams***: `app-agent-team-rule.md:40`, `api-agent-team-rule.md:38`,
`tools-agent-team-rule.md:39` and `utility-agent-team-rule.md:47`. No sibling rule still says "three
teams". The paired rule's own `## Companion Updates` entry came with them — line 251 now states that the
four headings and their six numbered imperatives are worded identically across all four rules and must
never be fixed one at a time — so this sub-section has nothing left to repoint at.

What survives is the **method, not the gap**: this class of cross-cutting fact lives in roughly 41 files
with varying wording and line wrapping, so a plain `grep` will not be sufficient for the next one. Use the
whitespace-normalising audit in `abstract-orchestrator-contract-docs.md` §2-2, and read §2-1 before
assuming a site can be collapsed into an `@see`. The 2026-09-09 isolation correction missed 13 agents on
its first pass for exactly this reason.

That leaves **§6.1 and §6.2 as the only genuinely open items in this section**, and neither is a defect
awaiting a fix: one is a `[CONSIDER]` requiring approval, the other an accepted limit of the hook
mechanism. §6.3 and §6.4 are recorded as closed rather than deleted so that a reader arriving from the
rule's `## Companion Updates` list does not re-open them. A short gaps section is the accurate state of
this team, not an omission — listing settled work here would make the open items harder to find.

---

## Appendix: Reference Assets

| Type | Path |
| --- | --- |
| Orchestrator | `.claude/agents/utility-agent-team.md` |
| Orchestration verdict SoT | `.claude/rules/utility-agent-team-rule.md` |
| Agent memory | `.claude/agent-memory/utility-agent-team/MEMORY.md` |
| The 4 domain skills | `.claude/skills/utility-{drawio-diagram,git-commit,shell-script,claude-code}-skill/SKILL.md` |
| The design skill | `.claude/skills/abstract-agentic-harness-skill/SKILL.md` (+ `references/`, `examples/`) |
| The 8 roster agents | `.claude/agents/utility-{drawio-diagram,git-commit,shell-script,claude-code}-{author,reviewer}.md` |
| The 4 domain verdict SoTs | `.claude/rules/utility-{drawio-diagram,git-commit,shell-script,claude-code}-rule.md` |
| Artifact spec SoT | `.claude/skills/utility-claude-code-skill/references/artifact-spec-guide.md` |
| Domain reference documents | `.claude/docs/utility-{drawio-diagram,git-commit,shell-script,claude-code}-docs.md` |
| Domain output styles | `.claude/output-styles/utility-{drawio-diagram,git-commit,shell-script}-style.md` |
| Roster guard | `.claude/hooks/pre-tool-use/agent-roster-guard.sh` |
| Shared operational contract | `.claude/docs/abstract-orchestrator-contract-docs.md` |
| Sibling team designs | `.claude/docs/{app,api,tools}-agent-team-docs.md` |
| Workflow playbooks | `.claude/workflows/README.md` |
