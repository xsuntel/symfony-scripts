# CLAUDE.md

This file configures Claude's behavior and expertise context for this project; Claude reads it automatically when
working in this repository.

## Directory Structure & Path Context

The project infrastructure acts as a wrapper; IDE and AI-assistant references live in the `./tools` directory.

```text
symfony-scripts/                             ← Repository root
└── tools/                                   ← Documents about tooling (AI assistants, IDEs)
    ├── ai/                                  ← AI assistant references
    │   ├── anthropic/
    │   │   └── claude/                      ← _ABSTRACT.md, _PLUGIN.md, _SKILLS.md
    │   ├── google/
    │   │   └── gemini/                      ← _ABSTRACT.md
    │   └── microsoft/
    │       └── github/                      ← _ABSTRACT.md (GitHub Copilot)
    ├── ide/                                 ← IDE setup references
    │   ├── phpstorm/                        ← _ABSTRACT.md, _CONFIG.md
    │   ├── vscode/                          ← _ABSTRACT.md, _CONFIG.md, symfony.code-snippets, CLAUDE.md
    │   └── tutorial.sh                      ← IDE onboarding helper script
    ├── _ABSTRACT.md
    └── CLAUDE.md
```

## Category Purpose

| Category | Purpose |
|----------|---------|
| `ai/` | Per-vendor AI assistant references — Anthropic Claude (plugins, skills), Google Gemini, GitHub Copilot |
| `ide/` | IDE setup and optimization references — PhpStorm and VSCode configuration, snippets, onboarding |
