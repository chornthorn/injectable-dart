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
import 'package:feature_catalog/features/reviews/review_service.dart' as _i3;
import 'package:feature_catalog/catalog_service.dart' as _i4;
import 'package:shared/greeting_service.dart' as _i5;

class ReviewsInjectableModule extends _i1.MicroPackageModule {
  @override
  void init(_i1.GetItHelper gh) {
    gh.lazySingleton<_i3.ReviewService>(
      () => _i3.ReviewService(
        gh<_i4.CatalogService>(),
        gh<_i5.GreetingService>(),
      ),
    );
  }
}

extension ReviewsInjectableModuleX on _i2.GetIt {
  _i2.GetIt initReviews({
    String? environment,
    _i1.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i1.GetItHelper(
      this,
      environment: environment,
      environmentFilter: environmentFilter,
    );
    ReviewsInjectableModule().init(gh);
    return this;
  }
}
