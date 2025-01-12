import 'package:flutter_qris/qris.dart';

/// A singleton helper class to work with MCC (Merchant Category Code) data.
///
/// This class provides methods to retrieve MCC data by MCC code and to convert the
/// retrieved data into a strongly-typed `MCC` object. The data is statically
/// stored in a list `_mccData`, which represents the MCC data extracted from
/// [MCC Code GitHub Repository](https://github.com/greggles/mcc-codes).
///
/// Usage:
/// ```dart
/// final mccHelper = MCCParser();
/// Map<String, dynamic> mccInfo = mccHelper._getMCCByCode("0742");
/// MCC mccDataObject = mccHelper.mccCodeToObject("0742");
/// ```
///
/// The MCC data format includes fields like `mcc`, `edited_description`, `combined_description`,
/// and others, as defined in the MCC data source.
///
/// For more information on MCC codes and their descriptions, visit the repository:
/// [MCC Codes GitHub Repository](https://github.com/greggles/mcc-codes)
///
/// Example JSON format from the repository:
/// ```json
/// {
///   "mcc": "0742",
///   "edited_description": "Veterinary Services",
///   "combined_description": "Veterinary Services",
///   "usda_description": "Veterinary Services",
///   "irs_description": "Veterinary Services",
///   "irs_reportable": "Yes",
///   "id": 0
/// }
/// ```
extension MCCParser on QRISMPM {
  /// Retrieves the MCC data by the provided MCC code.
  ///
  /// This method returns a `MCC` object representing the MCC data for the given `mccCode`.
  MCC get mcc => MCC.fromJson(_getMCCByCode(tlv.getValueByTag('52')));

  /// Retrieves MCC data by the provided MCC code.
  ///
  /// This method returns a map containing MCC data for the given `mccCode`.
  /// If the MCC code is not found, an empty map is returned.
  ///
  /// Example:
  /// ```dart
  /// Map<String, dynamic> mccInfo = MCCParser()._getMCCByCode("0742");
  /// ```
  ///
  /// Arguments:
  /// - `mccCode`: The MCC code as a `String` (e.g., `"0742"`).
  ///
  /// Returns:
  /// - `Map<String, dynamic>`: The MCC data corresponding to the given `mccCode`, or an empty map if not found.
  static Map<String, dynamic> _getMCCByCode([String? mccCode]) {
    return MccDataBase.dataList.firstWhere(
      (item) => item['mcc'] == mccCode,
      orElse: () => {},
    );
  }
}
