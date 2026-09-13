# Artifact Selection Guide

Supplementary reference for `harness-design-guide.md` Phase 2. It decides **what to build**.

**This is not judgment criteria** — frontmatter, naming and tool minimality are SoT in
`skills/utility-claude-code-skill/references/artifact-spec-guide.md`, and structure and placement in
`rules/utility-claude-code-rule.md`. This document covers **design judgment** only.

## Contents

1. [Division of labour across the 8 artifact kinds](#1-division-of-labour-across-the-8-artifact-kinds)
2. [Selection decision tree](#2-selection-decision-tree)
3. [Before adding an agent — 3 merge precedents](#3-before-adding-an-agent--3-merge-precedents)
4. [Duplication and reuse review](#4-duplication-and-reuse-review)
5. [How to avoid multiplying the SoT](#5-how-to-avoid-multiplying-the-sot)

---

## 1. Division of labour across the 8 artifact kinds

**Never build two artifacts that answer the same question.** Each kind answers a different one.

| Kind | The question it answers | When to create one |
| --- | --- | --- |
| **rule** `rules/` | *what is correct* (verdict SoT) | when criteria are missing or scattered. **Create it before the executor** |
| **agent** `agents/` | *who does it* | when an independent context genuinely raises verdict or generation quality |
| **skill** `skills/` | *in what order* (entry point) | when retry limits, gates and output paths must be controlled |
| **skill reference guide** `skills/<n>/references/` | *by what procedure is the verdict reached* | when a skill needs a second mode, or reads a procedure as its self-verification criteria. **Replaced `commands/`, retired 2026-09-10** — reach it from a `## Modes` table, never author a new command file |
| **reference doc** `docs/` | *why it was decided that way* | when background, account and examples are too long for the rule. **Do not write criteria here** |
| **output style** `output-styles/` | *how it is written* | when domain code and response notation must be consistent. Only one is active |
| **hook** `hooks/` | *when it is blocked automatically* | when a gate must run even if a person forgets |
| **agent memory** `agent-memory/` | *what burned us last time* | when a specific agent repeatedly steps on the same trap |

**The rule comes first.** An executor built without criteria improvises its verdicts. The reverse — 
criteria with no executor — is a **normal intermediate state**: that is exactly where the analyzer axis
stood before 2026-08-22 (the security rules existed, only the executor to check against them was
missing).

---

## 2. Selection decision tree

```text
Do the judgment criteria (SoT) exist in rules/?
├── No  → build the rule first. Stop here.
└── Yes ↓

Is generation needed, or only a verdict?
├── verdict only ↓
│   ├── the user will invoke it directly → a command (-review)
│   └── only other artifacts invoke it   → keep it a command and let the skill read it
│
└── generation + verification ↓
    Does an independent context genuinely raise verification quality?
    │   Grounds: is the output large, does it need structural-integrity
    │   verification, and are there defects that get missed when the
    │   verifier is contaminated by the generation context?
    │
    ├── Yes ↓
    │   Is a separately-addressable, reusable executor needed —
    │   one an orchestrator can spawn by name, with its own memory and gates?
    │   ├── Yes → an author + reviewer agent pair          (template ①)
    │   └── No  → one skill carrying `context: fork`       (template ③)
    │             isolation without adding an agent artifact
    │
    └── No  → a build command + a self-verifying skill     (template ②)
              Put the conventions and checklist in one command and have
              the skill check its own output against them
```

### Template ③ — `context: fork`, the branch this repository has never used

`[Measured]` 2026-09-10 — **zero artifacts declare `context: fork`**, and until this entry no bundle
file mentioned it. So this documents **an available lever, not current practice**; do not cite a local
precedent for it, because there is none.

A skill with `context: fork` runs in a forked subagent instead of inline, which buys template ①'s
uncontaminated verification context **without** a new file in `agents/`, a roster entry, an
`agent-memory/` directory or a `agent-roster-guard.sh` case branch. All `[Verified]` 2026-09-10
[WebFetch: <https://code.claude.com/docs/en/skills>]:

| Field | Behaviour that decides the design |
| --- | --- |
| `context: fork` | the skill content **becomes the prompt** driving the subagent |
| `agent:` | which subagent type executes it — a built-in (`Explore`, `Plan`, `general-purpose`) or any custom agent in `.claude/agents/`. Defaults to `general-purpose`; `Explore` and `Plan` skip CLAUDE.md and git status |
| `background:` | defaults to `true`. `false` waits in the invoking turn **and keeps the full tool set** |

**Four things that disqualify it — check them before choosing ③:**

1. **A guidelines-only skill returns nothing.** The docs are explicit: `context: fork` "only makes sense
   for skills with explicit instructions". A skill that carries conventions without a task hands the
   subagent guidelines and no actionable prompt. That rules out this repository's six
   `app-src-service-api-*-client-skill` criteria skills outright.
2. **The fork inherits no conversation history.** It pays exactly the cold start the 2026-09-09 merge of
   this skill was fighting. Isolation is not free here — it is the same bill, moved.
3. **A backgrounded fork runs with the narrower background-subagent tool set**, and its edits land
   **outside session checkpoints**, so `/rewind` will not undo them (use git). Set `background: false`
   if any step needs a tool outside that set.
4. **The roster guard does not cover this path.** See `graph-engineering-guide.md` §4 — a fork selects
   its agent through frontmatter rather than the `Agent` tool, so `agent-roster-guard.sh` is
   `[Inferred]` not to fire. Verify that before putting ③ inside an orchestrator's scope.

**Where ③ is the right answer:** a one-off structural verification that wants a clean context, is
invoked from exactly one place, and would otherwise add an agent nobody else ever spawns. Where a second
caller appears, or the executor needs memory across invocations, it has become template ①.

**Where templates ① and ② are actually adopted:**

| | Template ① (agent pair) | Template ② (command self-verification) |
| --- | --- | --- |
| Adopted by | PHP · JS · Twig · API Platform · git-commit · drawio | shell script · Claude Code config · **the 3 provider transport build skills** |
| Grounds | in code domains the gates are external tools (PHPStan, lint), so independent execution is natural. `.drawio` needs id uniqueness and edge references checked without the generation context | the conventions are long and domain-specific, so **gathering them in one place** reduces drift |

**Template ③ has no adopters** — the column is deliberately absent from the table above rather than left
blank. Adding the first one is a design decision to be recorded under Phase 7, not a fill-in.

> **The provider domain is a live ② instance** (`[Verified]` 2026-09-09) —
> `app-src-service-api-{rest,oauth2,websocket}-build-skill`. It is a **variant**: each self-verifies
> against a sibling **skill** (`app-src-service-api-*-client-skill`) rather than a command body, because
> no per-integration command is registered. This note previously said the five provider `*-build-skill`
> entries "do not exist on disk" — true of the design-era names, false of the domain. See §3-2.

---

## 3. Before adding an agent — 3 merge precedents

**Adding an agent is not the default.** This repository went the other way three times, and the reason
was the same every time: **to stop judgment criteria splitting across several places.**

### 3-1. 2026-08-08 — the Claude Code config domain (2 → 1)

The **2 agents** `utility-claude-code-author` and `utility-claude-code-reviewer` were merged into the
**1 command** `commands/utility-claude-code-review.md` — which itself became `skills/utility-claude-code-skill/references/artifact-spec-guide.md` on 2026-09-10, when the `commands/` tree folded into `skills/`.

- As a result this domain's SoT is **split in two** — structure and placement in the rule file, spec
  verdicts in that guide (the **command body**, before the 2026-09-10 fold).
- The absence of a `utility-claude-code-style.md` output style is not an omission but a consequence of
  that split.
- Background and trade-offs are in `docs/app-agent-team-docs.md` § 3.5.

### 3-2. 2026-08-15 — the provider domain (10 → 5), **and what it actually became**

The plan merged the **10** provider author and reviewer agents into **5** `*-build.md` commands, with
five `*-build-skill` skills running a **self-verification loop** against those commands instead of
spawning agents, and the criteria (SoT) staying in the provider rule files.

> ✅ `[Verified]` 2026-09-09 — **the merge succeeded; the per-provider inventory did not.** The 5 build
> commands, the 5 `*-build-skill` directories and the provider rule files were removed in the
> 2026-08-15 flattening and never rebuilt **under those names**. What shipped instead is **six skills
> organised by transport rather than by provider** —
> `app-src-service-api-{rest,oauth2,websocket}-{build,client}-skill` — so one build skill serves every
> integration and resolves criteria through a registry lookup with a documented fallback.
>
> **This paragraph read "none of that survives on disk" until 2026-09-09**, and that conclusion
> propagated into six other files. The error was **inferring absence from a failed name match**. The
> same correction is recorded in `rules/abstract-structure-rule.md` and
> `docs/abstract-orchestrator-contract-docs.md` §8.

**Two lessons, and the second is the more valuable one.** The design intent worth carrying forward is
that generation conventions, the verification checklist and the **known gaps** live in one place while
the criteria stay in the rules. But the sharper lesson is about **axis choice**: the design fanned
artifacts out **per provider** (10 agents → 5 commands → 5 skills, growing with every integration
added), and the implementation fanned them out **per transport** (3 build + 3 client, **fixed** however
many integrations exist). Prefer the axis that does not multiply with your data.

### 3-3. 2026-08-17 — api-platform (a partially reversed case)

`agents/api-platform-author.md` was merged into 2 build commands and the agent was **repurposed** as an
analyzer. Then **on 2026-08-22 the author was revived.**

**Read the reason it came back separately from what did not come back:**

- The revival was for **symmetry** — filling the 3 app-domain authors at the same time aligned the four
  code domains' routing on the same five axes.
- **The SoT for the generation conventions is still the two build commands.** The revived author
  references them via `@see` rather than duplicating them, so the original "avoid triplicating the
  criteria" premise still holds.
- The same reasoning is why the two build commands **do not carry their own** `## Verification
  Checklist` — `api-platform-reviewer` and `skills/api-platform-rest-build-skill/references/review-guide.md` both survived, so a third
  copy would have triplicated the criteria.

**The lesson:** adding an executor (an agent) and adding criteria (an SoT) are **different decisions**.
Adding an executor for symmetry is fine; that executor duplicating the criteria is not.

---

## 4. Duplication and reuse review

Before creating something new, check it against the existing artifacts. Repeatedly extending a harness
tends to accumulate overlapping roles under different names.

| Situation | Action |
| --- | --- |
| an existing artifact **fully covers** the new role | do not create — reuse it and extend only the trigger phrasing |
| **partial** coverage that can be generalized | generalize and extend the existing one. First check how the dependent orchestrators and rosters change |
| partial coverage where the **specialization is intended** | proceed with the new artifact — keep them separate |
| the role scopes are **entirely different** | proceed with the new artifact |

**How far to generalize** — generalization is unbounded, so stop at the **intended scope of
responsibility**. Remove accidental coupling and keep intended specialization.

Worked example, using the naming shape the provider skills were designed around:

| Step | Result | Judgment |
| --- | --- | --- |
| remove the per-provider coupling | "digital-asset REST client" | JWT signing and endpoints differ per provider, so this is **intended** specialization. Stop |
| remove the REST coupling | "HTTP client guide" | `app-php-symfony-skill` already covers it. Do not build it |

**The more one artifact focuses on one role, the more reusable it is and the less it duplicates.** If it
carries two or more roles, check first whether they can be separated.

---

## 5. How to avoid multiplying the SoT

The cost this repository has paid repeatedly is **the same criteria living in several files.** These
rules prevent it.

- **Write criteria in exactly one place.** Point at it with `@see` from everywhere else. When citing a
  section number, verify the section actually holds that content — **number drift is common**, and a
  live example is the `docs/app-agent-team-docs.md` "§2.4" that several documents cited until
  2026-09-06 despite no such section existing.
- **Do not write judgment criteria in a reference document (`docs/`).** It is not auto-applied and the
  rule wins on conflict. Giving it `paths` frontmatter is a `[MUST]` violation.
- **Duplication between an orchestrator prompt and a rule is the exception, and it is intended.** A
  sub-agent starts from an empty context and cannot reach an `@see`, so the instruction must physically
  be present. **Rationale and measurements are not duplicated**, though — those live only in
  `docs/abstract-orchestrator-contract-docs.md`.
- **Share the slug.** The same domain and subject use the same slug across kinds, and that sharing is
  what lets `@see` references find one another.

  ```text
  rules/utility-shell-script-rule.md
  skills/utility-shell-script-skill/references/review-guide.md
  docs/utility-shell-script-docs.md
  output-styles/utility-shell-script-style.md
  skills/utility-shell-script-skill/SKILL.md
  ```

  **Renaming one kind alone breaks the others' `@see` and the rule's `paths` at the same time.** Rename
  only when every related kind moves in the same change.
