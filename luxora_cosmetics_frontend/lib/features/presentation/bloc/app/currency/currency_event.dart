import '../../../../../core/resources/currency_model.dart';

abstract class AppCurrencyEvent {
  const AppCurrencyEvent();
}

class ChangeCurrency extends AppCurrencyEvent {
  final CurrencyModel currency;
  const ChangeCurrency(this.currency);
}
