# utility-claude-code-reviewer memory

Standing context for judging a Claude Code configuration artifact draft. The SoT is
`skills/utility-claude-code-skill/references/artifact-spec-guide.md` (frontmatter & body criteria) +
`rules/utility-claude-code-rule.md` (structure). The checks in the agent prompt are *executions* of
those clauses — where the two disagree, the guide wins and the check is the bug.

> **New as of 2026-09-11.** This domain self-verified inside the skill from 2026-08-08;
> `utility-claude-code-skill` has now handed the loop to this pair.

## Artifact paths

- Read: `./.claude/tmp/utility/claude-code/artifact-draft.md` + sidecar `artifact-meta.txt`
  (`round` · `target` · `type` · `action`).
- Write: `./.claude/tmp/utility/claude-code/artifact-review.md`, **line 1 exactly** `Verdict: PASS` or
  `Verdict: REDO` — the orchestrator reads that line and nothing else.
- **Append each round** via read-modify-write (no `Edit` held).

## Freshness gate — before anything else

Absent draft or sidecar, a `round` mismatch, or a `target`/`type`/`action` mismatch → `Verdict: REDO`,
reason `stale-or-missing-draft`, stop. **Also cross-check `type` against `target` yourself**: an agent
belongs in `.claude/agents/`, a skill at `.claude/skills/<name>/SKILL.md`, a style in
`.claude/output-styles/`. A disagreement means the artifact is mistyped or misplaced — both `[MUST]`.

## Not to be confused with the skill's Review mode

That mode judges a file **already on disk** (Mode A) or sweeps the repo's doc-derived claims (Mode B).
This agent judges a **tmp draft inside the authoring loop**. Same spec guide as SoT, different target.

## What only this reviewer catches

- **The identifier triple** — agent `name` = filename = `agent-memory/<name>/`; skill `name` = its
  directory; style `name` = its file slug. A mismatch **silently disables** memory or produces two
  identities for one artifact.
- **Reference rot** — in this domain a stale pointer **fails silently at read time**. Grep the draft's
  `.claude/**` paths and cited agent names against the real tree. `.claude/commands/` has been
  **retired and empty since 2026-09-10**, so any citation of it, or any instruction to type a
  `/…-review` command, is a `[MUST]`.
- **Dropped content on `action: edit`** — diff the draft against the live target and account for every
  removed line. A from-scratch read cannot see what the draft silently lost. For `settings.json` this is
  critical: a dropped key removes a permission or a hook.
- **Scope creep** — the draft must change **one** artifact. A draft that also rewrites a roster, a hook
  `case` table or an index row has exceeded its unit.

## Deliberate omissions — flagging these is a false finding

- The orchestrators omit `permissionMode` and `isolation` **by design**.
- `utility-git-commit-*` and `utility-drawio-diagram-*` must **not** take `isolation: worktree` —
  adding it is a `[MUST]`, removing a domain agent's is not.
- A read-only analyzer scoped to `app/**` still carries `isolation: worktree` — not an inconsistency.
- `abstract-structure-rule.md` and `utility-git-commit-rule.md` correctly declare **no `paths`**.
- `abstract-` is a permitted non-domain prefix; `.claude/skills/**` is layout-exempt (flat by
  necessity), so never flag a skill for sitting at `<name>/SKILL.md`.

## Budget discipline

**Re-fetch at most the one or two official pages governing this artifact's type.** The spec guide
already carries the verified facts with their dates; a full doc-currency sweep is Mode B of the skill,
not this loop, and it exhausts the turn budget before anything is judged.

## Boundaries

- **Never modify the draft**, and **never write to `.claude/**` outside the tmp review path** — you are
  judging the harness, and an "obvious" fix applied directly changes every later session, unreviewed.
- **Anti-thrash:** round 1 must be complete. A finding visible in round 1 but unreported is `[SHOULD]`
  on round 2 and must not be escalated. The budget is **2**, owned by the skill.
- Judge against the spec guide and the structure rule only — general advice about how agents "should"
  be written is not a source here, and several of this repo's conventions are deliberately unusual.
