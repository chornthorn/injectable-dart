// dart format width=80

// **************************************************************************
// InjectableGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:injectable/injectable.dart' as _i1;
import 'package:get_it/get_it.dart' as _i2;
import 'package:environments_filtering_example/services/analytics_service.dart'
    as _i3;
import 'package:environments_filtering_example/services/api_service.dart'
    as _i4;
import 'package:environments_filtering_example/services/app_config.dart' as _i5;
import 'package:environments_filtering_example/services/debug_logger.dart'
    as _i6;
import 'package:environments_filtering_example/services/feature_flags.dart'
    as _i7;

extension GetItInjectableX on _i2.GetIt {
  _i2.GetIt init({
    String? environment,
    _i1.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i1.GetItHelper(
      this,
      environment: environment,
      environmentFilter: environmentFilter,
    );
    gh.factory<_i3.AnalyticsService>(
      () => _i3.ConsoleAnalyticsService(),
      registerFor: {'dev'},
    );
    gh.factory<_i3.AnalyticsService>(
      () => _i3.RemoteAnalyticsService(),
      registerFor: {'prod'},
    );
    gh.factory<_i4.ApiService>(
      () => _i4.MockApiService(),
      registerFor: {'dev', 'test'},
    );
    gh.factory<_i4.ApiService>(
      () => _i4.RealApiService(),
      registerFor: {'prod'},
    );
    gh.factory<_i5.AppConfig>(() => _i5.AppConfig());
    gh.factory<_i6.DebugLogger>(
      () => _i6.DebugLogger(),
      registerFor: {'dev', 'debug'},
    );
    gh.factory<_i7.FeatureFlags>(
      () => _i7.FeatureFlags(gh<_i5.AppConfig>()),
      registerFor: {'staging'},
    );
    return this;
  }
}
