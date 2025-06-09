/// Enum representing the different types of tip indicators for QRIS.
enum TipIndicator {
  inputTipByCustomer,
  noTip,
  fixedTip,
  fixedTipPercentage,
}

/// Extension on `String` to convert raw string values (QRIS tip indicators) into `TipIndicator` enum.
extension TipIndicatorFromStringExtension on String {
  /// Converts raw string values like '01', '02', '03' to `TipIndicator` enum.
  ///
  /// - Returns: A `TipIndicator` enum value based on the string:
  ///   - '01' -> `TipIndicator.inputTipByCustomer`
  ///   - '02' -> `TipIndicator.fixedTip`
  ///   - '03' -> `TipIndicator.fixedTipPercentage`
  ///   - Any other value -> `TipIndicator.noTip`
  TipIndicator toTipIndicator() {
    switch (this) {
      case '01':
        return TipIndicator.inputTipByCustomer;
      case '02':
        return TipIndicator.fixedTip;
      case '03':
        return TipIndicator.fixedTipPercentage;
      default:
        return TipIndicator.noTip;
    }
  }
}

/// Extension on `TipIndicator` to map the enum back to its raw string value for QRIS.
extension TipIndicatorExtension on TipIndicator {
  bool get isInputTipByCustomer => this == TipIndicator.inputTipByCustomer;
  bool get isFixedTip => this == TipIndicator.fixedTip;
  bool get isFixedTipPercentage => this == TipIndicator.fixedTipPercentage;
  bool get isNoTip => this == TipIndicator.noTip;

  /// Converts `TipIndicator` enum to its corresponding raw string for QRIS.
  ///
  /// - Returns: A string like "01", "02", or "03" based on the `TipIndicator` value:
  ///   - `TipIndicator.inputTipByCustomer` -> "01"
  ///   - `TipIndicator.fixedTip` -> "02"
  ///   - `TipIndicator.fixedTipPercentage` -> "03"
  ///   - `TipIndicator.noTip` -> "" (empty string)
  String toRawValue() {
    switch (this) {
      case TipIndicator.inputTipByCustomer:
        return '01';
      case TipIndicator.fixedTip:
        return '02';
      case TipIndicator.fixedTipPercentage:
        return '03';
      case TipIndicator.noTip:
        return '';
    }
  }

  /// Converts `TipIndicator` enum to a human-readable string in uppercase for display.
  ///
  /// - Returns: A string representing the tip indicator:
  ///   - `TipIndicator.inputTipByCustomer` -> "INPUT_TIP"
  ///   - `TipIndicator.noTip` -> "" (empty string)
  ///   - `TipIndicator.fixedTip` -> "FIXED_AMOUNT"
  ///   - `TipIndicator.fixedTipPercentage` -> "FIXED_PERCENTAGE"
  String toTipStringUpperCase() {
    switch (this) {
      case TipIndicator.inputTipByCustomer:
        return 'INPUT_TIP';
      case TipIndicator.fixedTip:
        return 'FIXED_AMOUNT';
      case TipIndicator.fixedTipPercentage:
        return 'FIXED_PERCENTAGE';
      case TipIndicator.noTip:
        return '';
    }
  }

  /// Converts `TipIndicator` enum to a human-readable string in lowercase for display.
  ///
  /// - Returns: A string representing the tip indicator in lowercase:
  ///   - `TipIndicator.inputTipByCustomer` -> "input_tip"
  ///   - `TipIndicator.noTip` -> "" (empty string)
  ///   - `TipIndicator.fixedTip` -> "fixed_amount"
  ///   - `TipIndicator.fixedTipPercentage` -> "fixed_percentage"
  String toTipStringLowerCase() {
    switch (this) {
      case TipIndicator.inputTipByCustomer:
        return 'input_tip';
      case TipIndicator.fixedTip:
        return 'fixed_amount';
      case TipIndicator.fixedTipPercentage:
        return 'fixed_percentage';
      case TipIndicator.noTip:
        return '';
    }
  }
}
