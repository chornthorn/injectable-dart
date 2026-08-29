---
title: "Quickstart"
linkTitle: "Quickstart"
weight: 2
description: >
  Get up and running with a complete dependency injection setup in minutes.
---

This tutorial walks through creating a minimal application with dependency injection using Injectable.

---

## 1. Create the Dependency Injection Setup File

Create an entry file for DI configuration (typically `lib/injection.dart` or `lib/core/di.dart`):

```dart
// lib/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// The generated configuration extension will live in this file
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default: generates `getIt.init()`
)
void configureDependencies() => getIt.init();
```

---

## 2. Annotate Classes

Create services and repositories in your project, annotating them with `@Injectable()`:

```dart
// lib/services/api_client.dart
import 'package:injectable/injectable.dart';

@Injectable(scope: Scope.lazySingleton)
class ApiClient {
  String get baseUrl => 'https://api.example.com';
}
```

```dart
// lib/repositories/user_repository.dart
import 'package:injectable/injectable.dart';
import '../services/api_client.dart';

@Injectable()
class UserRepository {
  final ApiClient client;

  UserRepository(this.client);

  String fetchUser() => 'User from ${client.baseUrl}';
}
```

{{% alert title="Tip" color="success" %}}
Notice how `UserRepository` takes `ApiClient` in its constructor. Injectable automatically detects this parameter and resolves it from `GetIt` at runtime.
{{% /alert %}}

---

## 3. Run Code Generation

Run `build_runner` to generate `lib/injection.config.dart`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

The generator inspects all annotated files in your `lib/` directory and generates `lib/injection.config.dart`:

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ...
extension GetItInjectableX on _i1.GetIt {
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(this, environment: environment, environmentFilter: environmentFilter);
    gh.lazySingleton<_i3.ApiClient>(() => _i3.ApiClient());
    gh.factory<_i4.UserRepository>(() => _i4.UserRepository(gh<_i3.ApiClient>()));
    return this;
  }
}
```

---

## 4. Initialize and Run

Call `configureDependencies()` at application startup before retrieving any registered instances.

### Dart CLI / Server Application

```dart
// bin/main.dart
import 'package:my_app/injection.dart';
import 'package:my_app/repositories/user_repository.dart';

void main() {
  configureDependencies();

  final userRepo = getIt<UserRepository>();
  print(userRepo.fetchUser());
}
```

### Flutter Application

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'injection.dart';
import 'repositories/user_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepo = getIt<UserRepository>();
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(userRepo.fetchUser()),
        ),
      ),
    );
  }
}
```
