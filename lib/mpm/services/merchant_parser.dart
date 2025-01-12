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

  /// List of base tag IDs (26, 27, 50, 51) used to extract merchant information.
  final List<String> _baseTagIds = ['26', '27', '50', '51'];

  Merchant(this._raw);

  /// Retrieves the Merchant PAN (Primary Account Number) from the QR code data.
  ///
  /// The Merchant PAN is typically found in sub-tag `01` within the QR data tags `26` to `45`.
  /// The function will first attempt to extract the PAN from tag `26`, and if it's not available,
  /// it will proceed to check tag `51`. These are the standard tags where the Merchant PAN is stored.
  ///
  /// ### Returns:
  /// - The Merchant PAN as a string if available, or an empty string (`''`) if not found.
  ///   The value is taken from QR data tag `26` to `45`, specifically sub-tag `01`.
  ///
  /// ### Example:
  /// ```dart
  /// String pan = QRISMPM(qrData).merchant.pan;
  /// print(pan); // "936008860000000042" or an empty string if not found
  /// ```
  String get pan {
    for (var tagId in _baseTagIds) {
      var mPAN = _raw['merchant_information_$tagId'];

      if (mPAN != null && mPAN['merchant_pan'] != null) {
        String merchantPan = mPAN['merchant_pan'];
        return merchantPan;
      }
    }

    // Return an empty string if merchant_pan is not found
    return '';
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
    if (pan.isNotEmpty) {
      return pan.calculateMod10() == 0;
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
    if (pan.isNotEmpty) {
      '----------------------------------------'.myLog();
      'Starting PAN validation for: $pan'.myLog();

      // Perform the validation with verbose logging
      final isValid = pan.calculateMod10(verbose: true) == 0;

      'PAN Validation Result: ${isValid ? 'Valid' : 'Invalid'}'.myLog();
      '----------------------------------------'.myLog();

      return isValid;
    }
    'PAN is null or empty.'.myLog();
    return false;
  }

  /// Retrieves the Merchant Sequence from the PAN (Primary Account Number).
  ///
  /// The Merchant Sequence is extracted from the 9th character (index 8) to the second-to-last character
  /// of the PAN. If the PAN is too short (less than 9 characters) or empty, it returns `null`.
  ///
  /// ### Returns:
  /// - The Merchant Sequence as a string, or `null` if the PAN is too short or empty.
  ///
  /// ### Example:
  /// ```dart
  /// String? sequence = QRISMPM(qrData).merchant.merchantSequence;
  /// print(sequence); // "860000000042" or null
  /// ```
  String? get merchantSequence {
    if (pan.isNotEmpty && pan.length > 9) {
      return pan.substring(8, pan.length - 1);
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
    if (pan.isNotEmpty) {
      return int.tryParse(pan[pan.length - 1]);
    }
    return null;
  }

  /// Retrieves the Merchant ID (MID) from the QR code data.
  ///
  /// The Merchant ID (MID) is located in sub-tag `02` within the merchant information tags. The tags
  /// to be checked are `26`, `27`, `50`, and `51`. The MID is retrieved from the tag where it is found.
  ///
  /// The MID will be returned as a string:
  /// - If the MID is found and is less than 15 characters, it will be right-padded with spaces to ensure
  ///   it is exactly 15 characters long.
  /// - If the MID is 15 characters or longer, it will be returned as-is (without truncation).
  /// - If the MID is not found in any of the tags, an empty string is returned.
  ///
  /// ### Returns:
  /// - A string containing the Merchant ID (MID), with any leading or trailing spaces removed.
  ///   If the MID is not found, an empty string is returned.
  ///
  /// ### Example:
  /// ```dart
  /// String mid = QRISMPM(qrData).merchant.merchantId;
  /// print(mid); // "133211213"
  /// ```
  String get merchantId {
    for (var tagId in _baseTagIds) {
      var merchantData = _raw['merchant_information_$tagId'];
      if (merchantData != null && merchantData['merchant_id'] != null) {
        String merchantId = merchantData['merchant_id'];
        return merchantId;
      }
    }

    return '';
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
  ///
  /// - B 'RAW' value of the 9th character of the PAN.
  ///   - `0` for `unspecified`.
  ///   - `1` for `debit`.
  ///   - `2` for `credit`.
  ///   - `3` for `electronicMoney`.
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

  /// Retrieves the National Merchant ID from tag `51`, sub tag `02`.
  ///
  /// The National Merchant ID is typically found in tag `51`. If it's not available, `''` or String empty is returned.
  ///
  /// ### Returns:
  /// - Example: `ID1019000999007`
  /// - The National Merchant ID as a string, or `null` if not found.
  String get nationalMerchantId {
    final merchantInfo51 = _raw['merchant_information_51'];
    final nMID = merchantInfo51?['merchant_id'];

    if (nMID != null && nMID.isNotEmpty) {
      return nMID;
    }

    return '';
  }

  /// Extracts the Issuer's National Numbering System (NNS) from the Primary Account Number (PAN).
  ///
  /// The NNS is represented by the first 8 characters of the PAN. It is commonly used to identify the financial institution or issuer of the PAN.
  ///
  /// ### Parameters:
  /// - `pan`: A string representing the Primary Account Number (PAN).
  ///
  /// ### Returns:
  /// - A string containing the Issuer's NNS if the PAN is not null and has at least 8 characters.
  /// - Returns `null` if the PAN is null or shorter than 8 characters.
  String get issuerNns {
    if (pan.isNotEmpty && pan.length >= 8) {
      return pan.substring(0, 8);
    }
    return '';
  }

  /// Retrieves the Merchant Criteria (MC) from the QR code data.
  ///
  /// The Merchant Criteria is used to identify the type of transaction or payment method. There are two main
  /// cases for retrieving the merchant criteria:
  /// - For **Payment Credit with Inquiry MPAN**, the value is taken from the inquiry MPAN response.
  /// - For **Payment Credit without Inquiry MPAN**, the value is taken from the QR data tag `26` to `45`, specifically sub-tag `03`.
  ///
  /// The function will check the `merchant_criteria` field in the following tags:
  /// - Tag `26`
  /// - Tag `27`
  /// - Tag `50`
  /// - Tag `51`
  ///
  /// If the `merchant_criteria` is found, it will be converted to a `MerchantCriteria` enum value. If no valid
  /// `merchant_criteria` is found, it will default to `MerchantCriteria.regular`.
  ///
  /// ### Returns:
  /// - A `MerchantCriteria` enum value based on the retrieved criteria. If no criteria is found, it returns
  ///   `MerchantCriteria.regular` as the default.
  ///
  /// ### Example:
  /// ```dart
  /// MerchantCriteria criteria = QRISMPM(qrData).merchant.merchantCriteria;
  /// print(criteria); // MerchantCriteria.regular or another value depending on the QR data
  /// ```
  MerchantCriteria get merchantCriteria {
    for (var tagId in _baseTagIds) {
      var merchantData = _raw['merchant_information_$tagId'];
      if (merchantData != null && merchantData['merchant_criteria'] != null) {
        String criteria = merchantData['merchant_criteria'];
        return criteria.toMerchantCriteria;
      }
    }

    return MerchantCriteria.regular;
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
  Map<String, dynamic> _toMap() {
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
      'merchant_criteria': merchantCriteria.originalName,
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
    final json = _toMap();
    json['pan_merchant_method'] = panMerchantMethod.name.toUpperCase();

    return json.toPrettyString();
  }

  @visibleForTesting
  void logDebugMerchant() {
    return toString().myLog();
  }
}
