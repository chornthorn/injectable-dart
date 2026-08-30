# Injectify

Code-generated dependency injection for Dart & Flutter, built on top of [GetIt](https://pub.dev/packages/get_it).

Annotate plain Dart classes and let `injectify_generator` (via `build_runner`) emit a deterministic, type-safe registration file — no manual wiring, no reflection.

## Features

- **Class-form annotations**: `@Injectable`, `@InjectableInit`, `@InjectableMicroPackage`, `@ExternalModule`, `@Inject`, `@FactoryParam`, `@PreResolve`, `@Environment`, `@Order`, `@DisposeMethod`
- **Unified scopes**: `Scope.factory`, `Scope.singleton`, `Scope.lazySingleton`
- **Folder-scoped micro-packages**: isolate feature folders with automatic boundary exclusion
- **Monorepo composition**: compose modules from other pubspecs via `externalMicroPackages` in declaration order
- **Environment gating**: `env:` / `@Environment` + pluggable `EnvironmentFilter` implementations
- **Async singletons**: `Future`-returning members and `@PreResolve` classes emit `gh.singletonAsync<T>()` registrations

## Quickstart

```yaml
dependencies:
  get_it: ^9.2.1
  injectify: ^0.1.0

dev_dependencies:
  build_runner: ^2.4.0
  injectify_generator: ^0.1.0
```

```dart
import 'package:injectify/injectify.dart';

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

```dart
// lib/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectify/injectify.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();
```

Run code generation:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Documentation

Full documentation, tutorials, and API reference: <https://chornthorn.github.io/injectify-dart/>

## License

Apache-2.0 — see [LICENSE](LICENSE).
