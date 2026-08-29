import 'package:feature_catalog/catalog.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

/// Root app initializer.
///
/// The generated `injection.config.dart` composes everything in one `init()`:
/// 1. every declared [ExternalMicroPackage] in order — module types from other
///    packages with their own pubspec (`shared`, `feature_catalog`) that this
///    package's scan cannot discover,
/// 2. this package's own folder micro-packages, discovered flatly
///    (`useMicroPackage: true` — e.g. `features/dashboard`),
/// 3. this package's direct `@Injectable` classes.
@InjectableInit(
  initializerName: 'init',
  useMicroPackage: true,
  externalMicroPackages: [
    ExternalMicroPackage(SharedInjectableModule),
    ExternalMicroPackage(CatalogInjectableModule),
  ],
)
Future<void> configureDependencies() async {
  getIt.init();
  // Async (@PreResolve) singletons are REGISTERED but not yet RESOLVED.
  // The app decides when: `await getIt.getAsync<T>()` (on demand) or
  // `await getIt.allReady()` (all at once) — before that, `getIt<T>()` throws.
}
