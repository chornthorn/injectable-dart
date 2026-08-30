import 'package:environments_filtering_example/services/analytics_service.dart';
import 'package:environments_filtering_example/services/app_config.dart';
import 'package:injectify/injectify.dart';

import 'payment_gateway.dart';

/// Result of a completed checkout.
class CheckoutResult {
  const CheckoutResult({required this.receipt, required this.storeName});

  final PaymentReceipt receipt;
  final String storeName;

  @override
  String toString() =>
      '$storeName — ${receipt.gateway} ${receipt.status} '
      '(\$${receipt.amount.toStringAsFixed(2)})';
}

/// Orchestrates the checkout flow: charges the card through the active
/// (environment-gated) [PaymentGateway] and reports the event to the active
/// [AnalyticsService].
@Injectable(scope: Scope.factory)
class CheckoutService {
  CheckoutService(this._gateway, this._analytics, this._config);

  final PaymentGateway _gateway;
  final AnalyticsService _analytics;
  final AppConfig _config;

  Future<CheckoutResult> checkout({
    required String orderId,
    required double amount,
  }) async {
    final receipt = await _gateway.charge(amount, orderId: orderId);
    _analytics.track('checkout.${receipt.status}');
    return CheckoutResult(receipt: receipt, storeName: _config.appName);
  }
}
