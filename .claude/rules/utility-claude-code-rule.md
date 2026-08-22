---
paths:
  - ".claude/*.md"
  - ".claude/*.json"
  - ".claude/**/*.md"
  - ".claude/**/*.json"
  - ".claude/**/*.sh"
---

# Claude Code Config Rules (`.claude/**`)

This rule is the judgment criteria (SoT) for the **physical layout of the `.claude/` tree** — its
directory taxonomy, path depth, and file placement.

**Responsibility split (no duplication):** the per-type frontmatter and body criteria
(agent · skill · command · rule · output style · settings · CLAUDE.md) are owned by the review command
below; this rule does not restate them. It owns only the structural criteria.

@see .claude/commands/utility-claude-code-review.md — per-type frontmatter & verification checklist (SoT)
@see .claude/skills/utility-claude-code-skill/SKILL.md — artifact authoring & self-verification entry point
@see .claude/rules/abstract-structure-rule.md — repository directory structure & rule index
@see CLAUDE.md — the ``## Claude Code Tooling (`.claude/`)`` subdirectory table

## Prohibitions — Structure Immutability (non-negotiable)

Structural reorganization of `.claude/**` is forbidden unless the user **explicitly instructs it in the
current request**. "Cleanup", "consistency", "simplification", a refactoring suggestion, or a review
finding is **not** sufficient grounds.

**Every artifact tree is flat.** As of 2026-08-15 all seven — `rules/`, `docs/`, `skills/`, `commands/`,
`agents/`, `agent-memory/`, `output-styles/` — are a **single tier** that encodes the domain taxonomy as
a hyphenated filename prefix (`<domain>-<name>-<kind>.md`). The only directories that remain are
`.claude/skills/<name>/`, `.claude/agent-memory/<name>/` (each artifact's own container), and the
per-event `.claude/hooks/<event>/` directories, whose names the hook spec fixes.

Per-tree naming criteria live in the sections below: `## Rules Layout`, `## Docs Layout`,
`## Skill Directory Layout`, `## Commands Layout`, `## Agents Layout`, `## Agent Memory Layout`,
`## Output Style Layout`.

Six of the seven are flat **by necessity** — Claude Code resolves the artifact's identity from the file
or directory name itself (skill command, agent `name`, memory key, output-style slug, slash-command
name), so no domain tier can be imposed on them. `rules/` and `docs/` are flat **by convention**, for
consistency with the rest; their sections explain why that distinction still matters.

**History — the `-config` / `-gate` segment was dropped on 2026-08-19**, by explicit user instruction,
in two steps within one session. First the seven skill directories lost it
(`cache-redis-config-skill` → `cache-redis-skill`, `tools-app-deploy-gate-skill` →
`tools-app-deploy-skill`, …), which also retired the `<tier>` slot from the skill naming convention.
Then, to remove the cross-tree asymmetry that first step created, the same segment was dropped from the
six infrastructure domains in `rules/`, `agents/`, `commands/`, `docs/`, and `agent-memory/`
(`cache-redis-config-rule.md` → `cache-redis-rule.md`, `server-nginx-config-reviewer` →
`server-nginx-reviewer`, `/message-rabbitmq-config-review` → `/message-rabbitmq-review`, …). Every
domain artifact now reads `<domain>-<name>-<kind>` with no tier word. Two consequences to keep in mind:
the four `*-review` slash commands are **user-facing invocations that changed**, and the six reviewer
agents' `name` + `agent-memory/` directory moved together — the paired move is what kept the memories
from orphaning. `app-php-symfony-02-configuration-rule.md` is unrelated and keeps its name.

**Carve-out — the `api` domain is frozen.** See `## API Domain — Layout Freeze`.

- **Never re-introduce a directory tier.** Flat is the structure, not a transitional state. Do not
  "restore" `rules/app/php-symfony/01-architecture-rule.md` from
  `rules/app-php-symfony-01-architecture-rule.md`, and do not group files into a new `base/`, `cloud/`,
  or `agent/` subdirectory.
- **Never move, rename, or merge an existing file or directory** — no `mv` / `git mv`, and no
  Write-to-new-path followed by deleting the old path. In a flat tree the filename _is_ the identifier,
  so a rename is an interface change; see each tree's section for what must move with it.
- **Never merge a numbered rule series** (`00~15-*-rule.md`) into a single file, and never split one
  file across several.
- **Never delete a directory**, including the empty scaffolds — the `.gitkeep` placeholders under
  `.claude/hooks/**` are deliberate.
- **Never break a rule↔docs pairing.** Every domain rule has a `-docs.md` counterpart; adding, removing,
  or renaming one without the paired change to the other is a structure change. Both trees are now flat,
  so the two pair by **slug** and the slugs must stay aligned:
  `app-php-symfony-*-rule.md` ↔ `app-php-symfony-docs.md`.
- **Never add a new top-level directory** under `.claude/`. The 10 directories in the CLAUDE.md table
  (`rules`, `docs`, `skills`, `commands`, `agents`, `agent-memory`, `output-styles`, `hooks`, `scripts`,
  `workflows`) are the complete committed set; the gitignored `tmp/` below is the only permitted
  addition.

**Exception — `.claude/tmp/**`:** the gitignored runtime scratch tree that author/reviewer agents create
on demand is exempt from all of the above. Creating and overwriting paths under it is normal operation —
`mkdir -p` the **full parent** of the target file, not just `.claude/tmp` (a nested draft path such as
`.claude/tmp/utility/git/` needs the whole chain, or a Bash write fails). Removal is not part of the
exemption: `settings.json` denies `Bash(rm:*)` outright and a deny rule outranks any allow, so the
`cleanupPeriodDays` retention and `.gitignore` coverage are what keep the tree from accumulating.

## Rules Layout

`.claude/rules/**` is a **single flat tier**, flattened on 2026-08-15 — the last tree to be. Nothing in
Claude Code resolves a rule by path: a rule is auto-applied when an edited file matches its `paths`
frontmatter glob, and is otherwise reached via `@see`. So, like `docs/`, this tree is flat **by
convention** rather than necessity — adopted so that all seven artifact trees name themselves the same
way.

- **File names are `<domain>-<name>-rule.md`**, ending in the mandatory `-rule.md` suffix:
  `cache/redis-config-rule.md` → `cache-redis-rule.md`;
  `utility/shell-script-config-rule.md` → `utility-shell-script-rule.md`. Where the domain prefix
  already heads the name, do not double it — `api/api-platform-rule.md` → `api-platform-rule.md`.
- **A numbered series keeps its number after the domain prefix**:
  `app/php-symfony/09-testing-rule.md` → `app-php-symfony-09-testing-rule.md`. The number orders the
  series and must not be renumbered to close a gap.
- **`paths` frontmatter is unaffected by the flattening.** Those globs match the _source files the rule
  governs_ (`app/src/**/*.php`, `scripts/**/*.sh`), not the rule's own location. Never rewrite a `paths`
  glob to point at `.claude/rules/`.
- **`abstract-structure-rule.md` carries no domain prefix**, deliberately: it is the always-loaded index,
  not a domain rule. Do not "fix" it into `utility-abstract-structure-rule.md`. The same applies to any
  future `abstract-*` index.
- **Two rules have no `paths` frontmatter and that is intentional** — `abstract-structure-rule.md` (an
  index) and `utility-git-commit-rule.md` (applies to a commit message, which is not a file). Do not
  invent a glob for either.
- **Layout changes are permitted here (except for `api` — see `## API Domain — Layout Freeze`)**,
  provided the naming convention holds and every `@see` / prose reference is updated in the same change.
  A rule is the SoT for its domain, so a stale pointer to one sends a reader to no criteria at all.
- **Deleting a rule file is still prohibited** without an explicit instruction — that removes a domain's
  single source of truth. Its `-docs.md` counterpart must not be orphaned either.

## Skill Directory Layout

`.claude/skills/**` cannot follow the `<domain>/<tier>/…` taxonomy: Claude Code derives a project
skill's command name from **the directory name**, and it discovers only `.claude/skills/<name>/SKILL.md`
— a `SKILL.md` nested one level deeper is never loaded. The tree is therefore **flat by necessity**, and
this is not a taxonomy violation to be "fixed".

@see https://code.claude.com/docs/en/skills — "How a skill gets its command name" (directory name is the command)

- **Encode the taxonomy in the directory name**, joining the path segments with hyphens and ending
  with the mandatory `-skill` suffix: `<domain>-<name>-skill`. `tools/gcp-cloudrun` →
  `tools-gcp-cloudrun-skill`; `utility/git-commit` → `utility-git-commit-skill`. Never invent
  a prefix outside the rule-tree domains (`api`, `app`, `cache`, `database`, `message`, `server`,
  `tools`, `utility`), and **never omit the `-skill` suffix** — it is what keeps a skill invocation
  distinguishable from a slash command at the `/` prompt. A directory missing the suffix is a `[MUST]`
  finding in `/utility-claude-code-review`.
- **`name:` must equal the directory name.** For a project skill the frontmatter `name` is only a
  display label, so a mismatch silently produces two identities for one skill.
- **Layout changes are permitted here (except for `api` — see `## API Domain — Layout Freeze`)** — flatten, move, rename, merge, split — without a separate
  instruction, provided that: (a) the result follows the naming convention above and `name:` is kept in
  sync, and (b) **every `@see` / prose reference to the skill is updated in the same change** (search
  `.claude/**` for both the old path and the old bare name). Reference rot is the actual failure mode
  this exemption trades against.
- **Deleting a skill directory is still prohibited** without an explicit instruction — that is a
  capability removal, not a layout change.

## Agents Layout

`.claude/agents/**` is a **single flat tier**, flattened on 2026-08-15. Claude Code identifies a
sub-agent by its frontmatter `name`, not by its path — the `Agent` call, the agent-type listing, and the
`agent-memory/` lookup all key off `name`. A domain tier organizes nothing, so the taxonomy is carried
in the filename instead.

- **File names are `<domain>-<name>.md`** and the **filename must equal the frontmatter `name`**:
  `app/php-symfony-reviewer.md` → `app-php-symfony-reviewer.md` / `name: app-php-symfony-reviewer`.
  Use only the rule-tree domains (`api`, `app`, `cache`, `database`, `message`, `server`, `tools`,
  `utility`). Where the domain prefix already heads the name, do not double it —
  `api/api-platform-analyzer.md` → `api-platform-analyzer.md`.
- **Renaming an agent is a three-part change**: the file, the frontmatter `name`, and
  `agent-memory/<name>/`. Doing fewer than all three orphans the memory **silently** — see the next
  section.
- **A rename is an interface change, not a layout change.** Anything that dispatches by agent name — an
  orchestrator's routing table, a skill's `Agent` step, a workflow playbook — breaks when `name` changes.
  Update every dispatcher in the same change, not just the `@see` lines.
- **Layout changes are permitted here (except for `api` — see `## API Domain — Layout Freeze`)**,
  provided the naming convention holds and the three-part rename above is done atomically.
- **Deleting an agent file is still prohibited** without an explicit instruction — that is a capability
  removal, and its `agent-memory/` directory must not be deleted either.

## Agent Memory Layout

`.claude/agent-memory/**` cannot follow the `<domain>/<tier>/…` taxonomy either. Claude Code resolves an
agent's memory directory **from the agent's `name` alone**, with no domain segment:

```text
memory: user     →  ~/.claude/agent-memory/<agentType>/MEMORY.md
memory: project  →  .claude/agent-memory/<agentType>/MEMORY.md      ← this project
memory: local    →  .claude/agent-memory-local/<agentType>/MEMORY.md  (gitignored)
```

`<agentType>` is the frontmatter `name`, passed through a sanitizer that replaces every character
outside `[A-Za-z0-9_-]` with `-`. Our agent names are already slug-safe, so the directory is simply the
name verbatim. The entry file is always `MEMORY.md`. `[Verified]` — resolver and scope help-text read
directly out of the Claude Code 2.1.220 binary on 2026-08-14
(`function Itr(e,t){…join(root,".claude","agent-memory",sanitize(name))…}`).

- **The tree is flat by necessity.** Inserting a domain tier —
  `agent-memory/app/app-php-symfony-reviewer/MEMORY.md` — means the file is never read; Claude Code looks
  only at `agent-memory/app-php-symfony-reviewer/MEMORY.md`. A domain tier here does not organize the
  memory, it **silently disables** it, with no error at any point.
- **The directory name must equal the agent's `name`** — not the file path of the agent, and not a
  variant of it. Renaming an agent orphans its memory; move the directory in the same change. The
  2026-08-15 rename (`php-symfony-reviewer` → `app-php-symfony-reviewer`, etc.) required exactly that
  paired move for all 16 memory-bearing agents.
- **This is not a mirror of `agents/`.** Since `agents/` was flattened on 2026-08-15 the two trees happen
  to look alike, but they still correspond by **slug, not by path**: the memory directory is keyed off the
  frontmatter `name`, so renaming an agent file without renaming its `name` — or vice versa — silently
  breaks the pairing no matter how similar the two trees look.
- **Layout changes are permitted here (except for `api` — see `## API Domain — Layout Freeze`)** to keep the directory name in sync with an agent `name`, without
  a separate instruction. Deleting a memory directory is still prohibited — that discards accumulated
  project knowledge.
- An agent with no `memory:` key has no `agent-memory/` counterpart. That is expected, not a missing file.

## Output Style Layout

`.claude/output-styles/**` cannot follow the `<domain>/<tier>/…` taxonomy either. `settings.json`
selects a style by the **file slug alone** (`"outputStyle": "abstract-english-style"`), with no domain
segment and no path — so a style nested under a domain directory cannot be named in that setting. The
tree is **flat by necessity**, and this is not a taxonomy violation to be "fixed".

- **Domain styles are named `<domain>-<name>-style.md`**, joining the taxonomy segments with hyphens and
  ending in the mandatory `-style.md` suffix: `app/php-symfony-style.md` → `app-php-symfony-style.md`;
  `api/api-platform-style.md` → `api-platform-style.md`. Use only the rule-tree domains (`api`, `app`,
  `cache`, `database`, `message`, `server`, `tools`, `utility`). The slug may compress the source path
  rather than transliterate it — `utility/shell-script-config-style.md` became
  `utility-shell-script-style.md` to match its `utility-shell-script-skill` sibling — but it must stay
  a single hyphenated slug ending in `-style`.
- **`abstract-*-style.md` is the one exception to that naming rule**, and deliberately so: the base is
  not a domain style, so it carries an `abstract-` prefix instead of a domain one. It exists in two
  language variants — `abstract-english-style.md` and `abstract-korean-style.md` — which differ only in
  their language rules and prose; exactly one is selected in `settings.json`. Do not "fix" either into
  a domain-prefixed name, and do not flag the pair as duplication.
- **Frontmatter `name` must equal the file slug** — `app-php-symfony-style.md` /
  `name: app-php-symfony-style`. A mismatch produces two identities for one style and breaks the
  `settings.json` lookup.
- **Only one output style is active at a time** — the one named in `settings.json` (`outputStyle`),
  currently `abstract-english-style`. There is no runtime layering or inheritance: a domain style is _not_ auto-loaded
  on top of the base. "Specializes" is a documentation relationship — the base links to each domain
  style under `## Output Examples`, and agents/commands pull one in explicitly via `@see` + Read when
  working in that domain. Do not write a domain style that assumes the base is also in context.
- **This is not a mirror of `rules/`.** Since `rules/` was flattened on 2026-08-15 the two trees happen
  to look alike, but they still correspond by **slug, not by path**: a style is resolved from the
  `settings.json` slug and a rule from its `paths` glob, so neither tree can be derived from the other.
- **Layout changes are permitted here (except for `api` — see `## API Domain — Layout Freeze`)** — flatten, move, rename — without a separate instruction,
  provided that: (a) the result follows the naming convention above and `name:` is kept in sync, and
  (b) **every `@see` / prose reference is updated in the same change** (search `.claude/**` and
  `settings.json` for both the old path and the old slug). Reference rot is the failure mode this
  exemption trades against — the same trade-off as `## Skill Directory Layout`.
- **Deleting a style file is still prohibited** without an explicit instruction — that removes a
  documented convention, not a layout detail.

## Docs Layout

`.claude/docs/**` is a **single flat tier**, flattened on 2026-08-15. Be precise about why: unlike the
three trees above, nothing in Claude Code resolves a docs path — these files are reached only through
an `@see` reference someone wrote by hand. So the flat layout is **a convention, not a technical
constraint**, adopted so that `docs/`, `skills/`, and `output-styles/` all encode their taxonomy the
same way. Do not justify it as a resolver requirement.

- **File names are `<domain>-<name>-docs.md`**, joining the taxonomy segments with hyphens and ending in
  the mandatory `-docs.md` suffix: `app/php-symfony-docs.md` → `app-php-symfony-docs.md`;
  `cache/redis-config-docs.md` → `cache-redis-docs.md`. Where the domain prefix is already the
  head of the name, do not double it — `api/api-platform-docs.md` → `api-platform-docs.md`, never
  `api-api-platform-docs.md`.
- **`docs/` pairs with `rules/` by slug, not by path.** Both trees are flat, so they happen to look
  alike, but nothing derives one from the other — a docs file is reached only by a hand-written `@see`.
  Each domain rule still needs its `-docs.md` counterpart, and the two slugs must stay aligned; this is
  the same shape as the `rules/` ↔ `output-styles/` pairing.
- **A cross-domain design document is the exception to both of the above**, the same way `abstract-*` is
  an exception in `## Rules Layout` and `## Output Style Layout`: it is not a domain rule's reference
  edition, so it has **no paired rule** and carries no domain prefix.
  `agent-team-docs.md` (the agent-team composition draft, design SoT for
  `agents/agent-team.md`) is the only such file today. Do not "fix" it into a domain-prefixed
  name, and do not flag its missing rule counterpart.
- **A docs file is a reference, never a SoT.** It holds the example/detail edition of its rule; when the
  two disagree, the rule wins. Do not move judgment criteria into `docs/`.
- **Layout changes are permitted here (except for `api` — see `## API Domain — Layout Freeze`)** — flatten, move, rename — without a separate instruction,
  provided the result follows the naming convention above and **every `@see` / prose reference is
  updated in the same change** (search `.claude/**`, `CLAUDE.md`, and `TODO.md` for the old path).
  Because nothing resolves these paths automatically, a stale reference fails silently at read time
  rather than erroring — reference rot is the whole risk this exemption trades against.
- **Deleting a docs file is still prohibited** without an explicit instruction. An empty stub
  (`utility-claude-code-docs.md`, `utility-git-commit-docs.md` are both 0 bytes) is a deliberate
  placeholder tracked in `TODO.md`, not a file to clean up.

## Commands Layout

`.claude/commands/**` is a **single flat tier**, flattened on 2026-08-15. A slash command has no `name`
frontmatter — **the path is the invocation name**, so nesting was not neutral: `commands/app/
php-symfony-review.md` invoked as `/app:php-symfony-review`, with the directory becoming a `:`-separated
namespace. Flattening therefore _changed every command's invocation name_.

- **File names are `<domain>-<name>-review.md`** (or `-test.md`), and the filename minus `.md` is exactly
  what the user types: `app-php-symfony-review.md` → `/app-php-symfony-review`. Where the domain prefix
  already heads the name, do not double it — `api/api-platform-review.md` → `api-platform-review.md` →
  `/api-platform-review`.
- **Renaming or moving a command changes the user-facing invocation.** Treat it as an interface change:
  update every `@see`, every prose mention of the old `/domain:name` form, and any skill or agent that
  instructs the user to run it. A stale `/domain:name` reference is not a broken link — it is an
  instruction to type a command that no longer exists.
- **Layout changes are permitted here (except for `api` — see `## API Domain — Layout Freeze`)**,
  provided the naming convention holds and every invocation reference is updated in the same change.
- **Deleting a command file is still prohibited** without an explicit instruction — that removes a
  user-facing entry point.

## API Domain — Layout Freeze (overrides every "layout changes are permitted" clause above)

**The `api` domain is frozen at its current shape as of 2026-08-15.** Every other tree grants a
layout-change permission in its section; **that permission stops at the `api` entries.** Restructuring,
re-nesting, renaming, or merging any of the files below is prohibited without an explicit instruction
naming them.

Now that every tree is flat, the freeze is entirely about **names**, and that is the stronger constraint:
in a flat tree the filename _is_ the identifier Claude Code resolves — agent `name`, memory key, slash
command, skill invocation. Renaming one of these is a user- or dispatcher-facing interface change, not a
cosmetic path edit.

| Frozen path                          | Entries                                        | Why the name is load-bearing                                      |
| ------------------------------------ | ---------------------------------------------- | ----------------------------------------------------------------- |
| `.claude/rules/api-platform-rule.md` | 1                                              | the domain's SoT; every `@see` in the domain points here          |
| `.claude/agents/api-*.md`            | `api-platform-analyzer`, `api-platform-reviewer`, `api-platform-debugger`, `api-platform-tester` | filename = frontmatter `name` = agent-type identifier             |
| `.claude/agent-memory/api-*/`        | same four                                      | directory must equal the agent `name`, or memory silently orphans |
| `.claude/commands/api-*.md`          | `api-platform-review`                          | filename = the slash command the user types                       |
| `.claude/docs/api-*-docs.md`         | `api-platform-docs`                            | reached only by `@see`; a stale pointer fails silently            |
| `.claude/skills/api-*-skill/`        | 5 directories                                  | directory name = skill invocation                                 |

- **A consistency argument is explicitly not grounds.** That the sibling domains in a tree were renamed
  or restructured does not license doing the same to `api`.
- **Adding a new `api` artifact is still allowed** — it must follow the shape of its frozen siblings.
- **Content edits are unaffected.** The freeze covers paths and names only; editing the body of any
  `api` file at its existing path is normal work.
- **Only an explicit user instruction naming the `api` paths lifts this.** A review finding, a
  consistency cleanup, or a blanket "flatten the tree" request does not.

> Three notes on how this section got here. It was requested as `.claude/agent/api/**`; there is no
> `.claude/agent/` directory, so it covers `.claude/agents/` instead. And it was first written against
> `agents/api/` and `rules/api/` while both were still nested — the user then flattened each by explicit
> instruction, so the table records the resulting flat names rather than the original nesting.
>
> Finally, the table lost two entries on 2026-08-16. The agent row: `api-agent-team` was merged into
> `agent-team` (along with `app-agent-team` and `tools-app-deploy-agent-team`), and its
> `agent-memory/api-agent-team/` directory went with it. The docs row: `api-agent-team-docs` was merged
> into `agent-team-docs.md` to mirror that. Both are the "explicit user instruction naming the
> `api` paths" carve-out above — each request named the `api` file directly.
>
> The table changed again on 2026-08-17, under the same carve-out. The user renamed
> `agents/api-platform-author.md` → `agents/api-platform-analyzer.md` (with the paired
> `agent-memory/` move) and deleted `commands/api-platform-test.md`, then instructed that the api domain
> be brought into agreement with the rename. Two rows moved: the agents row now reads
> `api-platform-analyzer`, and the commands row drops to `api-platform-review` alone. The change was not
> cosmetic — the renamed agent was **converted from the Build(Author) role to the read-only Analyze
> axis**, giving `api` the same analyzer/debugger/reviewer/tester quartet as each `app` domain and
> leaving no author→reviewer agent pair in any code domain. The deleted command's per-operation test
> procedure moved into `agents/api-platform-tester.md`, which now owns the full TDD cycle.
>
> The remaining `api` entries (`api-platform-rule`, the four `api-platform-*` agents and their memory,
> `api-platform-review`, `api-platform-docs`, and the five `api-*-skill` directories) are untouched and
> remain frozen; neither precedent extends to them.

## Allowed Changes

- Editing the **contents** of an existing file at its existing path.
- **Adding** a new file at a path that follows the existing taxonomy, mirroring the closest sibling of
  the same kind.
- Adding a new **domain** directory — provided the `rule + docs + skill + reviewer-agent` quartet is
  created together and registered in the `abstract-structure-rule.md` index (per CLAUDE.md). The skill member of
  the quartet is a flat `.claude/skills/<domain>-<name>-skill/` directory, not a nested one.

## When a Structure Change Seems Warranted

Report it; do not perform it. State the finding as `[CONSIDER]` with the before/after paths and the
reason, then wait for an explicit user decision. A `[CONSIDER]` note never authorizes the move.

## Which Tool to Use

- Authoring a new `.claude/**` artifact uses the `utility-claude-code-skill` skill (self-verification loop);
  quality review of an existing artifact uses the `/utility-claude-code-review` command.
- Classify review severity as `[MUST]` / `[SHOULD]` / `[CONSIDER]`; only `[MUST]` blocks a merge.
