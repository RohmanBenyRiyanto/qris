import 'package:flutter/foundation.dart';
import 'package:flutter_qris/qris.dart';
import 'package:flutter_qris/qris_core/utils/type/tip_indicator.dart';

class MpmTip {
  final Map<String, dynamic> data;

  MpmTip(this.data);

  TipIndicator get indicator =>
      data['tip_indicator'].toString().toTipIndicator();
  num get transactionAmount => data.containsKey('transaction_amount')
      ? num.tryParse((data['transaction_amount'] ?? '0').toString()) ?? 0
      : 0;
  num get fixedTipAmount => data.containsKey('fixed_tip_amount')
      ? num.tryParse((data['fixed_tip_amount'] ?? '0').toString()) ?? 0
      : 0;
  num get percentageTipAmount => data.containsKey('percentage_tip_amount')
      ? num.tryParse((data['percentage_tip_amount'] ?? '0').toString()) ?? 0
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
    return toString().myLog();
  }
}
