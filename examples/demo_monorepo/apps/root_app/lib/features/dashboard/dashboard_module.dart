import 'package:injectify/injectify.dart';

/// Folder-scoped micro-package boundary INSIDE the root app itself.
///
/// With `useMicroPackage: true` on the root [@InjectableInit], this folder is
/// discovered by root_app's own scan and composed flatly in `init()` — next
/// to the external micro-packages and the root's direct registrations.
@InjectableMicroPackage(moduleName: 'Dashboard')
void configureDashboardModule() {}
