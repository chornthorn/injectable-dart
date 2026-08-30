import 'package:injectify/injectify.dart';

@Injectable()
class PaymentGateway {
  Future<bool> processPayment(double amount) async {
    // Simulated payment processing
    return amount > 0;
  }
}
