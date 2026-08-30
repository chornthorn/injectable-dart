---
title: "Agent Skills"
linkTitle: "Agent Skills"
weight: 45
description: >
  Standard Agent Skills for AI assistants (Claude Code, Cursor, Antigravity, GitHub Copilot) to automate dependency injection with Injectable.
---

Injectable provides an official, standard **Agent Skill** conforming to the [Agent Skills specification](https://agentskills.io).

By integrating the Injectable skill into your development workflow, AI coding assistants (such as Claude Code, Cursor, Antigravity, GitHub Copilot, and Codex) gain deep, context-aware knowledge of Injectable's modern API, folder-scoped micro-packages, and `build_runner` workflows.

---

## In this section

- [**Agent Skills Overview**](overview/)
  Learn how Agent Skills work and how they enhance AI-assisted development.
- [**Installation & Usage**](install-and-use/)
  Step-by-step instructions for downloading and enabling the Injectable skill in your Dart and Flutter projects.

---

## Why Use Agent Skills with Injectable?

- **Eliminate Deprecated APIs**: Guides AI agents to generate clean, modern class-form annotations (`@Injectable(scope: Scope.lazySingleton)`, `@InjectableInit()`, `@ExternalModule()`, `@Inject('tag')`) instead of outdated syntax.
- **Master Folder Micro-Packages**: Directs the agent to isolate feature domains with `@InjectableMicroPackage` and avoid duplicate registration pitfalls.
- **Accurate Code Generation**: Automates `build_runner` execution commands, cache invalidation, and diagnostic troubleshooting.
- **Monorepo Harmony**: Enables seamless multi-package monorepo composition using `externalMicroPackages`.
