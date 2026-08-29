---
title: "Manage Async Singletons"
linkTitle: "Manage Async Singletons"
weight: 6
description: >
  Initialize asynchronous dependencies and configure @PreResolve.
---

This guide covers registering and waiting for asynchronous dependencies.

---

## 1. Asynchronous Factory Methods

If your class needs asynchronous setup, define a static factory method annotated with `@FactoryMethod`:

```dart
import 'package:injectable/injectable.dart';

@Injectable(scope: Scope.singleton)
class LocalDatabase {
  final String dbPath;
  LocalDatabase._(this.dbPath);

  @FactoryMethod()
  static Future<LocalDatabase> initialize() async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simulating DB opening
    return LocalDatabase._('/data/app.db');
  }
}
```

---

## 2. Using `@PreResolve`

When you want the root `configureDependencies()` function to await the completion of this singleton before proceeding:

```dart
@ExternalModule()
abstract class CoreModule {
  @PreResolve
  @Injectable(scope: Scope.singleton)
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
```

Update your `configureDependencies` method to be `async`:

```dart
// lib/injection.dart
Future<void> configureDependencies() async {
  await getIt.init();
}
```

---

## 3. Resolving Without PreResolve

If you do not use `@PreResolve`, `GetIt` initializes the singleton asynchronously in the background. Access it using `getAsync` or `allReady()`:

```dart
void main() async {
  configureDependencies();

  // Option A: Await specific dependency
  final db = await getIt.getAsync<LocalDatabase>();

  // Option B: Await all pending async singletons
  await getIt.allReady();
  final readyDb = getIt<LocalDatabase>();
}
```
