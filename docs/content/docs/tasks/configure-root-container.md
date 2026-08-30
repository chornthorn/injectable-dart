---
title: "Configure the Root Container"
linkTitle: "Configure Root Container"
weight: 1
description: >
  Setup the application top-level DI entrypoint and generator options.
---

This guide explains how to configure the root dependency injection container for your application.

---

## 1. Create the Root DI File

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
  useMicroPackage: true, // Enables discovery of folder micro-packages
)
Future<void> configureDependencies(String env) async => getIt.init(environment: env);
```

---

## 2. Options Overview

Each parameter configures one aspect of the generated initializer:

- **`initializerName`** (`String`, default `'init'`) — Name of the generated method.
- **`preferRelativeImports`** (`bool`, default `true`) — When `true`, relative imports are used for local project files.
- **`asExtension`** (`bool`, default `true`) — When `true`, generates an extension on `GetIt` (`getIt.init()`).
- **`useMicroPackage`** (`bool`, default `false`) — When `true`, auto-discovers and flattens all `@InjectableMicroPackage` directories in this package.
- **`externalMicroPackages`** (`List<ExternalMicroPackage>`, default `const []`) — Micro-packages imported from other pubspecs.

---

## 3. Run Generator

```bash
dart run build_runner build --delete-conflicting-outputs
```
