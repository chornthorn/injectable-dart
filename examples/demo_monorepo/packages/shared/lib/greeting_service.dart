import 'package:injectify/injectify.dart';

import 'app_config.dart';

/// Factory service demonstrating intra-package constructor injection
/// (`AppConfig` is resolved from the same package).
@Injectable()
class GreetingService {
  final AppConfig _config;

  GreetingService(this._config);

  String greet(String name) => 'Hello, $name! (${_config.appName})';
}
