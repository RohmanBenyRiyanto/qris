import 'package:flutter/foundation.dart';
import 'package:flutter_qris/qris.dart';

class AdditionalData with TLVService {
  final List<TLV> tlv;

  AdditionalData(this.tlv);

  List<TLV>? _additionalData;

  List<TLV> get _getDecodedAdditionalData {
    _additionalData ??= _decodeAdditionalData();
    return _additionalData!;
  }

  List<TLV> _decodeAdditionalData() {
    List<TLV> additionalData = [];
    final tag62Data = tlv
        .firstWhere(
          (t) => t.tag == '62',
          orElse: () => TLV('62', 0, ''),
        )
        .value;

    if (tag62Data.isNotEmpty) {
      final decodedData = tlvDecode(tag62Data);
      additionalData.addAll(decodedData);
    }

    return additionalData;
  }

  /// Retrieves the billing ID from the additional data.
  ///
  /// This getter returns the value associated with the tag '00', which is
  /// the `billing_ide` field in the QRIS data. If no value is found, it returns
  /// an empty string (`''`).
  String get billingIde => _getDecodedAdditionalData.getValueByTag('00') ?? '';

  /// Retrieves the bill number from the additional data.
  ///
  /// This getter returns the value associated with the tag '01', which is
  /// the `bill_number` field in the QRIS data. If no value is found, it returns
  /// an empty string (`''`).
  String get billNumber => _getDecodedAdditionalData.getValueByTag('01') ?? '';

  /// Retrieves the mobile number from the additional data.
  ///
  /// This getter returns the value associated with the tag '02', which is
  /// the `mobile_number` field in the QRIS data. If no value is found, it returns
  /// an empty string (`''`).
  String get mobileNumber =>
      _getDecodedAdditionalData.getValueByTag('02') ?? '';

  /// Retrieves the store label from the additional data.
  ///
  /// This getter returns the value associated with the tag '03', which is
  /// the `store_label` field in the QRIS data. If no value is found, it returns
  /// an empty string (`''`).
  String get storeLabel => _getDecodedAdditionalData.getValueByTag('03') ?? '';

  /// Retrieves the loyalty number from the additional data.
  ///
  /// This getter returns the value associated with the tag '04', which is
  /// the `loyalty_number` field in the QRIS data. If no value is found, it returns
  /// an empty string (`''`).
  String get loyaltyNumber =>
      _getDecodedAdditionalData.getValueByTag('04') ?? '';

  /// Retrieves the reference label from the additional data.
  ///
  /// This getter returns the value associated with the tag '05', which is
  /// the `reference_label` field in the QRIS data. If no value is found, it returns
  /// an empty string (`''`).
  String get referenceLabel =>
      _getDecodedAdditionalData.getValueByTag('05') ?? '';

  /// Retrieves the customer label from the additional data.
  ///
  /// This getter returns the value associated with the tag '06', which is
  /// the `customer_label` field in the QRIS data. If no value is found, it returns
  /// an empty string (`''`).
  String get customerLabel =>
      _getDecodedAdditionalData.getValueByTag('06') ?? '';

  /// Retrieves the terminal label from the additional data.
  ///
  /// This getter returns the value associated with the tag '07', which is
  /// the `terminal_label` field in the QRIS data. If no value is found, it returns
  /// an empty string (`''`).
  String get terminalLabel =>
      _getDecodedAdditionalData.getValueByTag('07') ?? '';

  /// Retrieves the purpose of the transaction from the additional data.
  ///
  /// This getter returns the value associated with the tag '08', which is
  /// the `purpose_of_transaction` field in the QRIS data. If no value is found, it returns
  /// an empty string (`''`).
  String get purposeOfTransaction =>
      _getDecodedAdditionalData.getValueByTag('08') ?? '';

  /// Retrieves additional consumer data from the additional data.
  ///
  /// This getter returns the value associated with the tag '09', which is
  /// the `additional_consumer_data` field in the QRIS data. If no value is found, it returns
  /// an empty string (`''`).
  String get additionalConsumerData =>
      _getDecodedAdditionalData.getValueByTag('09') ?? '';

  /// Retrieves the merchant tax ID from the additional data.
  ///
  /// This getter returns the value associated with the tag '10', which is
  /// the `merchant_tax_id` field in the QRIS data. If no value is found, it returns
  /// an empty string (`''`).
  String get merchantTaxId =>
      _getDecodedAdditionalData.getValueByTag('10') ?? '';

  /// Retrieves the merchant channel from the additional data.
  ///
  /// This getter returns the value associated with the tag '11', which is
  /// the `merchant_channel` field in the QRIS data. If no value is found, it returns
  /// an empty string (`''`).
  String get merchantChannel =>
      _getDecodedAdditionalData.getValueByTag('11') ?? '';

  /// Retrieves extra data from the additional data.
  ///
  /// This getter returns the value associated with the tag '99', which is
  /// the `extra_data` field in the QRIS data. If no value is found, it returns
  /// an empty string (`''`).
  String get extraData => _getDecodedAdditionalData.getValueByTag('99') ?? '';

  @override
  String toString() {
    return {
      'billing_ide': billingIde,
      'bill_number': billNumber,
      'mobile_number': mobileNumber,
      'store_label': storeLabel,
      'loyalty_number': loyaltyNumber,
      'reference_label': referenceLabel,
      'customer_label': customerLabel,
      'terminal_label': terminalLabel,
      'purpose_of_transaction': purposeOfTransaction,
      'additional_consumer_data': additionalConsumerData,
      'merchant_tax_id': merchantTaxId,
      'merchant_channel': merchantChannel,
      'extra_data': extraData,
    }.toPrettyString();
  }

  @visibleForTesting
  void logDebugingAdditionalData() {
    return toString().qrLog();
  }
}
