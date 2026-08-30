---
title: "Async Dependencies & PreResolve"
linkTitle: "Async & PreResolve"
weight: 7
description: >
  Asynchronous singletons, initialization synchronization, and @PreResolve annotations.
---

Many modern services and SDKs require asynchronous initialization before they can be used (e.g. database opening, reading cached disk files, or setting up secure storage).

Injectify provides first-class support for asynchronous dependencies through `@PreResolve` and `singletonAsync`.

---

## 1. Asynchronous Singletons (`singletonAsync`)

When a class is marked with `@PreResolve`, or an external module getter/method returns a `Future<T>`, Injectify automatically emits an asynchronous registration (`gh.singletonAsync<T>`).

For an **external module member**, the `Future` return type is detected automatically — no annotation needed:

```dart
@ExternalModule()
abstract class StorageModule {
  @Injectable(scope: Scope.singleton)
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
```

For a **class**, mark it with `@PreResolve` so the generator emits `await gh.singletonAsync<T>(() async => T(...))`:

```dart
@PreResolve()
@Injectable(scope: Scope.singleton)
class DatabaseConnection {
  final Future<Database> db;

  DatabaseConnection() : db = openDatabase('app.db');
}
```

Generated registration:

```dart
await gh.singletonAsync<DatabaseConnection>(() async => DatabaseConnection());
```

---

## 2. Pre-resolving with `@PreResolve`

Async registrations are emitted with `await` inside the generated `init()`, which makes `init()` return `Future<GetIt>`. Note that only the **registration** is awaited — `registerSingletonAsync` does not run the factory to completion. The instance stays **pending** in the container until the app calls `await getIt.allReady()` or `await getIt.getAsync<T>()`; until then, synchronous `getIt<T>()` throws.

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
    final storageModule = _$StorageModule();
    await gh.singletonAsync<SharedPreferences>(() => storageModule.prefs);
    return this;
  }
}
```

{{% alert title="Note" color="info" %}}
If any dependency in your graph is async (`@PreResolve` or a `Future`-returning member), the generated `init()` method signature changes from synchronous `GetIt init()` to asynchronous `Future<GetIt> init()`.
{{% /alert %}}

---

## 3. Resolving Asynchronous Instances at Runtime

Async singletons are resolved after `init()` via either:

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
