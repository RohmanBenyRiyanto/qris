import 'dart:convert' show utf8;

import 'package:crclib/catalog.dart' show Crc16Ibm3740;
import 'package:flutter/foundation.dart';
import 'package:flutter_qris/qris.dart';

part '../qris_core/services/crc_parser.dart';
part 'services/mpm_tag_parser.dart';
part 'utils/qris_mpm_extension.dart';

/// A class representing a QRIS Merchant Presented Mode (MPM) QR code data with functionalities
/// for decoding and encoding QRIS data. This class decodes the QRIS data string into TLV format
/// and provides access to various QRIS tags, merchant information, and transaction details.
///
/// Parameters:
/// - `qrData`: The raw QRIS data string that represents the QR code data.
/// - `validateMandatoryTAGs`: Whether to validate mandatory tags in the QRIS data.
class QRISMPM with TLVService, MPMTagParser, CRCParser {
  /// The raw QRIS data string that represents the QR code data.
  ///
  /// This raw data will be decoded into a TLV structure for further analysis.
  @override
  final String qrData;

  /// Whether to validate mandatory tags in the QRIS data.
  final bool validateMandatoryTAGs;

  /// Constructs a [QRISMPM] instance by initializing the QRIS data and decoding it into TLV format.
  ///
  /// Throws a [TLVException] if the QRIS data is null or empty.
  QRISMPM(
    this.qrData, {
    this.validateMandatoryTAGs = false,
  }) {
    _initialDecodeTLVData();
  }

  /// List of TLV objects that represent the decoded QRIS data.
  ///
  /// This list contains the key-value pairs (tags and values) from the QRIS data.
  late final List<TLV> tlv;

  /// The payload format indicator from Tag "00".
  ///
  /// Represents the version of the QRIS data format. If not found, defaults to "01".
  String get payloadFormatIndicator =>
      tlv.getValueByTag(QrisMpmTags.payloadFormatIndicator.id) ?? '01';

  /// The point of initiation method from Tag "01".
  ///
  /// Returns a [PointOfInitiationMethod] based on the raw value of Tag "01".
  /// Defaults to [PointOfInitiationMethod.u] for unrecognized values.
  PointOfInitiationMethod get pointOfInitiationMethod => tlv
      .getValueByTag(QrisMpmTags.pointOfInitiationMethod.id)
      .toPointOfInitiationMethodFromRAW();

  /// The merchant's principal VISA information from Tag "02".
  ///
  /// Represents the VISA network's merchant ID, or an empty string if not available.
  String get merchantPrincipalVisa =>
      tlv.getValueByTag(QrisMpmTags.merchantPrincipalVisa.id) ?? '';

  /// The merchant's principal Mastercard information from Tag "03".
  ///
  /// Represents the Mastercard network's merchant ID, or an empty string if not available.
  String get merchantPrincipalMastercard =>
      tlv.getValueByTag(QrisMpmTags.merchantPrincipalMastercard.id) ?? '';

  /// The currency used in the transaction, extracted from Tag "53".
  ///
  /// Returns an [ISO4217Currency] object based on the currency code from Tag "53".
  /// Defaults to the currency code '360' (Indonesian Rupiah).
  ISO4217Currency get currency =>
      ISO4217Currency.fromNumCodetoObject(tlv.getValueByTag('53') ?? '360');

  /// The transaction details including any tips.
  ///
  /// Returns an instance of [Transaction], parsed from the QRIS data.
  Transaction get transaction => Transaction(tlvtoMap(tlv));

  /// The merchant information parsed from the QRIS data.
  ///
  /// Extracts the merchant information from the QRIS data based on the available tags:
  /// - Single Merchant: Information extracted from either Tag 26 or Tag 51.
  /// - Double Merchant: Information extracted from both Tag 26 and Tag 51 for multiple merchants.
  /// This is an instance of [Merchant], which contains the relevant merchant details.
  Merchant get merchant => Merchant(tlvtoMap(tlv));

  /// Additional data parsed from the QRIS data.
  ///
  /// Extracts the additional data from the QRIS data based on the available tags 62.
  /// This is an instance of [AdditionalData], which contains the relevant additional data.
  AdditionalData get additionalData => AdditionalData(tlv);

  /// Converts the TLV data into a map representation.
  ///
  /// This function takes the list of TLV objects and converts it into a map where each key is a tag ID,
  /// and each value is the corresponding tag's data.
  ///
  /// Returns:
  /// A `Map<String, dynamic>` representing the decoded QRIS data in a key-value format.
  Map<String, dynamic> tlvtoMap(tlv) => _rawTLVtoRawQrisTaggMap(tlv);

  /// Converts a map representation of QRIS data into a list of TLV objects.
  ///
  /// This function reverses the mapping process, converting the map back into a list of TLV objects.
  ///
  /// Returns:
  /// A list of [TLV] objects, each containing a tag and its corresponding value from the map.
  List<TLV> mapToListTLV(Map<String, dynamic> map) => _mapToListTLV(map);

  /// Decodes the QRIS data into a list of TLV objects.
  ///
  /// This function is called during initialization to parse the raw QRIS data into a list of TLV objects.
  /// It throws a [TLVException] if the QRIS data is null or empty, indicating that the QRIS data is invalid.
  void _initialDecodeTLVData() {
    if (qrData.isEmpty || qrData == 'null') {
      tlv = [];
      throw TLVException('QRIS data is null or empty');
    }

    try {
      //! Check if the QRIS data is valid
      if (!_isValidQRIS(qrData, validateMandatoryTAGs)) {
        tlv = [];
        throw TLVException('QRIS data is invalid');
      }

      tlv = tlvDecode(qrData);
    } on TLVException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// Validates the QRIS data format
  ///
  /// References: https://www.greyamp.com/blogs/decoding-aspi-standards-the-technical-backbone-of-qris-in-indonesia
  bool _isValidQRIS(String qrData, bool validateMandatoryTAGs) {
    if (qrData.isEmpty || qrData.length < 10) {
      return false; // QRIS data is too short or empty
    }

    // 1. Check that the QRIS string starts with the correct prefix and contains "CO.QRIS.WWW"
    if (!qrData.startsWith("000201") || !qrData.contains("CO.QRIS.WWW")) {
      return false;
    }

    if (validateMandatoryTAGs) {
      try {
        // 2. Decode the TLV data (this will throw an exception if the format is invalid)
        List<TLV> tlv = tlvDecode(qrData);

        // 3. Define a map for mandatory tags and their maximum lengths
        final Map<String, int> mandatoryTags = {
          "00": 2, // Tag 00: Max length 2
          "51": 99, // Tag 51: Max length 99
          "52": 4, // Tag 52: Max length 4
          "53": 3, // Tag 53: Max length 3
          "58": 2, // Tag 58: Max length 2
          "59": 25, // Tag 59: Max length 25
          "60": 15, // Tag 60: Max length 15
          "63": 4, // Tag 63: Max length 4
        };

        // 4. Check each mandatory tag for its presence and length constraints
        for (var entry in mandatoryTags.entries) {
          String? value = tlv.getValueByTag(entry.key);
          if (value == null || value.length > entry.value) {
            return false;
          }
        }

        return true;
      } catch (e) {
        return false;
      }
    }

    return true;
  }
}
