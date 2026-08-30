---
title: "Manage Async Singletons"
linkTitle: "Manage Async Singletons"
weight: 6
description: >
  Initialize asynchronous dependencies and configure @PreResolve.
---

This guide covers registering and waiting for asynchronous dependencies.

---

## 1. Asynchronous Classes

If your class needs asynchronous setup, mark it with `@PreResolve` so the generator emits `await gh.singletonAsync<T>(...)`:

```dart
import 'package:injectify/injectify.dart';

@PreResolve()
@Injectable(scope: Scope.singleton)
class LocalDatabase {
  final Future<void> opened;

  LocalDatabase() : opened = _open();

  static Future<void> _open() async {
    // Simulating DB opening
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}
```

Generated registration:

```dart
await gh.singletonAsync<LocalDatabase>(() async => LocalDatabase());
```

The singleton is registered as **pending** — `getIt<LocalDatabase>()` throws until the future completes.

---

## 2. Using `@PreResolve` on External Module Members

For `Future`-returning getters or methods in an `@ExternalModule`, the async registration is auto-detected from the return type (an explicit `@PreResolve` is optional):

```dart
@ExternalModule()
abstract class CoreModule {
  @PreResolve
  @Injectable(scope: Scope.singleton)
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
```

Because async registrations exist, `init()` is generated as `Future<GetIt>`:

```dart
// lib/injection.dart
Future<void> configureDependencies() async {
  await getIt.init();
  await getIt.allReady(); // resolve all pending async singletons
}
```

---

## 3. Resolving Without `allReady()`

If you do not call `allReady()`, the singleton stays pending. Access it with `getAsync` or wait with `allReady()`:

```dart
void main() async {
  await configureDependencies();

  // Option A: Await specific dependency
  final db = await getIt.getAsync<LocalDatabase>();

  // Option B: Await all pending async singletons
  await getIt.allReady();
  final readyDb = getIt<LocalDatabase>();
}
```
