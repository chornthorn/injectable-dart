---
title: "Annotations Reference"
linkTitle: "Annotations"
weight: 1
description: >
  Full API reference for all Injectify annotations.
---

Injectify uses explicit, class-form annotations. Const variables are omitted to ensure consistent syntax across all annotation usages.

---

## 1. Core Registration Annotations

### `@Injectable`

Marks a class as a dependency eligible for injection.

```dart
const Injectable({
  Scope scope = Scope.factory,
  Type? as,
  List<String>? env,
  int? order,
  String? getItScope,
  bool? signalsReady,
  List<Type>? dependsOn,
  Function? dispose,
});
```

Each parameter controls one aspect of the registration:

- **`scope`** (`Scope`, default `Scope.factory`) — Lifecycle scope: `Scope.factory`, `Scope.singleton`, or `Scope.lazySingleton`.
- **`as`** (`Type?`, default `null`) — Binds this implementation to an interface or abstract base class.
- **`env`** (`List<String>?`, default `null`) — Restricts registration to specified environments (e.g. `[Environment.dev]`).
- **`order`** (`int?`, default `0`) — Explicit sorting priority during registration generation.
- **`getItScope`** (`String?`, default `null`) — Accepted by the annotation API but not yet emitted by the generator; reserved for future GetIt scope support.
- **`signalsReady`** (`bool?`, default `null`) — Whether this singleton signals readiness to GetIt.
- **`dependsOn`** (`List<Type>?`, default `null`) — Accepted by the annotation API but not yet emitted by the generator; reserved for future dependency-ordering support.
- **`dispose`** (`Function?`, default `null`) — Optional dispose callback field on the annotation. Disposal is currently wired from methods marked with `@DisposeMethod` — see [Custom Disposal Hooks](/docs/tasks/custom-disposal-hooks/).

---

### `@InjectableInit`

Marks the root initialization entrypoint for dependency injection code generation.

```dart
const InjectableInit({
  String initializerName = 'init',
  bool preferRelativeImports = true,
  bool asExtension = true,
  List<String> generateForDir = const ['lib'],
  bool useMicroPackage = false,
  List<Type> modules = const [],
  List<ExternalMicroPackage> externalMicroPackages = const [],
  String? moduleName,
  String? moduleClassName,
  bool? allowMultipleRegistrations,
});
```

---

### `@InjectableMicroPackage`

Marks a feature directory or sub-module as an isolated micro-package.

```dart
const InjectableMicroPackage({
  String initializerName = 'init',
  bool preferRelativeImports = true,
  bool asExtension = true,
  List<String> generateForDir = const ['lib'],
  bool useMicroPackage = false,
  List<Type> modules = const [],
  List<ExternalMicroPackage> externalMicroPackages = const [],
  String? moduleName,
  String? moduleClassName,
  bool? allowMultipleRegistrations,
});
```

---

### `@ExternalMicroPackage`

References a `MicroPackageModule` class from another package (different `pubspec.yaml`) to be composed during root initialization.

```dart
const ExternalMicroPackage(Type moduleType);
```

---

### `@ExternalModule`

Marks an abstract class as a provider for external/third-party instances.

```dart
const ExternalModule();
```

---

## 2. Qualifier & Parameter Annotations

### `@Inject`

Qualifies a dependency with an explicit instance tag or string token.

```dart
const Inject(String tag);
```

### `@FactoryParam`

Marks a constructor parameter to be passed dynamically at runtime during resolution (`getIt<T>(param1: ..., param2: ...)`).

```dart
const FactoryParam();
```

### `@FactoryMethod`

Marks a specific **constructor** as the factory instantiator for the class. The generator emits the registration using that constructor instead of the unnamed one.

```dart
@Injectable(scope: Scope.singleton)
class DatabaseConnection {
  final Future<Database> db;

  @FactoryMethod()
  @PreResolve()
  DatabaseConnection.opened() : db = openDatabase('app.db');
}
```

### `@PreResolve`

Marks a class (or external module member) as an asynchronous singleton. The generator emits `await gh.singletonAsync<T>(...)`, registering the instance as **pending** in the container. The future completes when the app calls `await getIt.allReady()` or `await getIt.getAsync<T>()` — synchronous `getIt<T>()` throws until then.

```dart
const PreResolve();
```

### `@Environment`

Restricts dependency registration to specific named environments.

```dart
const Environment(String name);
```

### `@Order`

Sets explicit registration priority position (lower numbers register earlier).

```dart
const Order(int position);
```

### `@DisposeMethod`

Marks an instance method on a class to be executed when `GetIt` disposes of the singleton.

```dart
const DisposeMethod();
```
