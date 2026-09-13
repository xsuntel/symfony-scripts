# CLAUDE.md

This file configures Claude's behavior and expertise context for this project; Claude reads it automatically when
working in this repository.

## Directory Structure & Path Context

The project infrastructure acts as a wrapper, and the related shell-script files live in the `./scripts` directory.

```text
symfony-scripts/                             ← Repository root
└── scripts/                                 ← shell-script
    ├── base/                                ← Environment-independent install and configuration scripts
    │   ├── app/                             ← PHP config files + Symfony app CLI scripts
    │   │   ├── php/                         ← PHP install script + dev/prod FPM·CLI config (php.ini, pool.d)
    │   │   └── symfony/                     ← Symfony operation scripts (cache, database, assets, message)
    │   │       ├── base/                    ← CLI, components, deployment, local server helpers
    │   │       └── config/                  ← cron, database, messenger, permissions
    │   │           └── assets/              ← AssetMapper, Webpack
    │   ├── cache/redis/                     ← Redis install and dev/prod configuration (redis.conf)
    │   ├── database/postgresql/             ← PostgreSQL installation
    │   ├── message/rabbitmq/                ← RabbitMQ installation
    │   ├── server/
    │   │   ├── nginx/                       ← Nginx installation and configuration (symfony.conf)
    │   │   └── supervisor/                  ← Supervisor installation + Messenger worker configuration
    │   ├── utility/
    │   │   ├── docker/                      ← Docker installation and deployment scripts
    │   │   └── git/                         ← Git configuration and local server scripts
    │   ├── _abstract.sh                     ← Shared functions and variable definitions
    │   ├── _environment.sh                  ← Environment variable setup (dev/prod select menu)
    │   ├── _platform.sh                     ← OS and platform detection
    │   └── _project.sh                      ← Project path configuration
    ├── containers/                          ← Docker container configuration
    │   ├── dev/                             ← Development docker-compose + .env (Redis, PostgreSQL, RabbitMQ)
    │   └── prod/                            ← Production image: Dockerfile, deploy.sh, app/php, server/, utility/
    ├── deploy/                              ← OS-specific environment deployment scripts
    │    ├── dev/                            ← Each target: environment/ network/ packages/ security/
    │    │   ├── linux/ubuntu/               ← Ubuntu development server
    │    │   ├── mac/os/                     ← macOS development environment
    │    │   └── windows/wsl/                ← Windows development environment
    │    └── prod/                           ← Production deployment targets (cloud providers + on-premise)
    │         ├── aws/                       ← AWS: ecs/ elasticbeanstalk/ lightsail/ubuntu/ + base/ (_cli, _s3)
    │         ├── gcp/                       ← GCP: cloud_run/ + base/ (_cli, _cloud_storage) — project default
    │         ├── ncloud/                    ← NAVER Cloud: compute/ + base/app.sh
    │         └── office/server/             ← On-premise office server deployment
    ├── tools/                               ← Documents about tooling (AI assistants, IDEs)
    │   ├── ai/                              ← AI assistant references
    │   │   ├── anthropic/
    │   │   │   └── claude/                  ← _ABSTRACT.md, install.sh
    │   │   ├── google/
    │   │   │   └── gemini/                  ← _ABSTRACT.md
    │   │   └── microsoft/
    │   │       └── github/                  ← _ABSTRACT.md (GitHub Copilot)
    │   └── ide/                             ← IDE setup references
    │       ├── phpstorm/                    ← _ABSTRACT.md, _CONFIG.md
    │       ├── vscode/                      ← _ABSTRACT.md, _CONFIG.md
    │       └── tutorial.sh                  ← IDE onboarding helper script
    ├── .shellcheckrc                        ← ShellCheck config (rules disabled for the source-based layout)
    └── CLAUDE.md
```

> `.shellcheckrc` sits at `scripts/` rather than inside `base/` on purpose: ShellCheck looks for it in
> the checked file's own directory and its ancestors, never a sibling, so from `base/` it would leave
> `containers/`, `deploy/` and `tools/` unguarded.

## Category Purpose

| Category | Purpose |
|---------|---------|
| `base/` | Environment-independent component install and config scripts — referenced by both `containers/` and `deploy/` |
| `containers/dev/` | Local development Docker environment — run infrastructure services via `docker-compose up` |
| `containers/prod/` | Production container image build and deployment scripts |
| `deploy/dev/` | OS-specific development machine initial setup — packages, network, and security configuration |
| `deploy/prod/` | Production server deployment scripts — executed via `deploy.sh` |
| `tools/ai/` | Per-vendor AI assistant references — Anthropic Claude (plugins, skills), Google Gemini, GitHub Copilot |
| `tools/ide/` | IDE setup and optimization references — PhpStorm and VSCode configuration, snippets, onboarding |

## Shared Function Pattern

`base/_abstract.sh` defines shared variables (`PROJECT_PATH`, `PLATFORM_TYPE`, …) and helper functions used by all
other scripts. `_environment.sh` runs the dev/prod select menu, `_platform.sh` detects the OS/arch, and `_project.sh`
resolves project paths — `_abstract.sh` pulls them in, so an entry point sources only `_abstract.sh`.

A directly-executed entry point locates the repository root by walking up from its own location, rather than by a
relative `../..` hop, because entry points sit at varying depths (`deploy/prod/aws/lightsail/ubuntu/deploy.sh` is five
levels down). Every `source` is wrapped in an existence check — a bare `source` is prohibited:

```bash
find_project_root() {
    local PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    while [[ "${PROJECT_DIR}" != "/" ]]; do
        if [[ -d "${PROJECT_DIR}/.git" ]] || [[ -f "${PROJECT_DIR}/.env.app" ]]; then
            echo "${PROJECT_DIR}"
            return 0
        fi
        PROJECT_DIR="$(dirname "${PROJECT_DIR}")"
    done
    return 1
}

PROJECT_PATH=$(find_project_root)
cd "${PROJECT_PATH}" || exit

if [ -f "${PROJECT_PATH}/scripts/base/_abstract.sh" ]; then
  source "${PROJECT_PATH}/scripts/base/_abstract.sh"
else
  echo "Please check a file : ./scripts/base/_abstract.sh" && exit
fi
```

Sourced helpers (`_*.sh`) do **not** repeat this bootstrap — they inherit `PROJECT_PATH` and `PLATFORM_TYPE` from the
calling entry point. Full criteria: `.claude/rules/utility-shell-script-rule.md`.

## Usage

```bash
# Start development infrastructure (PostgreSQL, Redis, RabbitMQ) — run from project root
docker-compose -f scripts/containers/dev/docker-compose.yml up -d

# Initial Ubuntu dev server setup (run once on a new machine)
bash scripts/deploy/dev/linux/ubuntu/deploy.sh

# Production server deploy
bash scripts/deploy/prod/office/server/deploy.sh
```

## Key Scripts

| Script | Role |
|--------|------|
| `base/app/php/_install.sh` | PHP install + `dev`/`prod` CLI·FPM config deployment (branches on `ENVIRONMENT_NAME`) |
| `base/app/symfony/console/assets.sh` | AssetMapper asset compilation |
| `base/app/symfony/console/cache.sh` | Symfony cache clear and warm-up |
| `base/app/symfony/console/database.sh` | Doctrine migration execution |
| `base/app/symfony/console/message.sh` | Messenger and Scheduler console commands — debug, consume, stats, failed-queue inspection, stop-workers (Messenger worker helpers live in `base/app/symfony/config/_messenger.sh`) |
| `containers/dev/docker-compose.yml` | Development environment infrastructure service definitions |
| `containers/prod/deploy.sh` | Production container build and deployment |
| `deploy/dev/linux/ubuntu/deploy.sh` | Ubuntu development server initial setup |
| `deploy/dev/mac/os/deploy.sh` | Mac development server initial setup |
| `deploy/dev/windows/wsl/deploy.sh` | Windows development server initial setup |
| `deploy/prod/gcp/cloud_run/deploy.sh` | GCP Cloud Run production deploy (project default) |
| `deploy/prod/aws/ecs/deploy.sh` | AWS ECS production deploy (alternative) |
| `deploy/prod/aws/elasticbeanstalk/deploy.sh` | AWS Elastic Beanstalk production deploy |
| `deploy/prod/aws/lightsail/ubuntu/deploy.sh` | AWS Lightsail (Ubuntu) production deploy |
| `deploy/prod/ncloud/compute/deploy.sh` | NAVER Cloud Compute production deploy |
| `deploy/prod/office/server/deploy.sh` | On-premise office server deployment |
