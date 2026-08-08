---
name: deploy-gate-helper
description: "A pre-deploy gate that, before running a deployment, fans the changed deploy assets (nginx, Cloud Run, ECS, deploy scripts) out to the domain reviewers to verify security/config and decide go/no-go. Use it for requests like 'pre-deploy check', 'is it safe to deploy', 'deploy gate', 'pre-deploy review', or 'deployment readiness review'. This skill does not run the actual deploy/rollback — it hands off to cloudrun-config-helper for Cloud Run and ecs-config-helper for ECS."
---

# Deploy Gate Helper

**Right before** running a deployment, this gate fans the changed deploy assets out to their domain
reviewers, aggregates the security/config findings, and decides **go/no-go (PASS/BLOCK)**. On PASS, the
actual deploy is handed off to the respective config helper — **this skill does not deploy or roll back.**

- Intermediate artifacts location: `./.claude/tmp/` (gitignored)
- Verdict rule: any reviewer with ≥ 1 `[MUST]` → **BLOCK**; none → **PASS**
- Real deploy handoff: Cloud Run → `cloudrun-config-helper`, AWS ECS → `ecs-config-helper`

**Scope distinction:** this skill is a **pre-deploy verification gate**. Running the deploy command,
shifting traffic, rolling back, and checking logs are handled by `cloudrun-config-helper` (GCP) /
`ecs-config-helper` (AWS). To review a single domain only, use its review command directly
(`/server:base:nginx-config-review`, `/utility:shell-script:code-config-review`).

## Criteria (single source of truth: rule files)

The detailed gate criteria live in each domain rule (SoT). This skill does not restate them; it defines
only the routing, aggregation, and verdict procedure.

@see .claude/rules/server/base/nginx-config-rule.md — nginx security headers, static TTLs, FastCGI, 8080 exposure
@see .claude/rules/server/cloud/gcp/cloudrun-config-rule.md — Cloud Run deploy, secrets, IAM, cost, IaC
@see .claude/rules/server/cloud/aws/ecs-config-rule.md — ECS (Fargate) Task definition, secrets, IAM, autoscaling
@see .claude/rules/utility/shell-script/code-config-rule.md — deploy script safety (`rm -rf` guards, etc.)
@see .claude/skills/utility/git/commit-message-helper/SKILL.md — orchestration reference standard

---

## Routing (changed path → reviewer)

Match each changed file path against the rule `paths` glob to select the reviewer. One file can match
several reviewers (e.g. `scripts/containers/prod/**/Dockerfile` matches Cloud Run, ECS, and Shell).

| Changed path pattern | Reviewer (agent) | Backing rule (paths) |
|---|---|---|
| `scripts/**/nginx/**` | `nginx-config-reviewer` | `server/base/nginx-config-rule.md` |
| `scripts/containers/prod/**`, `**/*.tf`, `**/cloudbuild.yaml`, `**/Dockerfile` | `gcp-cloudrun-config-reviewer` | `server/cloud/gcp/cloudrun-config-rule.md` |
| `scripts/containers/prod/**`, `**/*.tf`, `**/taskdef*.json`, `**/buildspec.yml`, `**/Dockerfile` | `aws-ecs-config-reviewer` | `server/cloud/aws/ecs-config-rule.md` |
| `scripts/**/*.sh`, `scripts/**/entrypoint.sh` | `shell-script-code-config-reviewer` | `utility/shell-script/code-config-rule.md` |

> GCP and AWS have no dedicated review command, so **call the reviewer agent directly**. If the deploy
> target is Cloud Run, apply the GCP row only; if ECS, the AWS row only (both if both).

---

## Workflow

1. **Precondition — confirm the deploy target and scope**
   - Confirm the deploy target (**Cloud Run** / **AWS ECS**) and the scope of assets to verify.
   - If unclear, confirm with **one clear question** before proceeding (do not ask about multiple ambiguities at once).

2. **Collect changed assets**
   - Get the changed file list via `git diff --name-only` (or the user-specified scope).
   - Map the files to reviewers using the routing table above. If no reviewer matches, report "no gated
     deploy assets changed" and finish.

3. **Fan out to reviewers**
   - Call the mapped reviewers **in parallel** (no dependencies). Pass each the deploy target and changed file list.
   - Output: `./.claude/tmp/deploy-gate-<domain>-review.md` (e.g. `deploy-gate-nginx-review.md`).
   - Each reviewer reports findings at `[MUST]` / `[SHOULD]` / `[CONSIDER]` severity.

4. **Aggregate and decide**
   - Merge all review outputs and **dedupe findings** (same file + same issue counts once).
   - **PASS:** zero `[MUST]` → gate passes. `[SHOULD]`/`[CONSIDER]` are presented as recommendations.
   - **BLOCK:** ≥ 1 `[MUST]` → gate blocks. List the MUST items and their owning domain.

5. **Report and hand off**
   - **PASS:** present the aggregated report and point to the real deploy step
     (Cloud Run → `cloudrun-config-helper`, ECS → `ecs-config-helper`).
   - **BLOCK:** present the MUST findings in priority order and request fixes. After fixing, **re-run from step 2**.

6. **Retry-limit handling**
   - If still BLOCK after 2 gate re-runs, **do not proceed to the deploy handoff.**
   - Present the last aggregated report and finish with the warning "gate not passed — manual review recommended".

---

## Destructive / Irreversible Operations

This skill only runs up to the gate, but the subsequent deploy steps can be destructive. For the
following, **explain the impact scope and confirmation procedure first** and proceed only after user
approval (CLAUDE.md §4·§7):

- **Actual deploy, traffic shift, rollback**, **`terraform apply` (including resource replacement/destroy)**,
  and **IAM role changes** → each config helper presents the `plan`/impact first, then gets approval. This
  gate is the pre-approval step.
- **`git push`** is set to `ask` in `settings.json`, so it always requires user confirmation.
  `[Verified]` [Read: .claude/settings.json:54]
- Run the pre-deploy security check alongside the CLAUDE.md §7 convention ("before deploy → run security-auditor").

## Checklist (common to the gate)

- [ ] Is the deploy target (Cloud Run / ECS) confirmed?
- [ ] Are all changed deploy assets mapped via the routing table?
- [ ] Are all matching domain reviewers called (nginx · gcp/aws · shell as matched)?
- [ ] Are there zero `[MUST]` findings (any one → BLOCK)?
- [ ] Are secrets injected via Secret Manager/SSM, not plaintext env vars or commits?
- [ ] Are image tags digests (immutable) — no `latest`?
- [ ] Is a dedicated service account / Task Role used with least privilege (no Owner/Editor or wildcards)?
- [ ] Do deploy scripts have safety guards such as `rm -rf` guards?

Report the aggregated review result classified by severity MUST (critical) / SHOULD (recommended) / CONSIDER (optional).
