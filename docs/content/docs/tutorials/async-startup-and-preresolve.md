---
title: "Asynchronous Initialization & @PreResolve"
linkTitle: "Async Startup & @PreResolve"
weight: 2
description: >
  Learn how to handle asynchronous dependency initialization (Databases, SharedPreferences, Remote Config) with @PreResolve and splash screens.
---

Many modern mobile applications require asynchronous initialization during startup — reading user settings from `SharedPreferences`, opening a local SQLite / Isar / Hive database, or fetching remote configuration.

This tutorial shows how to configure asynchronous singletons with `@PreResolve()` so that all critical services are ready before your UI mounts.

---

## 1. Defining Third-Party Async Singletons

When working with packages like `shared_preferences`, create an `@ExternalModule` to instantiate and await the asynchronous singleton:

```dart
// lib/core/storage/storage_module.dart
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@ExternalModule()
abstract class StorageModule {
  @PreResolve()
  @Injectable(scope: Scope.singleton)
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
```

---

## 2. Defining Custom Async Services

For your own domain classes that require asynchronous connection or schema migration during startup:

```dart
// lib/core/database/database_service.dart
import 'package:injectable/injectable.dart';

@Injectable(scope: Scope.singleton)
class DatabaseService {
  final String dbName;
  bool _isOpened = false;

  DatabaseService._({required this.dbName});

  @FactoryMethod()
  @PreResolve()
  static Future<DatabaseService> create() async {
    final instance = DatabaseService._(dbName: 'app_database.db');
    await instance._openDatabase();
    return instance;
  }

  Future<void> _openDatabase() async {
    // Simulating database schema setup or connection
    await Future.delayed(const Duration(milliseconds: 300));
    _isOpened = true;
  }

  bool get isReady => _isOpened;
}
```

---

## 3. Dependent Services Consuming Async Singletons

Services that consume `SharedPreferences` or `DatabaseService` can now be registered synchronously because the generator guarantees the dependencies are fully resolved before dependent registrations run:

```dart
// lib/services/settings_service.dart
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(scope: Scope.lazySingleton)
class SettingsService {
  final SharedPreferences _prefs;

  SettingsService(this._prefs);

  bool get isDarkMode => _prefs.getBool('dark_mode') ?? false;

  Future<void> setDarkMode(bool enabled) async {
    await _prefs.setBool('dark_mode', enabled);
  }
}
```

---

## 4. Root Initialization

In `lib/injection.dart`:

```dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies({String? environment}) async =>
    getIt.init(environment: environment);
```

When you run `build_runner`, Injectable automatically emits asynchronous registration calls using `await gh.singletonAsync<T>()`, promoting `init()` to return `Future<GetIt>`.

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 5. Emitted Initialization Flow

Here is what the generated `injection.config.dart` produces:

```dart
extension GetItInjectableX on _i1.GetIt {
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(this, environment, environmentFilter);
    final storageModule = _$StorageModule();
    await gh.singletonAsync<_i3.SharedPreferences>(() => storageModule.prefs);
    await gh.singletonAsync<_i4.DatabaseService>(() => _i4.DatabaseService.create());
    gh.lazySingleton<_i5.SettingsService>(() => _i5.SettingsService(gh<_i3.SharedPreferences>()));
    return this;
  }
}
```

---

## 6. App Startup with Flutter Splash Screen

In `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'injection.dart';
import 'services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Await all @PreResolve singletons before launching the app
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = getIt<SettingsService>();

    return MaterialApp(
      theme: settings.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(title: const Text('Async Startup Ready')),
        body: Center(
          child: Text('Dark Mode: ${settings.isDarkMode}'),
        ),
      ),
    );
  }
}
```
