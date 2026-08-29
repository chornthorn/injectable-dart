---
title: "Compose External Micro-Packages"
linkTitle: "Compose External Micro-Packages"
weight: 3
description: >
  Wire up micro-packages located in separate packages across a monorepo.
---

This guide explains how to wire micro-packages located in separate pub packages across a monorepo.

---

## 1. Setup in External Package

In `packages/feature_cart/lib/cart_module.dart`:

```dart
import 'package:injectable/injectable.dart';

@InjectableInit.microPackage(moduleName: 'Cart')
void configureCartModule() {}
```

Generate the module inside `packages/feature_cart`:
```bash
cd packages/feature_cart
dart run build_runner build
```

This creates `CartInjectableModule` in `cart_module.config.dart`.

---

## 2. Compose in Application Root

In your app's `injection.dart`:

```dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// Import generated module config from external package
import 'package:feature_cart/cart_module.config.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  externalMicroPackages: [
    ExternalMicroPackage(CartInjectableModule),
  ],
)
void configureDependencies() => getIt.init();
```

---

## 3. Rebuild Application

```bash
cd apps/main_app
dart run build_runner build
```

The generator produces:

```dart
// apps/main_app/lib/injection.config.dart
gh.initMicroPackage(_i3.CartInjectableModule());
```
