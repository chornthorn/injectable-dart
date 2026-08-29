import 'package:feature_catalog/catalog.dart';
import 'package:get_it/get_it.dart';
import 'package:root_app/root_app.dart';
import 'package:shared/shared.dart';
import 'package:test/test.dart';

void main() {
  group('root_app', () {
    setUpAll(() async {
      await GetIt.instance.reset();
      await configureDependencies();
    });

    test('root app generates and initializes its own registrations', () {
      expect(
        getIt<StartupService>().banner(),
        'Demo Monorepo v1.0.0 ready',
      );
    });

    test('scenario A: shared and feature_catalog are composed', () {
      expect(getIt<AppConfig>().appName, 'Demo Monorepo');
      expect(
        getIt<CatalogService>().describe('A'),
        contains('2 products in catalog'),
      );
    });

    test('nested folder micro-package inside feature_catalog is composed', () {
      expect(
        getIt<ReviewService>().summarize(),
        contains('got 5 stars'),
      );
    });

    test('nested module resolves services from parent folder and shared', () {
      final review = getIt<ReviewService>().reviewFirst();
      expect(review.productId, 'p1');
      expect(review.stars, 5);
    });

    test('async singleton stays pending until resolved via getAsync/allReady',
        () async {
      // TelemetryProvider's async getter takes real time — registered by init()
      // but NOT resolved: direct get() throws "not ready yet".
      expect(() => GetIt.instance<TelemetrySession>(), throwsStateError);

      // Resolve it on demand.
      final telemetry = await GetIt.instance.getAsync<TelemetrySession>();
      expect(telemetry.sessionId, 'session-12345');
      expect(() => GetIt.instance<TelemetrySession>(), returnsNormally);
    });

    test('tagged @Inject singleton resolves by instanceName', () {
      expect(
        GetIt.instance<String>(instanceName: 'mydemotoken'),
        'demo-token-abc123',
      );
    });

    test('class depends on the tagged token via constructor injection', () {
      final reporter = GetIt.instance<TelemetryReporter>();
      expect(reporter.report('ping'), 'ping [token: demo-token-abc123]');
    });

    test('allReady resolves the remaining async singletons', () async {
      await GetIt.instance.allReady();
      final weather = GetIt.instance<WeatherService>();
      final snapshot = await weather.snapshot;
      expect(snapshot.condition, 'Sunny');
      expect(snapshot.tempCelsius, 21.5);
    });
  });
}
