import '../../qris.dart';

/// Formatter class for QRIS transactions, to format the transaction and tip information.
class QrisTransactionFormatter {
  final Map<String, dynamic> data;

  QrisTransactionFormatter(this.data);

  // Getters for the raw values
  TipIndicator get tipIndicator =>
      data['tip_indicator'].toString().toTipIndicator();
  String get transactionAmount => data['transaction_amount'] ?? '0';
  String get tipValue => data['tip_value'] ?? '0';
  String get fixedTipAmount => data['fixed_tip_amount'] ?? '0';
  String get percentageTipAmount => data['percentage_tip_amount'] ?? '0';

  /// Formats the transaction data and returns a map.
  Map<String, dynamic> formatTransaction() {
    String tipIndicatorRaw = data['tip_indicator'] ?? '';
    String transactionAmount = this.transactionAmount;
    String fixedTipAmount = this.fixedTipAmount;
    String percentageTipAmount = this.percentageTipAmount;

    // Convert raw tip indicator to `TipIndicator` enum
    TipIndicator tipIndicatorEnum = tipIndicatorRaw.toTipIndicator();

    // Determine the `tipValue` based on the `TipIndicator`
    dynamic tipValue = _calculateTipValue(
      tipIndicatorEnum,
      transactionAmount,
      fixedTipAmount,
      percentageTipAmount,
    );

    // Return the formatted data as a map
    return {
      'tip_indicator_raw': tipIndicatorEnum.toRawValue(),
      'tip_indicator': tipIndicatorEnum.toTipStringUpperCase(),
      'transaction_amount': transactionAmount,
      if (tipIndicatorEnum.isFixedTip) ...{
        'fixed_tip_amount': fixedTipAmount,
      },
      if (tipIndicatorEnum.isFixedTipPercentage) ...{
        'percentage_tip_amount': percentageTipAmount,
      },
      'tip_calculated': tipValue,
    };
  }

  /// Calculates the `tipValue` based on the `TipIndicator`.
  dynamic _calculateTipValue(
      TipIndicator tipIndicatorEnum,
      String transactionAmount,
      String fixedTipAmount,
      String percentageTipAmount) {
    switch (tipIndicatorEnum) {
      case TipIndicator.inputTipByCustomer:
        return null; // No predefined tip amount, to be input by the customer
      case TipIndicator.fixedTip:
        return fixedTipAmount; // Use the fixed tip amount
      case TipIndicator.fixedTipPercentage:
        return (num.tryParse(transactionAmount) ?? 0) *
            (num.tryParse(percentageTipAmount) ?? 0) /
            100; // Use percentage tip amount
      case TipIndicator.noTip:
        return null; // No tip
    }
  }
}
