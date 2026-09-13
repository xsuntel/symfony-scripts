# utility-agent-team memory

> Created 2026-09-11. The utility surface — diagrams, commits, shell, `.claude/**` — was transferred
> here from `app-agent-team` in the same change (its agent, rule and memory were updated to match), so
> a claim that `app-agent-team` still owns this surface is stale text, not a competing boundary.

## Role (verified)

- **Four domains, one entry point each** — `diagram/**` · the staged set (commit messages) ·
  `scripts/**/*.sh` · `.claude/**`. Every job is delegated with the **`Skill` tool**; you author
  nothing yourself, and you hold no judgment criteria (each skill resolves its own rule as SoT).
- **Four orchestrators exist** — app code (PHP, JS, Twig) and providers → `app-agent-team`; the
  exposure layer (`ApiResource`, `State`, `api_platform.yaml`) → `api-agent-team`;
  infrastructure/data/deployment → `tools-agent-team`. **They never spawn one another**; out-of-scope
  work is handed over by name and never dropped silently.
- **Self and siblings fall out at the pattern level** — `utility-agent-team` does not match
  `^utility-(drawio-diagram|git-commit|shell-script|claude-code)-(author|reviewer)$`, so the guard
  refuses a self-spawn for free.

## Structural trait — it delegates loops, it does not run them

- **No verification loop of its own, no REDO counter of its own.** **All four skills run an
  author→reviewer agent pair (template ①) capped at 2 retries** — shell-script and claude-code joined
  them on 2026-09-11, when those pairs were created and the skills handed their self-verification over.
  **The retry budget is always the skill's.**
- **No `utility-*` analyzer, debugger or tester exists** — those three role axes are **empty by
  design**, not by omission. Do not invent one; preflight will fail.
- Hence `maxTurns: 40`, matching `tools-agent-team` rather than the app/api siblings' **50** — routing
  plus delegation plus consolidation is the whole budget.

## Facts not to regress

1. **A skill runs in your own context** — the `Skill` tool injects instructions into your turn; it is
   not a worker. No utility skill declares subagent frontmatter.
2. **That is why you hold `Agent`.** All four loop-skills say "Call the … agent" in their loop, and
   **you** make that call; without `Agent` the skill cannot run past that step. The tool exists for that and
   nothing else — **never spawn on your own initiative.** Same reason for
   `mcp__drawio-tool__set_page`: the diagram apply step runs as you.
3. **`set_page` replaces the page wholesale.** The **pre-apply cell-count gate is required, not
   advisory** — compare the draft's `mxCell` count against a live `get_page` immediately before
   applying. An unexplained shortfall means stop and report.
4. **Commit is terminal.** The author stamps a `staged-stat` fingerprint in a sidecar; the reviewer and
   the skill's pre-commit re-check both compare it against the live index, so anything staged after the
   draft invalidates it. **Never stage on the user's behalf.**
5. **The roster guard is a backstop, not the rule** — it blocks a `subagent_type` outside the
   eight-agent pattern, and one that does not resolve on disk, but cannot tell a legitimate skill step
   from an improvised spawn of the same agent.
6. **`settings.json` lines (2026-09-11)**: `cleanupPeriodDays: 30` `:5` · `outputStyle:
   abstract-english-style` `:8` · `defaultMode: "plan"` `:137` · `ask: ["Bash(git push:*)"]` `:138`.
   The siblings' older `:94` citation for `git push` is **stale** — do not copy it.
7. **Relay the findings** — a subagent's report is not shown to the user. And **preflight covers every
   target kind**: skill **and its mode**, agent, and any rule cited as SoT (a skill told to read a
   missing rule improvises; an unlisted mode leaves it guessing).

## Routing (target → skill + mode)

> Re-confirm with the step-0 preflight. The globs are a **working map, not the authoritative list** —
> each rule's own `paths` wins, so read the rule when a call is close.

- `diagram/**/*.drawio` → `utility-drawio-diagram-skill` — **Author** to create/edit, **Review** to judge
- the staged set → `utility-git-commit-skill` (single mode)
- `scripts/**/*.sh`, outside a deploy context → `utility-shell-script-skill` — **Author** to write or
  refactor, **Review** to judge an existing file, **Guide** for "how do I write this"
- **one** artifact under `.claude/**` or `CLAUDE.md` → `utility-claude-code-skill` — **Author** or **Review**
- the `.claude/**` **system** (new domain or role axis, roster/routing change, drift audit, a loop
  that will not converge) → `abstract-agentic-harness-skill`
- **Always name the mode in the `Skill` call.** Author writes; Review does not write at all.

## Over-matching (3 cases)

1. **shell ↔ deployment assets.** `scripts/deploy/**/*.sh` and `scripts/containers/prod/**` are both.
   **In a deploy context the gate wins** — `tools-app-deploy-skill` already fans out to
   `/utility-shell-script-skill`, so delegating the shell half separately yields two verdicts on one
   file. Outside one, the shell skill's Author or Review mode.
2. **`scripts/**/nginx/**` is configuration, not shell** — matches `server-nginx-rule.md`, belongs to
   `tools-agent-team` despite living under `scripts/`.
3. **one artifact ↔ the artifact system.** Route `.claude/**` by **how many files the decision spans**,
   never by the request's wording — a multi-artifact decision sent to `utility-claude-code-skill`
   authors one file well and never sees the roster entry, the guard `case` table or the index row that
   had to move with it. A design handed back down from `abstract-agentic-harness-skill` is already
   scoped: pass it through per file, do not widen it.

## Sequencing

- **Commit last**, after every other axis reached a verdict (fact 4 above). If a write lands *after* a
  message was drafted, re-run the commit delegation from the start rather than committing the stale
  draft.
- Diagram, shell and `.claude` work has no interdependency — any order, preferably one response.

## Not in the roster (do not confuse)

- **The 8 agents are the skills', not yours** —
  `utility-{drawio-diagram,git-commit,shell-script,claude-code}-{author,reviewer}`. Spawn them only as
  a step of the skill that owns them; the guard pattern is
  `^utility-(drawio-diagram|git-commit|shell-script|claude-code)-(author|reviewer)$`.
- **The shell-script pair was restored and the claude-code pair created on 2026-09-11.** Older text
  saying the shell agents "do not exist" (merged into a command 2026-08-16) or that claude-code "has no
  author/reviewer pair" is **stale** — it survives in `docs/tools-agent-team-docs.md` and in sibling
  memories. `.claude/commands/` is still retired and empty; every former `/…-review` is a **mode** of
  its paired skill, so never tell a user to type one.
- **`abstract-agentic-harness-skill` carries no domain prefix** by design — a design skill bound to no
  domain, holding no criteria (it reaches the SoTs by `@see`). Not a taxonomy violation.
- **`message-rabbitmq-reviewer` belongs to no orchestrator's roster** → `/message-rabbitmq-skill`.

## Carve-out — a sibling may commit its own work

`app-agent-team` and `api-agent-team` may call `utility-git-commit-skill` **as the terminal step of a
change-review they themselves ran** — they cannot delegate to you, so forcing a team switch merely to
commit reviewed work would strand it. It covers **Commit only**, never diagrams/shell/`.claude`, and
does not make Commit shared: a request that *starts* with a commit, or bundles one with utility work,
is yours. Never re-run or re-review a commit a sibling already made.

## tmp paths (collision hazard)

- Yours: **`./.claude/tmp/utility/agent-team-report.md`**, fixed, best-effort. The skills' own, one
  pair per domain: `tmp/utility/{drawio,git,shell-script,claude-code}/` — **never hand-write into any of
  them**; each draft carries a header (drawio) or a sidecar (the other three) that its reviewer gates
  on. That split is deliberate: line 1 of a commit message, a script and a `.claude` artifact must be
  the message, the shebang and `---`, so none can take a header. `tmp/{app,api,tools}/` are the
  siblings'.
- **`.claude/tmp/` is never cleaned** (`Bash(rm:*)` denied, `cleanupPeriodDays: 30`), which is why both
  loop-skills stamp a round number and a fingerprint. `mkdir -p` the full parent chain before writing.
- **A `Write` there is refused in plan mode** (inherited; no `permissionMode` declared). Nothing reads
  the file, so a refusal is a **non-event** — no retry, no `Bash` workaround, never reported as
  persisted. The **returned report is the required channel.**

## Verdict & safety

- ≥ 1 `[MUST]` → blocked; 0 → pass; an unjudged axis **suspends** the verdict.
- **Tally across passed / failed / unchecked.** `exit 0` from a `PostToolUse` gate means "skipped"
  when its precondition is missing — `app/vendor` absent makes php-cs-fixer, PHPStan and `lint:twig`
  inert, and `scripts/.shellcheckrc` disables six rules project-wide.
- **A skill that stopped at its own retry limit is not a failure to re-delegate.** Relay
  "auto-approval limit reached — manual review recommended" verbatim, present the last draft, stop —
  re-running restarts a budget already spent.
- **Two irreversible actions run through this team** — `git commit -F` and `set_page`. Both belong to
  their skill: never run either outside its procedure, ahead of its gate, or to "fix up" a result.
  Check `git status` before diagram work. Never `git push`/`reset`/`rebase`, never rewrite history,
  never stage or unstage for the user.
- **Structure immutability** — never move, rename or delete anything under `.claude/**`, never
  re-introduce a directory tier; a warranted change is `[CONSIDER]` + before/after paths awaiting an
  explicit user decision. Never output a secret value — record the type and `file:line`, raise `[MUST]`.
- `## Actions taken` is mandatory — exactly what landed (commit hash, page name, artifact path).

## Known gaps (2026-09-11) — report them, do not imitate them

The three siblings each have these; this team does not yet. Still missing:
`rules/utility-agent-team-rule.md` (verdict SoT), `docs/utility-agent-team-docs.md` (design SoT), the
`abstract-structure-rule.md` index row, and a `workflows/README.md` entry.

> **The count drift is resolved.** `[Verified]` 2026-09-11 — `CLAUDE.md`,
> `skills/utility-claude-code-skill/references/artifact-spec-guide.md`, `harness-inventory.md`,
> `graph-engineering-guide.md`, `orchestration-guide.md`, `abstract-orchestrator-contract-docs.md`,
> `hooks/README.md`, `agent-roster-guard.sh` and both sibling rule files now read **four orchestrators
> / 38 agents** (34 specialists). The four artifacts listed above remain outstanding because creating
> them is authoring, not correction.

## SoT

- Rules: .claude/rules/utility-{drawio-diagram,git-commit,shell-script,claude-code}-rule.md
- Artifact spec: .claude/skills/utility-claude-code-skill/references/artifact-spec-guide.md
- Styles: .claude/output-styles/utility-{drawio-diagram,git-commit,shell-script}-style.md
- Contract: .claude/docs/abstract-orchestrator-contract-docs.md · Index: .claude/rules/abstract-structure-rule.md
- Siblings: .claude/agents/{app,api,tools}-agent-team.md
