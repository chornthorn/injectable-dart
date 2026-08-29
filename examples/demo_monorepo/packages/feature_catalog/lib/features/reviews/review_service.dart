import 'package:injectable/injectable.dart';
import 'package:shared/greeting_service.dart';

import '../../catalog_service.dart';
import 'review.dart';

/// Lazy singleton inside the `reviews` sub-feature micro-package.
///
/// Resolves [CatalogService] from the parent folder (registered by
/// `initCatalog()`) and [GreetingService] from the `shared` package —
/// both must be initialized before `initReviews()`.
@Injectable(scope: Scope.lazySingleton)
class ReviewService {
  final CatalogService _catalog;
  final GreetingService _greeting;

  ReviewService(this._catalog, this._greeting);

  Review reviewFirst() {
    final product = _catalog.listAll().first;
    return Review(productId: product.id, stars: 5, comment: product.title);
  }

  String summarize() {
    final review = reviewFirst();
    return '${_greeting.greet('Reviewer')} — "${review.comment}" got ${review.stars} stars';
  }
}
