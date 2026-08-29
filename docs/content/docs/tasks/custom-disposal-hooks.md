---
title: "Custom Disposal Hooks"
linkTitle: "Custom Disposal Hooks"
weight: 8
description: >
  Attach cleanup and disposal logic to singletons on container reset.
---

Injectable allows you to specify custom cleanup logic when `GetIt.reset()` or `GetIt.resetScope()` is invoked.

---

## 1. Using `@DisposeMethod` on Instance Methods

If your class has a method responsible for closing streams, database handles, or socket connections, mark it with `@DisposeMethod`:

```dart
import 'dart:async';
import 'package:injectable/injectable.dart';

@Injectable(scope: .lazySingleton)
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

## 2. Using `dispose:` Callback on `@Injectable`

You can also pass a top-level or static function to the `dispose:` argument of `@Injectable`:

```dart
void closeDatabase(AppDatabase db) => db.close();

@Injectable(scope: .singleton, dispose: closeDatabase)
class AppDatabase {
  void close() {}
}
```
