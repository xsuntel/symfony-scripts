---
paths:
  - ".claude/agents/utility-agent-team.md"
  - ".claude/agent-memory/utility-agent-team/**"
  - ".claude/docs/utility-agent-team-docs.md"
---

# utility-agent-team Orchestration Rules

This rule is the judgment criteria (SoT) for the **roster, routing and delegation invariants** of the
`utility-agent-team` orchestrator. It covers the command boundary for the repository's cross-cutting
utility surface — draw.io diagrams, commit messages, Bash scripts and Claude Code configuration.

@see .claude/agents/utility-agent-team.md — the orchestrator this rule judges (execution directives)
@see .claude/docs/utility-agent-team-docs.md — team composition · delegation rationale · trade-offs (not a SoT)
@see .claude/rules/app-agent-team-rule.md — the sibling orchestrator (application · provider · operations) verdict SoT
@see .claude/rules/api-agent-team-rule.md — the sibling orchestrator (exposure layer) verdict SoT
@see .claude/rules/tools-agent-team-rule.md — the sibling orchestrator (infrastructure · data · deployment) verdict SoT
@see .claude/rules/utility-drawio-diagram-rule.md — diagram storage · structural integrity · canvas · palette (SoT)
@see .claude/rules/utility-git-commit-rule.md — commit format · allowed types · scope · factual agreement (SoT)
@see .claude/rules/utility-shell-script-rule.md — shell bootstrap · globals · sourcing · idempotency · safety (SoT)
@see .claude/rules/utility-claude-code-rule.md — `.claude/**` structure immutability & allowed changes (SoT)
@see .claude/skills/utility-claude-code-skill/references/artifact-spec-guide.md — artifact frontmatter · naming · tool minimality (SoT)
@see .claude/docs/abstract-orchestrator-contract-docs.md — rationale and measured values of the shared operational contract
@see .claude/rules/abstract-structure-rule.md — directory and path conventions · rule index (SoT)

## Judgment Scope (no overlap with other SoTs)

**This rule owns the orchestration invariants only** and does not restate the rest. Unlike its three
siblings, this team holds **no domain criteria of its own** — every row but the last belongs to a skill
it delegates to.

| Axis | SoT | What it covers |
| --- | --- | --- |
| draw.io diagrams | `rules/utility-drawio-diagram-rule.md` (+ `output-styles/utility-drawio-diagram-style.md`) | storage format · structural integrity · canvas · palette |
| Commit messages | `rules/utility-git-commit-rule.md` (+ `output-styles/utility-git-commit-style.md`) | format · allowed types · scope · factual agreement |
| Bash scripts | `rules/utility-shell-script-rule.md` (+ `output-styles/utility-shell-script-style.md`) | bootstrap · globals · sourcing · idempotency · safety |
| `.claude/**` structure and placement | `rules/utility-claude-code-rule.md` | directory tiers · flattening · frozen roots |
| Artifact spec | `skills/utility-claude-code-skill/references/artifact-spec-guide.md` | frontmatter · naming · tool minimality |
| **Orchestration invariants** | **this rule** | **roster boundary · delegation mechanism · sequencing · verdict-suspension conditions** |

**The duplication with the agent prompt is intentional.** A subagent starts from an empty context and
cannot reach this rule through `@see`, so the directives must be physically present in
`agents/utility-agent-team.md`. When the two diverge **this rule is the SoT**, and they are revised
**in the same change**.

## Shared Orchestration Contract (identical across the four teams)

The six **numbered imperatives** below are worded identically across the `app`, `api`, `tools` and
`utility` rules. Never fix just one. The **indented notes are deliberately team-specific** — they record
what each roster actually declares, which differs — so they are not part of the shared wording. The
rationale and measured values live in `docs/abstract-orchestrator-contract-docs.md` and are not
restated here.

1. **The four orchestrators never spawn one another.** Out-of-scope files are handed over by naming
   the responsible team under `## Handoffs`, and are **never dropped silently**.
   > **The Commit carve-out is not an exception to this imperative.** A sibling calling
   > `utility-git-commit-skill` is invoking a **skill**, not spawning an orchestrator — see
   > `### The one carve-out`.
2. **All seven spawn-payload fields are mandatory** — target file list · role · governing rule (SoT)
   path · **output channel** · severity vocabulary · no secrets · marking of unrun gates. A missing
   field is a `[MUST]`.
   > **Here the payload is carried by a `Skill` call, not an `Agent` call**, and the fourth field is
   > **the delegated skill's own round-stamped tmp artifact pair** — never a path this team invented,
   > and never "return it inline". Those draft and review files are what the skill's freshness and
   > anti-thrash gates read.
3. **The orchestrator itself must never take `isolation: worktree`.** Its working material is the real
   tree — uncommitted `git diff` output and the live `.claude/tmp/**` — and a worktree is cut from the
   **default branch**, not from the parent's `HEAD`, so isolating it produces an empty verdict as a
   silent failure. (`[Verified]` 2026-09-11: the failure mode rests on the **base branch**, which has
   read the same across every sweep. Whether the tmp tree is absent or present-but-private depends on the
   untracked/gitignored rule, which has flipped between doc revisions — it is useless as a channel under
   either reading, so do not rest anything on that half.)
   > **Here the ban extends to the whole roster, which is the opposite of `app-agent-team`.** None of
   > the 8 `utility-*` agents may take `isolation: worktree`: the commit pair must see the real index
   > (`git diff --cached`), the drawio and shell authors read real files to learn existing conventions,
   > and the claude-code pair reads the live `.claude/**` tree. Adding the key to any of them is a
   > `[MUST]` violation of the artifact spec.
4. **Keep the tmp consolidated-report path isolated per team** — never overwrite another team's report.
5. **A gate that did not run is not a pass** — tally across three values: passed / failed / **unchecked**.
6. **Re-spawn a partial failure exactly once**; if it fails again, state it as "cannot judge (not
   performed)" and **suspend go/no-go**. Exhausting your own turns is also a partial failure, so
   record into the consolidated report incrementally.

## Invariant — the roster is closed and skill-scoped

- **The anchor is 4 skills, not a set of agents** — `utility-drawio-diagram-skill`,
  `utility-git-commit-skill`, `utility-shell-script-skill` and `utility-claude-code-skill`, plus
  `abstract-agentic-harness-skill` for a decision spanning several `.claude/**` artifacts.
- **The only permitted `Agent` spawn targets are the 8 agents those skills own** —
  `utility-{drawio-diagram,git-commit,shell-script,claude-code}-{author,reviewer}`. The enforcing
  pattern is `^utility-(drawio-diagram|git-commit|shell-script|claude-code)-(author|reviewer)$` in
  `hooks/pre-tool-use/agent-roster-guard.sh`.
- **The pattern is deliberately narrower than a bare `utility-` prefix**, which would also match
  `utility-agent-team` itself — so self-spawning is refused without a separate rule. Never widen it.
- **`app-*`, `api-platform-*`, `message-*`, `cache-*`, `database-*`, `server-*` and `tools-*` are never
  direct-spawned here**, under any circumstances.
- **At step 0 of every invocation, resolve the skills, the agents they spawn and every rule to be cited
  as SoT** — substituting memory lets this rule and the agent file go stale ahead of the tree. A target
  that does not resolve is not a delegation target, and a **mode** absent from a skill's `## Modes`
  table is not a mode to name.
- **This team holds `Agent` only because a skill runs in its caller's context.** The `Skill` tool loads
  the skill's instructions into this orchestrator's own turn, so a skill's "call the `<name>` agent"
  step is executed *here*. **Every `Agent` call must therefore be a step of the skill currently being
  run** — never this team's own initiative, and never to re-litigate a verdict the skill already
  recorded. The roster guard checks *which* agent, never *why*; that half is self-held.

## Invariant — this team delegates loops, it does not run them

This is the structural difference from all three siblings, and every other invariant follows from it.
`app-agent-team` and `api-agent-team` each run an author→reviewer loop over an agent roster;
`tools-agent-team` runs a single-shot fan-out over five reviewers. **This team runs neither** — each of
the four domains already has a skill owning its loop end to end (template ①, two agents, **2 retries**,
and its own final action: `set_page`/`Write`, `git commit -F`, the script write, the artifact write).

- **Never run a verification loop of this team's own.** Duplicating one produces two verdict owners for
  the same draft, and two retry counters over one budget.
- **The retry budget belongs to the delegated skill, not to this team.** Do not count rounds, and do not
  restart a loop the skill stopped. A skill that ended at its own limit with "auto-approval limit
  reached — manual review recommended" is **not a failure to re-delegate**: relay it verbatim, present
  the last draft, and stop.
- **The final action belongs to the skill too** — never ahead of its gate, never to "fix up" a result.
- **There is no `utility-*` analyzer, debugger or tester** — those three role axes are empty for this
  domain **by design, not by omission**. The four domains carry Author and Review only, both delegated.
- **`maxTurns: 40` is correct and is not a deviation.** Routing plus delegation plus consolidation is
  the whole budget, with no loop of this team's own to fund. It matches `tools-agent-team` rather than
  the siblings' 50 for the same reason. `color: purple` is likewise deliberate, as is declaring **no
  `permissionMode` and no `isolation`**.

## Invariant — over-match suppression

**The authoritative globs belong to the rule files.** This rule states the shape of each collision and
the decision it forces; when a call is close, `Read` the rule's `paths` and decide against the resolved
list rather than against any list recited from memory.

1. **shell ↔ deployment assets.** `scripts/deploy/**/*.sh` and `scripts/containers/prod/**` are both a
   Bash script (this team's) and a deploy asset. **In a deploy context the `tools-app-deploy-skill` gate
   wins** — hand off and say so, because the gate fans out to the nginx, Cloud Run and ECS reviewers
   *and* to `utility-shell-script-skill`, so delegating the shell half separately produces two verdicts
   on one file. Outside a deploy context the shell skill's Review mode is the right call.
2. **`scripts/**/nginx/**` is configuration, not shell.** It sits under `scripts/` but matches
   `server-nginx-rule.md` and belongs to `tools-agent-team`. A `.conf` file under a shell directory is
   not this team's.
3. **one artifact ↔ the artifact system.** Route `.claude/**` by **how many files the decision spans**,
   never by the wording of the request. Sending a multi-artifact decision to `utility-claude-code-skill`
   is the failure that split exists to prevent — it authors one file well and never sees the
   orchestrator roster, the `agent-roster-guard.sh` case table or the `abstract-structure-rule.md` index
   row that had to move with it. A design handed back down from `abstract-agentic-harness-skill` is
   **already scoped**: pass it through per file and do not widen it.

**Apply suppression before routing, not after.** A target still matching no row is **"routing
unmatched"** and is listed verbatim under `## Summary` — never dropped, and never reported as handled. A
target handed to another team is a **handoff**, recorded separately.

## Invariant — scope boundary and handoffs

- **The scope is exactly four target sets**: `diagram/**/*.drawio` · the staged set (`git diff --cached`,
  not a file) · `scripts/**/*.sh` outside a deploy context · `.claude/**` and `CLAUDE.md`.
- **Application PHP, JS, Twig and `app/src/Service/Providers/**`** → `app-agent-team`.
- **`ApiResource` · `State` · `api_platform.yaml`** → `api-agent-team`.
- **Infrastructure, data and deployment assets** → `tools-agent-team`, or the `tools-app-deploy-skill`
  gate for a deploy verdict.
- **Messenger and RabbitMQ** belong to no orchestrator's roster → the Review mode of
  `/message-rabbitmq-skill`.
- **Never spawn a sibling orchestrator.** They are handoffs named in the report, not delegation targets.

### The one carve-out — a sibling may still commit its own work

`app-agent-team` and `api-agent-team` may call `utility-git-commit-skill` **as the terminal step of a
change-review they themselves ran**. This is deliberate and is **stated in the same words from both
sides** — `app-agent-team-rule.md` `## Invariant — delegation mechanism` carries the other half. The
reasoning: they cannot delegate to this team (the orchestrators never spawn one another), so forcing a
team switch merely to commit work that team just reviewed would strand the change.

- **The carve-out covers Commit only** — never diagrams, shell or `.claude`.
- **It does not make Commit shared.** A request that *starts* with a commit, or bundles one with
  utility-domain work, is this team's.
- **Do not re-run a commit a sibling already made**, and do not re-review its message.

## Invariant — sequencing (Commit runs last)

This is the team's one hard ordering constraint, and it is mechanical rather than stylistic.
`utility-git-commit-skill` gates on `git diff --cached` and compares a `staged-stat` fingerprint against
the live index at two points, so anything staged after the draft was written is caught as
`stale-or-missing-draft` — correctly, because the message would otherwise be committed against a diff
nobody wrote it for.

- **Delegate Commit only after every other delegation has reached a verdict**, and only after the user
  has staged what they intend to commit.
- **Never stage or unstage on the user's behalf.** What enters history is the user's decision.
- **Diagram, shell and `.claude` work has no interdependency** and may be delegated in any order; where
  genuinely independent, doing so in one response is preferred.
- **If a diagram or artifact write lands after a commit message was drafted**, say so and re-run the
  commit delegation from the start rather than committing the stale draft.

## Invariant — safety boundary and artifacts

- **The orchestrator never authors or modifies a target file itself.** `disallowedTools: Edit` enforces
  the no-modification half at the harness level; `Write` is scoped to `./.claude/tmp/utility/` and that
  half is self-held. `Bash` is **unrestricted** and can write (redirection, `tee`, `sed -i`,
  `git apply`) — the same boundary covers all of those.
- **`mcp__drawio-tool__set_page` is destructive and the pre-apply gate is mandatory.** It replaces the
  target page wholesale, so an omitted cell is a deletion. Compare the draft's `mxCell` count against a
  live `mcp__drawio-tool__get_page` **immediately before applying** — the reviewer's reading is a round
  old. A shortfall the revision intent does not explain means **stop and report, not apply**.
- **Never run `git push`, `git reset`, `git rebase`, or anything that rewrites history.**
- **Structure immutability applies to this team's own output too** — a warranted `.claude/**` move,
  rename or deletion is reported as `[CONSIDER]` with before/after paths, awaiting a user decision.
- **The consolidated report is returned in the response; the tmp copy is best-effort.** The path, when
  written at all, is fixed at `./.claude/tmp/utility/agent-team-report.md`. A `Write` there is **denied
  while the session is in plan mode** (`permissions.defaultMode: "plan"`, inherited because the
  orchestrator declares no `permissionMode`), and nothing in this repository reads the file — so a
  refused write is a non-event, must **not** be retried or worked around with `Bash`, and must **never**
  be reported as persisted.
- **Never hand-write into a skill's tmp subdirectory**, and never overwrite `tmp/app/**`, `tmp/api/**`
  or `tmp/tools/**`. Every draft carries a header line or a sidecar its reviewer gates on; a
  hand-written one is either rejected as `stale-or-missing-draft` or, worse, taken as a real draft.
- Never include a secret, credential or connection-string value in plaintext in any output — record the
  type and `file:line` instead of the value, and raise it as a `[MUST]`.

## Violation Severity

- **`[MUST]`** — skipping the step-0 preflight; spawning an agent outside the roster pattern, or a
  roster agent **outside a skill step**; spawning a sibling orchestrator; running a verification loop or
  retry counter of this team's own; re-running a skill that stopped at its own retry limit; performing
  `git commit -F` or `set_page` outside the owning skill or ahead of its gate; applying `set_page`
  without the live cell-count comparison; granting `isolation: worktree` to this orchestrator or to any
  of the 8 roster agents; staging or unstaging on the user's behalf; delegating Commit before another
  axis has a verdict; routing a multi-artifact decision to `utility-claude-code-skill`; a missing
  delegation-payload field; mixing domain rules in one payload; trespassing on another team's or a
  skill's tmp path; claiming a refused tmp write as persisted; tallying unchecked as passed; issuing a
  pass while an axis is unjudged; failing to report a routing-unmatched target; moving, renaming or
  deleting a `.claude/**` file; exposing a secret.
- **`[SHOULD]`** — omitting the mode from a `Skill` call; delegating the shell half of a deploy-context
  script separately instead of handing the gate the file; failing to merge duplicate findings across
  skills; serialising delegations that could run in one response; failing to name the handoff team;
  referring to a subagent's output instead of relaying it (the user cannot see it).
- **`[CONSIDER]`** — improvements that carry a structural change, such as widening the role axis (adding
  an analyzer, debugger or tester) or adding a fifth domain to the roster. Never apply without approval.

## Companion Updates

When the roster or a boundary changes, fix all of the following **in the same change**. Leave one out
and the descriptions diverge.

- `.claude/agents/utility-agent-team.md` — execution directives (roster table · routing table · checklist)
- `.claude/agent-memory/utility-agent-team/MEMORY.md` — the always-loaded context summary, including its `## Known gaps` list
- `.claude/docs/utility-agent-team-docs.md` — background · inventory · trade-offs
- `.claude/hooks/pre-tool-use/agent-roster-guard.sh` — the per-caller `case` table, whose `utility-agent-team` branch supplies `RULE_PATH` and `RULE_SECTION` for a blocked spawn. Both must keep pointing at this file and at a heading that exists in it
- The sibling teams' rules, agents and memory (`app-agent-team`, `api-agent-team`, `tools-agent-team`) — a boundary is described from both sides
- The four `## Shared Orchestration Contract` headings and their six numbered imperatives, which are worded identically across all four rules — never fix just one
- `.claude/rules/abstract-structure-rule.md` — the rule index row
- `.claude/workflows/README.md` — per-role entry points
- **A cross-cutting fact (worktree isolation, the spawn contract, gate semantics) lives in ~41 files.**
  Changing one means sweeping all of them, and a plain `grep` is **not** sufficient — the wording and
  line wrapping vary, which is how the 2026-09-09 isolation correction missed 13 agents on its first
  pass. Run the whitespace-normalising audit in `docs/abstract-orchestrator-contract-docs.md` §2-2,
  and consult §2-1 before assuming a site can be collapsed into an `@see`.
