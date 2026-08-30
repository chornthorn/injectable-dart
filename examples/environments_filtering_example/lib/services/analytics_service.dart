import 'package:injectable/injectable.dart';

/// Contract for event analytics tracking.
abstract class AnalyticsService {
  void track(String event);
}

/// Development analytics that writes to the console.
///
/// A singleton so every tracked event is observable from one instance.
@Injectable(
  as: AnalyticsService,
  scope: Scope.lazySingleton,
  env: [Environment.dev],
)
class ConsoleAnalyticsService implements AnalyticsService {
  @override
  void track(String event) {
    // ignore: avoid_print
    print('[console-analytics] $event');
  }
}

/// Production analytics that forwards events to a remote collector.
@Injectable(
  as: AnalyticsService,
  scope: Scope.lazySingleton,
  env: [Environment.prod],
)
class RemoteAnalyticsService implements AnalyticsService {
  final List<String> _events = [];

  List<String> get events => List.unmodifiable(_events);

  @override
  void track(String event) => _events.add(event);
}
