import 'dart:convert' show utf8;

import 'package:crclib/catalog.dart' show Crc16Ibm3740;
import 'package:flutter/foundation.dart';
import 'package:flutter_qris/mpm/models/qris_mpm_tags.dart';
import 'package:flutter_qris/mpm/services/additional_data_parser.dart';
import 'package:flutter_qris/mpm/services/merchant_parser.dart';
import 'package:flutter_qris/mpm/services/mpm_transaction_parser.dart';
import 'package:flutter_qris/qris.dart';
import 'package:flutter_qris/qris_core/models/iso4217_currency.dart';
import 'package:flutter_qris/qris_core/models/qris_tag.dart';
import 'package:flutter_qris/qris_core/models/tlv.dart';
import 'package:flutter_qris/qris_core/services/tlv_service.dart';
import 'package:flutter_qris/qris_core/utils/type/point_of_initiation_method.dart';

part '../qris_core/services/crc_parser.dart';
part 'services/mpm_tag_parser.dart';
part 'utils/qris_mpm_extension.dart';

/// A class representing a QRIS Merchant Presented Mode (MPM) QR code data with functionalities
/// for decoding and encoding QRIS data. This class decodes the QRIS data string into TLV format
/// and provides access to various QRIS tags, merchant information, and transaction details.
class QRISMPM with TLVService, MPMTagParser, CRCParser {
  /// The raw QRIS data string that represents the QR code data.
  ///
  /// This raw data will be decoded into a TLV structure for further analysis.
  @override
  final String qrData;

  /// Constructs a [QRISMPM] instance by initializing the QRIS data and decoding it into TLV format.
  ///
  /// Throws a [TLVException] if the QRIS data is null or empty.
  QRISMPM(this.qrData) {
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
  /// Returns an instance of [MpmTip], parsed from the QRIS data.
  MpmTip get tip => MpmTip(tlvtoMap(tlv));

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
      if (!_isValidQRIS(qrData)) {
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

  bool _isValidQRIS(String qrData) {
    if (qrData.isEmpty || qrData.length < 10) {
      return false; // QRIS data is too short or empty
    }

    // 1. Check that the QRIS string starts with the correct prefix and contains "CO.QRIS.WWW"
    if (!qrData.startsWith("000201") || !qrData.contains("CO.QRIS.WWW")) {
      return false; // Invalid QRIS prefix
    }

    try {
      // 2. Try to decode the TLV data (this will throw an exception if the format is invalid)
      List<TLV> tlv = tlvDecode(qrData);

      // 3. Check for mandatory tags and their length constraints
      String? tag00 = tlv.getValueByTag("00"); // Tag 00
      if (tag00 == null || tag00.length > 2) {
        return false; // Tag 00 is either missing or too long
      }

      String? tag51 = tlv.getValueByTag("51"); // Tag 51
      if (tag51 == null || tag51.length > 99) {
        return false; // Tag 51 is either missing or too long
      }

      String? tag52 = tlv.getValueByTag("52"); // Tag 52
      if (tag52 == null || tag52.length > 4) {
        return false; // Tag 52 is either missing or too long
      }

      String? tag53 = tlv.getValueByTag("53"); // Tag 53
      if (tag53 == null || tag53.length > 3) {
        return false; // Tag 53 is either missing or too long
      }

      String? tag58 = tlv.getValueByTag("58"); // Tag 58
      if (tag58 == null || tag58.length > 2) {
        return false; // Tag 58 is either missing or too long
      }

      String? tag59 = tlv.getValueByTag("59"); // Tag 59
      if (tag59 == null || tag59.length > 25) {
        return false; // Tag 59 is either missing or too long
      }

      String? tag60 = tlv.getValueByTag("60"); // Tag 60
      if (tag60 == null || tag60.length > 15) {
        return false; // Tag 60 is either missing or does not have a length of 15
      }

      //!  SKIP TAG 63 as CRC
      // String? tag63 = tlv.getValueByTag("63"); // Tag 63
      // if (tag63 == null || tag63.length > 4) {
      //   return false; // Tag 63 is either missing or too long
      // }

      return true;
    } catch (e) {
      return false;
    }
  }
}
