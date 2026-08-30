import 'package:injectify/injectify.dart';

@Injectable()
class DiscountCalculator {
  final double discountRate;

  DiscountCalculator(@FactoryParam() this.discountRate);

  double applyDiscount(double amount) =>
      amount * (1.0 - (discountRate / 100.0));
}
