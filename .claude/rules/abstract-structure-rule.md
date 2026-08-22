# Directory Structure & Path Context

This rule defines the repository's physical structure and path conventions, and serves as the entry
point to the domain rule files. The **detailed criteria for architecture and code style live in each
domain rule file, which is the single source of truth (SoT)**; this document does not restate them —
it only maintains the path context and the rule index.

@see CLAUDE.md — role · tech stack · security · testing · response guidelines (global baseline)

## Directory Structure

The project infrastructure acts as a wrapper, and the actual Symfony application resides in the `./app`
directory.

> **Status (2026-08-14): `./app` currently holds only `.gitkeep`.** The Symfony application has not been
> scaffolded yet, so the tree below is the _target_ layout and every `app/**`-scoped rule in the index
> is dormant. Treat those rules as the standard to build against, not as a description of existing code,
> and do not cite an `app/**` path as evidence until the file actually exists.

```text
./                                           ← Repository root
└── app/                                     ← Symfony application root
    ├── assets/                              ← Symfony AssetMapper (Stimulus/Tailwind)
    ├── bin/                                 ← Symfony console
    ├── config/                              ← Symfony configuration (packages/ services/ parameters/)
    ├── migrations/                          ← Doctrine migrations (per EntityManager)
    ├── public/                              ← Web root (index.php, healthcheck.php, assets/)
    ├── src/                                 ← PHP source code (namespace: App\)
    ├── templates/                           ← Twig templates
    ├── tests/                               ← PHPUnit tests (Unit / Integration / Functional)
    ├── translations/                        ← Symfony translations
    ├── var/                                 ← Runtime artifacts (cache/ log/ sessions/ tailwind/)
    └── vendor/                              ← Composer dependencies
```

Primary namespaces under `src/`: `ApiResource`, `Command`, `Controller`, `DataFixtures`, `Entity`,
`EntityRepository`/`Repository`, `EventListener`/`EventSubscriber`, `Form`, `Messenger`, `MessageCommand`/
`MessageCommandHandler`/`MessageQuery`/`MessageQueryHandler`/`MessageEvent`/`MessageEventHandler`,
`Scheduler`, `Serializer`, `Service`, `Twig`.

## Provider Path Convention

External-provider integration code mirrors the same deep namespace hierarchy across every layer:

```text
{Layer}/Providers/Finance/App/{Securities|DigitalAsset}/{Provider}/Domestic/{Stock|Coin}/API/{REST|Websocket}/...
```

Example: `Service/Providers/Finance/App/DigitalAsset/UPbit/Domestic/Coin/API/REST/ExtendedHttpClient.php`.
Configuration (`config/services/`, `config/parameters/`) and the cache-pool / EntityManager names also
follow this path in compressed form.

> **Status:** no per-provider rule files exist yet — the `api/providers/finance/**` quartet
> (UPbit REST · WebSocket, KoreaInvestment OAuth2 · REST · WebSocket, Agencies ECOS · KOSIS REST) is
> planned, not implemented. Until `app/src/` gains provider code, the convention above is the only SoT
> for provider paths. See `TODO.md`.

## Project Rules (Index)

Domain rules live under `.claude/rules/`, and are auto-applied when a file matched by their `paths`
frontmatter is edited. Each rule is the single source of truth (SoT) for its topic, and the skills
under `.claude/skills/` reference it.

**`rules/` is flat**, like every other artifact tree — files are named `<domain>-<name>-rule.md` and a
numbered series keeps its number after the domain prefix. See `## Flat Trees` below.

| Rule file                                 | Scope                                                                                                                                                                                                             |
| ----------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `api-platform-rule.md`                    | API Platform (Symfony) — exposing our own API: resources · operations · serialization · State · validation · security · tests                                                                                     |
| `app-php-symfony-00~15-*-rule.md`         | PHP/Symfony standards (overview · architecture · configuration · controller · service · Doctrine · form · template · security · testing · frontend · performance · Workflow · Mailer/Notifier · i18n · Scheduler) |
| `app-javascript-stimulus-00~03-*-rule.md` | JavaScript/Stimulus (overview · modules · naming, controllers, security · performance · quality, realtime Mercure/SSE + Turbo Streams)                                                                            |
| `app-twig-symfony-00-overview-rule.md`    | Twig/Symfony template standards                                                                                                                                                                                   |
| `cache-redis-rule.md`                     | Redis caching · locks · sessions · transport                                                                                                                                                                      |
| `database-postgresql-rule.md`             | Entity mapping · Repository · migrations · PostgreSQL features                                                                                                                                                    |
| `message-rabbitmq-rule.md`                | RabbitMQ / Symfony Messenger — transport · bus · routing · retry · failure handling · worker operation                                                                                                            |
| `server-nginx-rule.md`                    | Nginx configuration (dev/prod, security, performance, deployment)                                                                                                                                                 |
| `tools-gcp-cloudrun-rule.md`              | GCP / Cloud Run deployment · secrets · IAM · cost · IaC                                                                                                                                                           |
| `tools-aws-ecs-rule.md`                   | AWS ECS (Fargate) deployment · task definitions · secrets · IAM · autoscaling · cost · IaC                                                                                                                        |
| `utility-claude-code-rule.md`             | Claude Code config artifacts (`.claude/**`) layout — flat-tree naming · re-nesting/move/delete prohibitions · scope needing approval                                                                              |
| `utility-drawio-diagram-rule.md`          | draw.io diagrams (`diagram/**/*.drawio`) — storage format · structural integrity · canvas spec · palette · multi-page edit procedure · quality gate                                                               |
| `utility-git-commit-rule.md` †            | Git commit messages — Conventional Commits format · allowed types · scope derivation · subject/body rules · author→reviewer verification loop                                                                     |
| `utility-shell-script-rule.md`            | Shell scripts (scripts/\*\*) bootstrap · global variables · sourcing · idempotency · taxonomy · safety (details: `.claude/docs/utility-shell-script-docs.md`)                                                     |
| `abstract-structure-rule.md` †            | This document — directory structure · path context · rule index                                                                                                                                                   |

**† No `paths` frontmatter — not auto-applied.** These two are judgment criteria that no file path can
trigger. `abstract-structure-rule.md` is an always-loaded index, and `utility-git-commit-rule.md` applies to a
commit message rather than to a file, so it is reached explicitly: `utility-git-commit-skill` and the
`utility-git-commit-author` / `utility-git-commit-reviewer` agents read it via `@see`. Do not "fix"
either by inventing a `paths` glob.

**Special case — split SoT for Claude Code config artifacts (`.claude/**`):\*\* this domain splits its
judgment criteria across two places.

- **Directory structure · placement** → `rules/utility-claude-code-rule.md` (auto-applied via
  `paths` matching).
- **Artifact spec judgment** (frontmatter · naming · tool minimality · convention agreement) → the slash
  command `.claude/commands/utility-claude-code-review.md` **body doubles as the SoT**. This is a
  structure deliberately adopted on 2026-08-08 when the author and reviewer agents were merged into a
  single command; the background and trade-offs are in section 3.5 of `.claude/docs/agent-team-docs.md`.

This domain has no `output-styles/utility-claude-*-style.md` — that is not an omission but a consequence
of the split above.

## Flat Trees

**All seven artifact trees are flat** as of 2026-08-15 — `rules/` was the last to be flattened. Each
encodes the domain taxonomy as a hyphenated filename prefix instead of a directory. All judgment criteria
are owned by `.claude/rules/utility-claude-code-rule.md` (SoT) in the section named below; this table is
the index only.

| Tree             | Naming                                  | Identity resolved from                  | Criteria section            |
| ---------------- | --------------------------------------- | --------------------------------------- | --------------------------- |
| `rules/`         | `<domain>-<name>-rule.md`               | `paths` frontmatter glob, not the path  | `## Rules Layout`           |
| `docs/`          | `<domain>-<name>-docs.md`               | nothing — `@see` only                   | `## Docs Layout`            |
| `skills/`        | `<domain>-<name>-skill/SKILL.md`        | directory name = slash invocation       | `## Skill Directory Layout` |
| `commands/`      | `<domain>-<name>-review.md`             | filename = slash invocation             | `## Commands Layout`        |
| `agents/`        | `<domain>-<name>.md`                    | frontmatter `name` (= filename)         | `## Agents Layout`          |
| `agent-memory/`  | `<agent-name>/MEMORY.md`                | the agent's `name`                      | `## Agent Memory Layout`    |
| `output-styles/` | `<domain>-<name>-style.md`              | slug in `settings.json` (`outputStyle`) | `## Output Style Layout`    |

The only directories left under `.claude/` are each artifact's own container
(`skills/<name>/`, `agent-memory/<name>/`) and the per-event `hooks/<event>/` directories, whose names
the hook spec fixes.

Three consequences worth stating explicitly, because each is a silent-failure mode:

- **`rules/` and `docs/` are flat by convention; the other five by necessity.** Nothing resolves a rule
  or docs _path_ — a rule is triggered by its `paths` glob and otherwise reached via `@see`, and a docs
  file only via `@see`. So a stale pointer to either fails silently at read time instead of erroring.
- **`agents/`, `commands/`, and `skills/` names are user- or dispatcher-facing.** Renaming one changes an
  invocation (`/app:php-symfony-review` → `/app-php-symfony-review`) or an agent-type identifier, not
  just a link. Every dispatcher and every prose instruction must move with it.
- **`rules/` ↔ `docs/` now pair by slug in a shared flat namespace.** Keep the slugs aligned
  (`app-php-symfony-*-rule.md` ↔ `app-php-symfony-docs.md`); each domain rule still requires its
  `-docs.md` counterpart.

**Naming exception — `abstract-*`:** two artifacts carry an `abstract-` prefix instead of a domain one,
because they are bases/indexes rather than domain artifacts: `abstract-structure-rule.md` (this document)
and `abstract-*-style.md`. Do not "fix" either into a domain-prefixed name.

**Output-style base:** `abstract-*-style.md` is the base every domain style specializes, and it exists in
two language variants — `abstract-english-style.md` and `abstract-korean-style.md`. Exactly one is
selected in `settings.json` (`outputStyle`); that is not a duplicate but the conversation-language switch
required by the `## Response Constraints` section of CLAUDE.md.

**`api` domain frozen (since 2026-08-15):** `api-platform-rule.md` and every `api-*` entry in
`agents/`, `agent-memory/`, `commands/`, `docs/`, and `skills/` keep their current names. No renaming,
re-nesting, or restructuring of the `api` domain in any tree — this **overrides** the layout-change
permission each tree's section otherwise grants. Criteria: the `## API Domain — Layout Freeze` section of
`.claude/rules/utility-claude-code-rule.md` (SoT).

## Reference Documents (not rules)

Background/procedure documents that are not judgment criteria live below. They have no `paths` matching,
so they are not auto-applied and are referenced only via `@see`.

| Path                          | Scope                                                                                                                                                                                   |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `.claude/docs/*-docs.md`      | Per-domain detailed examples · references · design background (the supporting document for each rule) — **flat tree**, named `<domain>-<name>-docs.md`                                  |
| `.claude/workflows/README.md` | Workflow playbooks — the trigger→entry-point→procedure for the 6 roles (Review · Analyze · Debug · Test · Build · Commit · Deploy). The design SoT is `.claude/docs/agent-team-docs.md` |
