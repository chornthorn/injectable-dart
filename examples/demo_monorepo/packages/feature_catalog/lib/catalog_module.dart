import 'package:injectify/injectify.dart';

/// Micro-package entry point for the `feature_catalog` package.
///
/// With `useMicroPackage: true`, the generated `CatalogInjectableModule`
/// auto-composes the nested `reviews` sub micro-package in its own `init()`
/// (the app no longer needs to call `initReviews()` explicitly).
///
/// Generates `CatalogInjectableModule` plus an `initCatalog()` GetIt extension
/// in `catalog_module.config.dart`.
@InjectableMicroPackage(
  moduleName: 'Catalog',
  initializerName: 'initCatalog',
  useMicroPackage: true,
)
void configureCatalogModule() {}
