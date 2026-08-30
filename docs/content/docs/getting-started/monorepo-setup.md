---
title: "Monorepo Setup"
linkTitle: "Monorepo Setup"
weight: 3
description: >
  Structuring workspace packages, Melos integration, and shared code generation.
---

When building large-scale Dart or Flutter projects, splitting functionality across multiple packages in a monorepo improves build times, isolates boundaries, and promotes code reuse.

Injectable provides first-class support for monorepo architectures through **External Micro-Packages** and folder-scoped micro-packages.

---

## 1. Monorepo Structure

A typical monorepo setup consists of multiple feature/shared packages and a top-level application package:

```
my_monorepo/
├── packages/
│   ├── shared/
│   │   ├── lib/
│   │   │   ├── shared_module.dart
│   │   │   └── shared_module.config.dart
│   │   └── pubspec.yaml
│   └── feature_auth/
│       ├── lib/
│       │   ├── auth_module.dart
│       │   └── auth_module.config.dart
│       └── pubspec.yaml
├── apps/
│   └── main_app/
│       ├── lib/
│       │   ├── injection.dart
│       │   └── injection.config.dart
│       └── pubspec.yaml
└── melos.yaml
```

---

## 2. Setting Up Packages

### Feature / Shared Package (`packages/shared`)

In a shared or feature package, mark the entry file with `@InjectableInit.microPackage()` or `@InjectableMicroPackage()`:

```dart
// packages/shared/lib/shared_module.dart
import 'package:injectify/injectify.dart';

@InjectableInit.microPackage(moduleName: 'Shared')
void configureSharedModule() {}
```

Run `build_runner` inside `packages/shared`:

```bash
dart run build_runner build
```

This generates `SharedInjectableModule` inside `packages/shared/lib/shared_module.config.dart`.

---

## 3. Composing in the App Package (`apps/main_app`)

In your root application's `pubspec.yaml`, add the workspace packages as path dependencies:

```yaml
dependencies:
  shared:
    path: ../../packages/shared
  feature_auth:
    path: ../../packages/feature_auth
  injectable:
    git:
      url: https://github.com/chornthorn/injectable-dart.git
      path: injectable
  get_it: ^9.2.1

dev_dependencies:
  build_runner: ^2.4.0
  injectable_codegen:
    git:
      url: https://github.com/chornthorn/injectable-dart.git
      path: injectable_codegen
```

In your application's `injection.dart`, declare the external micro-packages:

```dart
// apps/main_app/lib/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectify/injectify.dart';
import 'package:shared/shared_module.config.dart';
import 'package:feature_auth/auth_module.config.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  externalMicroPackages: [
    ExternalMicroPackage(SharedInjectableModule),
    ExternalMicroPackage(AuthInjectableModule),
  ],
)
void configureDependencies() => getIt.init();
```

{{% alert title="Important" color="warning" %}}
The order of `ExternalMicroPackage` entries determines their registration execution order. If `AuthInjectableModule` depends on singletons registered in `SharedInjectableModule`, list `SharedInjectableModule` first.
{{% /alert %}}

---

## 4. Automating with Melos

Add a build script to your `melos.yaml` to run code generation across all packages:

```yaml
name: my_monorepo
packages:
  - packages/**
  - apps/**

scripts:
  build:runner:
    exec: dart run build_runner build --delete-conflicting-outputs
    description: Run build_runner across all monorepo packages.
```

Run:

```bash
melos run build:runner
```
