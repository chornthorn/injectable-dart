---
title: "Work with Factory Parameters"
linkTitle: "Work with Factory Parameters"
weight: 4
description: >
  Pass dynamic runtime arguments to factory constructors via @FactoryParam.
---

Factory parameters allow you to pass dynamic arguments at runtime when requesting an instance from `GetIt`, while still auto-resolving standard dependencies from the container.

---

## 1. Annotating Factory Parameters

Use `@FactoryParam()` on up to **two** constructor parameters:

```dart
import 'package:injectify/injectify.dart';

@Injectable()
class OrderDetailBloc {
  final ApiClient client;       // Resolved from GetIt
  final String orderId;         // Passed at runtime (Param 1)
  final bool isEditable;        // Passed at runtime (Param 2)

  OrderDetailBloc(
    this.client, {
    @FactoryParam() required this.orderId,
    @FactoryParam() this.isEditable = false,
  });
}
```

---

## 2. Generated Registration

Injectify emits a `factoryWithParam` registration:

```dart
gh.factoryWithParam<OrderDetailBloc, String, bool>(
  (orderId, isEditable, _) => OrderDetailBloc(
    gh<ApiClient>(),
    orderId: orderId,
    isEditable: isEditable,
  ),
);
```

---

## 3. Resolving with Parameters at Runtime

Call `getIt<T>(param1: ..., param2: ...)`:

```dart
final bloc = getIt<OrderDetailBloc>(
  param1: 'ORD-98214',
  param2: true,
);
```
