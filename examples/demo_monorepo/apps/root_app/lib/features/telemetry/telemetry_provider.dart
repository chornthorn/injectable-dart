import 'package:injectify/injectify.dart';

class TelemetrySession {
  final String sessionId;

  const TelemetrySession(this.sessionId);
}

/// External provider module whose async member stays **pending** after `init()`.
///
/// Unlike a plain `@PreResolve` class (`() async => Ctor()` — resolves after a
/// microtask), the async getter's future takes real time, so until it completes:
/// - `getIt<TelemetrySession>()` throws `StateError` ("not ready yet"),
/// - `await getIt.isReady... / getAsync<TelemetrySession>()` resolves it on demand.
@ExternalModule()
abstract class TelemetryProvider {
  /// Async member — detected automatically from the `Future` return type
  /// (no `@PreResolve()` needed). The registration stays **pending** until
  /// this future completes.
  @Injectable(scope: Scope.singleton)
  Future<TelemetrySession> get telemetrySession async {
    // Simulates a real async bootstrap step (network handshake, token fetch, …).
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const TelemetrySession('session-12345');
  }

  /// Synchronous tagged dependency — resolved via
  /// `getIt<String>(instanceName: 'mydemotoken')`.
  @Inject('mydemotoken')
  @Injectable(scope: Scope.singleton)
  String get demoToken => 'demo-token-abc123';
}
