---
title: "Gate Dependencies by Environment"
linkTitle: "Environment Gating"
weight: 5
description: >
  Dynamically switch dependencies for dev, prod, and test environments.
---

This guide explains how to swap dependencies dynamically based on active environments (such as running tests or targeting dev/prod backends).

---

## 1. Annotate by Environment

```dart
abstract class PaymentGateway {
  Future<bool> charge(double amount);
}

// Dev / Test mock
@Injectable(as: PaymentGateway, env: [Environment.dev, Environment.test])
class FakePaymentGateway implements PaymentGateway {
  @override
  Future<bool> charge(double amount) async => true;
}

// Production gateway
@Injectable(as: PaymentGateway, env: [Environment.prod])
class StripePaymentGateway implements PaymentGateway {
  @override
  Future<bool> charge(double amount) async {
    // Process real card charge
    return true;
  }
}
```

---

## 2. Bootstrapping with Active Environment

```dart
// lib/injection.dart
void configureDependencies(String env) => getIt.init(environment: env);

// In your app entry point:
void main() {
  const env = String.fromEnvironment('APP_ENV', defaultValue: Environment.dev);
  configureDependencies(env);
}
```

---

## 3. Testing with Test Environment

In your integration or unit tests:

```dart
import 'package:test/test.dart';
import 'package:my_app/injection.dart';
import 'package:my_app/services/payment_gateway.dart';

void main() {
  setUp(() {
    getIt.reset();
    configureDependencies(Environment.test);
  });

  test('uses fake payment gateway in tests', () {
    final gateway = getIt<PaymentGateway>();
    expect(gateway, isA<FakePaymentGateway>());
  });
}
```
