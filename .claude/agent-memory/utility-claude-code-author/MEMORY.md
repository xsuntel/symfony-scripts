# utility-claude-code-author memory

Standing context for drafting **one** Claude Code configuration artifact. The SoT is
`skills/utility-claude-code-skill/references/artifact-spec-guide.md` (frontmatter & body criteria) +
`rules/utility-claude-code-rule.md` (structure); where they conflict with anything here, they win.

> **New as of 2026-09-11.** This domain had **no author/reviewer pair** from 2026-08-08 — the skill
> self-verified — and `utility-claude-code-skill` has now handed the loop to this pair. A claim that the
> domain "has no author/reviewer sub-agent pair" is stale text from that period.

## Artifact paths

- Draft: `./.claude/tmp/utility/claude-code/artifact-draft.md` — **the artifact verbatim**, line 1 =
  `---` for any frontmatter-bearing type. Never write to `.claude/**` or `CLAUDE.md`; the skill applies
  the draft on PASS.
- Sidecar: `./.claude/tmp/utility/claude-code/artifact-meta.txt` — `round` · `target` · `type` ·
  `action` (`create` | `edit`). Rewrite it every round, including a REDO.
- Review: `./.claude/tmp/utility/claude-code/artifact-review.md` — from round 2 on, **read it** and apply
  its latest `## Round N` block verbatim rather than the prompt's paraphrase.
- Overwrite draft and sidecar in full every round; `Bash(rm:*)` is denied.

**Why no header line:** line 1 must be `---`, and frontmatter that does not start at line 1 is not
parsed — the artifact silently loses its `name`, `description` and tool restrictions. Hence the sidecar,
the same shape `utility-git-commit-author` uses for the same reason.

## Scope — one artifact, and the structure is frozen

- **One artifact per draft.** A decision spanning several (new domain or role axis, roster or routing
  change, drift audit, a loop that will not converge) belongs to `abstract-agentic-harness-skill`, which
  designs across files then delegates each write back here. **A design handed down from it is already
  scoped — do not widen it.**
- **Never move, rename or delete** an existing file or directory; **never re-introduce a directory
  tier.** Every tree is flat with the domain as a hyphenated prefix (`<domain>-<name>-<kind>.md`).
- A request that appears to require relocating an artifact → **do not draft it**; report `[CONSIDER]`
  with before/after paths and stop. That call is the user's.
- **The `api` domain is additionally name-frozen.**
- A required companion change (roster entry, hook `case` branch, index row) is **named in the final
  message**, never folded into the draft.

## The identifier triple

- agent: `name` = filename = `agent-memory/<name>/` directory. A mismatch **silently disables memory**.
- skill: `name` = the parent **directory** name (the directory is what resolves the invocation).
- output style: `name` = file slug (`settings.json` resolves by `name`, falling back to the slug).

## Reference factuality — the most common REDO

Confirm every path, agent, skill, **mode** and tool exists before writing it. In this domain a stale
pointer **fails silently at read time** rather than erroring. Two standing traps:

- `.claude/commands/` was **retired and emptied on 2026-09-10** — never cite it, and never tell a user
  to type a `/…-review` command. Each is now a **mode** of its paired skill.
- A mode absent from a skill's `## Modes` table leaves the skill guessing.

## Deliberate omissions — do not "fix" them

Orchestrators omit `permissionMode` and `isolation`; the `utility-git-commit-*` and
`utility-drawio-diagram-*` pairs must **not** take `isolation: worktree`; two rules
(`abstract-structure-rule`, `utility-git-commit-rule`) correctly have no `paths`.

## Boundaries

- Documentation language is **English**, including titles, tables and code comments. The sole exception
  is `output-styles/abstract-korean-style.md`.
- A hook script target also follows `output-styles/utility-shell-script-style.md`.
- The retry budget (**2**) belongs to `utility-claude-code-skill`, not to this agent.
- On a REDO, change only what the instruction raised.
