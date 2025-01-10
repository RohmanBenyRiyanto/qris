class CrcData {
  final String? code;
  final bool isValidCrc;

  CrcData({
    this.code,
    this.isValidCrc = false,
  });

  factory CrcData.fromJson(Map<String, dynamic> json) {
    return CrcData(
      code: json['code'],
      isValidCrc: json['is_valid_crc'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'is_valid_crc': isValidCrc,
    };
  }
}
