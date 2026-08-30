---
title: "Modules & External Classes"
linkTitle: "External Modules"
weight: 5
description: >
  Registering third-party instances and abstract provider classes via @ExternalModule.
---

Not all dependencies are classes defined within your project that you can directly annotate. Many dependencies come from third-party packages (e.g. `SharedPreferences`, `Dio`, `FirebaseAuth`, `HttpClient`).

Injectable provides `@ExternalModule` to register these external instances cleanly.

---

## 1. Defining an External Module

To register third-party classes or custom factory functions, define an `abstract class` annotated with `@ExternalModule()`:

```dart
// lib/core/register_module.dart
import 'package:injectify/injectify.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

@ExternalModule()
abstract class RegisterModule {
  // Synchronous factory or singleton
  @Injectable(scope: Scope.lazySingleton)
  http.Client get httpClient => http.Client();

  // Asynchronous pre-resolved singleton
  @PreResolve
  @Injectable(scope: Scope.singleton)
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  // Parameterized factory method
  @Injectable(scope: Scope.factory)
  Uri apiUrl(@Inject('baseUrl') String host, @FactoryParam() String endpoint) {
    return Uri.parse('$host/$endpoint');
  }
}
```

---

## 2. How the Generator Handles External Modules

During code generation:

1. The generator creates a private helper implementation class `_$RegisterModule`.
2. It instantiates `_$RegisterModule` inside `init()`.
3. Every public getter or method annotated with `@Injectable` is registered into `GetIt` via `gh`:

```dart
// Generated in injection.config.dart
final registerModule = _$RegisterModule(this);
gh.lazySingleton<_i1.Client>(() => registerModule.httpClient);
await gh.singletonAsync<_i2.SharedPreferences>(() => registerModule.prefs);
```

---

## 3. Method vs Getter Rules

Choose between getters and methods based on how the dependency is resolved:

- **Getters** (`Type get myDep => ...`) — for zero-argument dependencies or dependencies that resolve their parameters from `GetIt`.
- **Methods** (`Type createDep(DepA a, @FactoryParam() String p) => ...`) — when passing parameters at resolution time, or requiring custom initialization logic.
