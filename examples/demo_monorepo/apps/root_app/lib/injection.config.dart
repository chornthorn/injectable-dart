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
import 'package:shared/shared_module.config.dart' as _i3;
import 'package:feature_catalog/catalog_module.config.dart' as _i4;
import 'package:root_app/features/bootstrap/bootstrap_module.config.dart'
    as _i5;
import 'package:root_app/features/dashboard/dashboard_module.config.dart'
    as _i6;
import 'package:root_app/features/my_app_module.config.dart' as _i7;
import 'package:root_app/features/telemetry/telemetry_module.config.dart'
    as _i8;
import 'package:root_app/startup_service.dart' as _i9;
import 'package:shared/app_config.dart' as _i10;

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
    gh.initMicroPackage(_i3.SharedInjectableModule());
    gh.initMicroPackage(_i4.CatalogInjectableModule());
    gh.initMicroPackage(_i5.BootstrapInjectableModule());
    gh.initMicroPackage(_i6.DashboardInjectableModule());
    gh.initMicroPackage(_i7.MyAppFeatureInjectableModule());
    gh.initMicroPackage(_i8.TelemetryInjectableModule());
    gh.lazySingleton<_i9.StartupService>(
      () => _i9.StartupService(gh<_i10.AppConfig>()),
    );
    gh.lazySingleton<_i9.RootDemoService>(
      () => _i9.RootDemoService(gh<_i10.AppConfig>()),
    );
    return this;
  }
}
