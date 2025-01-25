part of '../qris_mpm.dart';

extension QrisMpmExtension on List<TLV> {
  @visibleForTesting
  void logDebugingTLV() {
    '==================================================='.qrLog();
    for (var tlvItem in this) {
      'Tag: ${tlvItem.tag.padRight(4)} | '
              'Length: ${tlvItem.length.toString().padRight(5)} | '
              'Value: ${tlvItem.value}'
          .qrLog();
    }
    '==================================================='.qrLog();
  }
}
