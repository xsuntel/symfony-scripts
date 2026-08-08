---
name: commit-message-helper
description: "Writes, reviews, and commits a Conventional Commits message from the staged changes as a two-agent (author/reviewer) workflow. Always use it for natural-language requests like 'commit message', 'write a commit message', or 'make me a commit message' (in any language). Do not use it for a 'git commit -m' request where the message is already given."
---

# Git Commit Helper

Invokes a two-agent team (git-commit-message-author → git-commit-message-reviewer) in sequence to write and review a
Conventional Commits message, and runs the commit on a PASS verdict.

- Commit message language: **English**
- Intermediate artifacts location: `./.claude/tmp/` (gitignored)

---

## Workflow

1. **Precondition check**
   - Run `git diff --cached --quiet`.
   - Exit code 1 (staged changes present) → proceed; exit code 0 (no changes) →
     advise "stage your changes first with `git add`" and stop.

2. **Invoke the author**
   - Call the `git-commit-message-author` agent to generate `./.claude/tmp/utility/git/commit-message-draft.md`.

3. **Invoke the reviewer**
   - Call the `git-commit-message-reviewer` agent to generate `./.claude/tmp/utility/git/commit-message-review.md`.

4. **Verdict branching**
   - **PASS:** run `git commit -F ./.claude/tmp/utility/git/commit-message-draft.md`, report the commit hash and
     message, then stop.
   - **REDO:** include the revision instructions from `./.claude/tmp/utility/git/commit-message-review.md` in the
     author re-invocation prompt and repeat from step 2. **Retry at most twice.**

5. **Retry-limit handling**
   - If still REDO after 2 retries, **do not commit.**
   - Present the last draft to the user and stop with the warning "auto-approval limit reached —
     manual review recommended".
