import 'package:injectable/injectable.dart';

/// Contract for event analytics tracking.
abstract class AnalyticsService {
  void track(String event);
}

/// Development analytics that writes to the console.
@Injectable(as: AnalyticsService, env: [Environment.dev])
class ConsoleAnalyticsService implements AnalyticsService {
  @override
  void track(String event) {
    // ignore: avoid_print
    print('[console-analytics] $event');
  }
}

/// Production analytics that forwards events to a remote collector.
@Injectable(as: AnalyticsService, env: [Environment.prod])
class RemoteAnalyticsService implements AnalyticsService {
  final List<String> _events = [];

  List<String> get events => List.unmodifiable(_events);

  @override
  void track(String event) => _events.add(event);
}
