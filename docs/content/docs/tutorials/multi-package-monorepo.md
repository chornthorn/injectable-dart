---
title: "Structuring a Multi-Package Monorepo"
linkTitle: "Multi-Package Monorepo"
weight: 6
description: >
  Full walkthrough of building a multi-package monorepo using externalMicroPackages.
---

This tutorial walks through creating a clean, enterprise-grade multi-package Dart/Flutter monorepo using Injectable's `externalMicroPackages`.

---

## 1. Monorepo Architecture

```
my_app_workspace/
├── packages/
│   ├── core/
│   │   ├── lib/
│   │   │   ├── core_module.dart
│   │   │   ├── core_module.config.dart
│   │   │   └── services/logger_service.dart
│   │   └── pubspec.yaml
│   └── feature_billing/
│       ├── lib/
│       │   ├── billing_module.dart
│       │   ├── billing_module.config.dart
│       │   └── services/billing_service.dart
│       └── pubspec.yaml
└── apps/
    └── mobile_app/
        ├── lib/
        │   ├── injection.dart
        │   ├── injection.config.dart
        │   └── main.dart
        └── pubspec.yaml
```

---

## 2. Package A: `core`

In `packages/core/lib/services/logger_service.dart`:

```dart
import 'package:injectify/injectify.dart';

@Injectable(scope: Scope.lazySingleton)
class LoggerService {
  void log(String message) => print('[LOG] $message');
}
```

In `packages/core/lib/core_module.dart`:

```dart
import 'package:injectify/injectify.dart';

@InjectableInit.microPackage(moduleName: 'Core')
void configureCoreModule() {}
```

Generate `core_module.config.dart`:

```bash
cd packages/core && dart run build_runner build
```

---

## 3. Package B: `feature_billing`

`feature_billing` depends on `core` for its logger.

In `packages/feature_billing/pubspec.yaml`:

```yaml
dependencies:
  core:
    path: ../core
  get_it: ^8.0.3
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

In `packages/feature_billing/lib/services/billing_service.dart`:

```dart
import 'package:core/services/logger_service.dart';
import 'package:injectify/injectify.dart';

@Injectable(scope: Scope.lazySingleton)
class BillingService {
  final LoggerService logger;
  BillingService(this.logger);

  void checkout() => logger.log('Processing payment...');
}
```

In `packages/feature_billing/lib/billing_module.dart`:

```dart
import 'package:injectify/injectify.dart';

@InjectableInit.microPackage(moduleName: 'Billing')
void configureBillingModule() {}
```

Generate `billing_module.config.dart`:

```bash
cd packages/feature_billing && dart run build_runner build
```

---

## 4. Composing in `mobile_app`

In `apps/mobile_app/pubspec.yaml`:

```yaml
dependencies:
  core:
    path: ../../packages/core
  feature_billing:
    path: ../../packages/feature_billing
  get_it: ^8.0.3
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

In `apps/mobile_app/lib/injection.dart`:

```dart
import 'package:core/core_module.config.dart';
import 'package:feature_billing/billing_module.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectify/injectify.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  externalMicroPackages: [
    ExternalMicroPackage(CoreInjectableModule),
    ExternalMicroPackage(BillingInjectableModule),
  ],
)
void configureDependencies() => getIt.init();
```

Generate `apps/mobile_app/lib/injection.config.dart`:

```bash
cd apps/mobile_app && dart run build_runner build
```

---

## 5. Running the Application

In `apps/mobile_app/lib/main.dart`:

```dart
import 'package:feature_billing/services/billing_service.dart';
import 'injection.dart';

void main() {
  configureDependencies();

  final billing = getIt<BillingService>();
  billing.checkout();
  // Prints: [LOG] Processing payment...
}
```
