---
title: "Register Third-Party Types"
linkTitle: "Register Third-Party Types"
weight: 7
description: >
  Provide external dependencies such as HTTP clients and SDKs with @ExternalModule.
---

This guide demonstrates how to register classes and singletons from third-party packages that cannot be directly modified.

---

## 1. Create a Register Module

Create an abstract class annotated with `@ExternalModule()`:

```dart
// lib/core/third_party_module.dart
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@ExternalModule()
abstract class ThirdPartyModule {
  @Injectable(scope: .lazySingleton)
  http.Client get httpClient => http.Client();
}
```

---

## 2. Using Qualified / Named Registrations (`@Inject`)

If you need multiple instances of the same type (such as two different `http.Client`s with different interceptors or base URLs), use `@Inject()`:

```dart
@ExternalModule()
abstract class NetworkModule {
  @Inject('authClient')
  @Injectable(scope: .lazySingleton)
  http.Client get authClient => http.Client();

  @Inject('publicClient')
  @Injectable(scope: .lazySingleton)
  http.Client get publicClient => http.Client();
}
```

Inject specific instances using `@Inject` on constructor arguments:

```dart
@Injectable()
class SecureRepo {
  final http.Client client;

  SecureRepo(@Inject('authClient') this.client);
}
```
