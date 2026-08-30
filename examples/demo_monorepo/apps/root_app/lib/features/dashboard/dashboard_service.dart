import 'package:injectify/injectify.dart';
import 'package:shared/app_config.dart';

/// Lazy singleton inside root_app's own `dashboard` folder micro-package.
///
/// Resolves [AppConfig] from the `shared` package — registered by the
/// externally composed `SharedInjectableModule`, which runs before local
/// modules in the generated `init()`.
@Injectable(scope: Scope.lazySingleton)
class DashboardService {
  final AppConfig _config;

  DashboardService(this._config);

  String summary() => 'Dashboard for ${_config.appName}';
}
