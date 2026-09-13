---
name: utility-claude-code-skill
description: "Authors and reviews this project's Claude Code configuration artifacts (sub-agents, skills, rules, output styles, settings hooks, CLAUDE.md). Runs in two modes: Author (a two-agent author/reviewer loop that writes the target file on a PASS verdict) and Review (judges an existing artifact and returns MUST/SHOULD/CONSIDER findings without writing). Always use it for natural-language requests like 'create an agent', 'write a skill', 'edit CLAUDE.md', '.claude config', or 'review this agent file'. Do not use it for simple questions about Claude Code features/usage that neither author nor judge a config file."
argument-hint: "[review: path to one .claude config file, or .claude/**/* for a doc-currency sweep — omit to author]"
---

# Claude Code Skill

Authors a Claude Code project configuration artifact through a two-agent author→reviewer loop and
writes it to the target path on a PASS verdict — or judges an existing artifact against that same
checklist.

## Modes

| Request | Mode | Read |
| --- | --- | --- |
| "create/write/edit an agent, skill, rule, style, hook, CLAUDE.md" | **Author** | this file — the `## Workflow` below |
| "review `<path>`", spec/convention check of an existing artifact | **Review** | [`references/artifact-spec-guide.md`](references/artifact-spec-guide.md) |

**Both modes read the same checklist**, and that is the point: `references/artifact-spec-guide.md` is
the **artifact spec SoT** for this repository. In Author mode `utility-claude-code-author` reads it as
its writing criteria and `utility-claude-code-reviewer` as its judgment criteria; the Review mode reads
it directly. There is no second copy anywhere.

> **The two modes judge different things, and the distinction matters.** Author mode's reviewer judges
> a **tmp draft inside the loop**; Review mode judges a file **already on disk** (Mode A) or sweeps the
> repository's doc-derived claims (Mode B). Review mode writes nothing and spawns nobody.

> Until 2026-09-10 the Review mode was the separate slash command `/utility-claude-code-review`, split
> off on 2026-08-08 so that criteria and authoring had different owners. Folding `.claude/commands/`
> into `.claude/skills/` collapsed the file boundary; **this table is now what keeps the two roles
> apart.** The Review mode must not write or edit any file — it reports and stops.

- Authoring language: **English** (the project `.md` convention)
- Targets: `.claude/agents/**`, `.claude/skills/**/SKILL.md`, `.claude/skills/**/references/**`, `.claude/rules/**`,
  `.claude/output-styles/**`, `.claude/settings.json`, `.claude/hooks/**/*.sh`, `CLAUDE.md`
- A hook script follows `.claude/output-styles/utility-shell-script-style.md`. Read and apply it
  manually — an output style carries no `paths` frontmatter, so it never auto-applies to the file.

**Scope distinction:** use this skill only when **authoring or modifying** a config file. Do not use it
for a simple **question** about Claude Code features/usage that does not change any config.

**Scope distinction — upward.** This skill's unit is **one artifact.** When the decision spans several —
opening a new domain, filling or retiring a role axis, changing an orchestrator roster or its routing,
auditing the artifact system for drift, or fixing a verification loop that will not converge — hand it to
`abstract-agentic-harness-skill`, which decides the shape across files and then calls back here **once
per file**. Authoring a single file well while the roster entry, the
`hooks/pre-tool-use/agent-roster-guard.sh` case table or the `rules/abstract-structure-rule.md` index
entry that had to move with it goes untouched is the failure that division prevents. **A design handed
down from that skill is already scoped** — write the one file you were given and do not widen it.

@see .claude/skills/abstract-agentic-harness-skill/SKILL.md — multi-artifact design & audit (hand up to it; it delegates back here per file)
@see .claude/skills/utility-claude-code-skill/references/artifact-spec-guide.md — per-type frontmatter rules & verification checklist (SoT)
@see .claude/agents/utility-claude-code-author.md — draft role · draft file & sidecar contract
@see .claude/agents/utility-claude-code-reviewer.md — PASS/REDO verdict role · mechanical checks
@see .claude/rules/utility-claude-code-rule.md — `.claude/**` structure immutability & allowed changes (SoT)
@see https://code.claude.com/docs/en/subagents — sub-agent spec
@see https://code.claude.com/docs/en/skills — skill frontmatter reference & command-name resolution
@see https://code.claude.com/docs/en/memory — `.claude/rules/` layout & `paths` path-specific rules
@see https://code.claude.com/docs/en/output-styles — output-style frontmatter & `outputStyle` selection
@see https://code.claude.com/docs/en/hooks — hook events & the hook JSON schema
@see https://code.claude.com/docs/en/settings-reference — `settings.json` key reference
@see https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview — Agent Skills spec
@see https://platform.claude.com/docs/en/build-with-claude/skills-guide — Skills API name/description constraints

---

## Workflow

1. **Interpret the request (precondition)**
   - Determine the **artifact type** (agent / skill / skill `references/` guide / rule / output style / settings / CLAUDE.md) and **target path** from the user's request.
   - If the type/path is unclear, confirm it with **one clear question** before proceeding (do not ask about multiple ambiguities at once).

2. **Learn the conventions**
   - `Read` **1–2 existing files of the same kind** under `.claude/**` and follow their frontmatter, tone, and section structure — do not invent new conventions.

3. **Call the Author**
   - Call the `utility-claude-code-author` agent to produce
     `./.claude/tmp/utility/claude-code/artifact-draft.md` and its sidecar
     `./.claude/tmp/utility/claude-code/artifact-meta.txt`.
   - State the **artifact type**, the **target path**, the **action** (`create` | `edit`) and **the
     round number** (`round: 1`, `round: 2`, …) explicitly in the prompt. Both agents use the round for
     their freshness and anti-thrash gates; `.claude/tmp/` is never cleaned, so without it a leftover
     draft from an earlier run is indistinguishable from a fresh one.
   - The draft is the artifact verbatim — line 1 is `---` for a frontmatter-bearing type — so the
     provenance lives in the sidecar instead. A run without it cannot proceed.

4. **Call the Reviewer**
   - Call the `utility-claude-code-reviewer` agent to produce
     `./.claude/tmp/utility/claude-code/artifact-review.md`.
   - State the same type, target, action and round number, so it can check the sidecar against what was
     actually requested.
   - It judges against `references/artifact-spec-guide.md`: frontmatter validity, naming & path, tool
     minimality, convention agreement, reference factuality, structure immutability and role boundaries.

   > **This pair is new as of 2026-09-11.** From 2026-08-08 the skill verified its own draft, with no
   > downstream reviewer to defer to. The criteria did not move — `references/artifact-spec-guide.md`
   > is still the SoT, read by the author as its writing criteria and by the reviewer as its judgment
   > criteria — only the **owner of the verdict** did.

5. **Branch on the verdict, then write to the target path**
   - Read **line 1** of `./.claude/tmp/utility/claude-code/artifact-review.md` and branch on that token
     alone — the reviewer writes exactly `Verdict: PASS` or `Verdict: REDO` there.
     - `Verdict: PASS` → write the draft to the target path.
     - `Verdict: REDO` → include the correction instructions from the review file's latest `## Round N`
       section in the prompt when re-calling the Author, and repeat from step 3. The Author also reads
       that review file directly, so keep your paraphrase faithful to it. **Maximum 2 retries.**
     - **Anything else** → the verdict is malformed. **Fail closed:** treat it as REDO, say so, and
       count the round.
   - On PASS: create the needed parent directory first (`mkdir -p "$(dirname <target-path>)"`), write the draft **verbatim** (it carries no header to strip — that is what the sidecar is for), then report the written path and a summary.
   - The target path must follow the existing **flat** taxonomy — a single tier per tree, with the domain encoded as a hyphenated filename prefix (`<domain>-<name>-<kind>.md`) — and mirror the closest sibling of the same kind. **Never** re-introduce a directory tier, and never move or rename an existing file (no `mv`, and no write-to-new-path + delete-old-path).
   - If the request seems to require relocating an existing artifact, **do not write**: report it as `[CONSIDER]` with the before/after paths and get an explicit user decision first.

6. **Retry-limit handling**
   - If the verdict is still REDO after 2 retries, **do not write to the target path.**
   - Present the last draft to the user and finish with the warning "auto-approval limit reached — manual review recommended".
   - **The retry counter is yours.** Neither agent counts rounds; if you do not either, the REDO cycle runs unbounded.
