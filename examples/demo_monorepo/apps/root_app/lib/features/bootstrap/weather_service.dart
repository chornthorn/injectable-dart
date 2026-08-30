import 'package:injectify/injectify.dart';

class WeatherSnapshot {
  final double tempCelsius;
  final String condition;

  const WeatherSnapshot({required this.tempCelsius, required this.condition});
}

/// Async singleton resolved by `getIt.allReady()` after initialization.
///
/// `@PreResolve()` makes the generator emit
/// `await gh.singletonAsync<WeatherService>(() => WeatherService())` inside the
/// bootstrap module's `init()` — the instance is created during `allReady()`
/// and only then becomes resolvable from the container.
@PreResolve()
@Injectable(scope: Scope.singleton)
class WeatherService {
  /// Simulates an async bootstrap step (network fetch, config load, …).
  final Future<WeatherSnapshot> snapshot;

  WeatherService() : snapshot = _fetch();

  static Future<WeatherSnapshot> _fetch() async {
    await Future<void>.delayed(const Duration(milliseconds: 20));
    return const WeatherSnapshot(tempCelsius: 21.5, condition: 'Sunny');
  }
}
