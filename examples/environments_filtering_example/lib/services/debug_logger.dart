import 'package:injectable/injectable.dart';

/// Verbose logger that requires BOTH the `dev` and `debug` environments.
///
/// Useful to contrast `NoEnvOrContains` (any target environment matches)
/// with `NoEnvOrContainsAll` (every target environment must be active).
@Injectable(env: [Environment.dev, 'debug'])
class DebugLogger {
  void log(String message) {
    // ignore: avoid_print
    print('[debug] $message');
  }
}
