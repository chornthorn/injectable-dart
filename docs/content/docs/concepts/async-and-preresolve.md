---
title: "Async Dependencies & PreResolve"
linkTitle: "Async & PreResolve"
weight: 7
description: >
  Asynchronous singletons, initialization synchronization, and @PreResolve annotations.
---

Many modern services and SDKs require asynchronous initialization before they can be used (e.g. database opening, reading cached disk files, or setting up secure storage).

Injectable provides first-class support for asynchronous dependencies through `@PreResolve` and `singletonAsync`.

---

## 1. Asynchronous Singletons (`singletonAsync`)

When a factory method or class constructor returns a `Future<T>`, Injectable automatically generates an asynchronous registration.

```dart
@Injectable(scope: Scope.singleton)
class DatabaseConnection {
  final Database db;
  DatabaseConnection._(this.db);

  @FactoryMethod()
  static Future<DatabaseConnection> create() async {
    final db = await openDatabase('app.db');
    return DatabaseConnection._(db);
  }
}
```

Generated registration:

```dart
gh.singletonAsync<DatabaseConnection>(() => DatabaseConnection.create());
```

---

## 2. Pre-resolving with `@PreResolve`

When an asynchronous dependency is marked with `@PreResolve`, the generated `init()` function marks the step with `await`, guaranteeing that the instance is completely ready before `init()` completes.

```dart
@ExternalModule()
abstract class StorageModule {
  @PreResolve
  @Injectable(scope: Scope.singleton)
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
```

Generated initialization:

```dart
extension GetItInjectableX on GetIt {
  Future<GetIt> init({...}) async {
    final gh = GetItHelper(this, ...);
    final storageModule = _$StorageModule(this);
    await gh.singletonAsync<SharedPreferences>(() => storageModule.prefs);
    return this;
  }
}
```

{{% alert title="Note" color="info" %}}
If any dependency in your graph uses `@PreResolve`, the generated `init()` method signature changes from synchronous `GetIt init()` to asynchronous `Future<GetIt> init()`.
{{% /alert %}}

---

## 3. Resolving Asynchronous Instances at Runtime

If a singleton is registered via `singletonAsync` (without `@PreResolve`), it can be resolved at runtime using either:

### 1. `getIt.isReady<T>()` & `getIt.getAsync<T>()`

```dart
final db = await getIt.getAsync<DatabaseConnection>();
```

### 2. `getIt.allReady()`

Wait for all asynchronous singletons across the entire container to complete:

```dart
await getIt.allReady();
final db = getIt<DatabaseConnection>(); // Now safe to access synchronously
```
