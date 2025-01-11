part of '../qris_mpm.dart';

mixin MPMTagParser on TLVService {
  /// Converts a list of [TLV] objects into a map of QRIS tag names and their values.
  Map<String, dynamic> _rawTLVtoRawQrisTaggMap(List<TLV> tlv) {
    Map<String, dynamic> resultMap = {};

    for (var tlvItem in tlv) {
      var tag = tlvItem.tag;
      var value = tlvItem.value;

      if (!isValidTag(tag)) {
        continue;
      }

      var qrisTag = QrisMpmTags.allTags.firstWhere(
        (tagItem) => tagItem.id == tag,
        orElse: () => QrisTag(id: tag, name: 'unknown'),
      );

      if (qrisTag.name != 'unknown') {
        if (qrisTag.children.isNotEmpty) {
          try {
            List<TLV> childTLVs = tlvDecode(value);
            resultMap[qrisTag.name] =
                _decodeChildren(qrisTag.children, childTLVs);
          } catch (e) {
            'Error decoding child tags for $tag: $e'.myLog();
          }
        } else {
          resultMap[qrisTag.name] = value;
        }
      }
    }

    return resultMap;
  }

  /// Checks if the tag is a valid number.
  bool isValidTag(String tag) {
    return int.tryParse(tag) != null;
  }

  /// Decodes the children of a tag based on the provided child tags and TLV list.
  Map<String, dynamic> _decodeChildren(
      List<QrisTag> children, List<TLV> tlvList) {
    Map<String, dynamic> childMap = {};

    for (var childTag in children) {
      var matchingTLV = tlvList.firstWhere(
        (tlv) => tlv.tag == childTag.id,
        orElse: () => TLV('unknown', 0, ''),
      );

      if (matchingTLV.tag != 'unknown') {
        childMap[childTag.name] = matchingTLV.value;
      }
    }

    return childMap;
  }

  /// Converts a map of QRIS tag names and their values back into a list of [TLV] objects.
  List<TLV> _mapToListTLV(Map<String, dynamic> map) {
    List<TLV> tlvList = [];

    map.forEach((name, value) {
      var tag = _getTagByName(name);
      if (tag != null) {
        tlvList.add(TLV(tag, value.toString().length, value.toString()));
      }
    });

    return tlvList;
  }

  /// Helper method to find the tag associated with a QRIS tag name using QrisMpmTags.
  String? _getTagByName(String name) {
    var qrisTag = QrisMpmTags.allTags.firstWhere(
      (tagItem) => tagItem.name == name,
      orElse: () => QrisTag(id: 'unknown', name: 'unknown'),
    );

    return qrisTag.id != 'unknown' ? qrisTag.id : null;
  }
}
