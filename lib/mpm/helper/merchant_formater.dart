import 'pan_merchant_method.dart';

/// A class representing detailed information extracted from a Merchant QR Code.
class MerchantQRDataDetail {
  /// The raw data extracted from the QR code.
  final Map<String, dynamic> data;

  /// Constructor for [MerchantQRDataDetail].
  MerchantQRDataDetail(this.data);

  /// Retrieves the Merchant PAN (Primary Account Number).
  ///
  /// ### Returns:
  /// - The PAN from tag `26` or `51` if available.
  String? get merchantPan {
    return data['merchant_information_26']?['merchant_pan'] ??
        data['merchant_information_51']?['merchant_pan'];
  }

  /// Retrieves the Merchant ID.
  ///
  /// ### Returns:
  /// - The ID from tag `51` or falls back to tag `26` if available.
  String? get merchantId {
    return data['merchant_information_51']?['merchant_id'] ??
        data['merchant_information_26']?['merchant_id'];
  }

  /// Determines the PAN Merchant Method based on the 9th character of the PAN.
  ///
  /// ### Returns:
  /// - A [PANMerchantMethod] based on the 9th digit of the PAN.
  PANMerchantMethod get panMerchantMethod {
    final panCode = merchantPan;
    if (panCode != null && panCode.length >= 9) {
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

  /// Retrieves the National Merchant ID.
  ///
  /// ### Returns:
  /// - The ID from tag `51` if available.
  String? get nationalMerchantId =>
      data['merchant_information_51']?['merchant_id'];

  /// Extracts the Issuer National Numbering System (NNS).
  ///
  /// ### Returns:
  /// - The first 8 characters of the PAN, if available.
  String? get issuerNns {
    final panCode = merchantPan;
    return panCode != null && panCode.length >= 8
        ? panCode.substring(0, 8)
        : null;
  }

  /// Retrieves the Merchant Criteria from the QR code.
  ///
  /// ### Returns:
  /// - The criteria from tag `26` or `51` if available.
  String? get merchantCriteria {
    return data['merchant_information_26']?['merchant_criteria'] ??
        data['merchant_information_51']?['merchant_criteria'];
  }

  /// Retrieves the Merchant Name.
  String get name => data['merchant_name'] ?? '';

  /// Retrieves the Merchant City.
  String get city => data['merchant_city'] ?? '';

  /// Retrieves the Merchant Country Code.
  String get countryCode => data['country_code'] ?? '';

  /// Retrieves the Merchant Postal Code.
  String get postalCode => data['merchant_postal_code'] ?? '';

  /// Retrieves the Merchant's Location as a Map.
  ///
  /// ### Returns:
  /// - A map containing `city`, `country_code`, and `postal_code`.
  Map<String, dynamic> get location => {
        'city': city,
        'country_code': countryCode,
        'postal_code': postalCode,
      };

  /// Retrieves the National Institution Code from the Issuer NNS.
  ///
  /// ### Returns:
  /// - The 5th to 8th digits of the NNS, or a default of `'0000'` if unavailable.
  String? get institutionCode {
    final nns = issuerNns;
    return nns != null && nns.length >= 8 ? nns.substring(4, 8) : '0000';
  }

  /// Extracts and formats the Acquirer Name by removing common prefixes and non-alphanumeric characters.
  String get acquirerName {
    String rawName = data['merchant_information_26']
            ?['global_unique_identifier'] ??
        data['merchant_information_51']?['global_unique_identifier'] ??
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

  /// Generates a comprehensive map of all Merchant QR details.
  Map<String, dynamic> get result => {
        'name': name,
        'merchant_pan': merchantPan,
        'merchant_id': merchantId,
        'pan_merchant_method': panMerchantMethod.toString(),
        'national_merchant_id': nationalMerchantId,
        'institution_code': institutionCode,
        'issuer_nns': issuerNns,
        'acquirer_name': acquirerName,
        'merchant_criteria': merchantCriteria,
        'location': location,
      };

  /// Formats specific Merchant Information tags (26, 27, 50, 51).
  ///
  /// ### Returns:
  /// - A map with formatted merchant information grouped by tags.
  Map<String, dynamic> formatMerchantInformation() {
    final merchantInformation = <String, dynamic>{};

    for (final tag in ['26', '27', '50', '51']) {
      if (data.containsKey('merchant_information_$tag') &&
          data['merchant_information_$tag'] != null) {
        merchantInformation[tag] = data['merchant_information_$tag'];
      }
    }

    return merchantInformation;
  }
}
