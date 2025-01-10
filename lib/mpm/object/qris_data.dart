import '../../qris.dart';

class QRIS {
  String? payloadFormatIndicator;
  PointOfInitiationMethod? pointOfInitiationMethod;
  ISO4217Currency? currency;
  CRC? crc;
  MCC? mcc;
  AdditionalData? additionalData;
  Merchant? merchant;
  String? merchantPrincipalVisa;
  String? merchantPrincipalMastercard;
  Transaction? transaction;
  Map<int, MerchantInformation>? merchantInformation;
  String? qrCodeRaw;
  Map<String, dynamic>? qrCodeDecodedMapRaw;

  QRIS({
    this.payloadFormatIndicator,
    this.pointOfInitiationMethod,
    this.merchantPrincipalVisa,
    this.merchantPrincipalMastercard,
    this.currency,
    this.crc,
    this.mcc,
    this.additionalData,
    this.merchant,
    this.transaction,
    this.merchantInformation,
    this.qrCodeRaw,
    this.qrCodeDecodedMapRaw,
  });

  factory QRIS.fromJson(Map<String, dynamic> json) {
    return QRIS(
      payloadFormatIndicator: json['payload_format_indicator'],
      pointOfInitiationMethod: json['point_of_initiation_method']
          .toString()
          .toPointOfInitiationMethodFromRAW(),
      currency: ISO4217Currency.fromNumCodetoObject(
        json['transaction_currency'] ?? "360",
      ),
      crc: CRC.fromJson(json),
      mcc: MCC.fromJson(json),
      additionalData: AdditionalData.fromJson(json),
      merchant: Merchant.fromJson(json),
      merchantPrincipalVisa: json['merchant_principal_visa'],
      merchantPrincipalMastercard: json['merchant_principal_mastercard'],
      transaction: Transaction.fromJson(json),
      merchantInformation:
          MerchantInformation.formatMerchantInformationToObjects(
              MerchantQRDataDetail(json).formatMerchantInformation()),
      qrCodeRaw: json['qr_code'],
      qrCodeDecodedMapRaw: json,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return qrCodeDecodedMapRaw ?? {};
  }
}

class CRC {
  String? code;
  bool isValidCrc;

  CRC({this.code, this.isValidCrc = false});

  factory CRC.fromJson(Map<String, dynamic> rawQRISJson) {
    if (rawQRISJson.containsKey('qr_code') && rawQRISJson['qr_code'] != null) {
      final crcMap = CRCHelper.toMap(rawQRISJson['qr_code']);
      return CRC(
        code: crcMap['code'],
        isValidCrc: crcMap['is_valid_crc'],
      );
    } else {
      return CRC();
    }
  }
}

class MCC {
  int? id;
  String? mcc;
  String? editedDescription;
  String? combinedDescription;
  String? usdaDescription;
  String? irsDescription;
  String? irsReportable;

  MCC({
    this.id,
    this.mcc,
    this.editedDescription,
    this.combinedDescription,
    this.usdaDescription,
    this.irsDescription,
    this.irsReportable,
  });

  factory MCC.fromJson(Map<String, dynamic> rawJsonDecode) {
    Map<String, dynamic> mccJson = {};

    if (rawJsonDecode.containsKey('mcc') && rawJsonDecode['mcc'] != null) {
      mccJson = MCCHelper.getMCCByCode(rawJsonDecode['mcc']);
    }

    if (mccJson.isEmpty) {
      return MCC();
    }

    return MCC(
      id: mccJson['id'],
      mcc: mccJson['mcc'],
      editedDescription: mccJson['edited_description'],
      combinedDescription: mccJson['combined_description'],
      usdaDescription: mccJson['usda_description'],
      irsDescription: mccJson['irs_description'],
      irsReportable: mccJson['irs_reportable'],
    );
  }
}

class AdditionalData {
  String? billingIde;
  String? billNumber;
  String? mobileNumber;
  String? storeLabel;
  String? loyaltyNumber;
  String? referenceLabel;
  String? customerLabel;
  String? terminalLabel;
  String? purposeOfTransaction;
  String? additionalConsumerData;
  String? merchantTaxId;
  String? merchantChannel;

  AdditionalData({
    this.billingIde,
    this.billNumber,
    this.mobileNumber,
    this.storeLabel,
    this.loyaltyNumber,
    this.referenceLabel,
    this.customerLabel,
    this.terminalLabel,
    this.purposeOfTransaction,
    this.additionalConsumerData,
    this.merchantTaxId,
    this.merchantChannel,
  });

  factory AdditionalData.fromJson(Map<String, dynamic> json) {
    return AdditionalData(
      billingIde: json['billing_ide'],
      billNumber: json['bill_number'],
      mobileNumber: json['mobile_number'],
      storeLabel: json['store_label'],
      loyaltyNumber: json['loyalty_number'],
      referenceLabel: json['reference_label'],
      customerLabel: json['customer_label'],
      terminalLabel: json['terminal_label'],
      purposeOfTransaction: json['purpose_of_transaction'],
      additionalConsumerData: json['additional_consumer_data'],
      merchantTaxId: json['merchant_tax_id'],
      merchantChannel: json['merchant_channel'],
    );
  }
}

class Merchant with MerchantPANValidationMixin {
  String? name;
  @override
  String? merchantPan;
  String? merchantId;
  String? panMerchantMethod;
  String? nationalMerchantId;
  String? institutionCode;
  String? issuerNns;
  String? acquirerName;
  MerchantCriteria? merchantCriteria;
  MerchantLocation? location;

  Merchant({
    this.name,
    this.merchantPan,
    this.merchantId,
    this.panMerchantMethod,
    this.nationalMerchantId,
    this.institutionCode,
    this.issuerNns,
    this.acquirerName,
    this.merchantCriteria,
    this.location,
  });

  factory Merchant.fromJson(Map<String, dynamic> rawData) {
    final jsonMerchant = MerchantQRDataDetail(rawData).result;

    return Merchant(
      name: jsonMerchant['name'],
      merchantPan: jsonMerchant['merchant_pan'],
      merchantId: jsonMerchant['merchant_id'],
      panMerchantMethod: jsonMerchant['pan_merchant_method'],
      nationalMerchantId: jsonMerchant['national_merchant_id'],
      institutionCode: jsonMerchant['institution_code'],
      issuerNns: jsonMerchant['issuer_nns'],
      acquirerName: jsonMerchant['acquirer_name'],
      merchantCriteria:
          jsonMerchant['merchant_criteria'].toString().toMerchantCriteria,
      location: jsonMerchant['location'] != null
          ? MerchantLocation.fromJson(jsonMerchant['location'])
          : null,
    );
  }
}

class MerchantLocation {
  String? city;
  String? countryCode;
  String? postalCode;

  MerchantLocation({
    this.city,
    this.countryCode,
    this.postalCode,
  });

  @override
  String toString() {
    return '$city, $countryCode, $postalCode';
  }

  factory MerchantLocation.fromJson(Map<String, dynamic> json) {
    return MerchantLocation(
      city: json['city'],
      countryCode: json['country_code'],
      postalCode: json['postal_code'],
    );
  }
}

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

  static Map<int, MerchantInformation> formatMerchantInformationToObjects(
      Map<String, dynamic> data) {
    final Map<int, MerchantInformation> merchantInformationMap = {};

    final keysToFormat = ['26', '27', '50', '51'];

    for (var key in keysToFormat) {
      final keyName = 'merchant_information_$key';
      if (data.containsKey(keyName) && data[keyName] != null) {
        merchantInformationMap[int.parse(key)] =
            MerchantInformation.fromJson(data[keyName]);
      }
    }

    return merchantInformationMap;
  }
}

class Transaction {
  TipIndicator? tipIndicator;
  String? transactionAmount;
  String? fixedTipAmount;
  String? percentageTipAmount;
  String? tipCalculated;

  Transaction({
    this.transactionAmount,
    this.fixedTipAmount,
    this.percentageTipAmount,
    this.tipIndicator,
    this.tipCalculated,
  });

  factory Transaction.fromJson(Map<String, dynamic> rawData) {
    final tipIndicatorFormatter = QrisTransactionFormatter(rawData);
    final json = tipIndicatorFormatter.formatTransaction();

    return Transaction(
      tipIndicator: tipIndicatorFormatter.tipIndicator,
      transactionAmount: json['transaction_amount'],
      fixedTipAmount: json.containsKey('fixed_tip_amount')
          ? json['fixed_tip_amount']
          : null,
      percentageTipAmount: json.containsKey('percentage_tip_amount')
          ? json['percentage_tip_amount']
          : null,
      tipCalculated: json['tip_calculated'],
    );
  }
}
