import 'package:injectable/injectable.dart';

/// Eager singleton created when `initShared()` runs.
@Injectable(scope: Scope.singleton)
class AppConfig {
  final String appName;
  final String version;

  AppConfig()
      : appName = 'Demo Monorepo',
        version = '1.0.0';
}
