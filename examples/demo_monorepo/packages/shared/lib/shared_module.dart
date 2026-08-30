import 'package:injectify/injectify.dart';

/// Micro-package entry point for the `shared` package.
///
/// Generates `SharedInjectableModule` plus an `initShared()` GetIt extension
/// in `shared_module.config.dart`. Called from the app to register this
/// package's dependencies into the shared container.
@InjectableMicroPackage(moduleName: 'Shared', initializerName: 'initShared')
void configureSharedModule() {}
