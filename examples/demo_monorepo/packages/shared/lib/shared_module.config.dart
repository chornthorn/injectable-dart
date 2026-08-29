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
import 'package:shared/app_config.dart' as _i3;
import 'package:shared/greeting_service.dart' as _i4;

class SharedInjectableModule extends _i1.MicroPackageModule {
  @override
  void init(_i1.GetItHelper gh) {
    gh.singleton<_i3.AppConfig>(_i3.AppConfig());
    gh.factory<_i4.GreetingService>(
      () => _i4.GreetingService(gh<_i3.AppConfig>()),
    );
  }
}

extension SharedInjectableModuleX on _i2.GetIt {
  _i2.GetIt initShared({
    String? environment,
    _i1.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i1.GetItHelper(
      this,
      environment: environment,
      environmentFilter: environmentFilter,
    );
    SharedInjectableModule().init(gh);
    return this;
  }
}
