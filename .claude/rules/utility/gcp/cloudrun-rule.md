---
paths:
  - "scripts/containers/prod/**"
  - "**/*.tf"
  - "**/cloudbuild.yaml"
  - "**/Dockerfile"
---

# GCP / Cloud Run Rules

This rule applies to all code and configuration that deploys and operates this Symfony application on
Google Cloud Platform (GCP) — the default runtime environment, **Cloud Run**.

@see https://cloud.google.com/run/docs
@see https://cloud.google.com/secret-manager/docs
@see .claude/rules/server/nginx-rule.md — container nginx, TLS termination, port 8080 exposure

> ⚠️ GCP CLI options, service policies, and pricing change frequently. **Always verify the exact
> commands, flags, limits, and prices in the official documentation** — this rule fixes architectural
> conventions, not changing values.

## General Rules

- Unless otherwise stated, the default deployment target is **Cloud Run** (managed) — do not introduce GKE/GCE arbitrarily.
- Fix the region to a single project-standard region (e.g. `asia-northeast3` Seoul) — do not scatter regions across services.
- The container listens on the `PORT` environment variable (default 8080) — nginx exposes port 8080 inside the container and does not terminate TLS itself (external TLS is terminated by Cloud Run/the proxy).
- Design containers to be **stateless** — keep session/cache/lock state in Redis and persistent data in PostgreSQL (Cloud SQL). Do not store state on the container-local filesystem.
- Push images to Artifact Registry with a tag (immutable digest recommended) — do not deploy to production with the `latest` tag.

## Deployment Architecture

- **Bake build artifacts into the image** — run `asset-map:compile`, `composer install --no-dev`, and `cache:warmup` at image build time, and do not rely on runtime volume mounts (consistent with the nginx-rule deployment rules).
- Do not run Doctrine migrations automatically at container startup — run them per EntityManager in a **separate step** of the deployment pipeline (a Cloud Build step or a Cloud Run Job).
- Zero-downtime deployment: create a new revision → confirm it passes health checks → gradually shift traffic. Use `/healthcheck.php` as the Cloud Run health check.
- Set the autoscaling lower bound (`min-instances`) explicitly based on cold-start sensitivity — do not rely on the default.

## Secrets and Configuration

- Store all production secrets (DB password, Redis DSN, provider API keys, `APP_SECRET`) in **Secret Manager** and inject them into Cloud Run as secret references — no plaintext in images/environment variables and no committing `.env.*.local`.
- Enforce `APP_ENV=prod` and `APP_DEBUG=false` — do not deploy with `APP_DEBUG=true` (exposes stack traces, disables OPcache).
- Compile configuration into `.env.local.php` with `composer dump-env prod` to reduce runtime parsing cost.

## IAM and Security (least privilege)

- Run each service under a **dedicated service account** — do not reuse the default Compute service account.
- Deny by default, allow explicitly: grant a service account only the roles it actually needs (e.g. Secret Manager `secretAccessor`, Cloud SQL `client`). Do not grant broad Owner/Editor roles.
- Connect to Cloud SQL via the Cloud SQL Auth Proxy or a private IP — no public IP + broad firewall.
- For destructive/irreversible operations (deleting a service, IAM changes, rolling back a production revision), **explain the impact scope and confirmation procedure first** and proceed only after user approval.

## Cost Awareness

- Set `min-instances`, `max-instances`, `concurrency`, and CPU/memory allocation based on the load profile — no unjustified over-provisioning.
- State the expected cost impact of changes that affect cost (always-on instances, large machine types). Verify exact unit prices on the official pricing page.

## IaC / CI

- Manage infrastructure changes declaratively with Terraform (`.tf`) where possible — do not create drift with manual console changes.
- `apply` only after reviewing the `terraform plan` output — confirm destructive changes (`destroy`, resource replacement) beforehand.
- Run `composer audit`, `npm audit`, PHPStan, and PHPUnit in CI as pre-deployment gates.
