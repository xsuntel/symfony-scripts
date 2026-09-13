---
paths:
  - ".claude/agents/app-agent-team.md"
  - ".claude/agent-memory/app-agent-team/**"
  - ".claude/docs/app-agent-team-docs.md"
---

# app-agent-team Orchestration Rules

This rule is the judgment criteria (SoT) for the **routing, roster and handoff invariants** of the
`app-agent-team` orchestrator. It covers the command boundary for the application itself (PHP, JS,
Twig), external provider consumption, and operational assets.

@see .claude/agents/app-agent-team.md — the orchestrator this rule judges (execution directives)
@see .claude/docs/app-agent-team-docs.md — team composition · role axes · verification loop rationale (not a SoT)
@see .claude/rules/api-agent-team-rule.md — the sibling orchestrator (exposure layer) verdict SoT
@see .claude/rules/tools-agent-team-rule.md — the sibling orchestrator (infrastructure · data · deployment) verdict SoT
@see .claude/agents/utility-agent-team.md — the sibling orchestrator (diagrams · commits · shell · `.claude`) it hands the utility surface to; its own rule file is a tracked follow-up
@see .claude/docs/abstract-orchestrator-contract-docs.md — rationale and measured values of the shared operational contract
@see .claude/rules/abstract-structure-rule.md — directory and path conventions · rule index (SoT)

## Judgment Scope (no overlap with other SoTs)

This domain's criteria are split four ways. **This rule owns only the third axis** and does not
restate the others.

| Axis | SoT | What it covers |
| --- | --- | --- |
| `.claude/**` structure and placement | `rules/utility-claude-code-rule.md` | directory tiers · flattening · frozen roots |
| Artifact spec | `skills/utility-claude-code-skill/references/artifact-spec-guide.md` | frontmatter · naming · tool minimality |
| **Orchestration invariants** | **this rule** | **roster boundary · handoff direction · fan-out · verdict-suspension conditions** |
| Code verdicts | each domain rule (`app-php-symfony-*` etc.) | the code standards the subagents cross-check |

**The duplication with the agent prompt is intentional.** A subagent starts from an empty context and
cannot reach this rule through `@see`, so the directives must be physically present in
`agents/app-agent-team.md`. When the two diverge **this rule is the SoT**, and they are revised
**in the same change**.

## Shared Orchestration Contract (identical across the three teams)

The six **numbered imperatives** below are worded identically across the `app`, `api` and `tools`
rules. Never fix just one. The **indented notes are deliberately team-specific** — they record what
each roster actually declares, which differs — so they are not part of the shared wording. The
rationale and measured values live in `docs/abstract-orchestrator-contract-docs.md` and are not
restated here.

1. **The orchestrators never spawn one another** (four as of 2026-09-11, with the addition of
   `utility-agent-team`). Out-of-scope files are handed over by naming the responsible team under
   `## Handoffs`, and are **never dropped silently**.
   > **One documented exception, in one direction only:** `api-agent-team` delegates its non-exposure
   > half to `app-agent-team` (Mode D). That arrives here as a caller, and this team must not bounce
   > the exposure-layer half back — see `## Invariant — Mode D`.
2. **All seven spawn-payload fields are mandatory** — target file list · role · governing rule (SoT)
   path · **output channel** · severity vocabulary · no secrets · marking of unrun gates. A missing
   field is a `[MUST]`.
   > **The fourth field is a channel, not always a path.** An agent declaring
   > `disallowedTools: Edit, Write` **cannot write a file**, so handing it a tmp path guarantees a
   > spawn that fails at its last step. Give a tmp path only to an agent that is both write-capable
   > and non-isolated; otherwise require the findings **in the returned report**.
3. **The orchestrator itself must never take `isolation: worktree`.** Its working material is the real
   tree — uncommitted `git diff` output and the live `.claude/tmp/**` — and a worktree is cut from the
   **default branch**, not from the parent's `HEAD`, so isolating it produces an empty verdict as a
   silent failure. (`[Verified]` 2026-09-11: the failure mode rests on the **base branch**, which has
   read the same across every sweep. Whether the tmp tree is absent or present-but-private depends on the
   untracked/gitignored rule, which has flipped between doc revisions — it is useless as a channel under
   either reading, so do not rest anything on that half.)
   > **This is a constraint on the orchestrator, not a blanket ban.** `[Verified]` 2026-08-30: **all
   > 15 `app-*` specialists set `isolation: worktree`** by design. The consequence is the opposite of
   > a prohibition — see `## Invariant — verification loop` for the inline-diff requirement it forces.
4. **Keep the tmp consolidated-report path isolated per team** — never overwrite another team's report.
5. **A gate that did not run is not a pass** — tally across three values: passed / failed / **unchecked**.
6. **Re-spawn a partial failure exactly once**; if it fails again, state it as "cannot judge (not
   performed)" and **suspend go/no-go**. Exhausting your own turns is also a partial failure, so
   record into the consolidated report incrementally.

## Invariant — roster (direct spawn targets)

- **The only direct `Agent` spawn targets are the 15 `.claude/agents/app-*-*.md` agents**
  (PHP · JS · Twig × `-author`, `-analyzer`, `-debugger`, `-reviewer`, `-tester`). A name that starts
  with `app-` but does not end in a role suffix is not a spawn target.
- **Never spawn yourself** — `app-agent-team` also matches the `app-` prefix but is excluded.
- **The three groups below are never direct-spawned**, under any circumstances. Each goes through a
  command, a skill, or a sibling orchestrator.

  | Forbidden spawn target | The correct route |
  | --- | --- |
  | The 6 infrastructure and data reviewers (`cache-`, `database-`, `message-`, `server-`, `tools-aws-`, `tools-gcp-`) | the 4 `/…-review` commands, or a `tools-agent-team` handoff (which direct-spawns 5 of the 6) |
  | The 8 `utility-*` author/reviewer agents (Diagram · Commit · Shell · Claude Code config) | a `utility-agent-team` handoff — or, for the Commit carve-out below, `utility-git-commit-skill` directly |
  | The 5 `api-platform-*` agents | an `api-agent-team` handoff |

  > **Only four `/…-review` commands exist for those six reviewers** — `/cache-redis-skill`,
  > `/database-postgresql-skill`, `/message-rabbitmq-skill` and `/server-nginx-skill`. `[Verified]`
  > 2026-08-30: **GCP Cloud Run and AWS ECS have no dedicated review command.** For those two, route
  > to the deploy gate skill or hand off to `tools-agent-team`; never invent a command name.

## Invariant — scope boundary and handoffs

- **Only the three paths `ApiResource`, `State` and `api_platform.yaml` belong to `api-agent-team`.**
  Everything else under `app/src/**`, `app/assets/**` and `app/templates/**` is concluded by this
  team. When in doubt about *application code*, handle it here.
- **The utility surface left this team on 2026-09-11** — `diagram/**`, `scripts/**/*.sh` outside a
  deploy context, `.claude/**` and `CLAUDE.md`, and commit messages are **`utility-agent-team`'s**.
  Hand them over by naming that team; **delegating to its skills from here is a `[SHOULD]` routing
  defect**, because the split between a single artifact and the artifact system is that team's to
  make. An earlier revision of this clause claimed all of `scripts/**`, `diagram/**` and `.claude/**`
  for this team — do not restore it.
- **Never hand `app/src/Service/Providers/**` to `api-agent-team`** — since the 2026-08-29 transfer,
  all provider consumption belongs to this team. Handing it over creates a **handoff loop** that comes
  straight back (observed in practice with Agencies).
  > ✅ **A provider path is routable — route it to the matching transport build skill.** `[Verified]`
  > 2026-09-09: `app-src-service-api-rest-build-skill`, `app-src-service-api-oauth2-build-skill` and
  > `app-src-service-api-websocket-build-skill` all exist. **This corrects a warning that stood from
  > 2026-08-30 to 2026-09-09**, which declared the domain unimplemented and required a provider path to
  > be reported as **unroutable**. The premise was a name mismatch: the domain shipped as **one
  > integration-agnostic skill per transport**, not as the five `api-providers-*-build-skill`
  > directories the old text searched for. Refusing routable work is now itself a `[MUST]`.
  > **What is genuinely absent is the per-integration criteria layer, and it is not a blocker.** No
  > `{integration}-api-*-rule.md` exists and each skill's `references/provider-registry.md` is an empty
  > table, so the skill falls back to the matching `*-client-skill` plus the `app-php-symfony-*` rules
  > and must **state which criteria it used**. Redirecting quietly to `app-php-symfony-reviewer`, which
  > holds no transport criteria, remains wrong.
- **When infrastructure, data or deployment assets span several domains, hand off to
  `tools-agent-team`.** For a single domain the matching `/…-review` command is enough.
  **Only `message-rabbitmq-reviewer` sits outside that team's roster**, so it stays with this team's
  `/message-rabbitmq-skill` skill — do not hand it to `tools-agent-team` because the name looks
  similar.
- **`.claude/**` is `utility-agent-team`'s, and so is the three-way split inside it** (single
  artifact → `utility-claude-code-skill`; the artifact **system** → `abstract-agentic-harness-skill`;
  review → the Review mode of `utility-claude-code-skill`, routed by **how many files the decision
  spans**, never by the request's wording). That table now lives in `agents/utility-agent-team.md`
  and is not restated here. Hand the work over rather than making the split yourself.
- **Never drop a routing-unmatched file silently** — a changed file matching no row is stated verbatim
  under `## Summary` in the consolidated report. A file handed to another team is a **handoff**, not
  an unmatched file.

## Invariant — Mode D (delegation from `api-agent-team`)

- **Take the caller's file list verbatim.** Do not re-expand it with `git diff`; anything added is
  outside the delegation.
- **Suppress the exposure-layer split.** Step 2 normally routes `ApiResource`/`State`/
  `api_platform.yaml` to `api-agent-team`; under Mode D that orchestrator is the caller, so the split
  would loop and burn both budgets. Report such a path as **already owned by the caller** and judge
  the rest.
- **Return findings for the caller to merge.** Do not emit go/no-go as though you were the top-level
  orchestrator.
- **The roster stays closed under Mode D.** A delegation frequently expects a Doctrine Entity reached
  through `stateOptions` to be judged, but `database-postgresql-reviewer` still may not be spawned —
  return `/database-postgresql-skill` as a referral and say plainly that the layer was not reviewed.

## Invariant — delegation mechanism

- **When deployment assets fall in scope, or an "is it safe to deploy" intent is confirmed, delegate
  to the `tools-app-deploy-skill` gate instead of spawning reviewers directly.** Direct spawning
  splits ownership of go/no-go.
- **Diagram and Commit skills own the draft guard, the retry limit and the final action**, so never
  direct-spawn their agent pairs. Both skills now belong to `utility-agent-team`; **the single
  exception is the terminal Commit** — this team may call `utility-git-commit-skill` directly to
  commit a change-review it ran itself, because it cannot delegate to a sibling orchestrator and a
  team switch merely to commit reviewed work would strand it. The carve-out covers **Commit only**,
  never diagrams, shell or `.claude`, and a request that *starts* with a commit is
  `utility-agent-team`'s. It is stated in the same words from both sides.
- **The delegation mechanism is the `Skill` tool.** Do not substitute reading `SKILL.md` with `Read`
  and improvising the procedure — that detour skips every control the skill owns.
- **Never invent an entry point that does not exist.** GCP Cloud Run and AWS ECS have **no** dedicated
  review mode: for a deployment verdict use the gate skill, and otherwise hand off to
  `tools-agent-team`.

## Invariant — verification loop and artifacts

- **Build uses template ① (the agent pair)** — a `*-author` edits `app/**` directly (it writes no
  draft file) and a `*-reviewer` issues the verdict.
- **The reviewer cannot reach the author's work through the working tree.** `[Verified]` 2026-08-30:
  all 15 `app-*` agents set `isolation: worktree`, author and reviewer are two separate `Agent` calls
  with two separate worktrees, and a worktree is branched from the **default branch rather than the
  parent's `HEAD`** (`[Verified]` 2026-09-11 — the operative fact is the base branch; the
  untracked/gitignored half has flipped between doc revisions, so nothing here rests on it). A reviewer told to run `git diff`
  therefore sees an **empty diff and reports a clean pass on work it never read**. **Paste the author's full unified diff inline into the reviewer's
  prompt.**
  > An earlier revision of this rule said the reviewer "judges by `git diff`". That is the exact
  > silent-failure this invariant exists to prevent; do not restore it.
- **The provider axis uses template ②** (build skill + self-verification) and is a **live instance**,
  not a design sketch. `[Verified]` 2026-09-09: the three transport build skills each run
  generate → self-verify → PASS/REDO with a **3-retry limit** and an explicit stopping condition (stop
  as-is, do not revert, recommend manual review). They self-verify against the matching `*-client-skill`
  rather than a command body, because no per-integration command is registered yet.
- **Retry limits** — code domains **3**, configuration and meta domains (commit, diagram, `.claude`,
  shell) **2**. Past the limit, do not revert the source; stop as-is and present the unresolved
  instructions. **The orchestrator owns this counter**, because each author states that it does not
  count retries.
- **Never pass downstream to the tester while a `[MUST]` remains** — the resolution cycle comes first.
- **The consolidated report is returned in the response; the tmp copy is best-effort.** The path,
  when written, is `./.claude/tmp/app/app-agent-team-report.md`. A `Write` there is **denied while the
  session is in plan mode** (inherited, since the orchestrator declares no `permissionMode`), and
  nothing reads the file — a refused write is a non-event and must never be reported as persisted.
  Never overwrite `tmp/api/**` or `tmp/tools/**`.

## Invariant — safety boundary

- **The orchestrator never modifies code directly.** `disallowedTools: Edit` enforces the
  no-modification half at the harness level; writes are confined to `./.claude/tmp/**`. Note that
  `Bash` is unrestricted and can write (redirection, `tee`, `sed -i`, `git apply`) — the same boundary
  covers all of those.
- **Destructive or irreversible operations** (production deployment, `terraform apply`, drawio
  `set_page`, deletion, permission changes) require announcing the blast radius and obtaining user
  approval before execution.
- Never include a secret or credential value in plaintext in any output — record the type and
  `file:line` instead of the value, and raise it as a `[MUST]`.

## Violation Severity

- **`[MUST]`** — direct-spawning outside the roster; the three teams spawning one another (Mode D
  excepted); handing `Service/Providers/**` to `api-agent-team`; direct-spawning reviewers on a deploy
  intent; direct-spawning the Diagram or Commit agents; granting the orchestrator
  `isolation: worktree`; **routing a reviewer to a path instead of pasting the author's diff inline**;
  trespassing on another team's tmp path; a missing spawn-payload field; assigning a tmp path to an
  agent that declares `disallowedTools: Write`; tallying unchecked as passed; issuing go while an axis
  is unjudged; failing to report a routing-unmatched file; exposing a secret.
- **`[SHOULD]`** — failing to spawn independent agents in parallel (6 or fewer at a time is the
  bound); failing to merge cross-matched duplicates (doctrine↔postgresql, the broad cache paths);
  failing to name the handoff team.
- **`[CONSIDER]`** — improvements that carry a structural change, such as rearranging a role axis or
  creating a new agent. Never apply without approval.

## Companion Updates

When the roster or a boundary changes, fix all of the following **in the same change**. Leave one out
and the descriptions diverge.

- `.claude/agents/app-agent-team.md` — execution directives (roster table · routing table · checklist)
- `.claude/agent-memory/app-agent-team/MEMORY.md` — the always-loaded context summary
- `.claude/docs/app-agent-team-docs.md` — background · inventory · trade-offs
- The sibling teams' rules, agents and memory (`api-agent-team`, `tools-agent-team`, `utility-agent-team`) — a boundary is described from both sides
- `.claude/hooks/pre-tool-use/agent-roster-guard.sh` — the per-caller `case` table that enforces each roster
- `.claude/workflows/README.md` — per-role entry points
- **A cross-cutting fact (worktree isolation, the spawn contract, gate semantics) lives in ~41 files.**
  Changing one means sweeping all of them, and a plain `grep` is **not** sufficient — the wording and
  line wrapping vary, which is how the 2026-09-09 isolation correction missed 13 agents on its first
  pass. Run the whitespace-normalising audit in `docs/abstract-orchestrator-contract-docs.md` §2-2,
  and consult §2-1 before assuming a site can be collapsed into an `@see`.
