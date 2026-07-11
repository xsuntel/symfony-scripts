---
name: git-commit-helper
description: "Writes, reviews, and commits a Conventional Commits-format commit message based on staged changes as a two-person team (author/reviewer). Always use it for natural-language requests to create a commit message (in Korean or English). However, do not use it for a 'git commit -m' request where the message is already given."
---

# Git Commit Helper

Calls a two-person team (git-commit-author → git-commit-reviewer) sequentially to write and review a
Conventional Commits-format commit message, and runs the commit when the verdict is PASS.

- Commit message language: **English**
- Intermediate artifact location: `./.claude/tmp/` (registered in gitignore)

---

## Workflow

1. **Precondition check**
   - Run `git diff --cached --quiet`.
   - Exit code 1 (staged changes exist) passes; exit code 0 (no changes) exits after guiding the user
     to "stage your changes with `git add` first".

2. **Call the Author**
   - Call the `git-commit-author` agent to generate `./.claude/tmp/git-commit-draft.md`.

3. **Call the Reviewer**
   - Call the `git-commit-reviewer` agent to generate `./.claude/tmp/git-commit-review.md`.

4. **Verdict branching**
   - **PASS:** run `git commit -F ./.claude/tmp/git-commit-draft.md`, report the commit hash and
     message, then exit.
   - **REDO:** include the revision instructions from `./.claude/tmp/git-commit-review.md` in the
     Author re-call prompt and repeat from step 2. **At most 2 retries.**

5. **Retry-limit handling**
   - If it is still REDO after 2 retries, **do not commit.**
   - Present the last draft to the user and exit with the warning "auto-approval limit reached —
     manual review recommended".
