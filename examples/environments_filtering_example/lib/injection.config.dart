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
import 'package:environments_filtering_example/features/checkout/checkout_service.dart'
    as _i3;
import 'package:environments_filtering_example/features/checkout/payment_gateway.dart'
    as _i4;
import 'package:environments_filtering_example/services/analytics_service.dart'
    as _i5;
import 'package:environments_filtering_example/services/app_config.dart' as _i6;
import 'package:environments_filtering_example/features/checkout/sandbox_payment_gateway.dart'
    as _i7;
import 'package:environments_filtering_example/features/checkout/stripe_payment_gateway.dart'
    as _i8;
import 'package:environments_filtering_example/services/api_service.dart'
    as _i9;
import 'package:environments_filtering_example/services/debug_logger.dart'
    as _i10;
import 'package:environments_filtering_example/services/feature_flags.dart'
    as _i11;

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
    gh.factory<_i3.CheckoutService>(
      () => _i3.CheckoutService(
        gh<_i4.PaymentGateway>(),
        gh<_i5.AnalyticsService>(),
        gh<_i6.AppConfig>(),
      ),
    );
    gh.factory<_i4.PaymentGateway>(
      () => _i7.SandboxPaymentGateway(),
      registerFor: {'dev', 'test'},
    );
    gh.factory<_i4.PaymentGateway>(
      () => _i8.StripePaymentGateway(),
      registerFor: {'prod'},
    );
    gh.lazySingleton<_i5.AnalyticsService>(
      () => _i5.ConsoleAnalyticsService(),
      registerFor: {'dev'},
    );
    gh.lazySingleton<_i5.AnalyticsService>(
      () => _i5.RemoteAnalyticsService(),
      registerFor: {'prod'},
    );
    gh.factory<_i9.ApiService>(
      () => _i9.MockApiService(),
      registerFor: {'dev', 'test'},
    );
    gh.factory<_i9.ApiService>(
      () => _i9.RealApiService(),
      registerFor: {'prod'},
    );
    gh.factory<_i6.AppConfig>(() => _i6.AppConfig());
    gh.factory<_i10.DebugLogger>(
      () => _i10.DebugLogger(),
      registerFor: {'dev', 'debug'},
    );
    gh.factory<_i11.FeatureFlags>(
      () => _i11.FeatureFlags(gh<_i6.AppConfig>()),
      registerFor: {'staging'},
    );
    return this;
  }
}
