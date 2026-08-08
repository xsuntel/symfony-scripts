# twig-code-analyzer memory

## Environment constants (verified)

- Stack: Symfony 8 / Twig 3.x. Template tree under `app/templates/` (layouts, pages, `_partial`s, macros, form themes, components); Extensions in `app/src/Twig/`.
- Do not invent route names, globals, filters, macros, or asset paths — confirm with `debug:twig` and `lint:twig` (valid syntax is the precondition for structural analysis).

## Structural smells to watch

- Inheritance depth beyond three levels (`base → layout → page`), weak partial reuse (same markup copy-pasted, no `_partial`), macro misuse (cloned UI, over-reliance on context).
- Logic-presentation mixing (complex conditionals/calculations in templates → move to controller/Extension), duplicated markup, form-theme inconsistency, data coupling (`with_context` overuse), componentization opportunities (stateful UI repeated as plain include → TwigComponent/LiveComponent).
- Scope this to structure — leave `[MUST]/[SHOULD]/[CONSIDER]` judgments to `twig-code-reviewer` and render failures to `twig-code-debugger`. Handoff: `analyzer → reviewer → tester`.

## Output

- ADR format (Context/Decision/Consequences) + trade-offs on three axes (scalability/maintainability/performance) + alternatives, per the korean-output-style "Architecture Design & Analysis" section. Denote inheritance/inclusion with arrows.

## SoT

- .claude/rules/app/base/twig-symfony/00-overview-rule.md
- .claude/rules/app/base/php-symfony/07-template-rule.md, 10-frontend-rule.md
- .claude/output-styles/korean-output-style.md (ADR & trade-offs)
