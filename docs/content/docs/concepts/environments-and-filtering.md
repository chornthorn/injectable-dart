---
title: "Environments and Filtering"
linkTitle: "Environments"
weight: 6
description: >
  Environment gating for dev, prod, and test configurations using EnvironmentFilter.
---

Environment gating allows you to register different implementations of dependencies based on the runtime context (e.g. `dev`, `prod`, `test`).

---

## 1. Built-in Environment Names

`Environment` provides three predefined constants:
- `Environment.dev` (`'dev'`)
- `Environment.prod` (`'prod'`)
- `Environment.test` (`'test'`)

You can also define custom environment strings (e.g. `'staging'`, `'mock'`, `'demo'`).

---

## 2. Gating Dependencies

Use the `env:` parameter on `@Injectable()` or the `@Environment('...')` annotation:

```dart
abstract class ApiService {
  Future<String> fetchData();
}

// Development implementation (Mock)
@Injectable(as: ApiService, env: [Environment.dev, Environment.test])
class MockApiService implements ApiService {
  @override
  Future<String> fetchData() async => 'Mock data';
}

// Production implementation
@Injectable(as: ApiService, env: [Environment.prod])
class RealApiService implements ApiService {
  @override
  Future<String> fetchData() async => 'Real live data';
}
```

Generated registration:
```dart
gh.factory<ApiService>(
  () => MockApiService(),
  registerFor: {'dev', 'test'},
);
gh.factory<ApiService>(
  () => RealApiService(),
  registerFor: {'prod'},
);
```

---

## 3. Initializing with Environments

Pass the active environment to your initialization call:

```dart
// lib/injection.dart
void configureDependencies(String env) => getIt.init(environment: env);

// bin/main.dart
void main() {
  configureDependencies(Environment.prod);
}
```

---

## 4. Custom Environment Filters

If your app requires complex matching (such as multiple concurrent environments or custom gating rules), implement `EnvironmentFilter`:

```dart
import 'package:injectable/injectable.dart';

class CustomEnvironmentFilter extends EnvironmentFilter {
  final Set<String> activeEnvironments;

  CustomEnvironmentFilter(this.activeEnvironments);

  @override
  bool canRegister(Set<String> dependencyEnvironments) {
    // Register if dependency has no env restrictions or shares any active env
    return dependencyEnvironments.isEmpty ||
        dependencyEnvironments.any(activeEnvironments.contains);
  }
}
```

Pass the filter during initialization:

```dart
getIt.init(
  environmentFilter: CustomEnvironmentFilter({'prod', 'eu-region'}),
);
```
