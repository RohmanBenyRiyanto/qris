import 'dart:convert' show utf8;
import 'package:crclib/catalog.dart' show Crc16Ibm3740;

/// Helper class for CRC (Cyclic Redundancy Check) operations.
/// This class provides methods to calculate and validate CRC values for a given QR code data.
///
/// Example of `qrData`:
/// ```
/// 00020101021126590013ID.CO.BNI.WWW011893600009150305256502096102070790303UBE51440014ID.CO.QRIS.WWW0215ID20222337822690303UBE5204472253033605802ID5912VFS GLOBAL 66015JAKARTA SELATAN61051294062070703A016304D7C5
/// ```
class CRCHelper {
  /// The polynomial used for CRC calculation (hexadecimal 0x1021).
  static const int polynomial = 0x1021;

  /// The initial value for the CRC calculation (hexadecimal 0xFFFF).
  static const int initialValue = 0xFFFF;

  /// Calculates the CRC value for the given QR code data using the Crc16Ibm3740 algorithm.
  ///
  /// The CRC is computed only for the portion of the data matching the regular expression pattern
  /// `^.+63\d{2}`. If no match is found, an empty string is returned.
  ///
  /// [qrData] is the input QR code data string that includes the information to validate.
  ///
  /// Returns:
  /// - A string representing the calculated CRC in uppercase hexadecimal format.
  static String calculateCRC(String qrData) {
    final match = RegExp(r'^.+63\d{2}').firstMatch(qrData)?.group(0);
    if (match != null) {
      final crc = Crc16Ibm3740().convert(utf8.encode(match));
      return crc.toRadixString(16).toUpperCase();
    }
    return '';
  }

  /// Validates whether the CRC value in the QR code data matches the calculated CRC value.
  ///
  /// The QR code data is expected to end with a CRC value in the format `(63\d{2})([0-9A-Fa-f]{4})$`.
  /// This method extracts the embedded CRC value and compares it with the calculated CRC.
  ///
  /// [qrData] is the input QR code data string that includes the CRC to validate.
  ///
  /// Returns:
  /// - `true` if the CRC values match.
  /// - `false` otherwise.
  static  bool isValidCRC(String qrData) {
    final match = RegExp(r'(63\d{2})([0-9A-Fa-f]{4})$').firstMatch(qrData);
    final calculatedCRC = calculateCRC(qrData).toUpperCase();
    return match != null && match.group(2)?.toUpperCase() == calculatedCRC;
  }

  /// Asynchronously validates the CRC value in the QR code data.
  ///
  /// This method performs the same functionality as [isValidCRC] but operates asynchronously
  /// to allow non-blocking operations.
  ///
  /// [qrData] is the input QR code data string that includes the CRC to validate.
  ///
  /// Returns:
  /// - A `Future<bool>` indicating whether the CRC values match.
  static  Future<bool> isValidCRCAsync(String qrData) async {
    final calculatedCRC = await _calculateCRCAsyncHelper(qrData);
    final match = RegExp(r'(63\d{2})([0-9A-Fa-f]{4})$').firstMatch(qrData);
    return match != null && match.group(2)?.toUpperCase() == calculatedCRC;
  }

  /// A helper method to calculate the CRC asynchronously.
  ///
  /// This method extracts the portion of the QR code data matching the regular expression pattern
  /// `^.+63\d{2}` and calculates the CRC for that segment.
  ///
  /// [data] is the input QR code data string.
  ///
  /// Returns:
  /// - A `Future<String>` representing the calculated CRC in uppercase hexadecimal format.
  static Future<String> _calculateCRCAsyncHelper(String data) async {
    final match = RegExp(r'^.+63\d{2}').firstMatch(data)?.group(0);
    if (match != null) {
      final crc = Crc16Ibm3740().convert(utf8.encode(match));
      return crc.toRadixString(16).toUpperCase();
    }
    return '';
  }

  /// Converts the CRC validation result into a map for structured data representation.
  ///
  /// This method extracts the CRC value from the QR code data and validates it. The result is returned
  /// as a map with the following structure:
  /// - `code`: The extracted CRC value as a string.
  /// - `is_valid_crc`: A boolean indicating whether the CRC is valid.
  ///
  /// [qrData] is the input QR code data string to validate.
  ///
  /// Returns:
  /// - A map containing the extracted CRC value and its validation status.
  static Map<String, dynamic> toMap(String qrData) {
    final match = RegExp(r'(63\d{2})([0-9A-Fa-f]{4})$').firstMatch(qrData);
    if (match != null) {
      return {
        'code': match.group(2).toString(),
        'is_valid_crc': isValidCRC(qrData),
      };
    }
    return {'is_valid_crc': false};
  }
}
