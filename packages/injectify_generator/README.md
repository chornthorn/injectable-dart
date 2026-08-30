# injectify_generator

`build_runner` code generator for [injectify](https://pub.dev/packages/injectify) — parses `@Injectable`-family annotations and emits deterministic `.config.dart` registration files.

## How it works

The builder scans your package (boundary-aware), inspects every annotated class and external module, resolves constructor parameters, and writes a typed `GetIt` initialization extension:

```dart
extension GetItInjectableX on GetIt {
  GetIt init({...}) {
    final gh = GetItHelper(this, ...);
    gh.lazySingleton<ApiService>(() => ApiService());
    gh.factory<UserRepository>(() => UserRepository(gh<ApiService>()));
    return this;
  }
}
```

## Features

- Generates `MicroPackageModule` subclasses for folder-scoped micro-packages (`@InjectableMicroPackage`)
- Composes nested micro-packages (`useMicroPackage: true`) and cross-package modules (`externalMicroPackages`)
- Emits `factoryWithParam`, `singletonAsync`, environment-gated (`registerFor:`) and tagged (`instanceName:`) registrations
- Deterministic import aliasing (`_i1`, `_i2`, …) to avoid identifier collisions

## Usage

Add to `dev_dependencies`:

```yaml
dev_dependencies:
  build_runner: ^2.4.0
  injectify_generator: ^0.1.0
```

Run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

The generated files end with `.config.dart` (e.g. `lib/injection.config.dart`).

## Documentation

Full documentation, tutorials, and API reference: <https://chornthorn.github.io/injectify-dart/>

## License

Apache-2.0 — see [LICENSE](LICENSE).
