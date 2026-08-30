import 'package:injectify/injectify.dart';

/// Folder-scoped micro-package boundary for the async `bootstrap` feature.
///
/// Composed flatly by root_app's `useMicroPackage: true` scan, like the
/// `dashboard` feature.
@InjectableMicroPackage(moduleName: 'Bootstrap')
void configureBootstrapModule() {}
