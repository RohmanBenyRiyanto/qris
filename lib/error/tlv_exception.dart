class TLVException implements Exception {
  final String message;
  final String tag;
  final int position;
  final String? additionalInfo;

  const TLVException(
    this.message, {
    this.tag = '',
    this.position = -1,
    this.additionalInfo,
  });

  @override
  String toString() {
    String errorMessage = 'TLVException: $message';

    if (tag.isNotEmpty) {
      errorMessage += ' (Tag: $tag)';
    }
    if (position >= 0) {
      errorMessage += ' at position: $position';
    }
    if (additionalInfo != null) {
      errorMessage += ' - $additionalInfo';
    }

    return errorMessage;
  }
}
