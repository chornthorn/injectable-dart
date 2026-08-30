---
title: "Building Your First Injectify App"
linkTitle: "First Injectify App"
weight: 1
description: >
  A beginner-friendly, step-by-step tutorial to create a Dart/Flutter project with dependency injection from scratch.
---

This tutorial walks through creating a complete Dart/Flutter application with automated Dependency Injection using **Injectify** and **GetIt**.

---

## 1. Project Setup

Create a new Flutter or Dart project and configure your `pubspec.yaml`:

```yaml
name: my_first_app
description: "My first Injectify application"
version: 1.0.0+1

environment:
  sdk: ^3.12.0

dependencies:
  flutter:
    sdk: flutter
  get_it: ^9.2.1
  injectify:
    git:
      url: https://github.com/chornthorn/injectify-dart.git
      path: packages/injectify

dev_dependencies:
  build_runner: ^2.4.15
  injectify_generator:
    git:
      url: https://github.com/chornthorn/injectify-dart.git
      path: packages/injectify_generator
```

Run package resolution:

```bash
flutter pub get
```

---

## 2. Defining Domain Models and Services

Create `lib/services/quote_service.dart`:

```dart
import 'dart:math';
import 'package:injectify/injectify.dart';

@Injectable(scope: Scope.lazySingleton)
class QuoteService {
  final List<String> _quotes = [
    'Simplicity is the soul of efficiency.',
    'Code is like humor. When you have to explain it, it’s bad.',
    'Make it work, make it right, make it fast.',
  ];

  String getRandomQuote() {
    final random = Random();
    return _quotes[random.nextInt(_quotes.length)];
  }
}
```

Next, create `lib/repositories/quote_repository.dart` which depends on `QuoteService`:

```dart
import 'package:injectify/injectify.dart';
import '../services/quote_service.dart';

@Injectable(scope: Scope.factory)
class QuoteRepository {
  final QuoteService _quoteService;

  QuoteRepository(this._quoteService);

  String fetchDailyQuote() {
    return _quoteService.getRandomQuote();
  }
}
```

Notice that you do not manually construct `QuoteService` inside `QuoteRepository`. Injectify automatically resolves `QuoteService` from the container.

---

## 3. Configuring Root Injection

Create `lib/injection.dart`:

```dart
import 'package:get_it/get_it.dart';
import 'package:injectify/injectify.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => getIt.init();
```

---

## 4. Running the Code Generator

Run the code generator to generate `lib/injection.config.dart`:

```bash
# For Flutter
flutter pub run build_runner build --delete-conflicting-outputs

# For Dart
dart run build_runner build --delete-conflicting-outputs
```

### Generated Output Inspection

Look inside `lib/injection.config.dart`:

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectify/injectify.dart' as _i2;
import 'repositories/quote_repository.dart' as _i4;
import 'services/quote_service.dart' as _i3;

extension GetItInjectableX on _i1.GetIt {
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i3.QuoteService>(() => _i3.QuoteService());
    gh.factory<_i4.QuoteRepository>(() => _i4.QuoteRepository(gh<_i3.QuoteService>()));
    return this;
  }
}
```

---

## 5. Bootstrapping in `main.dart`

In `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'injection.dart';
import 'repositories/quote_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Resolve repository from GetIt
    final quoteRepo = getIt<QuoteRepository>();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Injectify Quickstart')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              quoteRepo.fetchDailyQuote(),
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
```
