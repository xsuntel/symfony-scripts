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

@see .claude/commands/utility/claude/code-config-review.md — per-type frontmatter & verification checklist (SoT)
@see .claude/skills/utility/claude/code-config-helper/SKILL.md — artifact authoring & self-verification entry point
@see .claude/rules/structure-rule.md — repository directory structure & rule index
@see CLAUDE.md — the ``## Claude Code Tooling (`.claude/`)`` subdirectory table

## Prohibitions — Structure Immutability (non-negotiable)

Structural reorganization of `.claude/**` is forbidden unless the user **explicitly instructs it in the
current request**. "Cleanup", "consistency", "simplification", a refactoring suggestion, or a review
finding is **not** sufficient grounds.

- **Never flatten the directory taxonomy.** The `<kind>/<domain>/<tier>/…` depth is intentional. Do not
  collapse it to a single level (`rules/app/base/php-symfony/01-architecture-rule.md` →
  `rules/php-symfony-rule.md`), and do not drop an intermediate tier (`base/`, `cloud/`, `agent/`).
- **Never move, rename, or merge an existing file or directory** — no `mv` / `git mv`, and no
  Write-to-new-path followed by deleting the old path.
- **Never split one file across new directories**, and never merge a numbered rule series
  (`00~11-*-rule.md`) into a single file.
- **Never delete a directory**, including the empty scaffolds — the `.gitkeep` placeholders under
  `.claude/hooks/**` and `.claude/skills/**/{assets,references,scripts}/` are deliberate.
- **Never break a mirrored tree.** `docs/` mirrors `rules/` at the `<domain>/<tier>/` level, and for
  every agent that sets `memory: project`, `agent-memory/<domain>/<tier>/<agent>/MEMORY.md` mirrors
  `agents/<domain>/<tier>/<agent>.md` slug for slug. (An agent without a `memory:` key has no
  `agent-memory/` counterpart — that is expected, not a missing file.) Relocating a file in one tree
  without the paired change in its mirror is a structure change.
- **Never add a new top-level directory** under `.claude/`. The 10 directories in the CLAUDE.md table
  (`rules`, `docs`, `skills`, `commands`, `agents`, `agent-memory`, `output-styles`, `hooks`, `scripts`,
  `workflows`) are the complete committed set; the gitignored `tmp/` below is the only permitted
  addition.

**Exception — `.claude/tmp/**`:** the gitignored runtime scratch tree that author/reviewer agents create
on demand (`mkdir -p .claude/tmp`) is exempt from all of the above. Creating, overwriting, and removing
paths under it is normal operation.

## Allowed Changes

- Editing the **contents** of an existing file at its existing path.
- **Adding** a new file at a path that follows the existing taxonomy, mirroring the closest sibling of
  the same kind.
- Adding a new **domain** directory — provided the `rule + docs + skill + reviewer-agent` quartet is
  created together and registered in the `structure-rule.md` index (per CLAUDE.md).

## When a Structure Change Seems Warranted

Report it; do not perform it. State the finding as `[CONSIDER]` with the before/after paths and the
reason, then wait for an explicit user decision. A `[CONSIDER]` note never authorizes the move.

## Which Tool to Use

- Authoring a new `.claude/**` artifact uses the `code-config-helper` skill (self-verification loop);
  quality review of an existing artifact uses the `/utility:claude:code-config-review` command.
- Classify review severity as `[MUST]` / `[SHOULD]` / `[CONSIDER]`; only `[MUST]` blocks a merge.
