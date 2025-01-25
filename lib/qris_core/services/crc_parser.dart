part of '../../mpm/qris_mpm.dart';

mixin CRCParser {
  String get qrData;

  /// Calculates the CRC value for the given QR code data using the Crc16Ibm3740 algorithm.
  ///
  /// The CRC is computed only for the portion of the data matching the regular expression pattern
  /// `^.+63\d{2}`. If no match is found, an empty string is returned.
  ///
  /// [qrData] is the input QR code data string that includes the information to validate.
  ///
  /// Returns:
  /// - A string representing the calculated CRC in uppercase hexadecimal format.
  String get crc {
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
  bool isValidCRC() {
    final match = RegExp(r'(63\d{2})([0-9A-Fa-f]{4})\$').firstMatch(qrData);
    final calculatedCRC = crc.toUpperCase();
    return match != null && match.group(2)?.toUpperCase() == calculatedCRC;
  }

  Future<bool> isValidCRCAsync() async {
    final calculatedCRC = await _calculateCRCAsyncHelper(qrData);
    final match = RegExp(r'(63\d{2})([0-9A-Fa-f]{4})\$').firstMatch(qrData);
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
  Future<String> _calculateCRCAsyncHelper(String data) async {
    final match = RegExp(r'^.+63\d{2}').firstMatch(data)?.group(0);
    if (match != null) {
      final crc = Crc16Ibm3740().convert(utf8.encode(match));
      return crc.toRadixString(16).toUpperCase();
    }
    return '';
  }

  @visibleForTesting
  void logDebugingCRC() {
    return 'CRC: $crc | CRC Valid: ${isValidCRC()}'.qrLog();
  }
}
