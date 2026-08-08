---
description: "Assesses the quality of Doctrine Entity / Repository / Migration code and provides structured improvement recommendations."
argument-hint: "[path to the file to analyze (Entity, Repository, or Migration)]"
---

Analyze the following database-related file:

**`$1`**

The single source of truth (SoT) for the judgment criteria is the rule file. At the start, read the
rule below, cross-check each provision against the target code, flag violations with the **exact line
number**, and provide concrete fixes (improved code snippets). Do not restate the criteria in this
command — when the rule is updated, this review follows automatically.

@see .claude/rules/database/base/postgresql-config-rule.md — judgment criteria (SoT)
@see https://symfony.com/doc/current/doctrine.html

## Review Procedure

Cross-check each section of the rule in order: multiple EntityManagers, table naming, entity class
design, timezone, column mapping, index strategy, Repository rules, migration workflow, PostgreSQL-specific
features. If the target is a Migration file, focus on the migration workflow/index sections; for an
Entity, on design/columns/timezone; for a Repository, on the Repository rules/N+1.

## Output Format

### Summary

| Category | Status (OK / WARN / FAIL) | Issue count |
| --- | --- | --- |
| Multiple EntityManagers | | |
| Table naming conventions | | |
| Entity class design | | |
| Timezone | | |
| Column mapping | | |
| Index strategy | | |
| Repository rules | | |
| Migration workflow | | |
| PostgreSQL-specific features | | |

### Critical Issues (must fix)

For each issue: **[Line N]** description → recommended fix including a code snippet.

### Improvement Suggestions (recommended)

For each suggestion: **[Line N]** description → recommended approach.

### Refactoring Suggestions

Describe structural changes (swapping the repository base class, removing N+1, adding indexes,
splitting a two-step migration, etc.) with before/after code examples.
