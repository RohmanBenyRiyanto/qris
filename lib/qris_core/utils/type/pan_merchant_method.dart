/// Represents the Transaction/Payment Method using this QRIS Code.
///
/// This enum categorizes different payment methods available in the system.
enum PANMerchantMethod {
  /// Unspecified payment method (default).
  unspecified,

  /// Payment method via Debit Cards.
  debit,

  /// Payment method via Credit Cards.
  credit,

  /// Payment method via popular Electronic Money Providers,
  /// such as GoPay, OVO, DANA, etc.
  electronicMoney,

  /// Reserved for Future Use (RFU).
  rfu,
}

/// Utility extension for [PANMerchantMethod] providing additional functionalities.
extension PANMerchantMethodExtension on PANMerchantMethod {
  String get name => toString().split('.').last;

  /// Retrieves the numeric identifier associated with the [PANMerchantMethod].
  ///
  /// ### Returns:
  /// - `0` for `unspecified`.
  /// - `1` for `debit`.
  /// - `2` for `credit`.
  /// - `3` for `electronicMoney`.
  /// - Defaults to `0` for other cases (e.g., RFU).
  int get paymentMethodCode {
    switch (this) {
      case PANMerchantMethod.unspecified:
        return 0;
      case PANMerchantMethod.debit:
        return 1;
      case PANMerchantMethod.credit:
        return 2;
      case PANMerchantMethod.electronicMoney:
        return 3;
      default:
        return 0; // Handles RFU and unexpected cases.
    }
  }
}
