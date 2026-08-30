---
title: "Runtime API Reference"
linkTitle: "Runtime API"
weight: 3
description: >
  GetItHelper, MicroPackageModule, EnvironmentFilter, and Scope API documentation.
---

This document covers the public runtime API provided by the `injectify` package.

---

## 1. `GetItHelper`

A wrapper around `GetIt` that applies environment filters and registers dependencies.

```dart
class GetItHelper {
  final GetIt getIt;
  final EnvironmentFilter? environmentFilter;
  final String? environment;

  GetItHelper(this.getIt, {this.environment, this.environmentFilter});

  T get<T extends Object>({String? instanceName, dynamic param1, dynamic param2, Type? type});
  T call<T extends Object>({String? instanceName, dynamic param1, dynamic param2, Type? type});

  void factory<T extends Object>(
    FactoryFunc<T> factoryFunc, {
    String? instanceName,
    Set<String>? registerFor,
  });

  void factoryWithParam<T extends Object, P1, P2>(
    FactoryFuncParam<T, P1, P2> factoryFunc, {
    String? instanceName,
    Set<String>? registerFor,
  });

  void lazySingleton<T extends Object>(
    FactoryFunc<T> factoryFunc, {
    String? instanceName,
    DisposingFunc<T>? dispose,
    Set<String>? registerFor,
  });

  T singleton<T extends Object>(
    T instance, {
    String? instanceName,
    bool? signalsReady,
    DisposingFunc<T>? dispose,
    Set<String>? registerFor,
  });

  Future<void> singletonAsync<T extends Object>(
    FactoryFuncAsync<T> factoryFunc, {
    String? instanceName,
    Iterable<Type>? dependsOn,
    bool? signalsReady,
    DisposingFunc<T>? dispose,
    Set<String>? registerFor,
  });

  FutureOr<void> initMicroPackage(MicroPackageModule module);
}
```

---

## 2. `MicroPackageModule`

The base class for all micro-package registration modules.

```dart
abstract class MicroPackageModule {
  const MicroPackageModule();
  FutureOr<void> init(GetItHelper gh);
}
```

---

## 3. `EnvironmentFilter`

Abstract strategy for deciding whether a dependency should be registered in the active environment.

```dart
abstract class EnvironmentFilter {
  final Set<String> environments;
  const EnvironmentFilter(this.environments);

  bool canRegister(Set<String> dependencyEnvironments);
}
```

### Predefined Implementations

- `NoEnvOrContains`: Registers if dependency has no environment restrictions OR matches any active environment.
- `NoEnvOrContainsAll`: Registers if dependency has no environment restrictions OR matches all active environments.
- `SimpleEnvironmentFilter`: Constructor-based filter equivalent to `NoEnvOrContains` — registers if the dependency's environments intersect the filter's active set.

---

## 4. `Scope`

Lifecycle enum for dependency registration.

```dart
enum Scope {
  factory,
  singleton,
  lazySingleton,
}
```
