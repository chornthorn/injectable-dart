import 'package:injectable/injectable.dart';

import 'app_config.dart';

/// Preview feature flags, available only on the `staging` environment.
///
/// Demonstrates the standalone [Environment] annotation combined with
/// [Injectable], and constructor injection of an un-gated dependency
/// ([AppConfig]) into a gated one.
@Injectable()
@Environment('staging')
class FeatureFlags {
  final AppConfig config;

  FeatureFlags(this.config);

  List<String> get previewFeatures => const ['beta-search', 'dark-mode-ui'];

  String get describe =>
      '${config.appName} preview: ${previewFeatures.join(', ')}';
}
