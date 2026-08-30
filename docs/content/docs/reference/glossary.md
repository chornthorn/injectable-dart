---
title: "Glossary"
linkTitle: "Glossary"
weight: 4
description: >
  Terminology and core definitions across Injectify and code generation.
---

Definitions of terms used throughout Injectify documentation and codebase.

---

### AST (Abstract Syntax Tree)

A tree representation of the abstract syntactic structure of Dart source code. Injectify uses AST nodes as a fallback when constant analysis is unavailable.

### Boundary Isolation

The guarantee that classes inside a folder annotated with `@InjectableMicroPackage` are not scanned or registered by parent folders or root initializers.

### External Micro-Package

A `MicroPackageModule` defined in a different package (`pubspec.yaml`) within the same monorepo or published dependency, composed explicitly via `ExternalMicroPackage(ModuleType)`.

### External Module

An abstract class annotated with `@ExternalModule()` used to register third-party instances and factory methods.

### Factory

A lifecycle scope (`Scope.factory`) where a new instance is created every time the dependency is requested from the locator.

### GetIt

The underlying Dart service locator package used by Injectify to hold and resolve runtime dependencies.

### Lazy Singleton

A lifecycle scope (`Scope.lazySingleton`) where a single shared instance is instantiated upon the first lookup and reused thereafter.

### Micro-Package

An isolated module of dependencies defined in a specific directory or package, generating an implementation of `MicroPackageModule`.

### PreResolve

An annotation (`@PreResolve`) marking a class or external module member as an asynchronous singleton. The generator registers it as **pending** via `await gh.singletonAsync<T>(...)`; the future completes when the app calls `await getIt.allReady()` or `await getIt.getAsync<T>()`.

### Singleton

A lifecycle scope (`Scope.singleton`) where a single instance is eagerly instantiated during container initialization.
