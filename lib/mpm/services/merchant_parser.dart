import 'package:flutter/foundation.dart';
import 'package:flutter_qris/qris.dart';

/// A class representing detailed information extracted from a Merchant QR Code.
///
/// This class provides various details encoded within a Merchant QR Code, including the
/// Merchant PAN (Primary Account Number), Merchant ID, Merchant Name, Merchant Location,
/// and other merchant-specific _raw information stored in the QR code's tags. Additionally,
/// it provides utility methods for parsing and validating this information.
///
/// ### Key Fields:
/// - `_raw`: A map containing the _raw data extracted from the QR code. Each tag within
///   the map corresponds to a specific merchant detail, such as the Merchant PAN, ID, Name, etc.
///
/// Example usage:
/// ```dart
/// final qrData = Merchant(someQrDataMap);
/// String? pan = qrData.pan;
/// String merchantName = qrData.name;
/// ```
class Merchant {
  final Map<String, dynamic> _raw;

  Merchant(this._raw);

  /// Retrieves the Merchant PAN (Primary Account Number) from the QR code data.
  ///
  /// The PAN is first attempted to be extracted from tag `26`, and if it's not available,
  /// it will check tag `51`. These are the standard tags where the Merchant PAN is typically stored.
  ///
  /// ### Returns:
  /// - The Merchant PAN as a string if available, or `null` if not found.
  String get pan {
    return _raw['merchant_information_26']?['merchant_pan'] ??
        _raw['merchant_information_51']?['merchant_pan'] ??
        '';
  }

  /// Validates the Merchant PAN using the Luhn Algorithm.
  ///
  /// The Luhn algorithm is used to validate the integrity of the PAN. This method checks if the PAN
  /// passes the checksum validation.
  ///
  /// ### Returns:
  /// - `true` if the PAN is valid according to the Luhn algorithm.
  /// - `false` if the PAN is invalid or null.
  bool isPanValid() {
    final panCode = pan;
    if (panCode.isNotEmpty) {
      return panCode.calculateMod10() == 0;
    }
    return false;
  }

  /// Validates the Merchant PAN using the Luhn Algorithm with verbose logging.
  ///
  /// This method logs each step of the Luhn calculation, which can be helpful for debugging.
  ///
  /// ### Returns:
  /// - `true` if the PAN is valid according to the Luhn algorithm.
  /// - `false` if the PAN is invalid or null.
  bool isPanValidVerbose() {
    final panCode = pan;
    if (panCode.isNotEmpty) {
      '----------------------------------------'.myLog();
      'Starting PAN validation for: $panCode'.myLog();

      // Perform the validation with verbose logging
      final isValid = panCode.calculateMod10(verbose: true) == 0;

      'PAN Validation Result: ${isValid ? 'Valid' : 'Invalid'}'.myLog();
      '----------------------------------------'.myLog();

      return isValid;
    }
    'PAN is null or empty.'.myLog();
    return false;
  }

  /// Retrieves the Merchant Sequence from the PAN.
  ///
  /// The Merchant Sequence is derived by extracting characters starting from the 9th character
  /// (index 8) up to the second-to-last character of the PAN.
  ///
  /// ### Returns:
  /// - The Merchant Sequence as a string, or `null` if the PAN is too short to extract.
  String? get merchantSequence {
    final panCode = pan;
    if (panCode.isNotEmpty && panCode.length > 9) {
      return panCode.substring(8, panCode.length - 1);
    }
    return null;
  }

  /// Retrieves the check digit from the PAN.
  ///
  /// The check digit is the last digit of the PAN, which is used for validation purposes.
  ///
  /// ### Returns:
  /// - The check digit as an integer, or `null` if the PAN is empty or null.
  int? get checkDigit {
    final panCode = pan;
    if (panCode.isNotEmpty) {
      return int.tryParse(panCode[panCode.length - 1]);
    }
    return null;
  }

  /// Retrieves the Merchant ID from the QR code data.
  ///
  /// The Merchant ID is typically found in tags `26` or `51`. This method first checks tag `51`,
  /// and if not found, falls back to tag `26`.
  ///
  /// ### Returns:
  /// - The Merchant ID as a string if found, or `null` if not available.
  String get merchantId {
    return _raw['merchant_information_51']?['merchant_id'] ??
        _raw['merchant_information_26']?['merchant_id'] ??
        '';
  }

  /// Determines the Merchant Payment Method based on the 9th character of the PAN.
  ///
  /// The 9th character (index 8) of the PAN is used to determine the Merchant's payment method,
  /// which could represent Debit, Credit, Electronic Money, or a reserved method for future use.
  ///
  /// ### Returns:
  /// - A `PANMerchantMethod` representing the payment method. Possible values include:
  ///   - [PANMerchantMethod.unspecified]
  ///   - [PANMerchantMethod.debit]
  ///   - [PANMerchantMethod.credit]
  ///   - [PANMerchantMethod.electronicMoney]
  ///   - [PANMerchantMethod.rfu] (reserved for future use)
  PANMerchantMethod get panMerchantMethod {
    final panCode = pan;
    if (panCode.isNotEmpty && panCode.length >= 9) {
      final code = int.tryParse(panCode[8]);
      switch (code) {
        case 0:
          return PANMerchantMethod.unspecified;
        case 1:
          return PANMerchantMethod.debit;
        case 2:
          return PANMerchantMethod.credit;
        case 3:
          return PANMerchantMethod.electronicMoney;
        default:
          return (code != null && code >= 4 && code <= 9)
              ? PANMerchantMethod.rfu
              : PANMerchantMethod.unspecified;
      }
    }
    return PANMerchantMethod.unspecified;
  }

  /// Retrieves the National Merchant ID from tag `51`.
  ///
  /// The National Merchant ID is typically found in tag `51`. If it's not available, `null` is returned.
  ///
  /// ### Returns:
  /// - The National Merchant ID as a string, or `null` if not found.
  String get nationalMerchantId =>
      _raw['merchant_information_51']?['merchant_id'] ?? '';

  /// Extracts the Issuer's National Numbering System (NNS) from the PAN.
  ///
  /// The NNS is represented by the first 8 characters of the PAN, typically used to identify the issuer.
  ///
  /// ### Returns:
  /// - The Issuer's NNS as a string, or `null` if the PAN is too short to extract.
  String get issuerNns {
    final panCode = pan;
    if (panCode.isNotEmpty) {
      return panCode.length >= 8 ? panCode.substring(0, 8) : "";
    } else {
      return "";
    }
  }

  /// Retrieves the Merchant Criteria from the QR code data.
  ///
  /// The Merchant Criteria is usually found in tags `26` or `51`. This method checks tag `26` first,
  /// and if not available, falls back to tag `51`.
  ///
  /// ### Returns:
  /// - The Merchant Criteria as a string, or `null` if not found.
  MerchantCriteria get merchantCriteria {
    return (_raw['merchant_information_26']?['merchant_criteria'] ??
            _raw['merchant_information_51']?['merchant_criteria'])
        .toString()
        .toMerchantCriteria;
  }

  /// Retrieves the Merchant's Name from the QR code data.
  ///
  /// The Merchant Name is extracted directly from the QR code _raw data. If not available,
  /// an empty string is returned.
  ///
  /// ### Returns:
  /// - The Merchant Name as a string, or an empty string if not available.
  String get name => _raw['merchant_name'] ?? '';

  /// Retrieves the Merchant's Location as a Map containing city, country code, and postal code.
  ///
  /// The Merchant Location is derived from the _raw data, and the returned map contains:
  /// - `city`: The city where the merchant is located.
  /// - `country_code`: The country code.
  /// - `postal_code`: The postal code.
  ///
  /// ### Returns:
  /// - A [MerchantLocation] object containing the city, country code, and postal code.
  MerchantLocation get location => MerchantLocation(
        city: _raw['merchant_city'] ?? '',
        countryCode: _raw['country_code'] ?? '',
        postalCode: _raw['merchant_postal_code'] ?? '',
      );

  /// Retrieves the National Institution Code derived from the Issuer's NNS.
  ///
  /// The National Institution Code is represented by the 5th to 8th digits of the NNS. If the NNS
  /// is unavailable, a default value of `'0000'` is returned.
  ///
  /// ### Returns:
  /// - The institution code as a string, or `'0000'` if the NNS is not available.
  String? get institutionCode {
    final nns = issuerNns;
    return (nns.isNotEmpty && nns.length >= 8) ? nns.substring(4, 8) : '0000';
  }

  /// Extracts and formats the Acquirer Name by removing common prefixes and non-alphanumeric characters.
  ///
  /// This method formats the Acquirer Name by removing common prefixes (e.g., `ID.`, `BANK.`)
  /// and non-alphanumeric characters, making the name cleaner and more readable.
  ///
  /// ### Returns:
  /// - The formatted Acquirer Name as a string.
  String get acquirerName {
    String rawName = _raw['merchant_information_26']
            ?['global_unique_identifier'] ??
        _raw['merchant_information_51']?['global_unique_identifier'] ??
        '';

    final prefixesToRemove = [
      'ID.',
      'COM.',
      'CO.',
      'QRIS.',
      'ORG.',
      'BANK.',
      'MERCHANT.',
      'GOV.',
      'IND.',
      'IN.',
      'COMMERCE.',
      'PT.',
      'MY.',
      'SG.',
      'KR.',
      'CN.',
      'JP.',
      'TH.'
    ];

    for (final prefix in prefixesToRemove) {
      rawName = rawName.replaceAll(prefix, '');
    }

    rawName = rawName
        .replaceAll(RegExp(r'\.[wW][wW][wW]$'), '') // Remove '.WWW'
        .replaceAll('BANK', 'BANK ') // Add space after 'BANK'
        .replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '') // Remove non-alphanumeric
        .trim(); // Trim spaces

    return rawName;
  }

  /// Formats and retrieves specific Merchant Information tags (26, 27, 50, 51).
  ///
  /// This method retrieves and formats the merchant information from specific tags (`26`, `27`, `50`, `51`).
  /// It returns a map containing only the relevant merchant information from these tags.
  ///
  /// ### Returns:
  /// - A map containing the merchant information, grouped by the corresponding tag.
  Map<int, MerchantInformation> get informations =>
      _formatMerchantInformationToObjects();

  Map<int, MerchantInformation> _formatMerchantInformationToObjects() {
    final Map<int, MerchantInformation> merchantInformationMap = {};

    final tags = ['26', '27', '50', '51'];

    for (final tag in tags) {
      final key = 'merchant_information_$tag';
      if (_raw.containsKey(key) && _raw[key] != null) {
        final merchantInfo = MerchantInformation.fromJson(_raw[key]);
        merchantInformationMap[int.parse(tag)] = merchantInfo;
      }
    }

    return merchantInformationMap;
  }

  /// Converts the Merchant instance into a map with snake_case keys.
  ///
  /// The map contains all the relevant merchant data extracted from the _raw QR code data.
  /// The keys in the map are formatted in snake_case style.
  ///
  /// ### Returns:
  /// - A Map with snake_case keys and corresponding values.
  Map<String, dynamic> toMap() {
    return {
      'merchant_pan': pan,
      'merchant_pan_valid': isPanValid(),
      'merchant_pan_valid_verbose': isPanValidVerbose(),
      'merchant_sequence': merchantSequence,
      'merchant_check_digit': checkDigit,
      'merchant_id': merchantId,
      'pan_merchant_method': panMerchantMethod.paymentMethodCode,
      'national_merchant_id': nationalMerchantId,
      'issuer_nns': issuerNns,
      'merchant_criteria': merchantCriteria.toString(),
      'merchant_name': name,
      'merchant_location': location.toMap(),
      'institution_code': institutionCode,
      'acquirer_name': acquirerName,
      'merchant_information': informations.isNotEmpty
          ? informations
              .map((key, value) => MapEntry(key.toString(), value.toJson()))
          : {},
    };
  }

  @override
  String toString() {
    final json = toMap();
    json['pan_merchant_method'] = panMerchantMethod.name;
    json['merchant_criteria'] = merchantCriteria.name;
    json['location'] = json['location'].toPrettyString();

    return json.toPrettyString();
  }

  @visibleForTesting
  void logDebugMerchant() {
    return toMap().toPrettyString().myLog();
  }
}
