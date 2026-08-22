import 'package:flutter_qris/qris_core/services/tlv_service.dart';

import '../../models/tlv.dart';

extension TLVExtension on List<TLV> {
  /// Retrieves the value for a given tag from the list of TLV objects.
  ///
  /// This method searches the list for a TLV object matching the provided tag
  /// and returns its value. If no matching tag is found, `null` is returned.
  ///
  /// Example:
  /// ```dart
  /// final tlvList = [TLV('00', 2, '01'), TLV('01', 4, 'Test')];
  /// print(tlvList.getValueByTag('01')); // Output: Test
  /// ```
  ///
  /// - `tag`: The tag whose value is to be retrieved.
  /// - Returns: The value associated with the tag if found, or `null` otherwise.
  String? getValueByTag(String tag) {
    try {
      return firstWhere((tlv) => tlv.tag == tag).value;
    } catch (e) {
      return null;
    }
  }

  /// Retrieves the value of a sub-tag from a parent tag within a TLV structure.
  ///
  /// This method searches for a `parentTag` in the provided list of TLV objects, decodes its value
  /// into a list of TLV objects, and retrieves the value of the specified `subTag`.
  /// Returns `null` if the parent tag or sub-tag is not found, or if decoding fails.
  ///
  /// ### Parameters:
  /// - `parentTag` (`String`): The tag of the parent TLV object to search for.
  /// - `subTag` (`String`): The tag of the sub-TLV to retrieve from the decoded parent value.
  /// - `tlv` (`List<TLV>?`): The list of TLV objects to search within. Defaults to `default decoded tlv`.
  ///
  /// ### Returns:
  /// - `String?`: The value of the sub-tag if found, or `null` otherwise.
  ///
  /// ### Example:
  /// ```dart
  /// final List<TLV> parentTLVs = [TLV('26', 4, 'EncodedData')];
  /// final String? subValue = getSubTagValue(parentTag: '26', subTag: '01', tlv: parentTLVs);
  /// print(subValue); // Output: Decoded sub-tag value (if found).
  /// ```
  ///
  /// ### Notes:
  /// - The `tlvDecode` function must correctly decode the parent value into TLV objects.
  /// - If `parentTag` or `subTag` is missing or invalid, `null` is returned.
  String? getSubTagValue({
    required String parentTag,
    required String subTag,
    List<TLV>? tlv = const [],
  }) {
    final parentValue = (tlv ?? this).getValueByTag(parentTag);
    if (parentValue == null || parentValue.isEmpty) return null;

    final decodedParent = _TLVServiceGetter().decode(parentValue);
    return decodedParent.getValueByTag(subTag);
  }
}

class _TLVServiceGetter with TLVService {
  List<TLV> decode(String data) => tlvDecode(data);
}
