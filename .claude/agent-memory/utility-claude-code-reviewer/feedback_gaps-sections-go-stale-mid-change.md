---
name: gaps-sections-go-stale-mid-change
description: A docs "Current Gaps"/"Known Gaps" section can go stale between authoring and review — or between review rounds — when a companion file changes elsewhere in the same multi-file rollout. Always re-check each named gap against the live file on every round, not just against the draft's own narrative or the previous round's findings.
metadata:
  type: feedback
---

When a docs file's `## Current Gaps and Follow-ups` (or an agent's `## Known gaps`) section names a
specific stale pointer in another file (a hook's `case` branch, a rule's heading text, an index row),
treat that claim as a hypothesis to verify, not a fact to relay. In a multi-file rollout (e.g. creating
an orchestrator's rule and its paired docs on the same day), companion files keep changing underneath a
long-lived draft — earlier or *concurrent* steps in the same change often fix the exact thing a gap
section still describes as broken, and this can happen **again between review rounds**, not only once
before round 1.

**Why:** caught twice on the same draft, `utility-agent-team-docs.md` (2026-09-13):

- **Round 1** — `## 6.3` claimed `agent-roster-guard.sh`'s `utility-agent-team)` branch still set
  `RULE_PATH='.claude/agents/utility-agent-team.md'` with a "no rule file yet" comment. A direct `grep`
  showed the branch had already been updated to `RULE_PATH='.claude/rules/utility-agent-team-rule.md'`.
- **Round 2** — after the author fixed `## 6.3` (and touched nothing else), an *unrelated* sub-section,
  `## 6.4`, was found freshly stale on independent re-check: it cited `tools-agent-team-rule.md` as the
  one sibling already converted from "three teams" to "four teams" headings, implying `app`/`api` were
  still mid-migration. A fresh `grep` across all three sibling rule files showed **all three** already
  read "four teams" — `app-agent-team-rule.md` and `api-agent-team-rule.md` had been converted by other
  concurrent work in the same session, between round 1 and round 2. Round 1 had not flagged this because
  it only checked the one fact `## 6.4` actually cited (`tools`) against the tree *as it stood then* —
  the app/api conversion landed afterward, per `git status` showing those two rule files modified in the
  same working session.

See [[utility-claude-code-reviewer]] boilerplate memory's "What only this reviewer catches" section for
the general reference-rot class this specializes.

**How to apply:**
- Whenever a draft's gap/follow-up section names a concrete file:line, a `case` branch, or a
  cross-file rollout status ("X already converted, Y still pending") as still-open or partially done,
  `Read` or `grep` that exact site fresh **on every review round**, not just round 1 — do not accept the
  draft's own framing at face value, and do not assume a claim is safe just because it cites
  `[Verified] <today's date>` or because an earlier round already checked a *different* fact in the same
  sub-section.
- A stale gap claim is exactly as much a `[MUST]` as a stale `@see` pointer: it reports a change as
  incomplete when it is not, and misdirects the next reader who tries to "fix" something already fixed.
- This is a legitimate **new** round-N finding, not an anti-thrash violation — the anti-thrash rule
  bars re-litigating what a previous round already had the evidence to catch, not catching something
  that only became true on disk after the previous round's check ran. Report it as a fresh finding with
  fresh evidence, and note explicitly that it postdates the prior round's check so the orchestrator does
  not misread it as goalpost-moving.
- When the sweep turns up more than one such site (round 1: `## 6.3`; round 2: `## 6.4`), treat it as a
  signal that this specific draft's "Current Gaps" section as a whole is unusually exposed to companion
  drift (a long author window during a large concurrent multi-file rollout) — worth a slightly wider
  sweep of the remaining gap entries than the orchestrator's brief strictly enumerated, per the
  fail-closed principle.

**Round 3 postscript:** the same draft converged cleanly — after the author closed `## 6.4` (citing all
four sibling rule files by fresh `grep`, not just the one `## 6.4` had previously named), an independent
round-3 re-sweep of the *entire* `## 6` section found no third stale site, and the draft passed. So the
pattern is not inherently unbounded: once a wide-enough re-check (not just the one fact previously
flagged) is applied on the fix round, convergence follows. The lesson is still to sweep wide before
each verdict, not to expect an automatic third recurrence.
