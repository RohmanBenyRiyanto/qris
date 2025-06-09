class TLV {
  final String tag;
  final int length;
  final String value;

  TLV(this.tag, this.length, this.value);

  @override
  String toString() {
    return 'Tag: $tag, Length: $length, Value: $value';
  }
}
