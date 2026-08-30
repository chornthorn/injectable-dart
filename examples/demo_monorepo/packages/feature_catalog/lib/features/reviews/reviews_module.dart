import 'package:injectify/injectify.dart';

/// Nested sub-feature micro-package inside the `feature_catalog` package.
///
/// No separate pubspec.yaml — just a folder boundary:
/// - the `catalog` module scan excludes this folder (boundary isolation),
/// - the app composes `ReviewsInjectableModule` independently via
///   `getIt.initReviews()`.
@InjectableMicroPackage(moduleName: 'Reviews', initializerName: 'initReviews')
void configureReviewsModule() {}
