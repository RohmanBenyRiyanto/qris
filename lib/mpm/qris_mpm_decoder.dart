import 'package:flutter_qris/qris.dart';

/// A decoder for processing QRIS (Quick Response Code Indonesian Standard) MPM payloads.
/// This class provides methods to decode QRIS payloads into a map or a QRIS object.
class QrisMpmDecoder {
  /// Decodes a QRIS payload string into a map representation.
  ///
  /// This method parses the QRIS payload according to its tags and hierarchy,
  /// converting the structured QRIS data into a nested `Map<String, dynamic>` format.
  ///
  /// ### Parameters:
  /// - `qrisPayload`: The QRIS payload string to decode.
  ///
  /// ### Returns:
  /// A `Future` that resolves to a `Map<String, dynamic>` containing the decoded data.
  ///
  /// ### Example:
  /// ```dart
  /// final decodedData = await QrisMpmDecoder.decodeToMap("010212...");
  /// print(decodedData);
  /// ```
  static Future<Map<String, dynamic>> decodeToMap(String qrisPayload) async {
    final data = <String, dynamic>{};

    /// A recursive helper function to parse the QRIS payload.
    ///
    /// - `tags`: A list of `QrisMpmTag` objects representing possible QRIS tags.
    /// - `qrPayload`: The remaining portion of the QRIS payload to parse.
    /// - `parent`: The name of the parent tag, used for nesting data.
    void parse(List<QrisMpmTag> tags, String qrPayload, [String? parent]) {
      int index = 0;

      // Iterate through the QRIS payload to extract tag-value pairs.
      while (index < qrPayload.length) {
        if (qrPayload.length < index + 4) break;

        final qr = qrPayload.substring(index);
        if (qr.length < 4) break;

        final tagId = qr.substring(0, 2);
        final tagValueLength = int.tryParse(qr.substring(2, 4)) ?? 0;

        if (qr.length < 4 + tagValueLength) break;

        final tagValue = qr.substring(4, 4 + tagValueLength);

        // Find the corresponding tag definition.
        final tag = tags.firstWhere(
          (t) => t.id == tagId,
          orElse: QrisMpmTag.empty,
        );

        if (tag.id.isNotEmpty) {
          if (tag.children.isNotEmpty) {
            // If the tag has child tags, parse them recursively.
            final childData = <String, dynamic>{};
            data[tag.name] = childData;
            parse(tag.children, tagValue, tag.name);
          } else {
            // Decode the tag value and store it in the map.
            final decodedValue = _decodeTagValue(tag.name, tagValue);
            if (parent != null) {
              data[parent] = {
                ...?data[parent],
                tag.name: decodedValue,
              };
            } else {
              data[tag.name] = decodedValue;
            }
          }
        }

        index += 4 + tagValueLength;
      }
    }

    parse(tagsArray, qrisPayload);
    data['qr_code'] = qrisPayload;

    return data;
  }

  /// Decodes a QRIS payload string into a `QRIS` object.
  ///
  /// This method converts the QRIS payload into a map using [decodeToMap],
  /// and then maps the result into a `QRIS` object using its `fromJson` constructor.
  ///
  /// ### Parameters:
  /// - `qrisPayload`: The QRIS payload string to decode.
  ///
  /// ### Returns:
  /// A `Future` that resolves to a `QRIS` object.
  ///
  /// ### Example:
  /// ```dart
  /// final qrisObject = await QrisMpmDecoder.decodeToObject("010212...");
  /// print(qrisObject);
  /// ```
  static Future<QRIS> decodeToObject(String qrisPayload) async {
    final data = await decodeToMap(qrisPayload);
    return QRIS.fromJson(data);
  }

  /// Decodes specific tag values based on their tag names.
  ///
  /// This method applies specific decoding logic for certain tags,
  /// such as converting numeric values into a standardized format.
  ///
  /// ### Parameters:
  /// - `tagName`: The name of the tag to decode.
  /// - `value`: The raw value of the tag.
  ///
  /// ### Returns:
  /// The decoded value. For numeric tags like 'transaction_amount',
  /// the value is parsed into a number and returned as a string.
  static dynamic _decodeTagValue(String tagName, String value) {
    switch (tagName) {
      case 'fixed_tip_amount':
      case 'transaction_amount':
      case 'percentage_tip_amount':
        return num.tryParse(value)?.toString() ?? value;
      default:
        return value;
    }
  }
}
