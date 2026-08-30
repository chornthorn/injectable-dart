import 'package:injectify/injectify.dart';
import 'package:shared/greeting_service.dart';

import 'product.dart';

@Injectable(scope: Scope.lazySingleton)
class CatalogService {
  final GreetingService _greeting;

  CatalogService(this._greeting);

  List<Product> listAll() => const [
        Product(id: 'p1', title: 'Injectable for Dart', price: 29.99),
        Product(id: 'p2', title: 'Monorepo Patterns', price: 39.99),
      ];

  /// Demonstrates cross-package injection: [GreetingService] lives in `shared`.
  String describe(String shopper) =>
      '${_greeting.greet(shopper)} — ${listAll().length} products in catalog';
}
