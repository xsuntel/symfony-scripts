# Graph Engineering Guide — how it connects

The **"how it connects"** axis of `abstract-agentic-harness-skill`: how several loops connect (nodes =
agents, edges = routing). How an individual loop converges is out of scope.

**This is not judgment criteria** — roster invariants are SoT in the three `*-agent-team-rule.md` files,
structure and placement in `rules/utility-claude-code-rule.md`, and the shared rationale and
measurements in `docs/abstract-orchestrator-contract-docs.md`.

> Sibling axes: whether to create a node belongs to `harness-design-guide.md`, and the loop running
> inside a node belongs to `loop-engineering-guide.md`. The decision to create a new agent comes from
> the harness axis; **which roster it attaches to, and how**, is decided here.

## Contents

1. [This repository's graph](#1-this-repositorys-graph)
2. [Edges are decided by path, not by name](#2-edges-are-decided-by-path-not-by-name)
3. [The edge contract — the 7-field spawn payload](#3-the-edge-contract--the-7-field-spawn-payload)
4. [Edges are enforced by a hook](#4-edges-are-enforced-by-a-hook)
5. [Fan-out — the width has a limit](#5-fan-out--the-width-has-a-limit)
6. [Consolidation — where the nodes converge](#6-consolidation--where-the-nodes-converge)
7. [Graph integrity check](#7-graph-integrity-check)
8. [Creating a new orchestrator](#8-creating-a-new-orchestrator)
9. [Dynamic workflows](#9-dynamic-workflows--this-repository-does-not-use-them-yet)

---

## 1. This repository's graph

Claude Code already supplies the graph-engineering primitives — **a sub-agent is a node, a delegating
orchestrator is a routing node, and the routing between them is an edge**. This repository uses that as
a three-root forest.

```text
        main conversation (routing)
        ├── app-agent-team   ──► app-*-{author,analyzer,debugger,reviewer,tester}, 15 agents
        │      └─(Skill)────► domain review modes · the deploy gate · commit and diagram skills
        ├── api-agent-team   ──► api-platform-{author,analyzer,debugger,reviewer,tester}, 5 agents
        └── tools-agent-team ──► cache-* · database-* · server-* · tools-aws-* · tools-gcp-*
```

**The four orchestrators never spawn one another.** The edges between them are **handoffs**, not
spawns: name the owning team explicitly and **never drop the work silently**.

| Axis | Owns | Roster definition | tmp |
| --- | --- | --- | --- |
| `app-agent-team` | the app proper (PHP · JS · Twig) · **all provider consumption** · operations and configuration | `^app-.+-(author\|analyzer\|debugger\|reviewer\|tester)$` | `.claude/tmp/app/` |
| `api-agent-team` | the API Platform exposure layer only | `^api-platform-(author\|analyzer\|debugger\|reviewer\|tester)$` | `.claude/tmp/api/` |
| `tools-agent-team` | infrastructure · data · deployment | `^(cache\|database\|server\|tools-aws\|tools-gcp)-.+$` | `.claude/tmp/tools/` |

> **`app-agent-team`'s `Skill` edges are not symmetric with its `Agent` edges.** It delegates to the
> domain `/…-review` commands, `tools-app-deploy-skill`, `utility-git-commit-skill`,
> `utility-drawio-diagram-skill` and the three provider transport build skills
> (`app-src-service-api-{rest,oauth2,websocket}-build-skill`) — **all of which exist**
> (`[Verified]` 2026-09-09).
>
> **Corrected 2026-09-09 — this note used to call the provider edge dead.** It said no
> `api-providers-*-build-skill` directory was on disk and that a provider-path change was
> **unroutable**. Both halves were an artefact of searching for the **design-era name**: the domain
> shipped as one integration-agnostic skill per transport, not five per-provider ones. Do not report a
> provider path as unroutable. What is still missing is the **per-integration criteria layer** (no
> `{integration}-api-*-rule.md`, empty `provider-registry.md`), for which each build skill has a defined
> fallback — see `loop-engineering-guide.md` §1.

---

## 2. Edges are decided by path, not by name

**Routing ownership is decided by the target code path.** Inferring it from a prefix gets it wrong.

| Target code path | Owner |
| --- | --- |
| `app/src/ApiResource/**` · `app/src/State/**` · `api_platform.yaml` | `api-agent-team` |
| every other `app/src/**` (providers included) · `app/assets/**` · `app/templates/**` · `scripts/**` · `diagram/**` · `.claude/**` | `app-agent-team` |
| Redis · Doctrine/PostgreSQL · Nginx · Cloud Run · ECS assets | `tools-agent-team` |

The verdict SoT for this table is `rules/app-agent-team-rule.md`,
`## Invariant — scope boundary and handoffs`, and its two siblings.

**Three boundary cases that are repeatedly got wrong:**

1. **Provider consumption belongs to `app-`** (transferred 2026-08-29), and the route is **live**:
   `app/src/Service/Providers/**` dispatches by transport to
   `app-src-service-api-{rest,oauth2,websocket}-build-skill`. `[Verified]` 2026-09-09 — this item
   previously concluded that a provider-path change was "unroutable" because "the artifacts were never
   built"; the **skill layer was built**, under a transport-agnostic naming scheme. Only the
   per-integration **rule** layer is absent, and the skills define a fallback for it.
2. **`message-rabbitmq-reviewer` is outside the `tools-agent-team` roster** — it matches none of the
   five prefixes, so it is reached through `app-agent-team`'s `/message-rabbitmq-skill` skill. Do
   not pull it in because the name looks like infrastructure.
3. **`tools-agent-team` itself starts with `tools-` but does not match its own roster** — the pattern
   is `tools-aws-` / `tools-gcp-` only, so it is excluded at the glob level.

**A roster is defined by prefix rather than by a fixed list, and is resolved by preflight on every
invocation.**

---

## 3. The edge contract — the 7-field spawn payload

**Every sub-agent starts from an empty context.** It inherits nothing from the orchestrator's context,
and `@see` is a notation rather than an import, so **it only arrives if the agent `Read`s it**. The
edge is the contract that fills that gap.

```text
1. target file list (no summarizing, no eliding)   5. severity notation convention
2. exactly one role                                6. no secrets
3. the governing rule (SoT) path                   7. how to report an unrun gate
4. output path
```

Which failure each field prevents is owned by the table in
`docs/abstract-orchestrator-contract-docs.md` §1. It is not restated here.

**Field 1 carries a second obligation under worktree isolation.** 19 of the domain agents run in their
own worktree and therefore **cannot see the parent session's uncommitted edits** — so when the spawn is
the reviewer half of an author→reviewer loop, the author's **full unified diff must be inlined as text**
in the prompt. Routing a reviewer to a path and assuming it can reach the bytes is the highest-cost
silent failure available here. Details in `loop-engineering-guide.md` §5-1 and contract §2.

**Do not mix layers in field 3.** `app-agent-team` holds both the app proper
(`app-php-symfony-*-rule.md`) and provider consumption in one team. No **integration-specific** rule
file exists yet, so field 3 for a provider path names the **documented fallback** — the matching
`app-src-service-api-*-client-skill` plus the `app-php-symfony-*` rules — and the executor must state
which criteria it used. `[Verified]` 2026-09-09: this paragraph previously said such a spawn had "no
SoT to name". Do not substitute `app-php-symfony-*` **alone**, which holds no transport criteria.

---

## 4. Edges are enforced by a hook

`.claude/hooks/pre-tool-use/agent-roster-guard.sh` compares `agent_type` (the caller) against
`tool_input.subagent_type` (the target) and **blocks an out-of-roster spawn with `exit 2`**.

**Why the hook is necessary** — every other mechanism is unfit:

| Alternative | Why it fails |
| --- | --- |
| a `tools: Agent(a, b)` parenthesised allowlist | it looks like an allowlist and is not. It applies only to an agent arriving on the main thread via `claude --agent`; **in a sub-agent definition the type list inside the parentheses is silently ignored** |
| `permissions.deny` | a repo-wide denylist, so expressing "only these five prefixes, and only for this caller" means enumerating everything else — and it would also block a sibling orchestrator's legitimate spawns |

**The rule is SoT and the hook follows it.** The hook holds no criteria of its own; it is an executable
projection of the rules, so when a roster changes, **fix the rule and the hook's `case` table in the
same commit**.

**There is one path where the guard silently stops guarding** — when `jq` is missing it prints a warning
and exits `1` (non-blocking). The roster constraint is **unenforced** for that call. If you see the
warning, say so in the report.

### 4-1. The guard covers the `Agent` tool, and only the `Agent` tool

`[Verified]` 2026-09-10 — the hook is registered in `settings.json` with matcher **`Agent|Task`**, and
its own body exits `0` immediately for any other `tool_name`, reading the target out of
`tool_input.subagent_type`. So the guard sees a spawn **only when a spawn is a tool call.**

That matters because the skill spec provides a second way to reach a subagent. A skill declaring
`context: fork` selects its executor through the **`agent:` frontmatter field**, not through the `Agent`
tool (`[Verified]` 2026-09-10 [WebFetch: <https://code.claude.com/docs/en/skills>] — "The `agent` field
specifies which subagent configuration to use … If omitted, uses `general-purpose`"). `[Inferred]` the
hook therefore does not fire on that path.

**Treat this as unverified and blocking, not as a known hole.** Nothing in this repository uses
`context: fork` today (`[Measured]` 2026-09-10 — zero artifacts), so the exposure is currently
theoretical. Before adopting it anywhere inside an orchestrator's scope, **test empirically whether a
fork emits an `Agent` tool call.** If it does not, then a forked skill naming a custom `agent:` is an
**unguarded spawn path**, and the roster invariant would rest on prose alone — which the three
orchestrator prompts state outright cannot be delegated to the harness. In that case either keep
`context: fork` out of orchestrator scope, or extend the hook's matcher before adopting it.

`artifact-selection-guide.md` §2 owns the decision of *whether* to reach for `context: fork` at all;
this section owns only what it does to the edge-enforcement guarantee.

---

## 5. Fan-out — the width has a limit

`maxTurns` is the whole orchestration budget (`[Verified]` 2026-09-06 — **app 50 · api 50 · tools 40**),
and **a spawn and its return each consume a turn**.

- Cap parallel spawns at **6 per batch**.
- With more targets than that, split into batches by priority (code domains → infrastructure) and report
  the remainder as **deferred** — never drop it silently.
- Never spawn the same agent on the same file twice in one invocation.
- **Run independent branches in parallel.** The only sequential edge is the author→reviewer loop.
- When the budget runs out, stop spawning, consolidate what returned, and name the targets left untouched.
- **Nested spawn depth is 3 layers** (`CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH`, default 3). At the cap the
  harness **withholds** the `Agent` tool rather than erroring, so the agent quietly does the work itself.
- **A separate cap of 20 concurrent sub-agents applies** (`CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS`).
  Exceeding it fails the spawn with `Concurrent subagent limit reached` — unlike the depth cap, this one
  is loud.

`api-agent-team → app-agent-team → specialist` already fills the depth budget with **zero headroom**;
`tools-agent-team` spawns no orchestrator, so it keeps one layer spare.

**The agent-teams experiment is off** (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS: "0"`), and the reason
matters because it was once recorded wrongly. The operative reasons are:

- **No nested teams — teammates cannot spawn teammates of their own.** This is the decisive one: all
  four orchestrators exist to spawn or delegate, and `api-agent-team` additionally delegates to `app-agent-team`.
  Promoted to teammates, that entire routing layer stops working.
- **No background sub-agents from in-process teammates** — a teammate spawning a `background: true`
  agent errors.
- A teammate is a full Claude Code session, so it costs more tokens than orchestration that only needs a
  returned report.

> **Retired claim, do not repeat it:** that a teammate returns "an idle notification instead of its
> result". The live documentation says the opposite — a finishing teammate notifies the lead and
> **includes its final answer**. The `"0"` verdict stands; only its justification changed.

The `agent-team` in the four orchestrators' names is **just their name** and has nothing to do with that
harness feature.

---

## 6. Consolidation — where the nodes converge

- Duplicate findings on the same file and line **merge into one at the strictest severity**. Several
  reviewers matching at once across domains is normal.
- Sort `[MUST]` > `[SHOULD]` > `[CONSIDER]`, and **only `[MUST]` blocks a merge**.
- **A sub-agent's final report is not shown to the user.** Restate anything they need to know in the
  consolidated report — never write "see the reviewer's output".
- **Do not forget the scope verdict** — if files were handed off to a sibling orchestrator, do not issue
  a go/no-go over that scope.
- The three teams' consolidated report paths are separate, so they cannot overwrite one another.

> **The tmp report is best-effort, not guaranteed.** The orchestrators hold `Write` but declare no
> `permissionMode`, so they inherit the session's mode — and `permissions.defaultMode` is `plan`, which
> is read-only. **The returned report is the required channel.** Never report a tmp path as written when
> the write was refused, never retry a refused write, and never reach for `Bash` redirection to defeat
> the permission mode.

---

## 7. Graph integrity check

**Routing tables go stale faster than the tree does.** Treat every rule, agent, skill and command a
spawn prompt cites as **unverified until checked**.

```bash
# 1. Orphan nodes — agents matching no roster regex
for f in .claude/agents/*.md; do n=$(basename "$f" .md)
  echo "$n" | grep -qE '^(app-.+-(author|analyzer|debugger|reviewer|tester)|api-platform-(author|analyzer|debugger|reviewer|tester)|(cache|database|server|tools-aws|tools-gcp)-.+|(app|api|tools)-agent-team)$' \
    || echo "  outside every roster: $n"
done

# 2. Dead edges — do the artifacts the orchestrators point at actually exist?
grep -rhoE '\.claude/[A-Za-z0-9/._-]+\.(md|sh)' .claude/agents/*-agent-team.md | sort -u | \
  while read -r p; do [ -e "$p" ] || echo "  MISSING: $p"; done

# 3. Roster ↔ hook sync — do the rules' prefixes match the hook's case table?
grep -n 'ALLOW_PATTERN' .claude/hooks/pre-tool-use/agent-roster-guard.sh

# 4. Preflight — does every delegation target skill actually load?
find .claude/skills -name SKILL.md | wc -l
ls -d .claude/skills/*/ | wc -l          # a mismatch is the defect

# 5. Cross-cutting claim drift — a plain grep is NOT sufficient here (see below)
python3 - <<'EOF'
import pathlib, re
CLAIMS = ["tracked content only", "absent from your worktree", "absent from every worktree"]
for p in sorted(pathlib.Path(".claude").rglob("*.md")):
    body = re.sub(r"```.*?```", " ", p.read_text(), flags=re.S)   # drop fences: this script quotes CLAIMS
    flat = re.sub(r"\s+", " ", body)
    for c in CLAIMS:
        for m in re.finditer(re.escape(c), flat):
            ctx = flat[max(0, m.start()-260):m.end()+60]
            if not any(k in ctx for k in ("Corrected", "corrected", "previously", "passage said")):
                print(f"STALE {p}")
EOF
```

**Check 5 exists because check-by-grep failed twice on the same fact.** The worktree-isolation
correction of 2026-09-09 touched **41 files**, and the first pass missed **13** — every one of them an
agent that happened to wrap the phrase across a line break (`tracked content\nonly`). **Normalise
whitespace before matching any claim that spans more than a few words**, and keep the retired wording
as the search key. The owner of that particular claim, and its `CLAIMS` list, is
`docs/abstract-orchestrator-contract-docs.md` §2-2.

> **Do not "fix" this duplication by pointing the agents at the contract with `@see`.** 22 of the 41
> sites are agent prompts, which start cold — `@see` is a notation, not an import. Contract §2-1 holds
> the per-kind table of which sites may be replaced by a pointer and which may not.

**"Outside every roster" in check 1 is not automatically a defect** — `message-rabbitmq-reviewer` and
the four `utility-*` agents are deliberately outside and are reached through command and skill entry
points. It is an orphan node **only when no path reaches it at all**.

**When a target is missing, do not substitute a near-match and do not skip it silently** — name the path
that was expected and **report it as unroutable**. A missing artifact is a defect worth surfacing, not
an obstacle to route around.

**Checking that a file exists is not enough.** Ten provider skills once existed on disk yet **never
loaded**, because they were nested (19 of 29 loaded). Commands of the same name registered correctly
under a `:` namespace, so the listing mixed the two and the skills read as present — and the instruction
"route only through the build skills" **failed silently**. That is why check 4 runs every time.

### Review checklist

- [ ] Does the new node match **exactly one** roster regex (or is it deliberately outside)?
- [ ] If a roster changed, were **the rule · the orchestrator's routing table · the hook `case`** all
      fixed together?
- [ ] Do handoffs **not cycle** — two teams passing to each other so nobody handles the work?
      (Agencies actually fell into this loop, and it is what prompted creating `tools-agent-team`.)
- [ ] Is fan-out width ≤ 6 per batch, and within the 20-concurrent cap?
- [ ] Do the tmp paths separate by team?
- [ ] Does `isolation` on each node match the **domain-scope** convention (see
      `loop-engineering-guide.md` §5-1), rather than being copied from a role axis?
- [ ] Does a node that must delegate carry `Skill` in `tools`?

---

## 8. Creating a new orchestrator

**Ask first whether three is insufficient.** It has been done once (2026-08-29, `tools-agent-team`), on
two grounds:

1. **The rules and tools did not overlap** — infrastructure, data and deployment judge by different
   criteria than the code domains.
2. **A handoff loop had formed** — Agencies (ECOS · KOSIS) fell between two teams and neither handled it.
   That it was an **observed** failure rather than an anticipated risk is the important part.

Creating one means **maintaining the boundary description across three files**. If routing misjudgment
has not actually been observed, widening an existing roster is cheaper.

The three slugs to create together (all three teams have been symmetric since 2026-08-30), plus memory:

```text
agents/{axis}-agent-team.md               ← the execution instructions themselves
rules/{axis}-agent-team-rule.md           ← roster invariants (verdict SoT)
docs/{axis}-agent-team-docs.md            ← team composition · role axes · trade-offs (not criteria)
agent-memory/{axis}-agent-team/MEMORY.md  ← if it declares memory: project
```

Then add a new branch to the `case` in `hooks/pre-tool-use/agent-roster-guard.sh`. The per-artifact
detail of that bundle is in `orchestration-guide.md`.

---

## 9. Dynamic workflows — this repository does not use them yet

**A dynamic workflow is what the official documentation means by "the graph moved into code".** The
script itself holds the loops, branches and intermediate results, so only the final answer lands in
Claude's context.

`[Verified]` 2026-09-06 — **`.claude/workflows/` holds `README.md` and nothing else; there are zero
`.js` files.** Neither `disableWorkflows`, `workflowSizeGuideline` nor `ultracode` is set in
`settings.json`.

**So this guide does not presuppose workflows.** Adopting them requires the following first.

### Steps required before adoption

1. **Re-examining the placement requires user approval.** `utility-claude-code-rule.md` states it:
   saving a `.js` puts **a reference document (`README.md`) and an executable artifact in one
   directory**, which triggers a placement review, and that falls under `## When a Structure Change
   Seems Warranted`.
2. **Check for `/` namespace collisions.** A saved workflow becomes `/<name>` from its `meta.name` and
   shares **one namespace with commands, skills and built-ins**. This repository has zero collisions
   only because of the `-skill` / `-review` · `-build` · `-test` suffix split, so a workflow name must
   follow the same convention.
3. **Respect the `meta` block constraints.** `export const meta` must be the **first statement** and a
   **plain object literal** with `name` and `description`. A variable, function call or spread makes it
   **silently vanish** from `/` autocomplete.
4. **Know the determinism constraint.** The runtime **throws** on `Date.now()`, `Math.random()` and
   argument-less `new Date()`, so a re-run repeats the same `agent()` calls. Pass timestamps in through
   `args`.
5. **Design around the runtime limits** — 16 concurrent agents, 4,096 items per `parallel()` /
   `pipeline()` call, 1,000 agents total per run, no module loading (`import()` fails before execution),
   and no filesystem or shell access from the script itself.
6. **Know the resume cost** — a failure mid-fan-out **re-runs every agent after it**. In an A·B·C·D
   sequence, a failure at B serves A from cache and re-runs B·C·D.

**Until then this repository's graph is four orchestrators plus sub-agent fan-out, and sections 1–8 are
the whole of it.**
