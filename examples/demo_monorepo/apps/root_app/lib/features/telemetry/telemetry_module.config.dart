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
import 'package:root_app/features/telemetry/telemetry_provider.dart' as _i3;
import 'package:root_app/features/telemetry/telemetry_reporter.dart' as _i4;

class TelemetryInjectableModule extends _i1.MicroPackageModule {
  @override
  Future<void> init(_i1.GetItHelper gh) async {
    final telemetryProvider = _$TelemetryProvider();
    await gh.singletonAsync<_i3.TelemetrySession>(
      () async => telemetryProvider.telemetrySession,
    );
    gh.singleton<String>(
      telemetryProvider.demoToken,
      instanceName: 'mydemotoken',
    );
    gh.lazySingleton<_i4.TelemetryReporter>(
      () => _i4.TelemetryReporter(gh<String>(instanceName: 'mydemotoken')),
    );
  }
}

extension TelemetryInjectableModuleX on _i2.GetIt {
  Future<_i2.GetIt> init({
    String? environment,
    _i1.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i1.GetItHelper(
      this,
      environment: environment,
      environmentFilter: environmentFilter,
    );
    await TelemetryInjectableModule().init(gh);
    return this;
  }
}

class _$TelemetryProvider extends _i3.TelemetryProvider {}
