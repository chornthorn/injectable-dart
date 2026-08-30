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
import 'package:injectify/injectify.dart' as _i1;
import 'package:get_it/get_it.dart' as _i2;
import 'package:root_app/features/dashboard/dashboard_service.dart' as _i3;
import 'package:shared/app_config.dart' as _i4;

class DashboardInjectableModule extends _i1.MicroPackageModule {
  @override
  void init(_i1.GetItHelper gh) {
    gh.lazySingleton<_i3.DashboardService>(
      () => _i3.DashboardService(gh<_i4.AppConfig>()),
    );
  }
}

extension DashboardInjectableModuleX on _i2.GetIt {
  _i2.GetIt init({
    String? environment,
    _i1.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i1.GetItHelper(
      this,
      environment: environment,
      environmentFilter: environmentFilter,
    );
    DashboardInjectableModule().init(gh);
    return this;
  }
}
