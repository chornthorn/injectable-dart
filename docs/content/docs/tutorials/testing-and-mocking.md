---
title: "Testing & Mocking Strategies"
linkTitle: "Testing & Mocking"
weight: 5
description: >
  Comprehensive guide to unit testing, widget testing, environment switching, and mocking dependencies in Injectable.
---

Testing applications built with Injectify is straightforward because dependencies are decoupled through constructor injection and environment filtering.

This tutorial covers unit testing, mocking interfaces, environment switching (`@Environment`), and resetting the GetIt locator between tests.

---

## 1. Defining Interfaces for Mocking

To enable seamless test substitution, bind implementations to abstract contracts:

```dart
// lib/domain/auth_repository.dart
abstract class AuthRepository {
  Future<bool> login(String email, String password);
}
```

Implement the production repository:

```dart
// lib/data/auth_repository_impl.dart
import 'package:injectify/injectify.dart';
import '../domain/auth_repository.dart';

@Environment(Environment.prod)
@Environment(Environment.dev)
@Injectable(as: AuthRepository, scope: Scope.lazySingleton)
class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  AuthRepositoryImpl(this.apiClient);

  @override
  Future<bool> login(String email, String password) async {
    return apiClient.authenticate(email, password);
  }
}
```

Implement an automated test mock repository:

```dart
// lib/data/mock_auth_repository.dart
import 'package:injectify/injectify.dart';
import '../domain/auth_repository.dart';

@Environment(Environment.test)
@Injectable(as: AuthRepository, scope: Scope.lazySingleton)
class MockAuthRepository implements AuthRepository {
  bool shouldSucceed = true;

  @override
  Future<bool> login(String email, String password) async {
    return shouldSucceed;
  }
}
```

---

## 2. Unit Testing Services in Isolation (Pure Unit Tests)

Because services take their dependencies as constructor arguments, you do not need to boot GetIt for simple unit tests. You can instantiate them directly with mock objects:

```dart
// test/auth_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/domain/auth_repository.dart';

class TestMockRepo implements AuthRepository {
  @override
  Future<bool> login(String email, String password) async => email == 'user@test.com';
}

void main() {
  test('Login succeeds with valid credentials', () async {
    final mockRepo = TestMockRepo();
    final result = await mockRepo.login('user@test.com', 'password123');
    expect(result, isTrue);
  });
}
```

---

## 3. Integration & Container Testing with Environments

When you want to test the full DI container configuration with test implementations:

```dart
// test/container_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:injectify/injectify.dart';
import 'package:my_app/domain/auth_repository.dart';
import 'package:my_app/data/mock_auth_repository.dart';
import 'package:my_app/injection.dart';

void main() {
  setUp(() async {
    // Reset container before each test to prevent registration pollution
    await getIt.reset();
    // Initialize container for test environment
    await configureDependencies(environment: Environment.test);
  });

  tearDown(() async {
    await getIt.reset();
  });

  test('Resolves MockAuthRepository in test environment', () {
    final repo = getIt<AuthRepository>();
    expect(repo, isA<MockAuthRepository>());
  });
}
```

---

## 4. Overriding Registrations Dynamically in Tests

GetIt allows overriding any registration on the fly for specific test scenarios using `allowMultipleRegistrations` or manual reregistration:

```dart
// test/widget_flow_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:my_app/domain/auth_repository.dart';
import 'package:my_app/injection.dart';

class CustomTestAuthRepo implements AuthRepository {
  @override
  Future<bool> login(String email, String password) async => false;
}

void main() {
  setUp(() async {
    await getIt.reset();
    await configureDependencies(environment: Environment.test);

    // Override with a specific test instance
    if (getIt.isRegistered<AuthRepository>()) {
      getIt.unregister<AuthRepository>();
    }
    getIt.registerLazySingleton<AuthRepository>(() => CustomTestAuthRepo());
  });

  test('Custom mock returns false', () async {
    final repo = getIt<AuthRepository>();
    final result = await repo.login('any@test.com', 'pass');
    expect(result, isFalse);
  });
}
```

---

## 5. Best Practices for Test Hygiene

- Always call `await getIt.reset()` inside `setUp()` or `tearDown()`.
- Use `@Environment(Environment.test)` to provide persistent test stubs for network or file I/O dependencies.
- Prefer constructor injection so units can be tested without invoking GetIt at all.
