import 'package:equatable/equatable.dart';

import '../../../../../core/resources/currency_model.dart';

abstract class AppCurrencyState extends Equatable {
  final CurrencyModel currency;
  const AppCurrencyState({required this.currency});

  @override
  List<Object?> get props => [currency];
}

class AppCurrencyInitial extends AppCurrencyState {
  // Pass a default value or handle as needed.
  const AppCurrencyInitial() : super(currency: CurrencyModel.mad);
}

class AppCurrencyChanged extends AppCurrencyState {
  const AppCurrencyChanged(CurrencyModel currency) : super(currency: currency);
}
