# demo_monorepo

A self-contained monorepo demo proving that the **`injectify`** /
`injectify_generator` packages (pulled from GitHub) support two DI layouts:

| Layout                               | Where                                                                                                                                                           |
| ------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **A — multi-package monorepo**       | Every package has its **own `pubspec.yaml`**; each generates its own `XInjectableModule` + GetIt extension and registers into one shared container.             | `packages/shared`, `packages/feature_catalog` |
| **A′ — nested folder micro-package** | A folder **without its own `pubspec.yaml`** inside a package, declared with `@InjectableMicroPackage`; the parent module scan excludes it (boundary isolation). | `feature_catalog/features/reviews`            |

`apps/root_app` is the runnable entry point: it generates its **own**
`injection.config.dart` via `@InjectableInit` and composes every package
of the monorepo in a single `await configureDependencies();`.

All packages share one `GetIt` instance, so services can cross boundaries:

- `CatalogService` (`feature_catalog`) injects `GreetingService` from `shared`.
- `ReviewService` (nested folder micro-package) injects `CatalogService` from
  the parent folder **and** `GreetingService` from `shared`.
- `StartupService` (root_app's own registration) injects `AppConfig` from `shared`.

## Layout

```
demo_monorepo/                  # workspace root only (no runtime code)
├── pubspec.yaml                # workspace + dependency_overrides for injectify
├── apps/
│   └── root_app/               # runnable app: own pubspec, own generated config
│       ├── pubspec.yaml
│       ├── lib/injection.dart       # @InjectableInit → injection.config.dart
│       ├── lib/startup_service.dart # own @Injectable registration
│       ├── bin/main.dart            # await configureDependencies();
│       └── test/root_app_test.dart
├── packages/
│   ├── shared/                 # scenario A: own pubspec.yaml
│   │   ├── pubspec.yaml
│   │   └── lib/shared_module.dart    # @InjectableMicroPackage(moduleName: 'Shared', initializerName: 'initShared')
│   └── feature_catalog/        # scenario A: own pubspec.yaml, depends on shared
│       ├── pubspec.yaml
│       ├── lib/catalog_module.dart   # @InjectableMicroPackage(moduleName: 'Catalog', initializerName: 'initCatalog')
│       └── lib/features/reviews/     # nested folder micro-package (no pubspec.yaml)
│           └── reviews_module.dart   # @InjectableMicroPackage(moduleName: 'Reviews', initializerName: 'initReviews')
```

## Run

```bash
# from examples/demo_monorepo
dart pub get

# regenerate configs after annotation changes (in shared/, feature_catalog/,
# apps/root_app/):
dart run build_runner build --delete-conflicting-outputs

# run the app
dart run apps/root_app/bin/main.dart

# tests
(cd apps/root_app && dart test)
```

## Dependencies

`injectify` / `injectify_generator` are consumed via **local path dependencies**
(`../../packages/injectify`, `../../packages/injectify_generator`). The git
URLs (`https://github.com/chornthorn/injectify-dart.git`) are kept as commented
references in every pubspec — handy if this example is moved to another repo,
where only the git source is available.

The root `dependency_overrides` pins `injectify` (and defensively
`injectify_generator`) to the local path, because `injectify_generator`'s
manifest declares `injectify` as an unversioned hosted dependency
(workspace-member style) which pub cannot merge with a direct path dependency.

## How the root app composes everything

`apps/root_app` declares the other packages' module types as `externalMicroPackages`
(they live in other pubspecs, so this package's scan cannot discover them):

```dart
// apps/root_app/lib/injection.dart
@InjectableInit(
  initializerName: 'init',
  useMicroPackage: true, // compose this package's own folder micro-packages flatly
  externalMicroPackages: [
    ExternalMicroPackage(SharedInjectableModule),
    ExternalMicroPackage(CatalogInjectableModule),
  ],
)
Future<void> configureDependencies() async => getIt.init();
```

The generated `injection.config.dart` composes everything **in one `init()`** —
externals in declaration order, then this package's own discovered folder
micro-packages (`features/dashboard`), then its direct registrations — no
manual `getIt.initShared()` / `getIt.initCatalog()` wiring:

```dart
extension GetItInjectableX on _i2.GetIt {
  _i2.GetIt init(...) {
    final gh = _i1.GetItHelper(this, ...);
    gh.initMicroPackage(_i3.SharedInjectableModule());      // external
    gh.initMicroPackage(_i4.CatalogInjectableModule());     // external (auto-composes reviews)
    gh.initMicroPackage(_i5.DashboardInjectableModule());   // own folder micro-package
    gh.initMicroPackage(_i8.BootstrapInjectableModule());   // own folder micro-package (async)
    gh.lazySingleton<_i7.StartupService>(() => _i7.StartupService(gh<_i8.AppConfig>()));
    return this;
  }
}
```

`CatalogInjectableModule` in turn auto-composes its nested `reviews` module
(`useMicroPackage: true`), so one `await configureDependencies()` wires the
whole monorepo.

## Async `@PreResolve` singletons

Two async demo features in `apps/root_app`:

**`features/bootstrap/weather_service.dart` — trivial-async factory**

```dart
@PreResolve()
@Injectable(scope: Scope.singleton)
class WeatherService { ... }
```

Generated: `await gh.singletonAsync<WeatherService>(() async => WeatherService())`.
GetIt starts the factory eagerly, so a factory that only constructs the object
completes after a microtask — effectively ready right after `init()`.

**`features/telemetry/telemetry_provider.dart` — genuinely pending factory**

```dart
@ExternalModule()
abstract class TelemetryProvider {
  // Async is auto-detected from the `Future` return type — no @PreResolve() needed.
  @Injectable(scope: Scope.singleton)
  Future<TelemetrySession> get telemetrySession async { ... } // takes real time
}
```

Generated: `await gh.singletonAsync<TelemetrySession>(() async => telemetryProvider.telemetrySession)`.
Because the async getter takes real time, the registration stays **pending**:
`getIt<TelemetrySession>()` throws `StateError` ("not ready yet") until it
completes.

`configureDependencies()` only runs `getIt.init()` — it does **not** call
`allReady()`, so the app decides when to resolve async singletons:

```dart
await configureDependencies();
try { getIt<TelemetrySession>(); } catch (_) { /* pending — throws */ }
final t = await getIt.getAsync<TelemetrySession>(); // resolve one on demand
await getIt.allReady();                              // resolve all remaining
```

The same `TelemetryProvider` also demonstrates **tagged sync injection** — an
`@Inject('mydemotoken')` singleton getter registered with an instance name:

```dart
@Inject('mydemotoken')
@Injectable(scope: Scope.singleton)
String get demoToken => 'demo-token-abc123';
```

Resolved via `getIt<String>(instanceName: 'mydemotoken')` — the async and
tagged registrations coexist in one `TelemetryInjectableModule`.

A consumer class receives the token through constructor injection — the
generator emits the same tagged lookup:

```dart
@Injectable(scope: Scope.lazySingleton)
class TelemetryReporter {
  TelemetryReporter(@Inject('mydemotoken') this._token);
}
// generated: TelemetryReporter(gh<String>(instanceName: 'mydemotoken'))
```

## How scenario A works

Each sub-package declares its own micro-package entry:

```dart
// packages/shared/lib/shared_module.dart
@InjectableMicroPackage(moduleName: 'Shared', initializerName: 'initShared')
void configureSharedModule() {}
```

Codegen emits `SharedInjectableModule` + `extension SharedInjectableModuleX on GetIt { initShared() }`.
The root app composes them per package over one container:

```dart
getIt.initShared();   // shared
getIt.initCatalog();  // feature_catalog, may resolve shared's services
```

## Nested micro-packages inside a scenario-A package

`feature_catalog/features/reviews/` is a folder micro-package **without its own
pubspec.yaml** nested inside a package that does have one. The parent module
auto-composes it with `useMicroPackage: true`:

```dart
// packages/feature_catalog/lib/catalog_module.dart
@InjectableMicroPackage(
  moduleName: 'Catalog',
  initializerName: 'initCatalog',
  useMicroPackage: true, // auto-compose nested sub micro-packages in init()
)
void configureCatalogModule() {}
```

This generates a `CatalogInjectableModule` whose `init()` registers its own
dependencies **and then** calls `gh.initMicroPackage(ReviewsInjectableModule())`:

```dart
// packages/feature_catalog/lib/catalog_module.config.dart
class CatalogInjectableModule extends _i1.MicroPackageModule {
  @override
  void init(_i1.GetItHelper gh) {
    gh.lazySingleton<_i4.CatalogService>(...);
    gh.initMicroPackage(_i3.ReviewsInjectableModule()); // ← auto-composed
  }
}
```

Boundary isolation still applies: search `catalog_module.config.dart` for
`ReviewService` — the reviews folder is excluded from the catalog module's own
dependency scan (no double registration). `ReviewService` resolves
`CatalogService` (parent folder) and `GreetingService` (shared) through the
shared container at runtime.

> Compose each module exactly once: either the parent module composes a nested
> sub-module (`useMicroPackage: true`), or the app composes it explicitly —
> not both, or GetIt throws on double registration.

## Note

- Newly annotated sources need `dart run build_runner build --delete-conflicting-outputs` in the affected
  package (`shared/`, `feature_catalog/`, `apps/root_app/`).
- The demo is intentionally **not** a member of the root workspace — it
  has its own nested workspace so it behaves like a standalone repo, consuming
  the packages via local path dependencies (git URLs kept as commented
  references for relocation).
