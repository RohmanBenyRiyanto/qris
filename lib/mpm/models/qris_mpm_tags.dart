import 'package:flutter_qris/qris_core/models/qris_tag.dart';

/// Abstract class representing the base data for QRIS tags.
///
/// This class contains the definitions of QRIS tags used in the QRIS Merchant Precented Mode (MPM).
/// It serves as the foundation for tag data, including their associated IDs, names, and potential children tags.
abstract class QrisMpmTags {
  static QrisTag payloadFormatIndicator = QrisTag(
    id: '00',
    name: 'payload_format_indicator',
  );

  static QrisTag pointOfInitiationMethod = QrisTag(
    id: '01',
    name: 'point_of_initiation_method',
  );

  static QrisTag merchantPrincipalVisa = QrisTag(
    id: '02',
    name: 'merchant_principal_visa',
  );

  static QrisTag merchantCriteria = QrisTag(
    id: '03',
    name: 'merchant_criteria',
  );

  static QrisTag merchantPrincipalMastercard = QrisTag(
    id: '04',
    name: 'merchant_principal_mastercard',
  );

  static QrisTag terminalLabel = QrisTag(
    id: '07',
    name: 'terminal_label',
  );

  static QrisTag merchantInformation26 = QrisTag(
    id: '26',
    name: 'merchant_information_26',
    children: [
      QrisTag(id: '00', name: 'global_unique_identifier'),
      QrisTag(id: '01', name: 'merchant_pan'),
      QrisTag(id: '02', name: 'merchant_id'),
      merchantCriteria,
    ],
  );

  static QrisTag merchantInformation27 = QrisTag(
    id: '27',
    name: 'merchant_information_27',
    children: [
      QrisTag(id: '00', name: 'global_unique_identifier'),
      QrisTag(id: '01', name: 'merchant_pan'),
      QrisTag(id: '02', name: 'merchant_id'),
      merchantCriteria,
    ],
  );

  static QrisTag merchantInformation50 = QrisTag(
    id: '50',
    name: 'merchant_information_50',
    children: [
      QrisTag(id: '00', name: 'global_unique_identifier'),
      QrisTag(id: '01', name: 'merchant_pan'),
      QrisTag(id: '02', name: 'merchant_id'),
      merchantCriteria,
    ],
  );

  static QrisTag merchantInformation51 = QrisTag(
    id: '51',
    name: 'merchant_information_51',
    children: [
      QrisTag(id: '00', name: 'global_unique_identifier'),
      QrisTag(id: '01', name: 'merchant_pan'),
      QrisTag(id: '02', name: 'merchant_id'),
      merchantCriteria,
    ],
  );

  static QrisTag merchantCategoryCode = QrisTag(
    id: '52',
    name: 'mcc',
  );

  static QrisTag transactionCurrency = QrisTag(
    id: '53',
    name: 'transaction_currency',
  );

  static QrisTag transactionAmount = QrisTag(
    id: '54',
    name: 'transaction_amount',
  );

  static QrisTag tipIndicator = QrisTag(
    id: '55',
    name: 'tip_indicator',
  );

  static QrisTag fixedTipAmount = QrisTag(
    id: '56',
    name: 'fixed_tip_amount',
  );

  static QrisTag percentageTipAmount = QrisTag(
    id: '57',
    name: 'percentage_tip_amount',
  );

  static QrisTag countryCode = QrisTag(
    id: '58',
    name: 'country_code',
  );

  static QrisTag merchantName = QrisTag(
    id: '59',
    name: 'merchant_name',
  );

  static QrisTag merchantCity = QrisTag(
    id: '60',
    name: 'merchant_city',
  );

  static QrisTag merchantPostalCode = QrisTag(
    id: '61',
    name: 'merchant_postal_code',
  );

  static QrisTag additionalData = QrisTag(
    id: '62',
    name: 'additional_data',
    children: [
      QrisTag(id: '00', name: 'billing_ide'),
      QrisTag(id: '01', name: 'bill_number'),
      QrisTag(id: '02', name: 'mobile_number'),
      QrisTag(id: '03', name: 'store_label'),
      QrisTag(id: '04', name: 'loyalty_number'),
      QrisTag(id: '05', name: 'reference_label'),
      QrisTag(id: '06', name: 'customer_label'),
      terminalLabel,
      QrisTag(id: '08', name: 'purpose_of_transaction'),
      QrisTag(id: '09', name: 'additional_consumer_data'),
      QrisTag(id: '10', name: 'merchant_tax_id'),
      QrisTag(id: '11', name: 'merchant_channel'),
      extraData,
    ],
  );

  static QrisTag checksum = QrisTag(
    id: '63',
    name: 'crc',
  );

  static QrisTag extraData = QrisTag(
    id: '99',
    name: 'extra_data',
  );

  static List<QrisTag> allTags = [
    payloadFormatIndicator,
    pointOfInitiationMethod,
    merchantPrincipalVisa,
    merchantCriteria,
    merchantPrincipalMastercard,
    terminalLabel,
    merchantInformation26,
    merchantInformation27,
    merchantInformation50,
    merchantInformation51,
    merchantCategoryCode,
    transactionCurrency,
    transactionAmount,
    tipIndicator,
    fixedTipAmount,
    percentageTipAmount,
    countryCode,
    merchantName,
    merchantCity,
    merchantPostalCode,
    additionalData,
    checksum,
    extraData,
  ];
}
