import 'package:injectify/injectify.dart';

/// Depends on the tagged `'mydemotoken'` String via constructor injection.
///
/// The generator resolves the parameter through the locator with the same tag:
/// `TelemetryReporter(gh<String>(instanceName: 'mydemotoken'))`.
@Injectable(scope: Scope.lazySingleton)
class TelemetryReporter {
  final String _token;

  TelemetryReporter(@Inject('mydemotoken') this._token);

  String get token => _token;

  String report(String event) => '$event [token: $_token]';
}
