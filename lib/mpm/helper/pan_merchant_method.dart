import 'package:flutter/foundation.dart';
import 'package:flutter_qris/qris.dart';

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
extension PANMerchantMethodUtils on PANMerchantMethod {
  /// Retrieves the numeric indicator associated with the [PANMerchantMethod].
  ///
  /// ### Returns:
  /// - `0` for `unspecified`.
  /// - `1` for `debit`.
  /// - `2` for `credit`.
  /// - `3` for `electronicMoney`.
  /// - Defaults to `0` for other cases (e.g., RFU).
  int get indicator {
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

/// A mixin to validate and extract details from the Personal Account Number (PAN).
///
/// This mixin provides utilities for:
/// - Extracting the merchant sequence from the PAN.
/// - Retrieving the check digit from the PAN.
/// - Validating the check digit using the Luhn (Mod 10) algorithm.
/// - Debugging the validation process with verbose output.
mixin MerchantPANValidationMixin {
  /// The Personal Account Number (PAN) associated with the merchant.
  ///
  /// This should be a string of digits that adheres to the PAN format, typically
  /// containing the merchant sequence and a check digit.
  String? get merchantPan;

  /// Retrieves the merchant sequence from the PAN.
  ///
  /// The merchant sequence is extracted starting from the 9th character
  /// (index 9) up to the second-to-last character in the PAN.
  ///
  /// ### Returns:
  /// - The extracted merchant sequence as a string.
  /// - `null` if the PAN is `null` or shorter than 10 characters.
  String? get merchantSequence {
    final pan = merchantPan;
    if (pan != null && pan.length > 9) {
      return pan.substring(9, pan.length - 1);
    }
    return null;
  }

  /// Retrieves the check digit from the PAN.
  ///
  /// The check digit is the last character in the PAN, which is used for
  /// validation purposes.
  ///
  /// ### Returns:
  /// - The check digit as an integer.
  /// - `null` if the PAN is `null` or empty, or if the last character
  ///   is not a valid digit.
  int? get checkDigit {
    final pan = merchantPan;
    if (pan != null && pan.isNotEmpty) {
      return int.tryParse(pan[pan.length - 1]);
    }
    return null;
  }

  /// Validates the check digit of the PAN using the Luhn (Mod 10) algorithm.
  ///
  /// The validation is performed by calculating the checksum of all digits
  /// in the PAN except the last one, and comparing it to the check digit.
  ///
  /// ### Parameters:
  /// - [useDeduction]: If `true`, uses the formula `10 - (mod % 10)` to
  ///   calculate the expected check digit. Otherwise, compares the plain
  ///   Mod 10 result with the provided check digit.
  ///
  /// ### Returns:
  /// - `true` if the PAN passes the check digit validation.
  /// - `false` otherwise.
  bool isValidCheckDigit({bool useDeduction = false}) {
    final pan = merchantPan;
    if (pan != null) {
      final checkSequence = pan.substring(0, pan.length - 1);
      final mod = checkSequence.getMod10();
      if (useDeduction) {
        final calculatedCheckDigit = (10 - mod) % 10;
        return calculatedCheckDigit == checkDigit;
      }
      return mod == checkDigit;
    }
    return false;
  }

  /// Validates the check digit with verbose logging for debugging purposes.
  ///
  /// This method performs the same validation as [isValidCheckDigit], but
  /// also prints detailed information about the process to the debug console.
  ///
  /// ### Parameters:
  /// - [useDeduction]: If `true`, uses the formula `10 - (mod % 10)` to
  ///   calculate the expected check digit. Otherwise, compares the plain
  ///   Mod 10 result with the provided check digit.
  ///
  /// ### Logs:
  /// - The entire PAN.
  /// - The sequence used for validation.
  /// - The check digit.
  /// - The result of the Mod 10 operation.
  /// - The calculated check digit (if deduction is used).
  /// - The validation result.
  ///
  /// ### Returns:
  /// - `true` if the PAN passes the check digit validation.
  /// - `false` otherwise.
  @visibleForTesting
  bool isValidCheckDigitVerbose({bool useDeduction = false}) {
    final pan = merchantPan;
    if (pan != null) {
      debugPrint('-----------------');
      debugPrint('mPAN: $pan');
      final checkSequence = pan.substring(0, pan.length - 1);
      debugPrint('Check Sequence: $checkSequence');
      debugPrint('Check Digit: $checkDigit');
      final mod = checkSequence.getMod10(verbose: true);
      if (useDeduction) {
        final calculatedCheckDigit = (10 - mod) % 10;
        debugPrint('Calculated Check Digit: $calculatedCheckDigit');
        final result = calculatedCheckDigit == checkDigit;
        debugPrint('Validation Result: $result');
        debugPrint('-----------------');
        return result;
      } else {
        debugPrint('Mod 10 Result: $mod');
        final result = mod == checkDigit;
        debugPrint('Validation Result: $result');
        debugPrint('-----------------');
        return result;
      }
    }
    return false;
  }
}
