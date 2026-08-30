import 'package:environments_filtering_example/custom_environment_filter.dart';
import 'package:environments_filtering_example/injection.dart';
import 'package:environments_filtering_example/services/analytics_service.dart';
import 'package:environments_filtering_example/services/api_service.dart';
import 'package:environments_filtering_example/services/app_config.dart';
import 'package:environments_filtering_example/services/debug_logger.dart';
import 'package:environments_filtering_example/services/feature_flags.dart';
import 'package:injectable/injectable.dart';

Future<void> main() async {
  // ignore: avoid_print
  print('========================================================');
  // ignore: avoid_print
  print('🌍 Injectable Environments & Filtering Demo');
  // ignore: avoid_print
  print('========================================================');

  // 1. Single environment: dev
  await _sectionDev();

  // 2. Single environment: prod
  await _sectionProd();

  // 3. Multiple environments via the built-in NoEnvOrContains filter
  await _sectionFilterAny();

  // 4. NoEnvOrContainsAll — all target environments must be active
  await _sectionFilterAll();

  // 5. Custom filter: NotInFilter (denylist semantics)
  await _sectionCustomFilter();

  // ignore: avoid_print
  print(
    '\n✅ Environment gating and filtering working — see the printed checks above!',
  );
}

Future<void> _sectionDev() async {
  await getIt.reset();
  configureDependencies(environment: Environment.dev);

  // ignore: avoid_print
  print('\n──────────────────────────────────────────────────────');
  // ignore: avoid_print
  print('1️⃣  DEV environment — init(environment: ${Environment.dev})');
  // ignore: avoid_print
  print('──────────────────────────────────────────────────────');

  final api = getIt<ApiService>();
  // ignore: avoid_print
  print('ApiService        : ${await api.fetchData()} (mock)');

  final analytics = getIt<AnalyticsService>();
  // ignore: avoid_print
  print('AnalyticsService  : ${analytics.runtimeType}');

  final config = getIt<AppConfig>();
  // ignore: avoid_print
  print('AppConfig         : ${config.appName} v${config.version} (always)');

  // ignore: avoid_print
  print('Registered<RealApiService> : ${getIt.isRegistered<RealApiService>()}');
  // ignore: avoid_print
  print(
    'Registered<FeatureFlags>   : ${getIt.isRegistered<FeatureFlags>()} '
    '(staging-only)',
  );

  final debug = getIt<DebugLogger>();
  debug.log('DebugLogger needs {dev, debug}; default env matches on "any"');
}

Future<void> _sectionProd() async {
  await getIt.reset();
  configureDependencies(environment: Environment.prod);

  // ignore: avoid_print
  print('\n──────────────────────────────────────────────────────');
  // ignore: avoid_print
  print('2️⃣  PROD environment — init(environment: ${Environment.prod})');
  // ignore: avoid_print
  print('──────────────────────────────────────────────────────');

  final api = getIt<ApiService>();
  // ignore: avoid_print
  print('ApiService        : ${await api.fetchData()} (live)');

  final analytics = getIt<AnalyticsService>();
  analytics.track('checkout_started');
  final remote = analytics as RemoteAnalyticsService;
  // ignore: avoid_print
  print(
    'AnalyticsService  : ${remote.runtimeType} '
    '(events: ${remote.events.length})',
  );

  // ignore: avoid_print
  print('Registered<MockApiService> : ${getIt.isRegistered<MockApiService>()}');
  // ignore: avoid_print
  print('Registered<DebugLogger>    : ${getIt.isRegistered<DebugLogger>()}');

  try {
    getIt<MockApiService>();
  } on StateError {
    // ignore: avoid_print
    print('getIt<MockApiService>() : throws (not registered in prod)');
  }
}

Future<void> _sectionFilterAny() async {
  await getIt.reset();
  configureDependencies(
    environmentFilter: const NoEnvOrContains({'dev', 'staging'}),
  );

  // ignore: avoid_print
  print('\n──────────────────────────────────────────────────────');
  // ignore: avoid_print
  print("3️⃣  NoEnvOrContains({'dev', 'staging'}) — multiple active envs");
  // ignore: avoid_print
  print('──────────────────────────────────────────────────────');

  final api = getIt<ApiService>();
  // ignore: avoid_print
  print('ApiService        : ${await api.fetchData()} (matched "dev")');

  final flags = getIt<FeatureFlags>();
  // ignore: avoid_print
  print('FeatureFlags      : ${flags.describe} (matched "staging")');

  final debug = getIt<DebugLogger>();
  debug.log('DebugLogger matched on "dev"');

  // ignore: avoid_print
  print(
    'Registered<RealApiService> : ${getIt.isRegistered<RealApiService>()} '
    '(prod not active)',
  );
}

Future<void> _sectionFilterAll() async {
  // ignore: avoid_print
  print('\n──────────────────────────────────────────────────────');
  // ignore: avoid_print
  print("4️⃣  NoEnvOrContainsAll — DebugLogger requires {'dev', 'debug'}");
  // ignore: avoid_print
  print('──────────────────────────────────────────────────────');

  await getIt.reset();
  configureDependencies(environment: Environment.dev);
  // ignore: avoid_print
  print(
    'environment: dev (any-match)         : '
    '${getIt.isRegistered<DebugLogger>()}',
  );

  await getIt.reset();
  configureDependencies(environmentFilter: const NoEnvOrContainsAll({'dev'}));
  // ignore: avoid_print
  print(
    'NoEnvOrContainsAll({dev})         : '
    '${getIt.isRegistered<DebugLogger>()} (debug missing)',
  );

  await getIt.reset();
  configureDependencies(
    environmentFilter: const NoEnvOrContainsAll({'dev', 'debug'}),
  );
  // ignore: avoid_print
  print(
    'NoEnvOrContainsAll({dev, debug})  : '
    '${getIt.isRegistered<DebugLogger>()}',
  );
  getIt<DebugLogger>().log('All required environments active');
}

Future<void> _sectionCustomFilter() async {
  await getIt.reset();
  configureDependencies(environmentFilter: const NotInFilter({'prod'}));

  // ignore: avoid_print
  print('\n──────────────────────────────────────────────────────');
  // ignore: avoid_print
  print("5️⃣  Custom NotInFilter({'prod'}) — denylist semantics");
  // ignore: avoid_print
  print('──────────────────────────────────────────────────────');

  final api = getIt<ApiService>();
  // ignore: avoid_print
  print('ApiService        : ${await api.fetchData()} (mock, not blocked)');

  final flags = getIt<FeatureFlags>();
  // ignore: avoid_print
  print('FeatureFlags      : ${flags.describe} (staging, not blocked)');

  final analytics = getIt<AnalyticsService>();
  // ignore: avoid_print
  print('AnalyticsService  : ${analytics.runtimeType} (dev impl)');

  // ignore: avoid_print
  print(
    'Registered<RealApiService>          : '
    '${getIt.isRegistered<RealApiService>()} (prod blocked)',
  );
  // ignore: avoid_print
  print(
    'Registered<RemoteAnalyticsService>  : '
    '${getIt.isRegistered<RemoteAnalyticsService>()} (prod blocked)',
  );
}
