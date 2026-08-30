import 'package:injectable/injectable.dart';

/// A denylist-style filter: registers a dependency unless any of its target
/// environments is blocked.
///
/// This complements the built-in allowlist filters [NoEnvOrContains] and
/// [NoEnvOrContainsAll] and shows how to plug custom gating rules into
/// `getIt.init(environmentFilter: ...)`.
class NotInFilter extends EnvironmentFilter {
  /// Creates a filter that blocks every environment in [environments].
  const NotInFilter(super.environments);

  @override
  bool canRegister(Set<String> targetEnvironments) {
    if (targetEnvironments.isEmpty) return true;
    return !targetEnvironments.any(environments.contains);
  }
}
