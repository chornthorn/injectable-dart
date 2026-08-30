---
title: "Custom Disposal Hooks"
linkTitle: "Custom Disposal Hooks"
weight: 8
description: >
  Attach cleanup and disposal logic to singletons on container reset.
---

Injectify allows you to specify custom cleanup logic when `GetIt.reset()` or `GetIt.resetScope()` is invoked.

---

## 1. Using `@DisposeMethod` on Instance Methods

If your class has a method responsible for closing streams, database handles, or socket connections, mark it with `@DisposeMethod`:

```dart
import 'dart:async';
import 'package:injectify/injectify.dart';

@Injectable(scope: Scope.lazySingleton)
class WebSocketManager {
  final StreamController<String> _stream = StreamController.broadcast();

  @DisposeMethod()
  void dispose() {
    _stream.close();
  }
}
```

Generated code:

```dart
gh.lazySingleton<WebSocketManager>(
  () => WebSocketManager(),
  dispose: (i) => i.dispose(),
);
```

---

## 2. The `dispose:` Field on `@Injectable`

The `Injectable` annotation exposes a `dispose:` field (`Function?`), but the generator currently wires disposal only from instance methods marked with `@DisposeMethod` — method references passed to `dispose:` are not emitted into the registration. Use `@DisposeMethod` for disposal hooks.
