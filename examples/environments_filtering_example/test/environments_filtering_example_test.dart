import 'package:environments_filtering_example/custom_environment_filter.dart';
import 'package:environments_filtering_example/injection.dart';
import 'package:environments_filtering_example/services/analytics_service.dart';
import 'package:environments_filtering_example/services/api_service.dart';
import 'package:environments_filtering_example/services/app_config.dart';
import 'package:environments_filtering_example/services/debug_logger.dart';
import 'package:environments_filtering_example/services/feature_flags.dart';
import 'package:injectable/injectable.dart';
import 'package:test/test.dart';

void main() {
  setUp(getIt.reset);

  group('single environment', () {
    test('dev registers mock implementations and un-gated services', () {
      configureDependencies(environment: Environment.dev);

      expect(getIt.isRegistered<ApiService>(), isTrue);
      expect(getIt.isRegistered<RealApiService>(), isFalse);
      expect(getIt.isRegistered<AnalyticsService>(), isTrue);
      expect(getIt.isRegistered<DebugLogger>(), isTrue);
      expect(getIt.isRegistered<AppConfig>(), isTrue);
      expect(getIt.isRegistered<FeatureFlags>(), isFalse);

      expect(getIt<ApiService>(), isA<MockApiService>());
      expect(getIt<AnalyticsService>(), isA<ConsoleAnalyticsService>());
    });

    test('prod registers live implementations and skips dev-only ones', () {
      configureDependencies(environment: Environment.prod);

      expect(getIt.isRegistered<ApiService>(), isTrue);
      expect(getIt.isRegistered<MockApiService>(), isFalse);
      expect(getIt.isRegistered<DebugLogger>(), isFalse);
      expect(getIt.isRegistered<AnalyticsService>(), isTrue);

      expect(getIt<ApiService>(), isA<RealApiService>());
      expect(getIt<AnalyticsService>(), isA<RemoteAnalyticsService>());
      expect(() => getIt<MockApiService>(), throwsStateError);
    });
  });

  group('EnvironmentFilter', () {
    test('NoEnvOrContains registers when ANY target environment is active', () {
      configureDependencies(
        environmentFilter: const NoEnvOrContains({'dev', 'staging'}),
      );

      expect(getIt.isRegistered<ApiService>(), isTrue); // mock matches 'dev'
      expect(getIt.isRegistered<RealApiService>(), isFalse); // 'prod' inactive
      expect(getIt.isRegistered<FeatureFlags>(), isTrue); // 'staging' active
      expect(getIt.isRegistered<DebugLogger>(), isTrue); // 'dev' active
    });

    test('NoEnvOrContainsAll requires every target environment', () async {
      configureDependencies(
        environmentFilter: const NoEnvOrContainsAll({'dev'}),
      );
      expect(getIt.isRegistered<DebugLogger>(), isFalse); // 'debug' missing

      await getIt.reset();
      configureDependencies(
        environmentFilter: const NoEnvOrContainsAll({'dev', 'debug'}),
      );
      expect(getIt.isRegistered<DebugLogger>(), isTrue);

      // Un-gated dependencies are always registered.
      expect(getIt.isRegistered<AppConfig>(), isTrue);
    });

    test('custom NotInFilter blocks listed environments', () {
      configureDependencies(environmentFilter: const NotInFilter({'prod'}));

      expect(getIt<ApiService>(), isA<MockApiService>());
      expect(getIt.isRegistered<RealApiService>(), isFalse);
      expect(getIt<AnalyticsService>(), isA<ConsoleAnalyticsService>());
      expect(
        getIt.isRegistered<FeatureFlags>(),
        isTrue,
      ); // 'staging' not blocked
    });
  });
}
