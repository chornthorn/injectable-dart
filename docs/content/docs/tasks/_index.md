---
title: "Tasks"
linkTitle: "Tasks"
weight: 30
description: >
  Step-by-step how-to recipes for common development workflows with Injectable.
---

This section contains goal-oriented, step-by-step how-to recipes for common tasks using Injectable.

---

## In this section

- [**Configure the Root Container**](configure-root-container/)
  Setup the top-level DI entrypoint and generator settings.
- [**Declare Folder Micro-Packages**](declare-folder-micro-packages/)
  Isolate feature directories into self-contained sub-modules.
- [**Compose External Micro-Packages**](compose-external-micro-packages/)
  Wire up micro-packages located in other monorepo packages.
- [**Work with Factory Parameters**](work-with-factory-parameters/)
  Pass dynamic runtime arguments to factory constructors via `@FactoryParam`.
- [**Gate Dependencies by Environment**](gate-dependencies-by-environment/)
  Switch between mock, development, and production services.
- [**Manage Async Singletons**](manage-async-singletons/)
  Handle asynchronous initialization and `@PreResolve`.
- [**Register Third-Party Types**](register-third-party-types/)
  Use `@ExternalModule` to provide non-annotatable instances.
- [**Custom Disposal Hooks**](custom-disposal-hooks/)
  Attach cleanup callbacks to singletons on container reset.
