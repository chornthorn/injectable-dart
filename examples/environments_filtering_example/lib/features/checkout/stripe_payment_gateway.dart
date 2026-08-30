import 'package:injectify/injectify.dart';

import 'payment_gateway.dart';

/// Production gateway that talks to the real payment provider.
@Injectable(as: PaymentGateway, env: [Environment.prod])
class StripePaymentGateway implements PaymentGateway {
  @override
  Future<PaymentReceipt> charge(
    double amount, {
    required String orderId,
  }) async {
    // In a real app this would POST to the provider with a live API key and
    // validate the card; here we validate the amount to simulate that.
    if (amount <= 0) {
      throw ArgumentError.value(amount, 'amount', 'must be positive');
    }

    return PaymentReceipt(
      id: 'stripe_${DateTime.now().millisecondsSinceEpoch}',
      orderId: orderId,
      amount: amount,
      gateway: 'stripe',
      status: 'paid',
    );
  }
}
