import 'package:flutter_qris/qris.dart';

/// A service class that provides functionality for encoding and decoding
/// Type-Length-Value (TLV) data format.
///
/// The TLV format is a flexible encoding structure used in many communication
/// protocols and data formats. Each data unit consists of a:
/// - **Tag**: A 2-character identifier representing the type of data.
/// - **Length**: A 2-character field that specifies the length of the value.
/// - **Value**: The actual data associated with the tag, whose length is defined
/// by the length field.
///
/// Example:
/// - For a TLV string like `0012345A`:
///   - Tag: `00`
///   - Length: `12` (indicating the value field is 12 characters long)
///   - Value: `345A`
mixin TLVService {
  /// Decodes a TLV encoded string into a list of [TLV] objects.
  ///
  /// The method iterates through the provided TLV encoded string, extracting
  /// the tag, length, and value for each TLV item and converts them into a list
  /// of [TLV] objects. It validates the TLV structure and skips invalid tags
  /// in the range of `00-99`. If the data is malformed or incomplete, the method
  /// may stop parsing further.
  ///
  /// - Parameters:
  ///   - [data]: The TLV encoded string to decode. The string should be in the
  ///     standard TLV format (tag, length, value).
  ///
  /// - Returns:
  ///   A list of [TLV] objects representing the decoded tags, lengths, and values.
  ///
  /// - Example:
  ///   ```dart
  ///   TLVService tlvService = TLVService();
  ///   List<TLV> decoded = tlvService.tlvDecode('0012345A0103ABC');
  ///   print(decoded); // [TLV("00", 12, "345A"), TLV("01", 3, "ABC")]
  ///   ```
  List<TLV> tlvDecode(String data) {
    List<TLV> tlvList = [];
    int index = 0;
    int dataLength = data.length;

    try {
      while (index + 4 <= dataLength) {
        final tag = data[index] + data[index + 1]; // Tag as a string "XX"
        index += 2;

        if (!_isValidTag(tag)) {
          'Invalid tag: $tag, skipping...'.myLog();
          index += 2; // Skip length (2 digits) and value (based on length)

          //! DISABLED for This Version
          // if (tag != "5B") {
          //   throw TLVException(
          //     'Invalid TAG',
          //     tag: tag,
          //     position: index,
          //     additionalInfo: 'Skipped tag: $tag',
          //   );
          // } else {
          //   continue;
          // }
          continue;
        }

        final tagValueLengthStr =
            data[index] + data[index + 1]; // Length as "XX"
        index += 2;

        final tagValueLength = int.tryParse(tagValueLengthStr) ?? 0;
        if (index + tagValueLength > dataLength) {
          break; // Validate if we have enough data for the tag
        }

        final value = data.substring(index, index + tagValueLength);
        index += tagValueLength;

        tlvList.add(TLV(tag, tagValueLength, value));
      }

      return tlvList;
    } catch (e) {
      throw TLVException(
        'Error decoding TLV data',
        tag: '',
        position: index,
        additionalInfo: e.toString(),
      );
    }
  }

  bool _isValidTag(String tag) {
    // Validate that tag is a number between "00" and "99"
    return int.tryParse(tag)?.between(0, 99) ?? false;
  }

  /// Encodes a list of [TLV] objects into a TLV encoded string.
  ///
  /// This method processes a list of [TLV] objects and converts each object into
  /// its corresponding TLV format by concatenating the tag, length (as a 2-digit
  /// number), and the value. It returns the concatenated string representing the
  /// encoded TLV data.
  ///
  /// - Parameters:
  ///   - [tlvList]: A list of [TLV] objects that need to be encoded into the
  ///     TLV format.
  ///
  /// - Returns:
  ///   A string representing the encoded TLV data, with each tag-length-value
  ///   pair concatenated together.
  ///
  /// Example:
  /// ```dart
  /// TLVService tlvService = TLVService();
  /// List<TLV> tlvList = [
  ///   TLV("00", 12, "345A"),
  ///   TLV("01", 3, "ABC")
  /// ];
  /// String encoded = tlvService.tlvEncode(tlvList);
  /// print(encoded); // "0012345A0103ABC"
  /// ```
  String tlvEncode(List<TLV> tlvList) {
    StringBuffer encodedData = StringBuffer();

    for (var tlv in tlvList) {
      String length = tlv.length.toString().padLeft(2, '0');
      encodedData.write(tlv.tag);
      encodedData.write(length);
      encodedData.write(tlv.value);
    }

    return encodedData.toString();
  }
}

/// Private extension to add a `between` method to the `int` class.
///
/// - `bool between(int lower, int upper)`: Checks if the `int` is within the range of `lower` and `upper`.
extension _IntRange on int {
  bool between(int lower, int upper) => this >= lower && this <= upper;
}
