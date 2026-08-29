# Injectable for Dart & Flutter

[![Dart CI](https://img.shields.io/badge/Dart-3.12+-blue.svg?logo=dart)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![style: lints](https://img.shields.io/badge/style-lints-40c463.svg)](https://pub.dev/packages/lints)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://makeapullrequest.com)

A modern, code-generated dependency injection toolkit for Dart and Flutter,
built on `get_it` with **folder-scoped micro-packages** and explicit, class-form
annotations — no magic, no globals, no boilerplate matching.

📖 **[Complete Documentation](docs/README.md)** — Comprehensive guides covering Getting Started, Concepts, Tasks, Tutorials, and API Reference.

---

## Monorepo Packages

| Package                                                      | Description                                                                                                                                                                                                                        |
| :----------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`packages/injectable`](packages/injectable)                 | Runtime annotations (`@Injectable`, `@InjectableInit`, `@InjectableMicroPackage`, `@ExternalModule`, …), `Scope` enum, `MicroPackageModule` base class, and `GetItHelper` (environment-gated registration wrapper around `GetIt`). |
| [`packages/injectable_codegen`](packages/injectable_codegen) | `build_runner` generator that scans annotated sources and emits `<file>.config.dart` with collision-free aliased imports and typed registrations.                                                                                  |

> How the generator works end-to-end: see [INJECTABLE_CODEGEN.md](INJECTABLE_CODEGEN.md) and [Architecture Documentation](docs/content/docs/concepts/architecture.md).

---

## Key Features

- **Code-Generated Registrations**: Annotate, run `build_runner`, and get a typed GetIt `init()` — constructor parameters resolve from the container.
- **Folder-Scoped Micro-Packages**: `@InjectableMicroPackage(moduleName: 'Feature')` isolates a folder into its own module. Nested sub-modules auto-compose via `useMicroPackage: true` (each module is composed exactly once).
- **Root Compositor**: `@InjectableInit(useMicroPackage: true)` discovers all folder micro-packages and registers them flatly at the root container.
- **External Module Composition**: `externalMicroPackages: [ExternalMicroPackage(ModuleType)]` composes modules from other packages (other pubspecs) in declaration order — no manual `getIt.initX()` wiring.
- **Scopes**: Unified `@Injectable(scope: Scope.singleton | Scope.lazySingleton | Scope.factory)` with Dart enum dot-shorthand support (`scope: .lazySingleton`).
- **Async & Tagged Registrations**: `@PreResolve` / `Future` factories emit `singletonAsync`; `@Inject('tag')` emits named GetIt lookups.
- **Environment Gating**: `@Environment('dev')` / `@dev` registers only for matching environments via `EnvironmentFilter`.

---

## Documentation Overview

- **[Getting Started](docs/content/docs/getting-started/_index.md)**: [Installation](docs/content/docs/getting-started/installation.md) · [Quickstart](docs/content/docs/getting-started/quickstart.md) · [Monorepo Setup](docs/content/docs/getting-started/monorepo-setup.md)
- **[Concepts](docs/content/docs/concepts/_index.md)**: [Architecture](docs/content/docs/concepts/architecture.md) · [Scopes & Lifecycles](docs/content/docs/concepts/scopes-and-lifecycles.md) · [Micro-Packages](docs/content/docs/concepts/micro-packages.md) · [Environments](docs/content/docs/concepts/environments-and-filtering.md) · [Async & PreResolve](docs/content/docs/concepts/async-and-preresolve.md)
- **[Tasks](docs/content/docs/tasks/_index.md)**: [Root Container](docs/content/docs/tasks/configure-root-container.md) · [Folder Micro-Packages](docs/content/docs/tasks/declare-folder-micro-packages.md) · [External Micro-Packages](docs/content/docs/tasks/compose-external-micro-packages.md) · [Factory Parameters](docs/content/docs/tasks/work-with-factory-parameters.md) · [Third-Party Types](docs/content/docs/tasks/register-third-party-types.md)
- **[Tutorials](docs/content/docs/tutorials/_index.md)**: [Modular Flutter App](docs/content/docs/tutorials/modular-flutter-app.md) · [Multi-Package Monorepo](docs/content/docs/tutorials/multi-package-monorepo.md)
- **[Reference](docs/content/docs/reference/_index.md)**: [Annotations](docs/content/docs/reference/annotations.md) · [Build Configuration](docs/content/docs/reference/build-configuration.md) · [Runtime API](docs/content/docs/reference/runtime-api.md) · [Glossary](docs/content/docs/reference/glossary.md)

---

## Quick Start

### 1. Installation

Add `injectable` and its generator to your `pubspec.yaml`:

```yaml
dependencies:
  injectable: ^1.0.0
  get_it: ^9.2.1

dev_dependencies:
  build_runner: ^2.4.0
  injectable_codegen: ^1.0.0
```

### 2. Annotate Your Classes

```dart
import 'package:injectable/injectable.dart';

@Injectable(scope: Scope.singleton)
class ApiClient {
  ApiClient(@Inject('baseUrl') this.baseUrl);
  final String baseUrl;
}

@Injectable(scope: Scope.lazySingleton)
class OrderService {
  OrderService(this.api);
  final ApiClient api;
}

@ExternalModule()
abstract class ConfigModule {
  @Injectable(scope: Scope.singleton)
  String get baseUrl => 'https://api.example.com';
}
```

### 3. Declare the Entry Point

```dart
// lib/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(initializerName: 'init')
Future<void> configureDependencies() async => getIt.init();
```

### 4. Run Code Generation

```bash
dart run build_runner build
```

This emits `lib/injection.config.dart` with a typed `GetIt` extension.
`await configureDependencies()` in `main()` and resolve:

```dart
void main() async {
  await configureDependencies();
  final orderService = getIt<OrderService>();
}
```

---

## Feature Micro-Packages

Bound a folder into its own module — its dependencies cannot leak into sibling folders, and nested sub-modules are self-contained:

```dart
// lib/features/orders/orders_module.dart
import 'package:injectable/injectable.dart';

@InjectableMicroPackage(
  moduleName: 'Orders',
  initializerName: 'initOrders',
  useMicroPackage: true, // auto-compose nested sub micro-packages
)
void configureOrdersModule() {}
```

A root compositor then wires everything in one call:

```dart
// lib/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  useMicroPackage: true, // auto-discovers orders_module and any other micro-packages
)
Future<void> configureDependencies() async => getIt.init();
```

---

## Author

Created and maintained by **[Thorn Chorn](https://github.com/chornthorn)**.

---

## Community & Acknowledgements

Special thanks to the Dart and Flutter open-source community:

- **[get_it](https://pub.dev/packages/get_it)** by [Thomas Burkhart](https://github.com/ThomasBurkhart) — the foundational Service Locator for Dart and Flutter.
- **[injectable](https://pub.dev/packages/injectable)** by [Milad Akarie](https://github.com/Milad-Akarie) — the original inspiration for code-generated dependency injection in Flutter.

---

## License

MIT License. See [LICENSE](LICENSE) for details.
