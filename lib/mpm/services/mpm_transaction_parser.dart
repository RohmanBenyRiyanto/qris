import 'package:flutter/foundation.dart';
import 'package:flutter_qris/qris.dart';

class Transaction {
  final Map<String, dynamic> _raw;

  Transaction(this._raw);

  TipIndicator get indicator =>
      _raw['tip_indicator'].toString().toTipIndicator();
  num get transactionAmount => _raw.containsKey('transaction_amount')
      ? num.tryParse((_raw['transaction_amount'] ?? '0').toString()) ?? 0
      : 0;
  num get fixedTipAmount => _raw.containsKey('fixed_tip_amount')
      ? num.tryParse((_raw['fixed_tip_amount'] ?? '0').toString()) ?? 0
      : 0;
  num get percentageTipAmount => _raw.containsKey('percentage_tip_amount')
      ? num.tryParse((_raw['percentage_tip_amount'] ?? '0').toString()) ?? 0
      : 0;
  num get tipCalculated =>
      _calculateTipValue(
          indicator, transactionAmount, fixedTipAmount, percentageTipAmount) ??
      0;

  dynamic _calculateTipValue(TipIndicator tipIndicatorEnum,
      num transactionAmount, num fixedTipAmount, num percentageTipAmount) {
    switch (tipIndicatorEnum) {
      case TipIndicator.inputTipByCustomer:
        return null; // No predefined tip amount, to be input by the customer
      case TipIndicator.fixedTip:
        return fixedTipAmount; // Use the fixed tip amount
      case TipIndicator.fixedTipPercentage:
        return (transactionAmount) *
            (percentageTipAmount) /
            100; // Use percentage tip amount
      case TipIndicator.noTip:
        return null; // No tip
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'indicator': indicator.toTipStringUpperCase(),
      'transaction_amount': transactionAmount,
      'fixed_tip_amount': fixedTipAmount,
      'percentage_tip_amount': percentageTipAmount,
      'tip_calculated': tipCalculated
    };
  }

  @override
  String toString() {
    return toMap().toPrettyString();
  }

  @visibleForTesting
  void logDebugingTip() {
    return toString().qrLog();
  }
}
