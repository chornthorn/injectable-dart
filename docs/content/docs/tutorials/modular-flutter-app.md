---
title: "Building a Modular Flutter App"
linkTitle: "Modular Flutter App"
weight: 1
description: >
  End-to-end tutorial for architecting a feature-modular Flutter application.
---

This tutorial demonstrates how to architect a modular Flutter application using folder-scoped micro-packages and environment-gated configuration.

---

## 1. Project Directory Structure

```
lib/
├── core/
│   ├── network/
│   │   ├── api_client.dart
│   │   └── network_module.dart
│   └── di/
│       ├── injection.dart
│       └── injection.config.dart
├── features/
│   ├── auth/
│   │   ├── auth_module.dart
│   │   ├── auth_module.config.dart
│   │   ├── models/
│   │   ├── services/
│   │   └── presentation/
│   └── feed/
│       ├── feed_module.dart
│       ├── feed_module.config.dart
│       └── presentation/
└── main.dart
```

---

## 2. Setting Up the Core Network Module

In `lib/core/network/network_module.dart`:

```dart
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@ExternalModule()
abstract class NetworkModule {
  @Injectable(scope: .lazySingleton)
  http.Client get client => http.Client();
}
```

In `lib/core/network/api_client.dart`:

```dart
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@Injectable(scope: .lazySingleton)
class ApiClient {
  final http.Client client;
  ApiClient(this.client);
}
```

---

## 3. Creating the Auth Feature Micro-Package

In `lib/features/auth/auth_module.dart`:

```dart
import 'package:injectable/injectable.dart';

@InjectableMicroPackage(moduleName: 'Auth')
void configureAuthModule() {}
```

In `lib/features/auth/services/auth_service.dart`:

```dart
import 'package:injectable/injectable.dart';
import '../../../core/network/api_client.dart';

@Injectable(scope: .lazySingleton)
class AuthService {
  final ApiClient client;
  AuthService(this.client);

  bool isLoggedIn() => true;
}
```

---

## 4. Setting Up the Root DI Container

In `lib/core/di/injection.dart`:

```dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  useMicroPackage: true, // Automatically discovers Auth and Feed micro-packages
)
Future<void> configureDependencies({String? env}) async {
  getIt.init(environment: env);
}
```

---

## 5. Running Code Generation

Execute the generator:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Notice that `auth_module.config.dart` creates `AuthInjectableModule`, and `injection.config.dart` includes:

```dart
gh.initMicroPackage(_i3.AuthInjectableModule());
```

---

## 6. Integrating with Flutter `main.dart`

```dart
import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'features/auth/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(env: Environment.prod);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = getIt<AuthService>();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Modular Flutter App')),
        body: Center(
          child: Text('Logged in: ${authService.isLoggedIn()}'),
        ),
      ),
    );
  }
}
```
