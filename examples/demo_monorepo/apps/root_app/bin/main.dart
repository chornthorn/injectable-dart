import 'package:feature_catalog/catalog.dart';
import 'package:root_app/root_app.dart';
import 'package:shared/shared.dart';

Future<void> main() async {
  // Root app entry: `configureDependencies()` runs this package's generated
  // injection.config.dart and composes all monorepo packages.
  await configureDependencies();

  // ignore: avoid_print
  print('===== root_app: own registrations =====');
  // ignore: avoid_print
  print(getIt<StartupService>().banner());

  // ignore: avoid_print
  print('\n===== Scenario A: packages with their own pubspec.yaml =====');
  final config = getIt<AppConfig>();
  final catalog = getIt<CatalogService>();
  // ignore: avoid_print
  print('AppConfig: ${config.appName} v${config.version} (from shared)');
  // ignore: avoid_print
  print('Catalog:   ${catalog.describe('A')}');

  // ignore: avoid_print
  print('\n===== Nested folder micro-package (no pubspec.yaml) =====');
  final reviews = getIt<ReviewService>();
  // ignore: avoid_print
  print('Reviews:   ${reviews.summarize()} (feature_catalog/features/reviews)');

  // ignore: avoid_print
  print('\n===== Async @PreResolve (pending until resolved) =====');

  // 1. TelemetryProvider's async getter takes real time -> still pending:
  //    direct get() throws "not ready yet".
  try {
    getIt<TelemetrySession>();
    // ignore: avoid_print
    print('direct get: resolved?! (unexpected)');
  } catch (e) {
    // ignore: avoid_print
    print('direct get: throws -> ${e.runtimeType}');
  }

  // 2. Resolve ONE async singleton on demand.
  final telemetry = await getIt.getAsync<TelemetrySession>();
  // ignore: avoid_print
  print('Telemetry: session ${telemetry.sessionId} (getAsync)');

  // 2b. Sync tagged dependency — resolved by instanceName.
  final token = getIt<String>(instanceName: 'mydemotoken');
  // ignore: avoid_print
  print('Token:     $token (@Inject \'mydemotoken\')');

  // 2c. A class depending on the tagged token via constructor injection.
  final reporter = getIt<TelemetryReporter>();
  // ignore: avoid_print
  print('Reporter:  ${reporter.report('ping')}');

  // 3. Resolve every remaining async singleton (weather).
  await getIt.allReady();
  final weather = getIt<WeatherService>();
  final snapshot = await weather.snapshot;
  // ignore: avoid_print
  print('Weather:   ${snapshot.condition} at ${snapshot.tempCelsius}°C (allReady)');
  // ignore: avoid_print
  print('Dashboard: ${getIt<DashboardService>().summary()}');

  // ignore: avoid_print
  print('\n✅ root_app generated its own config and awaited configureDependencies().');
}
