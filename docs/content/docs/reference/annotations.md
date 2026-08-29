---
title: "Annotations Reference"
linkTitle: "Annotations"
weight: 1
description: >
  Full API reference for all Injectable annotations.
---

Injectable uses explicit, class-form annotations. Const variables are omitted to ensure consistent syntax across all annotation usages.

---

## 1. Core Registration Annotations

### `@Injectable`

Marks a class or factory method as a dependency eligible for injection.

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

| Parameter      | Type            | Default         | Description                                                                  |
| :------------- | :-------------- | :-------------- | :--------------------------------------------------------------------------- |
| `scope`        | `Scope`         | `Scope.factory` | Lifecycle scope (`Scope.factory`, `Scope.singleton`, `Scope.lazySingleton`). |
| `as`           | `Type?`         | `null`          | Bind this implementation to an interface or abstract base class.             |
| `env`          | `List<String>?` | `null`          | Restrict registration to specified environments (e.g. `[Environment.dev]`).  |
| `order`        | `int?`          | `0`             | Explicit sorting priority during registration generation.                    |
| `getItScope`   | `String?`       | `null`          | Optional GetIt scope name.                                                   |
| `signalsReady` | `bool?`         | `null`          | Whether this singleton signals readiness to GetIt.                           |
| `dependsOn`    | `List<Type>?`   | `null`          | Dependencies that must be initialized before this async singleton.           |
| `dispose`      | `Function?`     | `null`          | Disposal callback invoked on container reset.                                |

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

Marks a specific constructor or static method as the factory instantiator for the class.

```dart
const FactoryMethod();
```

### `@PreResolve`

Marks an asynchronous singleton dependency that must be awaited during container initialization.

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

### `@PostLocalInit`

Marks a method on an instance to be executed immediately after the instance is instantiated.

```dart
const PostLocalInit();
```
