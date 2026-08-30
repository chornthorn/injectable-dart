---
name: add-docs
description: Create, extend, or fix documentation pages in the Injectify docs site (Hugo + Docsy, content under docs/content/docs/). Use when adding a new page or section, updating an existing docs page, or verifying docs match the current Injectify API.
---

# Adding & Updating Docs

## When to use

Use this skill whenever the task involves the documentation site at `docs/`:

- Adding a new page (concept, task, guide, or reference entry).
- Creating a new top-level section folder.
- Editing or fixing an existing page under `docs/content/docs/`.
- Checking that docs examples match the current Injectify API.

## Where docs live

- The site is **Hugo + Docsy**, rooted at `docs/` (`docs/hugo.toml`, Docsy theme via `docs/go.mod`).
- All page content lives under `docs/content/docs/`, organized into section folders:

| Folder            | Weight | Purpose                                    |
| :---------------- | :----- | :----------------------------------------- |
| `getting-started` | 10     | Installation, quickstart, monorepo setup   |
| `concepts`        | 20     | Architecture, scopes, micro-packages, envs |
| `tutorials`       | 25     | Step-by-step end-to-end tutorials          |
| `tasks`           | 30     | Step-by-step how-to recipes                |
| `skills`          | 40     | AI agent skills integration                |
| `reference`       | 50     | Annotations, build config, runtime API     |

- Every section folder has `docs/content/docs/<section>/_index.md` (section landing page).
- A new top-level section requires its own `_index.md` with a `weight` that fits the ordering above.

## Page frontmatter

Every page starts with YAML frontmatter. `title`, `linkTitle`, `weight`, and `description` are required, in this order:

```markdown
---
title: "Page Title"
linkTitle: "Short Nav Title"
weight: 1
description: >
  One or two sentences describing what this page covers.
---
```

- `weight` starts at **1** per section and increments per page. Reuse a template from `templates/` when starting fresh.

## Rules for section indexes

When adding a page to a section, also update that section's `_index.md`:

- Append an entry to the "In this section" list.
- Format: `- [**Page Name**](page-folder-name/)` followed by a one-line description on the next line.

Example (from `tasks/_index.md`):

```markdown
- [**Register Third-Party Types**](register-third-party-types/)
  Use `@ExternalModule` to provide non-annotatable instances.
```

## Content conventions (match existing pages)

- Structure long pages with numbered sections: `## 1. ...`, `## 2. ...`, separated by `---`.
- Use fenced code blocks with the `dart` language tag; verbatim annotation examples.
- After annotation examples, show what the generated code looks like under a "Generated code:" heading.
- Use **ordered lists** for sequential steps (tasks pages) and **unordered lists** for explanatory content.
- Emphasis hierarchy: one bold level per line for the key concept; use _italic_ for secondary emphasis — never two competing bold words in one line.
- Link to other pages with relative paths: `[Text](configure-root-container/)`. Verify the target exists.

## API accuracy (non-negotiable)

The docs must reflect the current, clean API — never legacy forms. Per the project rules:

- Use the unified `@Injectable(scope: Scope.singleton | Scope.lazySingleton | Scope.factory)`.
- Use `@ExternalModule()` for external provider modules and `@Inject('tag')` for qualifiers.
- Use `@InjectableInit`, `@InjectableMicroPackage`, and `ExternalMicroPackage(ModuleType)` for initialization and micro-package composition.
- **Never** write docs using removed APIs: no old `@module`, no `@Named`, no `@thirdParty`, no deprecated aliases.
- Before writing an example, verify the exact annotation or function signature against the sources in `packages/` (e.g. `packages/injectify/lib/`) rather than guessing.

## Validation

Run from the `docs/` directory:

1. `npm run serve` — starts the Hugo dev server at `http://localhost:1313/`. Check the new page renders, the sidebar shows it under the right section, and in-page links resolve.
2. `npm run build` — production build (`hugo --minify`) to catch frontmatter or template errors. Output goes to `docs/public/`, which is gitignored build output.
