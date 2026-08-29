---
title: "Glossary"
linkTitle: "Glossary"
weight: 4
description: >
  Terminology and core definitions across Injectable and code generation.
---

Definitions of terms used throughout Injectable documentation and codebase.

---

### AST (Abstract Syntax Tree)
A tree representation of the abstract syntactic structure of Dart source code. Injectable uses AST nodes as a fallback when constant analysis is unavailable.

### Boundary Isolation
The guarantee that classes inside a folder annotated with `@InjectableMicroPackage` are not scanned or registered by parent folders or root initializers.

### Dot-Shorthand Syntax
A Dart language feature (introduced in Dart 3) allowing enum values to be written without prefixing the enum type (e.g. `.lazySingleton` instead of `Scope.lazySingleton`).

### External Micro-Package
A `MicroPackageModule` defined in a different package (`pubspec.yaml`) within the same monorepo or published dependency, composed explicitly via `ExternalMicroPackage(ModuleType)`.

### External Module
An abstract class annotated with `@ExternalModule()` used to register third-party instances and factory methods.

### Factory
A lifecycle scope (`Scope.factory`) where a new instance is created every time the dependency is requested from the locator.

### GetIt
The underlying Dart service locator package used by Injectable to hold and resolve runtime dependencies.

### Lazy Singleton
A lifecycle scope (`Scope.lazySingleton`) where a single shared instance is instantiated upon the first lookup and reused thereafter.

### Micro-Package
An isolated module of dependencies defined in a specific directory or package, generating an implementation of `MicroPackageModule`.

### PreResolve
An annotation (`@PreResolve`) marking an asynchronous singleton that must be awaited during initial container startup before returning the initialized `GetIt` instance.

### Singleton
A lifecycle scope (`Scope.singleton`) where a single instance is eagerly instantiated during container initialization.
