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
}
