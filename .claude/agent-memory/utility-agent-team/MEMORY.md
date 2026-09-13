# utility-agent-team memory

> Created 2026-09-11. The utility surface — diagrams, commits, shell, `.claude/**` — transferred here
> from `app-agent-team` in the same change, so a claim that it still owns this surface is stale text,
> not a competing boundary.

## Role (verified)

- **Four domains, one entry point each** — `diagram/**` · the staged set · `scripts/**/*.sh` ·
  `.claude/**`. Every job is delegated with the **`Skill` tool**; you author nothing and hold no
  judgment criteria (each skill resolves its own rule as SoT).
- **Four orchestrators** — app code and providers → `app-agent-team`; the exposure layer
  (`ApiResource`, `State`, `api_platform.yaml`) → `api-agent-team`; infrastructure/data/deployment →
  `tools-agent-team`. **They never spawn one another**; out-of-scope work is handed over by name.
- **Self and siblings fall out at the pattern level** — `utility-agent-team` does not match the roster
  regex, so the guard refuses a self-spawn for free.

## Structural trait — it delegates loops, it does not run them

- **No verification loop and no REDO counter of its own.** All four skills run an author→reviewer pair
  (template ①) capped at **2 retries**; shell-script and claude-code joined 2026-09-11. **The retry
  budget is always the skill's.**
- **No `utility-*` analyzer, debugger or tester exists** — those axes are **empty by design**; do not
  invent one. Hence `maxTurns: 40` (vs the app/api siblings' 50): routing, delegation and consolidation
  is the whole budget.

## Facts not to regress

1. **A skill runs in your own context** — `Skill` injects instructions into your turn; it is not a
   worker. No utility skill declares subagent frontmatter.
2. **That is why you hold `Agent`.** All four loop-skills say "Call the … agent", and **you** make that
   call. It exists for that and nothing else — **never spawn on your own initiative.** Same for
   `mcp__drawio-tool__set_page`: the apply runs as you.
3. **`set_page` replaces the page wholesale.** The pre-apply cell-count gate is **required** — compare
   the draft's `mxCell` count against a live `get_page` immediately before applying; an unexplained
   shortfall means stop and report.
4. **Commit is terminal.** The author stamps a `staged-stat` fingerprint in a sidecar; the reviewer and
   the pre-commit re-check compare it against the live index, so anything staged after the draft
   invalidates it. **Never stage on the user's behalf.**
5. **The roster guard is a backstop, not the rule** — it blocks a `subagent_type` outside the pattern
   or one that does not resolve on disk, but cannot tell a skill step from an improvised spawn.
6. **`settings.json`**: `defaultMode: "plan"` `:137` · `ask: ["Bash(git push:*)"]` `:138` (siblings'
   `:94` is **stale**). **Relay the findings** — a subagent's report is not shown to the user, and
   **preflight every target kind**: skill **and its mode**, agent, and any rule cited as SoT.

## Routing (target → skill + mode)

> Re-confirm with the step-0 preflight. The globs are a **working map, not the authoritative list** —
> each rule's own `paths` wins.

- `diagram/**/*.drawio` → `utility-drawio-diagram-skill` — **Author** / **Review**
- the staged set → `utility-git-commit-skill` (single mode)
- `scripts/**/*.sh` outside a deploy context → `utility-shell-script-skill` — **Author**/**Review**/**Guide**
- **one** artifact under `.claude/**` or `CLAUDE.md` → `utility-claude-code-skill` — **Author**/**Review**
- the `.claude/**` **system** (new domain or role axis, roster/routing change, drift audit, a loop that
  will not converge) → `abstract-agentic-harness-skill`
- **Always name the mode.** Author writes; Review does not write at all.

## Over-matching (3 cases)

1. **shell ↔ deployment assets.** `scripts/deploy/**/*.sh` and `scripts/containers/prod/**` are both.
   **In a deploy context the gate wins** — `tools-app-deploy-skill` already fans out to the shell skill,
   so delegating the shell half separately yields two verdicts on one file.
2. **`scripts/**/nginx/**` is configuration, not shell** — `server-nginx-rule.md`, so
   `tools-agent-team`, despite living under `scripts/`.
3. **one artifact ↔ the artifact system.** Route `.claude/**` by **how many files the decision spans**,
   never by wording — a multi-artifact decision sent to `utility-claude-code-skill` authors one file
   well and never sees the roster entry, guard `case` table or index row that had to move with it. A
   design handed down from `abstract-agentic-harness-skill` is already scoped; do not widen it.

## Sequencing

- **Commit last**, after every other axis reached a verdict (fact 4). If a write lands *after* a message
  was drafted, re-run the commit delegation rather than committing the stale draft. Diagram, shell and
  `.claude` work has no interdependency — any order, preferably one response.
- **Carve-out:** `app-agent-team` and `api-agent-team` may call `utility-git-commit-skill` as the
  terminal step of a change-review **they ran themselves** — they cannot delegate to you, so a team
  switch merely to commit would strand it. **Commit only**; a request that *starts* with a commit is
  yours. Never re-review a sibling's commit.

## Not in the roster (do not confuse)

- **The 8 agents are the skills', not yours** —
  `utility-{drawio-diagram,git-commit,shell-script,claude-code}-{author,reviewer}`, which is also the
  guard's regex. Spawn them only as a step of the skill that owns them.
- **The shell-script pair was restored and the claude-code pair created on 2026-09-11.** Text saying
  either "does not exist" is **stale**. `.claude/commands/` is retired and empty; every former
  `/…-review` is a **mode** of its paired skill — never tell a user to type one.
- **`abstract-agentic-harness-skill` carries no domain prefix** by design — bound to no domain, holding
  no criteria. Not a taxonomy violation.
- **`message-rabbitmq-reviewer` belongs to no orchestrator's roster** → `/message-rabbitmq-skill`.

## tmp paths (collision hazard)

- Yours: **`./.claude/tmp/utility/agent-team-report.md`**, fixed, best-effort. The skills' own:
  `tmp/utility/{drawio,git,shell-script,claude-code}/` — **never hand-write into any of them**; each
  draft carries a header (drawio) or a sidecar (the other three) that its reviewer gates on, because
  line 1 of a commit message, a script and a `.claude` artifact must be the message, the shebang and
  `---`. `tmp/{app,api,tools}/` are the siblings'.
- **`.claude/tmp/` is never cleaned** (`Bash(rm:*)` denied) — hence the round number and fingerprint.
  `mkdir -p` the full parent chain before writing.
- **A `Write` there is refused in plan mode** (inherited; no `permissionMode`). Nothing reads the file,
  so a refusal is a **non-event** — no retry, no `Bash` workaround, never reported as persisted; the
  **returned report is the required channel.**

## Verdict & safety

- ≥ 1 `[MUST]` → blocked; 0 → pass; an unjudged axis **suspends** the verdict. **Tally across passed /
  failed / unchecked** — `exit 0` from a `PostToolUse` gate means "skipped" when its precondition is
  missing (no `app/vendor` makes php-cs-fixer, PHPStan and `lint:twig` inert; `scripts/.shellcheckrc`
  disables six rules project-wide).
- **A skill that stopped at its own retry limit is not a failure to re-delegate.** Relay
  "auto-approval limit reached — manual review recommended" verbatim, present the last draft, stop.
- **Two irreversible actions run through this team** — `git commit -F` and `set_page`. Both belong to
  their skill: never run either outside its procedure, ahead of its gate, or to "fix up" a result. Check
  `git status` before diagram work. Never push/reset/rebase or stage for the user.
- **Structure immutability** — never move, rename or delete anything under `.claude/**`, never
  re-introduce a directory tier; a warranted change is `[CONSIDER]` + before/after paths awaiting the
  user. Never output a secret — record type and `file:line`, raise `[MUST]`.
- `## Actions taken` is mandatory — exactly what landed (commit hash, page name, artifact path).

## Known gaps — closed 2026-09-13

Rule, docs, the `abstract-structure-rule.md` index + reference rows and the `workflows/README.md` entry
all exist now, and `agent-roster-guard.sh` points `RULE_PATH` at the rule. Created 2026-09-11 without
them, this team grew workarounds at three sites in two days — create agent + rule + docs + memory **in
one change**. **Still open** (do not imitate): `utility-git-commit-skill` has no `## Modes` or `references/`,
and `docs/utility-git-commit-docs.md` is a 0-byte stub in `TODO.md`. The guard cannot verify *why* a
spawn happened. Detail: `docs/utility-agent-team-docs.md` §6. Counts read **four orchestrators /
38 agents** (34 specialists) everywhere.

## SoT

- **Own rule: .claude/rules/utility-agent-team-rule.md** (verdict SoT) · design: .claude/docs/utility-agent-team-docs.md
- Rules: .claude/rules/utility-{drawio-diagram,git-commit,shell-script,claude-code}-rule.md
- Artifact spec: .claude/skills/utility-claude-code-skill/references/artifact-spec-guide.md
- Styles: .claude/output-styles/utility-{drawio-diagram,git-commit,shell-script}-style.md
- Contract: .claude/docs/abstract-orchestrator-contract-docs.md · Index: .claude/rules/abstract-structure-rule.md
- Siblings: .claude/agents/{app,api,tools}-agent-team.md
