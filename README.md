# Injectable for Dart & Flutter

A powerful code-generation dependency injection toolkit for Dart & Flutter built on top of [GetIt](https://pub.dev/packages/get_it).

It automates service locator registration, manages asynchronous dependency resolution, isolates modular domains via **Folder-Scoped Micro-Packages**, and supports seamless multi-package monorepo architectures.

---

## Documentation

Full documentation, interactive architecture diagrams, tutorials, and API reference are available at:

👉 **[https://chornthorn.github.io/injectable-dart/](https://chornthorn.github.io/injectable-dart/)**

---

## Key Features

- **Code-Generated Registrations**: Annotate, run `build_runner`, and get a typed GetIt `init()` — constructor parameters resolve from the container.
- **Folder-Scoped Micro-Packages**: `@InjectableMicroPackage(moduleName: 'Feature')` isolates a folder into its own module. Nested sub-modules auto-compose via `useMicroPackage: true` (each module is composed exactly once).
- **Root Compositor**: `@InjectableInit(useMicroPackage: true)` discovers all folder micro-packages and registers them flatly at the root container.
- **External Module Composition**: `externalMicroPackages: [ExternalMicroPackage(ModuleType)]` composes modules from other packages (other pubspecs) in declaration order — no manual `getIt.initX()` wiring.
- **Scopes**: Unified `@Injectable(scope: Scope.singleton | Scope.lazySingleton | Scope.factory)`.
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
  injectable:
    git:
      url: https://github.com/chornthorn/injectable-dart.git
      path: injectable
  get_it: ^9.2.1

dev_dependencies:
  build_runner: ^2.4.0
  injectable_codegen:
    git:
      url: https://github.com/chornthorn/injectable-dart.git
      path: injectable_codegen
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
