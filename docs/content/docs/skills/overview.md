---
title: "Agent Skills Overview"
linkTitle: "Overview"
weight: 1
description: >
  Understand the Agent Skills specification, folder structure, and how it equips AI models with Injectify expertise.
---

The **Agent Skills** format ([agentskills.io](https://agentskills.io)) is an open standard that allows framework authors to package instructions, code references, validation rules, and templates into modular, version-controlled directories.

When you install an agent skill into your project, compatible AI assistants automatically read the skill's instructions when handling tasks related to that framework.

---

## 1. Structure of the Injectify Skill

The Injectify skill lives in the `skills/injectify/` directory of the repository:

```
skills/injectify/
├── SKILL.md                          # Main skill instructions and frontmatter
├── references/
│   ├── annotations.md               # Complete reference for annotations & scopes
│   ├── micro_packages.md            # Micro-package isolation & monorepos
│   ├── recipes.md                   # BLoC, dynamic params, third-party clients
│   └── troubleshooting.md           # Diagnostics, circular dependencies, cache
└── assets/
    ├── injection_template.dart      # Standard root container template
    ├── module_template.dart         # Folder micro-package template
    └── build.yaml                   # Recommended build runner options
```

---

## 2. Progressive Disclosure

The skill leverages the **Progressive Disclosure** architecture to keep LLM context lightweight while retaining comprehensive reference depth:

- **Startup Metadata** (~100 tokens): The AI loads only the `name` and `description` frontmatter at startup.
- **Skill Activation** (< 5000 tokens): When you ask the agent to add dependencies, create an injectable service, or wire a feature module, the agent loads `SKILL.md`.
- **Targeted References**: When dealing with advanced tasks (such as resolving a circular dependency, configuring `externalMicroPackages`, or wiring `Dio` via `@ExternalModule`), the agent reads specific sub-documents in `references/` on demand.

---

## 3. Supported AI Clients

The Injectify skill is compatible with all modern AI programming tools that support the Agent Skills specification or directory-based instructions:

- **Claude Code** (`.claude/skills/` or `skills/`)
- **Cursor** (`.cursor/skills/` or project context)
- **Antigravity / Gemini CLI** (`.gemini/skills/` or `.agents/skills/`)
- **Codex & GitHub Copilot** (project instruction files)
- **Any custom agent runtime** reading standard `SKILL.md` bundles

---

## 4. Key Rules Enforced by the Skill

- **Class-Form Annotations Only**: Always outputs `@Injectable()`, `@InjectableInit()`, `@InjectableMicroPackage()`, and `@ExternalModule()`.
- **Explicit Scopes**: Enforces `Scope.factory`, `Scope.lazySingleton`, or `Scope.singleton`.
- **Single Composition Rule**: Ensures micro-packages are composed exactly once to prevent GetIt double registration errors.
- **Async Awareness**: Identifies `Future<T>` singletons and enforces `@PreResolve()` so async registrations are emitted, and `await getIt.allReady()` before resolving them synchronously.
