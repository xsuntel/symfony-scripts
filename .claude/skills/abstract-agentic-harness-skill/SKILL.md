---
name: abstract-agentic-harness-skill
argument-hint: '[audit | <design request> | <target path>]'
allowed-tools: Bash(ls:*) Bash(wc:*) Bash(grep:*) Read Glob Grep
description: 'Designs, extends and audits this repository''s agentic harness (the `.claude/**` artifact system) across three axes — **what to build** (artifact kinds · counts · role axes), **how it converges** (gates · verdicts · retries · stopping) and **how it connects** (rosters · handoffs · fan-out · routing). Use it for requests like ''design the harness'', ''audit the harness'', ''harness status'', ''sync the agents and skills'', ''add a new provider axis'', ''check for empty role axes'', ''design a loop'', ''check the verification loop'', ''retry budget'', ''endless REDO'', ''stopping condition'', ''the gate is not running'', ''check the routing'', ''extend a roster'', ''add an orchestrator'', ''the handoff keeps bouncing'', ''which team owns this'', ''adopt dynamic workflows'' (in any language). A request to write or edit a **single** artifact (''create an agent'', ''write a skill'') belongs to utility-claude-code-skill — hand that over.'
---

# Agentic Harness Skill

Designs this repository's harness **at the system level** — the `.claude/**` artifact system, the
verification loops that run inside it, and the orchestration graph that connects them. Writing,
verifying and recording an individual file is delegated to `utility-claude-code-skill`; this skill
decides only **what to build, how it converges, and how it connects**.

- Intermediate output: `./.claude/tmp/utility/harness/` (gitignored — not removable, since `rm` is denied)
- This skill **holds no judgment criteria.** It points at the SoTs below with `@see` and does not
  restate them. That is why it ships without the `rule + docs + reviewer-agent` quartet: a quartet
  member would be a second copy of criteria that already have an owner.
- Bundle paths (`references/…`, `examples/…`) are written **bare and relative to this skill's own
  directory**, which is what `harness-verification-guide.md` §2's integrity grep expects. When the cwd
  is not that directory, resolve them against **`${CLAUDE_SKILL_DIR}`** — do not rewrite the paths in
  the dispatch table to an absolute form, or that grep stops finding them.

@see .claude/rules/utility-claude-code-rule.md — `.claude/**` structure and placement verdicts (SoT)
@see .claude/skills/utility-claude-code-skill/references/artifact-spec-guide.md — artifact spec · frontmatter · tool minimality verdicts (SoT)
@see .claude/rules/abstract-structure-rule.md — repository structure and rule index (SoT)
@see .claude/rules/app-agent-team-rule.md — orchestration invariants for the app-proper axis (SoT)
@see .claude/rules/api-agent-team-rule.md — orchestration invariants for the exposure-layer axis (SoT)
@see .claude/rules/tools-agent-team-rule.md — orchestration invariants for the infrastructure · data · deployment axis (SoT)
@see .claude/docs/abstract-orchestrator-contract-docs.md — the operating contract shared by the four orchestrators (rationale · measurements)
@see .claude/hooks/README.md — hook wiring conventions · event mapping · execution contract
@see .claude/hooks/pre-tool-use/agent-roster-guard.sh — the edge-enforcing hook (an executable projection of the rules)
@see .claude/skills/utility-claude-code-skill/SKILL.md — the delegate for writing and recording a single artifact
@see .claude/skills/utility-git-commit-skill/SKILL.md — the reference loop (the first instance)
@see <https://code.claude.com/docs/en/skills> — skill spec
@see <https://code.claude.com/docs/en/sub-agents> — sub-agent (node) spec
@see <https://code.claude.com/docs/en/hooks> — hook events · execution contract
@see <https://code.claude.com/docs/en/workflows> — dynamic workflows (the graph moved into code)

---

## The three axes (read this first)

This maps the three layers of the public discourse onto this repository. **They are three sections of
one skill, not three skills** — merged on 2026-09-09 because a single design decision routinely needs
all three and was paying three cold starts for it. The boundaries below still hold: **none of the three
restates another**, and each has its own reference guide.

```text
what to build   = artifact kinds · counts · role axes · new domains   → references/harness-design-guide.md
how it converges = gates · verdicts · retries · stopping              → references/loop-engineering-guide.md
how it connects  = nodes · edges · fan-out · routing · rosters        → references/graph-engineering-guide.md
```

**Loops create cycles, and cycles are what make the graph hard.** The moment a REDO exists the workflow
stops being a DAG, and cost, state and termination problems begin. The loop guide owns termination; the
graph guide owns cost and routing. Whether a node should exist at all is the harness guide's call.

**Vertical axis — once the design is settled, it descends to file writing.**

```text
abstract-agentic-harness-skill  (this skill. It never writes files itself)
        │ delegates file by file with the Skill tool
        ↓
utility-claude-code-skill      = draft a single artifact → self-verify → record at the target path
        │ reads its verification criteria from
        ↓
skills/utility-claude-code-skill/references/artifact-spec-guide.md  = artifact spec verdicts (SoT)
rules/utility-claude-code-rule.md       = directory structure and placement verdicts (SoT)
```

**This skill never writes a file into `.claude/**` itself.** Once the design is fixed, it invokes
`utility-claude-code-skill` with the `Skill` tool, once per file. That skill owns the draft guard, the
retry limit (2) and the user-approval gate, so bypassing it skips all three.

**If a request ends at one artifact, do not use this skill** — go straight to
`utility-claude-code-skill`. This skill only earns its cost when the decision **spans several files**.

---

## Phase 0: Status audit (always first)

The harness goes stale faster than the code. **Do not read the inventory — count it.**

**Every artifact tree is flat**, so a single-tier glob counts each one exactly:

```bash
ls .claude/agents/*.md | wc -l
ls .claude/skills/*/references/*.md | wc -l   # references/ guides (commands/ retired 2026-09-10, now empty)
ls .claude/rules/*.md | wc -l
ls .claude/docs/*.md | wc -l
ls .claude/output-styles/*.md | wc -l
ls .claude/hooks/*/*.sh | wc -l
ls -d .claude/skills/*/ | wc -l
ls -d .claude/agent-memory/*/ | wc -l
```

**These are written as separate prefix-led commands on purpose.** This skill's `allowed-tools` grant is
matched **by command prefix**, and `permissions.defaultMode` is `plan` with none of `ls`, `wc` or `grep`
in `settings.json`'s `allow` list. Wrapping them back into a `for` loop or a `cd … && …` compound makes
the prefix stop matching, and the audit this skill calls "always first" starts prompting on every
invocation. The grant also clears on the next user message, so a later turn re-prompts unless the skill
is invoked again.

**`find` is deliberately absent from the grant, and must stay absent.** `Bash(find:*)` would pre-approve
`find … -delete` and `find … -exec rm …`, and `settings.json`'s `Bash(rm:*)` deny **would not catch
either** — a permission matcher keys on the leading command, which is `find`. That turns a convenience
grant into a bypass of the repository's one destructive-command denial. Adding it back is a `[MUST]`
finding.

**Preflight — never skip this comparison.** A file that exists but the harness cannot find is the same
as a file that does not exist.

This one comparison **needs a recursive search**, and a flat glob cannot substitute for it: the whole
point is to catch a `SKILL.md` sitting one tier too deep, which `.claude/skills/*/SKILL.md` matches by
definition never. Use the **`Glob` tool** (granted above, and read-only by construction) rather than
`find`:

```text
Glob  .claude/skills/**/SKILL.md   → count the matches   # every SKILL.md at any depth
```

```bash
ls -d .claude/skills/*/ | wc -l              # flat first-tier entries the harness scans — these must match
```

A difference means that many artifacts are **uninvocable**. They are absent from autocomplete, cannot be
called by name, and **nothing errors**. Ten provider skills were once in exactly this state (19 of 29);
the account is in `docs/abstract-orchestrator-contract-docs.md` §8.

---

## Dispatch — which guide to read

**A split without a pointer means the file is never read.** That is the documented mechanism, not a
figure of speech: `[Verified]` 2026-09-10 [WebFetch: <https://code.claude.com/docs/en/skills>] —
supporting files under a skill directory **load on demand and are not preloaded when the skill is
invoked**. Nothing under `references/` or `examples/` arrives unless something `Read`s it, so a guide
that this table does not name is dead weight on disk.

Having run Phase 0, `Read` the guide that matches the request. More than one may apply; read them in the
order listed.

| Request shape | Read |
| --- | --- |
| "audit the harness", "harness status", a drift or sync check | `references/harness-design-guide.md` (Phase 6 only) |
| add a role or entry point to a domain that already exists | `references/harness-design-guide.md` Phases 1 → 2 → 3 → 5 → 6 |
| a new domain, provider or artifact kind | `references/harness-design-guide.md`, Phases 1–7 in full |
| "design a loop", "the verification loop", "retry budget", "endless REDO", "stopping condition", "the gate is not running" | `references/loop-engineering-guide.md` |
| "check the routing", "extend a roster", "which team owns this", "the handoff keeps bouncing", "fan-out width", "adopt dynamic workflows" | `references/graph-engineering-guide.md` |
| "add an orchestrator" | `references/graph-engineering-guide.md` §8 (whether · routing) **and** `references/orchestration-guide.md` (the artifact bundle) |
| the measured status, verified premises, or the role-axis × domain matrix | `references/harness-inventory.md` |
| which of the 8 artifact kinds to use; whether to merge an agent into a command; **whether isolation needs a new agent at all (`context: fork`)** | `references/artifact-selection-guide.md` (§2) |
| writing a `description`, a `name`, or a body | `references/skill-authoring-guide.md` |
| verifying a change landed (preflight · triggers · dry run) | `references/harness-verification-guide.md` |
| an agent definition template for one of the five role axes | `examples/agent-{author,analyzer,debugger,reviewer,tester}-guide.md` |

**Do not answer a design question from this router alone.** It carries the axis map and the preflight;
every judgment lives in the guides.

---

## How skill content behaves once loaded

**This is why the router-plus-guides split exists** — not tidiness. `[Verified]` 2026-09-10
[WebFetch: <https://code.claude.com/docs/en/skills>]:

| Fact | What it forces on a design |
| --- | --- |
| The rendered `SKILL.md` enters the conversation as **one message and stays there across later turns** | every line is a **recurring** cost, not a one-off. Keep the router thin and push detail into `references/` |
| **Claude Code does not re-read the skill file on later turns** | write **standing instructions**, not one-time steps. A line phrased "first, do X" is read once and then sits in context meaning nothing for the rest of the task |
| Re-invoking with **identical** rendered content adds a short "already loaded" note, not a second copy; **differing** content (changed arguments, dynamic context) appends in full | re-invoking to "refresh" the skill does nothing. If behaviour drifted, the content is still present and the model is choosing otherwise |
| After auto-compaction, invoked skills are re-attached at **the first 5,000 tokens each, 25,000 combined** | anything past ~5,000 tokens of a body **does not survive compaction**. A router that fits inside that budget survives; a monolith is truncated mid-document |
| A skill that seems to stop working is usually still loaded | strengthen the `description` and the instructions, or **enforce it with a hook** — which is exactly what `hooks/pre-tool-use/agent-roster-guard.sh` does for the roster invariant |

**Apply the last row when designing.** Prose in a skill body is advisory and degrades; a hook with
`exit 2` is deterministic. When a constraint must hold, ask which of the two you are actually building.

---

## Output checklist

Applies to every branch. The per-phase checklists are in the guides.

- [ ] Phase 0 preflight values match (`find` = `ls -d`)
- [ ] The right axis was identified — building vs. converging vs. connecting — and its guide was read
- [ ] Owning orchestrator identified **by path, not by prefix**
- [ ] The **command-merge alternative** was considered before adding an agent, and so was
      **`context: fork`** — isolation does not always need a new agent artifact
- [ ] Anything written into a skill body reads as a **standing instruction**, not a one-time step
      (the file is not re-read on later turns), and the body fits the 5,000-token re-attach budget
- [ ] The judgment criteria (SoT) rule exists before the executor does
- [ ] Every file write delegated to `utility-claude-code-skill` (nothing written directly)
- [ ] `/utility-claude-code-skill` confirms 0 `[MUST]`
- [ ] The account recorded with **a date and a reason** in `docs/*-agent-team-docs.md` or
      `rules/abstract-structure-rule.md`
