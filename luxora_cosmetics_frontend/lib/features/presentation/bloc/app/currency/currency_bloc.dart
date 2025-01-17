import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/shared_preference_keys.dart';
import '../../../../../core/resources/currency_model.dart';
import '../../../../../core/util/prefs_util.dart';
import 'currency_event.dart';
import 'currency_state.dart';

class AppCurrencyBloc extends Bloc<AppCurrencyEvent, AppCurrencyState> {
  AppCurrencyBloc() : super(const AppCurrencyInitial()) {
    on<ChangeCurrency>(onChangeCurrency);
    _initializeCurrency();
  }
  void _initializeCurrency() {
    //final savedCurrencyCode = PrefsUtil.getString(PrefsKeys.currencyCode);
    final savedCurrencyCode = CurrencyModel.mad.code;
    final currencyCode = savedCurrencyCode /* ?? CurrencyModel.usd.code*/;

    // Add an event to change the currency
    add(ChangeCurrency(CurrencyModel.fromCode(currencyCode)));
  }

  /// Event handler for changing a new currency
  void onChangeCurrency(
      ChangeCurrency event, Emitter<AppCurrencyState> emit) async {
    emit(const AppCurrencyInitial());
    PrefsUtil.setString(PrefsKeys.currencyCode, event.currency.code);

    emit(AppCurrencyChanged(event.currency));
  }
}
