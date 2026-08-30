import 'package:environments_filtering_example/custom_environment_filter.dart';
import 'package:environments_filtering_example/features/checkout/checkout_service.dart';
import 'package:environments_filtering_example/features/checkout/payment_gateway.dart';
import 'package:environments_filtering_example/injection.dart';
import 'package:environments_filtering_example/services/analytics_service.dart';
import 'package:environments_filtering_example/services/api_service.dart';
import 'package:environments_filtering_example/services/debug_logger.dart';
import 'package:environments_filtering_example/services/feature_flags.dart';
import 'package:injectify/injectify.dart';

Future<void> main() async {
  // ignore: avoid_print
  print('========================================================');
  // ignore: avoid_print
  print('🛍️  Environments & Filtering Demo — Checkout App');
  // ignore: avoid_print
  print('========================================================');
  // ignore: avoid_print
  print('Real use case: an e-commerce checkout that gates the payment');
  // ignore: avoid_print
  print('gateway by environment so test mode can never run in prod.');

  // 1. dev: full sandbox checkout (no real money)
  await _sectionDev();

  // 2. prod: live checkout via the real gateway
  await _sectionProd();

  // 3. staging: preview features + working checkout
  await _sectionStaging();

  // 4. NoEnvOrContainsAll — all target environments must be active
  await _sectionFilterAll();

  // 5. Custom filter: NotInFilter (denylist semantics)
  await _sectionCustomFilter();

  // ignore: avoid_print
  print(
    '\n✅ Checkout ran end-to-end under environment gating — see the checks above!',
  );
}

Future<void> _sectionDev() async {
  await getIt.reset();
  configureDependencies(environment: Environment.dev);

  // ignore: avoid_print
  print('\n──────────────────────────────────────────────────────');
  // ignore: avoid_print
  print('1️⃣  DEV — init(environment: dev) → sandbox checkout');
  // ignore: avoid_print
  print('──────────────────────────────────────────────────────');

  // ignore: avoid_print
  print('ApiService        : ${await getIt<ApiService>().fetchData()} (mock)');
  // ignore: avoid_print
  print('PaymentGateway    : ${getIt<PaymentGateway>().runtimeType}');

  final result = await getIt<CheckoutService>().checkout(
    orderId: 'order-1001',
    amount: 49.99,
  );
  // ignore: avoid_print
  print('Checkout          : ${result.receipt}');
  // ignore: avoid_print
  print('Analytics         : ${getIt<AnalyticsService>().runtimeType}');

  getIt<DebugLogger>().log('dev session started');
  // ignore: avoid_print
  print(
    'Registered<FeatureFlags>         : '
    '${getIt.isRegistered<FeatureFlags>()} (staging-only)',
  );
  // ignore: avoid_print
  print(
    'Registered<DebugLogger>          : '
    '${getIt.isRegistered<DebugLogger>()} (needs {dev, debug})',
  );
}

Future<void> _sectionProd() async {
  await getIt.reset();
  configureDependencies(environment: Environment.prod);

  // ignore: avoid_print
  print('\n──────────────────────────────────────────────────────');
  // ignore: avoid_print
  print('2️⃣  PROD — init(environment: prod) → live checkout');
  // ignore: avoid_print
  print('──────────────────────────────────────────────────────');

  // ignore: avoid_print
  print('ApiService        : ${await getIt<ApiService>().fetchData()} (live)');
  // ignore: avoid_print
  print('PaymentGateway    : ${getIt<PaymentGateway>().runtimeType}');

  final result = await getIt<CheckoutService>().checkout(
    orderId: 'order-1002',
    amount: 129.99,
  );
  // ignore: avoid_print
  print('Checkout          : ${result.receipt}');

  final analytics = getIt<AnalyticsService>() as RemoteAnalyticsService;
  // ignore: avoid_print
  print('Analytics events  : ${analytics.events} (collected remotely)');
  // ignore: avoid_print
  print('Registered<DebugLogger>    : ${getIt.isRegistered<DebugLogger>()}');

  // In prod the container holds ONLY the Stripe gateway under PaymentGateway —
  // code asking for the gateway gets live charging, never the sandbox.
  // ignore: avoid_print
  print(
    'Resolved gateway  : ${getIt<PaymentGateway>().runtimeType} — '
    'test mode is impossible here',
  );
}

Future<void> _sectionStaging() async {
  await getIt.reset();
  configureDependencies(
    environmentFilter: const NoEnvOrContains({'dev', 'staging'}),
  );

  // ignore: avoid_print
  print('\n──────────────────────────────────────────────────────');
  // ignore: avoid_print
  print("3️⃣  STAGING preview — NoEnvOrContains({'dev', 'staging'})");
  // ignore: avoid_print
  print('──────────────────────────────────────────────────────');

  // ignore: avoid_print
  print('PaymentGateway    : ${getIt<PaymentGateway>().runtimeType} (dev)');

  final result = await getIt<CheckoutService>().checkout(
    orderId: 'order-1003',
    amount: 24.99,
  );
  // ignore: avoid_print
  print('Checkout          : ${result.receipt}');

  final flags = getIt<FeatureFlags>();
  // ignore: avoid_print
  print('FeatureFlags      : ${flags.describe} (staging active)');
  // ignore: avoid_print
  print(
    'Registered<DebugLogger>   : ${getIt.isRegistered<DebugLogger>()} '
    '(dev active)',
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
    'environment: dev (any-match)          : '
    '${getIt.isRegistered<DebugLogger>()}',
  );

  await getIt.reset();
  configureDependencies(environmentFilter: const NoEnvOrContainsAll({'dev'}));
  // ignore: avoid_print
  print(
    'NoEnvOrContainsAll({dev})          : '
    '${getIt.isRegistered<DebugLogger>()} (debug missing)',
  );
  // ignore: avoid_print
  print(
    'Registered<ApiService>             : '
    '${getIt.isRegistered<ApiService>()} (sandbox needs {dev, test})',
  );
  // ignore: avoid_print
  print(
    'Registered<PaymentGateway>         : '
    '${getIt.isRegistered<PaymentGateway>()}',
  );
  // ignore: avoid_print
  print(
    '=> CheckoutService stays unresolvable while PaymentGateway is'
    ' missing — strict filters cascade into real features',
  );

  await getIt.reset();
  configureDependencies(
    environmentFilter: const NoEnvOrContainsAll({'dev', 'debug'}),
  );
  // ignore: avoid_print
  print(
    'NoEnvOrContainsAll({dev, debug})   : '
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

  // ignore: avoid_print
  print('ApiService        : ${await getIt<ApiService>().fetchData()} (mock)');
  // ignore: avoid_print
  print('PaymentGateway    : ${getIt<PaymentGateway>().runtimeType}');

  final result = await getIt<CheckoutService>().checkout(
    orderId: 'order-1004',
    amount: 9.99,
  );
  // ignore: avoid_print
  print('Checkout          : ${result.receipt} (not blocked)');

  final flags = getIt<FeatureFlags>();
  // ignore: avoid_print
  print('FeatureFlags      : ${flags.describe} (staging, not blocked)');
  // ignore: avoid_print
  print(
    'Analytics         : ${getIt<AnalyticsService>().runtimeType} (dev impl)',
  );
}
