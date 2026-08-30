## 0.1.0

- Initial public release.
- Boundary-aware `LibraryScanner` for folder-scoped micro-packages (`lib/**` scan, sub-folder exclusion).
- Emits `MicroPackageModule` subclasses and `GetIt` initialization extensions (`.config.dart`).
- Root compositor (`@InjectableInit(useMicroPackage: true)`) and module compositor mode.
- `externalMicroPackages` composition in declaration order.
- `factoryWithParam`, `singletonAsync`, environment-gated and tagged registrations.
- Deterministic import alias registry (`_i1`, `_i2`, …).
