# Injectable for Dart & Flutter

A powerful code-generation dependency injection toolkit for Dart & Flutter built on top of [GetIt](https://pub.dev/packages/get_it).

It automates service locator registration, manages asynchronous dependency resolution, isolates modular domains via **Folder-Scoped Micro-Packages**, and supports seamless multi-package monorepo architectures.

---

## Documentation

Full documentation, interactive architecture diagrams, tutorials, and API reference are available at:

**[https://chornthorn.github.io/injectable-dart/](https://chornthorn.github.io/injectable-dart/)**

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

## Agent Skills Support

This repository ships with a standard [Agent Skill](https://agentskills.io) conforming to the Agent Skills specification located in [`skills/injectable/`](skills/injectable/).

Developers using AI assistants (Claude Code, Cursor, Antigravity, GitHub Copilot, Codex, etc.) can equip their agents with full Injectable expertise by copying or downloading the skill into their project:

```bash
# In your Dart/Flutter project directory:
mkdir -p .agents/skills/injectable
cp -r /path/to/injectable-dart/skills/injectable/* .agents/skills/injectable/
```

The skill includes complete guidance for:

- Automatic DI setup and code generation (`build_runner`)
- Modern annotations (`@Injectable`, `@InjectableInit`, `@InjectableMicroPackage`, `@ExternalModule`, `@Inject`, `@FactoryParam`, `@PreResolve`)
- Folder micro-packages and multi-package monorepos
- Ready-to-use templates for `injection.dart`, micro-packages, and `build.yaml`

---

## Documentation Overview

The documentation is organized into four core pillars:

1. **[Getting Started](https://chornthorn.github.io/injectable-dart/docs/getting-started/)**: Installation, initial configuration, `build_runner` workflows, and quickstart tutorials.
2. **[Core Concepts](https://chornthorn.github.io/injectable-dart/docs/concepts/)**: Deep dives into dependency injection mechanics, lifetimes, micro-package isolation, asynchronous startup (`@PreResolve`), and environment gating.
3. **[How-To Tasks](https://chornthorn.github.io/injectable-dart/docs/tasks/)**: Step-by-step recipes for custom disposal hooks, parameterized factories, third-party module registration, and cross-package linking.
4. **[API Reference](https://chornthorn.github.io/injectable-dart/docs/reference/)**: Exhaustive specifications for all annotations, CLI builder options, diagnostic error codes, and glossary definitions.

---

## Quickstart

### 1. Add Dependencies

Add the runtime annotations to `dependencies` and the code generator to `dev_dependencies`:

```yaml
dependencies:
  get_it: ^8.0.3
  injectable:
    git:
      url: https://github.com/chornthorn/injectable-dart.git
      path: packages/injectable

dev_dependencies:
  build_runner: ^2.4.15
  injectable_codegen:
    git:
      url: https://github.com/chornthorn/injectable-dart.git
      path: packages/injectable_codegen
```

### 2. Define Injectable Services

```dart
import 'package:injectable/injectable.dart';

@Injectable(scope: Scope.lazySingleton)
class ApiService {
  final String baseUrl;
  ApiService({this.baseUrl = 'https://api.example.com'});
}

@Injectable(scope: Scope.factory)
class UserRepository {
  final ApiService api;
  UserRepository(this.api);
}
```

### 3. Initialize GetIt Registry

```dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'main.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

void main() async {
  await configureDependencies();

  final repo = getIt<UserRepository>();
  print('UserRepository initialized with API: ${repo.api.baseUrl}');
}
```

### 4. Run Builder

```bash
# Dart
dart run build_runner build --delete-conflicting-outputs

# Flutter
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Monorepo & Modular Architecture

For large scale codebases, decompose your feature modules using **Folder Micro-Packages**:

```
lib/
├── features/
│   ├── auth/
│   │   ├── auth_service.dart          # Annotated with @Injectable()
│   │   └── auth_module.dart           # Annotated with @InjectableMicroPackage(moduleName: 'Auth')
│   └── catalog/
│       ├── catalog_service.dart       # Annotated with @Injectable()
│       └── catalog_module.dart        # Annotated with @InjectableMicroPackage(moduleName: 'Catalog')
└── main.dart                          # Annotated with @InjectableInit(useMicroPackage: true)
```

Run `build_runner` once at the root: each feature generates its own isolated module initialization extension, and the root `init()` orchestrates the entire container tree cleanly.

---

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.
