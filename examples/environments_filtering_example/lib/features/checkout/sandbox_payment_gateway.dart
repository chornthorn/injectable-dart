import 'package:injectable/injectable.dart';

import 'payment_gateway.dart';

/// Dev/test gateway: accepts any card and returns a fake receipt.
///
/// No money moves, so it is safe for local development, CI, and widget tests.
@Injectable(as: PaymentGateway, env: [Environment.dev, Environment.test])
class SandboxPaymentGateway implements PaymentGateway {
  @override
  Future<PaymentReceipt> charge(
    double amount, {
    required String orderId,
  }) async {
    return PaymentReceipt(
      id: 'sandbox_${DateTime.now().millisecondsSinceEpoch}',
      orderId: orderId,
      amount: amount,
      gateway: 'sandbox',
      status: 'approved_simulated',
    );
  }
}
