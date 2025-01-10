class QrisMpmTag {
  final String id;
  final String name;
  final List<QrisMpmTag> children;

  QrisMpmTag({
    required this.id,
    required this.name,
    this.children = const [], // Default empty list to ensure null safety
  });

  // Factory constructor for creating an empty tag
  factory QrisMpmTag.empty() {
    return QrisMpmTag(id: '', name: '');
  }
}

final List<QrisMpmTag> tagsArray = [
  QrisMpmTag(id: '00', name: 'payload_format_indicator'),
  QrisMpmTag(id: '01', name: 'point_of_initiation_method'),
  QrisMpmTag(id: '02', name: 'merchant_principal_visa'),
  QrisMpmTag(id: '04', name: 'merchant_principal_mastercard'),
  QrisMpmTag(
    id: '26',
    name: 'merchant_information_26',
    children: [
      QrisMpmTag(id: '00', name: 'global_unique_identifier'),
      QrisMpmTag(id: '01', name: 'merchant_pan'),
      QrisMpmTag(id: '02', name: 'merchant_id'),
      QrisMpmTag(id: '03', name: 'merchant_criteria'),
    ],
  ),
  QrisMpmTag(
    id: '27',
    name: 'merchant_information_27',
    children: [
      QrisMpmTag(id: '00', name: 'global_unique_identifier'),
      QrisMpmTag(id: '01', name: 'merchant_pan'),
      QrisMpmTag(id: '02', name: 'merchant_id'),
      QrisMpmTag(id: '03', name: 'merchant_criteria'),
    ],
  ),
  QrisMpmTag(
    id: '50',
    name: 'merchant_information_50',
    children: [
      QrisMpmTag(id: '00', name: 'global_unique_identifier'),
      QrisMpmTag(id: '01', name: 'merchant_pan'),
      QrisMpmTag(id: '02', name: 'merchant_id'),
      QrisMpmTag(id: '03', name: 'merchant_criteria'),
    ],
  ),
  QrisMpmTag(
    id: '51',
    name: 'merchant_information_51',
    children: [
      QrisMpmTag(id: '00', name: 'global_unique_identifier'),
      QrisMpmTag(id: '01', name: 'merchant_pan'),
      QrisMpmTag(id: '02', name: 'merchant_id'),
      QrisMpmTag(id: '03', name: 'merchant_criteria'),
    ],
  ),
  QrisMpmTag(id: '52', name: 'mcc'),
  QrisMpmTag(id: '53', name: 'transaction_currency'),
  QrisMpmTag(id: '54', name: 'transaction_amount'),
  QrisMpmTag(id: '55', name: 'tip_indicator'),
  QrisMpmTag(id: '56', name: 'fixed_tip_amount'),
  QrisMpmTag(id: '57', name: 'percentage_tip_amount'),
  QrisMpmTag(id: '58', name: 'country_code'),
  QrisMpmTag(id: '59', name: 'merchant_name'),
  QrisMpmTag(id: '60', name: 'merchant_city'),
  QrisMpmTag(id: '61', name: 'merchant_postal_code'),
  QrisMpmTag(
    id: '62',
    name: 'additional_data',
    children: [
      QrisMpmTag(id: '00', name: 'billing_ide'),
      QrisMpmTag(id: '01', name: 'bill_number'),
      QrisMpmTag(id: '02', name: 'mobile_number'),
      QrisMpmTag(id: '03', name: 'store_label'),
      QrisMpmTag(id: '04', name: 'loyalty_number'),
      QrisMpmTag(id: '05', name: 'reference_label'),
      QrisMpmTag(id: '06', name: 'customer_label'),
      QrisMpmTag(id: '07', name: 'terminal_label'),
      QrisMpmTag(id: '08', name: 'purpose_of_transaction'),
      QrisMpmTag(id: '09', name: 'additional_consumer_data'),
      QrisMpmTag(id: '10', name: 'merchant_tax_id'),
      QrisMpmTag(id: '11', name: 'merchant_channel'),
    ],
  ),
  QrisMpmTag(id: '63', name: 'crc'),
];
