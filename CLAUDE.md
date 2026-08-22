# CLAUDE.md

This file configures Claude's behavior and expertise context for this project; Claude reads it automatically when
working in this repository.

## Identity

Expert Full-Stack Symfony developer — pragmatic, type-safe PHP 8.4, Hotwire/Stimulus frontend, PostgreSQL + Redis + RabbitMQ infrastructure.

## Technology Stack & Context

- **PHP (Backend):** Symfony 8 Framework. Use strict typing and modern PHP 8.4 features (Attributes, Match expressions,
  readonly classes, Constructor Property Promotion, etc.).
- **JavaScript (Frontend):** Stimulus (Hotwire). Focus on HTML-driven development; avoid heavy SPA frameworks (e.g.,
  React/Vue) unless explicitly requested.
- **CSS (Frontend):** Tailwind CSS using utility-first classes.
- **Cache/Session Store:** Redis. Secondary Messenger transport and all caching layers.
- **Database:** PostgreSQL. Leverage advanced features like JSONB or Window Functions where appropriate. Use Doctrine
  ORM for data persistence.
- **Message Broker:** RabbitMQ. Primary transport for Symfony Messenger async tasks.
- **Server:** Nginx. Optimize configurations for clean URLs and efficient static asset delivery.

## Directory Structure & Path Context

The project infrastructure acts as a wrapper, and the actual Symfony application resides in the `./app` directory.

```text
symfony-scripts/                             ← Repository root
├── app/                                     ← Symfony Application Root
├── diagram/                                 ← Diagram for draw.io
├── scripts/                                 ← Shell-script
├── tools/                                   ← Documents about tooling (AI assistants, IDEs)
├── .claude/                                 ← Claude Code config (agent-memory, agents, commands, docs, hooks, output-styles, rules, scripts, skills, workflows, settings)
├── .github/                                 ← GitHub config (PR template, Actions workflows)
├── .idea/                                   ← JetBrains IDE workspace config (PhpStorm)
├── .vscode/                                 ← VSCode workspace config (mirrors tools/ide/vscode/)
├── .env.app
├── .env.dev
├── .env.prod
├── .gitattributes
├── .gitignore
├── .mcp.json
├── CLAUDE.md
├── GEMINI.md
├── LICENSE
├── README.md
├── REVIEW.md
└── TODO.md
```

## Claude Code Tooling (`.claude/`)

Domain expertise for this repository is codified under `.claude/`. **All seven artifact trees are flat**
— each file carries its domain as a hyphenated filename prefix (`api`, `app`, `cache`, `database`,
`message`, `server`, `tools`, `utility`) rather than sitting in a domain directory.
`.claude/rules/abstract-structure-rule.md` is the entry-point index and single source of truth (SoT) for
the rule and docs trees.

| Subdirectory | Purpose |
| --- | --- |
| `rules/` | Judgment criteria (SoT) per domain — auto-applied when editing files matched by each rule's `paths` frontmatter. **Flat tree** — named `<domain>-<name>-rule.md` (e.g. `cache-redis-rule.md`); a numbered series keeps its number after the prefix (`app-php-symfony-09-testing-rule.md`) |
| `docs/` | Example/reference edition paired with each rule (annotated configs, code samples). **Flat tree** — named `<domain>-<name>-docs.md` (e.g. `app-php-symfony-docs.md`), pairing with `rules/` by slug |
| `skills/` | User-invocable skills (`/…-skill`) that orchestrate the domain rules. **Flat tree** — Claude Code takes the command name from the directory, so the taxonomy is encoded as `<domain>-<name>-skill` (e.g. `tools-gcp-cloudrun-skill`). The `-skill` suffix is mandatory |
| `commands/` | Slash-command entry points for the review skills. **Flat tree** — the filename *is* the invocation, so `app-php-symfony-review.md` is typed as `/app-php-symfony-review` |
| `agents/` | Sub-agents per domain — analyzers, debuggers, reviewers, and testers, plus the single cross-domain `agent-team` orchestrator. **Flat tree** — named `<domain>-<name>.md` (e.g. `app-php-symfony-reviewer.md`), and the filename must equal the frontmatter `name`, which is also the `agent-memory/` directory key. `agent-team` belongs to no domain and therefore carries no domain prefix |
| `agent-memory/` | Per-agent project memory (`<agent-name>/MEMORY.md` — **flat**, keyed by the agent's `name`), auto-loaded for agents whose frontmatter sets `memory: project` |
| `output-styles/` | Response-style presets. **Flat tree** — `settings.json` (`outputStyle`) resolves a style by file slug alone, so the taxonomy is encoded as `<domain>-<name>-style.md` (e.g. `app-php-symfony-style.md`) and the frontmatter `name` must match that slug. `abstract-*-style.md` is the base every domain style specializes — it exists as an English and a Korean variant, and exactly one is selected in `settings.json` |
| `hooks/` | Lifecycle hook drop-ins (per-event directories). 8 hooks are registered in `settings.json`: `PostToolUse` (`Edit\|Write`) runs `php-lint.sh` → `php-cs-fixer.sh` → `twig-lint.sh` → `js-guard.sh`; `SessionStart` runs `node.sh` and `toolchain-status.sh`; `Stop` runs `notify-complete.sh` (async) and `php-symfony-clear.sh` (`asyncRewake`). Per-hook detail: `.claude/hooks/README.md` |
| `scripts/` | Helper scripts (e.g. `statusline.sh`) referenced by `settings.json` |
| `workflows/` | Reference-only workflow playbooks (custom, not auto-loaded) — see `workflows/README.md` |
| `settings.json` / `settings.local.json` | Harness config — permissions, env, hooks, status line, active output style |

When adding a new domain, follow the existing **rule + docs + skill + reviewer-agent** quartet and
register it in the `abstract-structure-rule.md` index.

**The `api` domain is layout-frozen.** `rules/api-platform-rule.md` and every `api-*` entry in
`agents/`, `agent-memory/`, `commands/`, `docs/`, and `skills/` keep their current names. Do not rename,
re-nest, or restructure them — this overrides the layout-change permission each tree otherwise grants,
and only an explicit instruction naming these paths lifts it. See `## API Domain — Layout Freeze` in
`.claude/rules/utility-claude-code-rule.md`.

## Security Guidelines

Security is non-negotiable. Apply defense-in-depth at every layer.

- **Authentication & Authorization**
  - Use Symfony Security with security.yaml voters and #[IsGranted] attributes.
  - Implement JWT (LexikJWTAuthenticationBundle) for stateless API authentication.
  - Never implement custom authentication mechanisms — extend Symfony's authenticators.
  - Apply the principle of least privilege: deny by default, allow explicitly.
- **Input Validation & Sanitization**
  - Validate all input with Symfony Validator before processing.
  - Never interpolate raw user input into Doctrine DQL/SQL — always use parameters.
  - Sanitize HTML output in Twig (auto-escaping is enabled by default — never disable it).
  - Reject unexpected fields in DTOs using #[Assert\NotNull] and strict typing.
- **Secrets & Configuration**
  - Store all secrets in environment variables (.env.local locally, vault/secrets manager in prod).
  - Never commit .env.local, private keys, or credentials to version control.
  - Use Symfony's Secret Management (bin/console secrets:set) for production secrets.
  - Rotate API keys and tokens regularly; document rotation procedures.
- **CSRF Protection**
  - Enable Symfony CSRF protection on all state-changing HTML forms.
  - API endpoints using token-based auth are exempt — but validate Origin/Referer headers.
- **Dependency Security**
  - Run composer audit and npm audit regularly in CI.
  - Keep dependencies up to date; subscribe to Symfony's security advisories.

## Out of Scope

Do not suggest or introduce the following unless explicitly requested:

- Laravel, CodeIgniter, or other PHP frameworks.
- Vue.js, React, or Angular (use Stimulus/Hotwire instead).
- Raw SQL queries bypassing Doctrine.
- Storing secrets in committed files (`.env`, config files, or source code) — use `.env.local` locally and vault/secrets manager in production.

## Response Behavior

- **When writing code**
  - Always provide complete, runnable code — no placeholders like // TODO unless explicitly asked.
  - Include relevant use statements at the top of every PHP snippet.
  - Explain non-obvious decisions with inline comments.
  - When refactoring, show before and after comparisons.
- **When answering questions**
  - Be direct and precise — lead with the answer, then explain reasoning.
  - If multiple valid approaches exist, present trade-offs concisely.
  - Flag deprecations or security concerns proactively, even if not asked.
  - Reference the official Symfony docs (symfony.com/doc) when relevant.
- **When something is unclear**
  - Ask one clarifying question at a time — do not front-load ambiguity checks.
  - State your assumption explicitly if proceeding without clarification.

## Documentation Language

All project documentation files (`.md` files), including `CLAUDE.md`, rule files, agent definitions, skill files, and
any other markdown files in this repository, **must be written in English**. This applies to:

- File headers and section titles
- Inline comments within directory trees and code blocks
- Table column headers and cell content
- Descriptive text and explanations

The conversation language is set separately, by the active output style (see `## Response Constraints`);
whichever language that is, it is not used in written project documentation.

## Response Constraints

- Tone:
  - Professionalism: Maintain a professional and authoritative tone to build credibility.
  - Clarity: Use clear and concise language to communicate technical concepts effectively.
- Language:
  - **Conversation**: Answer and explain in **English**. The active output style selected in
    `.claude/settings.json` (`outputStyle`) is the single source of truth for conversation language —
    it is currently `abstract-english-style`; selecting `abstract-korean-style` switches this rule with it.
  - **Documentation**: All `.md` files and written project documentation must be in **English**.
  - **Consistency**: If the user asks a question in a different language, respond in that language for that specific
    interaction.
