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
import 'package:root_app/features/bootstrap/weather_service.dart' as _i3;

class BootstrapInjectableModule extends _i1.MicroPackageModule {
  @override
  Future<void> init(_i1.GetItHelper gh) async {
    await gh.singletonAsync<_i3.WeatherService>(
      () async => _i3.WeatherService(),
    );
  }
}

extension BootstrapInjectableModuleX on _i2.GetIt {
  Future<_i2.GetIt> init({
    String? environment,
    _i1.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i1.GetItHelper(
      this,
      environment: environment,
      environmentFilter: environmentFilter,
    );
    await BootstrapInjectableModule().init(gh);
    return this;
  }
}
