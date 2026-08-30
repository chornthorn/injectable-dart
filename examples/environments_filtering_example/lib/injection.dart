import 'package:injectify/injectify.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

/// Root initializer for the environments & filtering demo.
///
/// Pass an active environment, a custom [EnvironmentFilter], or both to the
/// generated `init()`. Only dependencies whose declared environments match
/// (see `lib/services`) are registered.
@InjectableInit(initializerName: 'init')
void configureDependencies({
  String? environment,
  EnvironmentFilter? environmentFilter,
}) {
  getIt.init(environment: environment, environmentFilter: environmentFilter);
}
