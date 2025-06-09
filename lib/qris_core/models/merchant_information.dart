import '../utils/type/merchant_criteria.dart';

class MerchantInformation {
  String? globalUniqueIdentifier;
  String? merchantPan;
  String? merchantId;
  MerchantCriteria? merchantCriteria;

  MerchantInformation({
    this.globalUniqueIdentifier,
    this.merchantPan,
    this.merchantId,
    this.merchantCriteria,
  });

  factory MerchantInformation.fromJson(Map<String, dynamic> json) {
    return MerchantInformation(
      globalUniqueIdentifier: json['global_unique_identifier'],
      merchantPan: json['merchant_pan'],
      merchantId: json['merchant_id'],
      merchantCriteria: json['merchant_criteria'].toString().toMerchantCriteria,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'global_unique_identifier': globalUniqueIdentifier,
      'merchant_pan': merchantPan,
      'merchant_id': merchantId,
      'merchant_criteria': merchantCriteria.toString(),
    };
  }
}
