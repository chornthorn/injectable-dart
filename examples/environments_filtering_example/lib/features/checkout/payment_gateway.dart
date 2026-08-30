/// Receipt returned by a [PaymentGateway] after a charge attempt.
class PaymentReceipt {
  const PaymentReceipt({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.gateway,
    required this.status,
  });

  final String id;
  final String orderId;
  final double amount;
  final String gateway;
  final String status;

  @override
  String toString() =>
      '$gateway #$id $status \$${amount.toStringAsFixed(2)} (order $orderId)';
}

/// Contract for processing a card charge.
///
/// The active implementation is chosen by environment:
/// - dev / test  -> [SandboxPaymentGateway] (simulated, no real money)
/// - prod        -> [StripePaymentGateway] (live)
abstract class PaymentGateway {
  /// Charges [amount] for [orderId] and returns a [PaymentReceipt].
  Future<PaymentReceipt> charge(double amount, {required String orderId});
}
