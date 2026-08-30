import 'package:environments_filtering_example/custom_environment_filter.dart';
import 'package:environments_filtering_example/features/checkout/checkout_service.dart';
import 'package:environments_filtering_example/features/checkout/payment_gateway.dart';
import 'package:environments_filtering_example/features/checkout/sandbox_payment_gateway.dart';
import 'package:environments_filtering_example/features/checkout/stripe_payment_gateway.dart';
import 'package:environments_filtering_example/injection.dart';
import 'package:environments_filtering_example/services/analytics_service.dart';
import 'package:environments_filtering_example/services/api_service.dart';
import 'package:environments_filtering_example/services/app_config.dart';
import 'package:environments_filtering_example/services/debug_logger.dart';
import 'package:environments_filtering_example/services/feature_flags.dart';
import 'package:injectify/injectify.dart';
import 'package:test/test.dart';

void main() {
  setUp(getIt.reset);

  group('single environment', () {
    test('dev registers mock implementations and un-gated services', () {
      configureDependencies(environment: Environment.dev);

      expect(getIt<ApiService>(), isA<MockApiService>());
      expect(getIt<AnalyticsService>(), isA<ConsoleAnalyticsService>());
      expect(getIt.isRegistered<DebugLogger>(), isTrue);
      expect(getIt.isRegistered<AppConfig>(), isTrue);
      expect(getIt.isRegistered<FeatureFlags>(), isFalse);
    });

    test('prod registers live implementations and skips dev-only ones', () {
      configureDependencies(environment: Environment.prod);

      expect(getIt<ApiService>(), isA<RealApiService>());
      expect(getIt<AnalyticsService>(), isA<RemoteAnalyticsService>());
      expect(getIt.isRegistered<DebugLogger>(), isFalse);
    });
  });

  group('checkout feature', () {
    test('dev checkout completes on the sandbox gateway', () async {
      configureDependencies(environment: Environment.dev);

      expect(getIt<PaymentGateway>(), isA<SandboxPaymentGateway>());

      final result = await getIt<CheckoutService>().checkout(
        orderId: 'order-1',
        amount: 49.99,
      );
      expect(result.receipt.gateway, 'sandbox');
      expect(result.receipt.status, 'approved_simulated');
    });

    test('prod checkout completes on the live gateway', () async {
      configureDependencies(environment: Environment.prod);

      expect(getIt<PaymentGateway>(), isA<StripePaymentGateway>());

      final result = await getIt<CheckoutService>().checkout(
        orderId: 'order-2',
        amount: 129.99,
      );
      expect(result.receipt.gateway, 'stripe');
      expect(result.receipt.status, 'paid');
    });
  });

  group('EnvironmentFilter', () {
    test('NoEnvOrContains registers when ANY target environment is active', () {
      configureDependencies(
        environmentFilter: const NoEnvOrContains({'dev', 'staging'}),
      );

      expect(getIt<ApiService>(), isA<MockApiService>()); // 'dev' active
      expect(getIt.isRegistered<FeatureFlags>(), isTrue); // 'staging' active
      expect(getIt.isRegistered<DebugLogger>(), isTrue); // 'dev' active
    });

    test('NoEnvOrContainsAll requires every target environment', () async {
      configureDependencies(
        environmentFilter: const NoEnvOrContainsAll({'dev'}),
      );
      expect(getIt.isRegistered<DebugLogger>(), isFalse); // 'debug' missing
      expect(
        getIt.isRegistered<ApiService>(),
        isFalse,
      ); // sandbox needs {dev, test}
      expect(getIt.isRegistered<AppConfig>(), isTrue); // un-gated always in

      await getIt.reset();
      configureDependencies(
        environmentFilter: const NoEnvOrContainsAll({'dev', 'debug'}),
      );
      expect(getIt.isRegistered<DebugLogger>(), isTrue);
    });

    test('custom NotInFilter blocks listed environments', () {
      configureDependencies(environmentFilter: const NotInFilter({'prod'}));

      expect(getIt<ApiService>(), isA<MockApiService>());
      expect(getIt<AnalyticsService>(), isA<ConsoleAnalyticsService>());
      expect(
        getIt.isRegistered<FeatureFlags>(),
        isTrue,
      ); // 'staging' not blocked
    });
  });
}
