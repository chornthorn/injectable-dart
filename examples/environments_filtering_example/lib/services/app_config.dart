import 'package:injectify/injectify.dart';

/// Stateless app configuration.
///
/// Deliberately has NO environment gating, so it is registered in every
/// environment and available to gated dependencies via constructor injection.
@Injectable()
class AppConfig {
  final String appName;
  final String version;

  AppConfig() : appName = 'Injectify Demo', version = '1.0.0';
}
