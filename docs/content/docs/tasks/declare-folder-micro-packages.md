---
title: "Declare Folder Micro-Packages"
linkTitle: "Declare Folder Micro-Packages"
weight: 2
description: >
  Isolate feature directories into self-contained sub-modules.
---

This guide explains how to scope a feature folder into its own isolated micro-package.

---

## 1. Create the Feature Module File

Inside your feature folder (e.g. `lib/features/auth/`), create a file named `auth_module.dart`:

```dart
// lib/features/auth/auth_module.dart
import 'package:injectable/injectable.dart';

@InjectableMicroPackage(moduleName: 'Auth')
void configureAuthModule() {}
```

---

## 2. Annotate Feature Classes

Create classes inside `lib/features/auth/`:

```dart
// lib/features/auth/services/auth_service.dart
import 'package:injectable/injectable.dart';

@Injectable(scope: .lazySingleton)
class AuthService {
  bool get isAuthenticated => true;
}
```

```dart
// lib/features/auth/bloc/auth_bloc.dart
import 'package:injectable/injectable.dart';
import '../services/auth_service.dart';

@Injectable()
class AuthBloc {
  final AuthService authService;
  AuthBloc(this.authService);
}
```

---

## 3. Run the Generator

```bash
dart run build_runner build
```

This generates `lib/features/auth/auth_module.config.dart` containing `AuthInjectableModule`:

```dart
class AuthInjectableModule extends _i1.MicroPackageModule {
  @override
  _i2.FutureOr<void> init(_i1.GetItHelper gh) {
    gh.lazySingleton<_i3.AuthService>(() => _i3.AuthService());
    gh.factory<_i4.AuthBloc>(() => _i4.AuthBloc(gh<_i3.AuthService>()));
  }
}
```

---

## 4. Root Auto-Composition

When the root container has `useMicroPackage: true`, it automatically finds `AuthInjectableModule` and registers it in `lib/injection.config.dart`:

```dart
extension GetItInjectableX on _i1.GetIt {
  _i1.GetIt init(...) {
    final gh = _i2.GetItHelper(this, ...);
    gh.initMicroPackage(_i3.AuthInjectableModule());
    return this;
  }
}
```
