---
title: "Scopes and Lifecycles"
linkTitle: "Scopes & Lifecycles"
weight: 3
description: >
  Instance lifetimes in Injectable: Factory, Singleton, Lazy Singleton, and dot-shorthand syntax.
---

In Injectable, the lifecycle of a dependency is controlled by the `Scope` enumeration.

---

## 1. Supported Lifecycles

| Scope | Enum Value | Behavior | GetIt Equivalent |
| :--- | :--- | :--- | :--- |
| **Factory** | `Scope.factory` (default) | A new instance is created on **every lookup** (`getIt<T>()`). | `registerFactory` |
| **Lazy Singleton** | `Scope.lazySingleton` | A single shared instance created **on first lookup** and cached. | `registerLazySingleton` |
| **Eager Singleton** | `Scope.singleton` | A single shared instance created **immediately** at `init()` time. | `registerSingleton` |

---

## 2. Defining Lifecycles

### Factory (Default)

```dart
import 'package:injectable/injectable.dart';

// Omitting the scope parameter defaults to Scope.factory
@Injectable()
class SearchBloc {
  final ApiClient client;
  SearchBloc(this.client);
}
```

Generated code:
```dart
gh.factory<SearchBloc>(() => SearchBloc(gh<ApiClient>()));
```

---

### Lazy Singleton

Recommended for stateless services, repositories, and API clients that should only be created if needed.

```dart
@Injectable(scope: Scope.lazySingleton)
class AnalyticsTracker {
  // Initialized only when first requested
}
```

Generated code:
```dart
gh.lazySingleton<AnalyticsTracker>(() => AnalyticsTracker());
```

---

### Eager Singleton

Useful for services that perform background monitoring, cache pre-warming, or must be instantiated immediately during app initialization.

```dart
@Injectable(scope: Scope.singleton)
class PushNotificationManager {
  PushNotificationManager() {
    _startListening();
  }
  void _startListening() {}
}
```

Generated code:
```dart
gh.singleton<PushNotificationManager>(PushNotificationManager());
```

---

## 3. Dart 3 Dot-Shorthand Syntax

Injectable supports Dart's enum dot-shorthand syntax for clean, concise annotations:

```dart
// Explicit enum reference
@Injectable(scope: Scope.lazySingleton)
class MyServiceA {}

// Dot-shorthand equivalent
@Injectable(scope: .lazySingleton)
class MyServiceB {}

@Injectable(scope: .singleton)
class MyServiceC {}

@Injectable(scope: .factory)
class MyServiceD {}
```

---

## 4. Binding to an Interface / Abstract Type

To register an implementation under an interface or abstract base class type, use the `as:` parameter:

```dart
abstract class AuthRepository {
  Future<void> login(String username, String password);
}

@Injectable(as: AuthRepository, scope: .lazySingleton)
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<void> login(String username, String password) async {}
}
```

Generated registration:
```dart
gh.lazySingleton<AuthRepository>(() => AuthRepositoryImpl());
```

Clients resolve the dependency via the interface type:
```dart
final auth = getIt<AuthRepository>(); // Resolves AuthRepositoryImpl
```
