# Injectable for Dart & Flutter

[![Dart CI](https://img.shields.io/badge/Dart-3.12+-blue.svg?logo=dart)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![style: lints](https://img.shields.io/badge/style-lints-40c463.svg)](https://pub.dev/packages/lints)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://makeapullrequest.com)

A modern, code-generated dependency injection toolkit for Dart and Flutter,
built on `get_it` with **folder-scoped micro-packages** and explicit, class-form
annotations — no magic, no globals, no boilerplate matching.

📖 **[Complete Documentation](docs/README.md)** — Comprehensive guides organized by the Diátaxis framework (Getting Started, Concepts, Tasks, Tutorials, Reference).

---

## Monorepo Packages

| Package                                                      | Description                                                                                                                                                                                                                        |
| ------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`packages/injectable`](packages/injectable)                 | Runtime annotations (`@Injectable`, `@InjectableInit`, `@InjectableMicroPackage`, `@ExternalModule`, …), `Scope` enum, `MicroPackageModule` base class, and `GetItHelper` (environment-gated registration wrapper around `GetIt`). |
| [`packages/injectable_codegen`](packages/injectable_codegen) | `build_runner` generator that scans annotated sources and emits `<file>.config.dart` with collision-free aliased imports and typed registrations.                                                                                  |

> How the generator works end-to-end: see [INJECTABLE_CODEGEN.md](INJECTABLE_CODEGEN.md) and [Architecture Documentation](docs/concepts/architecture.md).

---

## Key Features

- **Code-Generated Registrations**: Annotate, run `build_runner`, and get a
  typed GetIt `init()` — constructor parameters resolve from the container.
- **Folder-Scoped Micro-Packages**: `@InjectableMicroPackage(moduleName: 'Feature')`
  isolates a folder into its own module. Nested sub-modules auto-compose via
  `useMicroPackage: true` (each module is composed exactly once).
- **Root Compositor**: `@InjectableInit(useMicroPackage: true)` discovers all
  folder micro-packages and registers them flatly at the root container.
- **External Module Composition**: `externalMicroPackages: [ExternalMicroPackage(ModuleType)]`
  composes modules from other packages (other pubspecs) in declaration order —
  no manual `getIt.initX()` wiring.
- **Scopes**: unified `@Injectable(scope: Scope.singleton | Scope.lazySingleton | Scope.factory)`
  with Dart enum dot-shorthand support (`scope: .lazySingleton`).
- **Async & Tagged Registrations**: `@PreResolve` / `Future` factories emit
  `singletonAsync`; `@Inject('tag')` emits named GetIt lookups.
- **Environment Gating**: `@Environment('dev')` / `@dev` registers only for
  matching environments via `EnvironmentFilter`.

---

## Documentation Structure

Our documentation follows the standard Diátaxis framework adopted by Kubernetes:

- **[Getting Started](docs/getting-started/README.md)**: [Installation](docs/getting-started/installation.md) · [Quickstart](docs/getting-started/quickstart.md) · [Monorepo Setup](docs/getting-started/monorepo-setup.md)
- **[Concepts](docs/concepts/README.md)**: [Architecture](docs/concepts/architecture.md) · [Scopes & Lifecycles](docs/concepts/scopes-and-lifecycles.md) · [Micro-Packages](docs/concepts/micro-packages.md) · [Environments](docs/concepts/environments-and-filtering.md) · [Async & PreResolve](docs/concepts/async-and-preresolve.md)
- **[Tasks](docs/tasks/README.md)**: [Root Container](docs/tasks/configure-root-container.md) · [Folder Micro-Packages](docs/tasks/declare-folder-micro-packages.md) · [External Micro-Packages](docs/tasks/compose-external-micro-packages.md) · [Factory Parameters](docs/tasks/work-with-factory-parameters.md) · [Third-Party Types](docs/tasks/register-third-party-types.md)
- **[Tutorials](docs/tutorials/README.md)**: [Modular Flutter App](docs/tutorials/modular-flutter-app.md) · [Multi-Package Monorepo](docs/tutorials/multi-package-monorepo.md)
- **[Reference](docs/reference/README.md)**: [Annotations](docs/reference/annotations.md) · [Build Configuration](docs/reference/build-configuration.md) · [Runtime API](docs/reference/runtime-api.md) · [Glossary](docs/reference/glossary.md)

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

Bound a folder into its own module — its dependencies cannot leak into sibling
folders, and nested sub-modules are self-contained:

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
@InjectableInit(
  initializerName: 'init',\
  useMicroPackage: true, // discover and compose all folder micro-packages
  externalMicroPackages: [
    ExternalMicroPackage(SharedInjectableModule), // modules from other pubspecs
  ],
)
Future<void> configureDependencies() async => getIt.init();
```

---

## Examples

| Example                                                            | Demonstrates                                                                                                                                                                                                               |
| ------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`examples/micro_package_example`](examples/micro_package_example) | Folder-scoped micro-packages (`features/auth`, `features/catalog`, `features/cart`) without per-folder pubspec files, composed flatly by a root `@InjectableInit`.                                                         |
| [`examples/demo_monorepo`](examples/demo_monorepo)                 | A self-contained monorepo: packages with their own pubspecs (scenario A) plus a nested folder micro-package (scenario A′), composed via `externalMicroPackages`, with async `@PreResolve` singletons and tagged injection. |

---

## Monorepo Development

This repository uses [Dart Pub Workspaces](https://dart.dev/tools/pub/workspaces) and [Melos](https://pub.dev/packages/melos).

### Setup

```bash
dart pub get
```

### Workspace Commands

| Command         | Description                                                |
| --------------- | ---------------------------------------------------------- |
| `melos analyze` | Analyze all packages with zero lints or warnings           |
| `melos test`    | Run the test suite across all packages                     |
| `melos build`   | Run `build_runner build` across packages that depend on it |
| `melos format`  | Check code formatting                                      |

### Regenerating Example Configs

After changing annotations or the generator:

```bash
dart run build_runner build --delete-conflicting-outputs  # in each example
```

Generated `.config.dart` files are committed in this repo's examples.

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
