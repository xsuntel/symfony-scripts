---
name: gcp-cloudrun-helper
description: Use when deploying and operating this Symfony project on Google Cloud Run. Covers Cloud Run service deployment, traffic splitting, revision rollback, log inspection, Secret Manager secret injection, IAM service accounts, and autoscaling/cost settings. Triggered by requests like 'Cloud Run deploy', 'Cloud Run rollback', 'Cloud Run logs', 'gcloud run', 'traffic splitting', 'Secret Manager injection'. However, do not use it for a 'gcloud run deploy ...' execution request where a complete command is already given.
---

# Google Cloud Run Helper

This is the entry point for deploying and operating this project on GCP Cloud Run.

## Information Source (single source of truth: the rule file)

**All detailed criteria** — Cloud Run deployment architecture, secrets, IAM least privilege, cost,
IaC — are in the rule file. This skill does not duplicate the rules; it only provides the work
procedure and verification commands.

@see .claude/rules/server/nginx-rule.md — container nginx, port 8080 exposure, TLS termination, deployment checklist
@see .claude/rules/utility/gcp/cloudrun-rule.md — full Cloud Run deployment/secrets/IAM/cost/IaC standards (SoT)
@see https://cloud.google.com/run/docs

Source of truth (configuration): `scripts/containers/prod/**` (Dockerfile, nginx), `**/*.tf`, `**/cloudbuild.yaml`.

> ⚠️ **gcloud CLI options, service policies, and pricing change frequently.** The commands below are
> conventions; verify exact flags, limits, and prices with `gcloud ... --help` or the official docs
> before running — do not assert unverified flags/defaults.

## Work Procedure

1. **Deployment prep** → confirm build artifacts (`asset-map:compile`, `composer install --no-dev`, `cache:warmup`) are baked into the image. `APP_ENV=prod`, `APP_DEBUG=false`, secrets injected via Secret Manager (no plaintext environment variables). See the rule's `## Deployment Architecture` and `## Secrets and Configuration`.
2. **Migrations** → run per EntityManager in a **separate step** (Cloud Build step / Cloud Run Job), not automatically at container startup. See the rule's `## Deployment Architecture`.
3. **Traffic shift** → after deploying a new revision, confirm `/healthcheck.php` passes and shift gradually. Avoid an immediate 100% shift.
4. **IAM/cost** → dedicated service account + minimal roles per service, set `min/max-instances` and `concurrency` based on load. See the rule's `## IAM and Security` and `## Cost Awareness`.

## Verification & Operations (Bash)

State the project ID, region (e.g. `asia-northeast3`), and service name as premises. Run them as variables.

```bash
# Premise variables (replace with real values)
PROJECT_ID="your-project"
REGION="asia-northeast3"
SERVICE="your-service"

# Check the service's current state, revisions, traffic
gcloud run services describe "${SERVICE}" --region "${REGION}" --project "${PROJECT_ID}"
gcloud run revisions list --service "${SERVICE}" --region "${REGION}" --project "${PROJECT_ID}"

# Deploy an image (digest tag recommended — no latest)
gcloud run deploy "${SERVICE}" \
  --image "${REGION}-docker.pkg.dev/${PROJECT_ID}/repo/${SERVICE}@sha256:..." \
  --region "${REGION}" --no-traffic

# Inject secrets (Secret Manager reference — do not pass plaintext values)
gcloud run services update "${SERVICE}" --region "${REGION}" \
  --update-secrets "DATABASE_URL=projects/${PROJECT_ID}/secrets/database-url:latest"

# Gradual traffic shift → raise the ratio after confirming the health check passes
gcloud run services update-traffic "${SERVICE}" --region "${REGION}" \
  --to-revisions "NEW_REVISION=10"

# Health check (container internal 8080)
curl -f "$(gcloud run services describe "${SERVICE}" --region "${REGION}" --format='value(status.url)')/healthcheck.php" || echo "UNHEALTHY"

# Read logs
gcloud run services logs read "${SERVICE}" --region "${REGION}" --limit 100
```

## Destructive/Irreversible Operation Caution

For the operations below, **explain the impact scope and confirmation procedure first** and proceed only after user approval (CLAUDE.md §4, §7):

- **Rollback** — shift traffic to a previous revision. Present the target revision and current traffic ratio first.
  ```bash
  gcloud run services update-traffic "${SERVICE}" --region "${REGION}" --to-revisions "PREVIOUS_REVISION=100"
  ```
- **Deleting a service/revision**, **changing an IAM role**, **`terraform apply` (including resource replacement/destroy)** — review and present the `plan`/impact scope first, then get approval.

## Checklist (common to deployment & review)

- [ ] Did you bake build artifacts (assets, vendor, cache) into the image (no runtime volume dependency)?
- [ ] Is it `APP_ENV=prod` and `APP_DEBUG=false`?
- [ ] Did you inject all production secrets via Secret Manager (no plaintext environment variables/commits)?
- [ ] Does the container listen on `PORT` (8080) with no TLS termination itself?
- [ ] Are sessions/cache/locks in Redis and persistent data in Cloud SQL (stateless container)?
- [ ] Did you run migrations per EntityManager in a separate step?
- [ ] Is the image tag a digest (immutable) (no `latest`)?
- [ ] Is it a dedicated service account + minimal roles per service (no Owner/Editor)?
- [ ] Did you shift traffic gradually after the health check passed?
- [ ] Did you set `min/max-instances` and `concurrency` based on load?

When a review is requested, report severity as MUST (critical) / SHOULD (recommended) / CONSIDER (optional).
