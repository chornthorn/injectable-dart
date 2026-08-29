---
title: "Concepts"
linkTitle: "Concepts"
weight: 20
description: >
  Fundamental architectural concepts, mental models, and design principles behind Injectable.
---

This section covers the core concepts and architectural decisions that power Injectable.

---

## In this section

- [**Architecture & Pipeline**](architecture/)
  Deep dive into the six-stage code generation pipeline: AST parsing, boundary gating, dependency extraction, alias registration, and emission.
- [**Dependency Injection Principles**](dependency-injection/)
  How Injectable separates dependency declaration from registration and service locator lookup.
- [**Scopes and Lifecycles**](scopes-and-lifecycles/)
  Factory, Singleton, and Lazy Singleton lifetimes and registration mechanics.
- [**Micro-Packages and Boundaries**](micro-packages/)
  Folder-scoped isolation, nested sub-modules, boundary exclusion, and cross-package composition.
- [**Modules & External Classes**](modules-and-external-classes/)
  Registering third-party classes, abstract provider classes (`@ExternalModule`), and custom constructor hooks.
- [**Environments and Filtering**](environments-and-filtering/)
  Environment tags (`dev`, `prod`, `test`), `EnvironmentFilter`, and conditional registration mechanics.
- [**Async Dependencies & PreResolve**](async-and-preresolve/)
  Asynchronous instantiation (`singletonAsync`), `@PreResolve`, and lifecycle synchronization with `allReady()`.
