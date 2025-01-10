/// Enum representing the merchant's size/scale.
///
/// Excludes the asset values of occupied land for business and infrastructures.
/// Number figures are represented in IDR (Indonesian Rupiah).
enum MerchantCriteria {
  /// The smallest merchant size with an average net profit up to 50 million
  /// and average sales up to 300 million.
  micro,

  /// The small merchant size, larger than [MerchantCriteria.micro],
  /// with a net profit up to 500 million and average sales up to 2.5 billion.
  small,

  /// The medium merchant size, with a net profit between 500 million and
  /// up to 10 billion, and average sales up to 50 billion.
  medium,

  /// Larger than [MerchantCriteria.medium] in terms of net profit and sales.
  large,

  /// Default merchant size with no specific size or scale.
  regular,
}

extension MerchantCriteriaExtension on MerchantCriteria {
  /// Returns the string representation of the criteria.
  ///
  /// Corresponding values:
  /// - [MerchantCriteria.micro] -> "UMI"
  /// - [MerchantCriteria.small] -> "UKE"
  /// - [MerchantCriteria.medium] -> "UME"
  /// - [MerchantCriteria.large] -> "UBE"
  /// - [MerchantCriteria.regular] -> "URE"
  String get criteriaString {
    switch (this) {
      case MerchantCriteria.micro:
        return 'UMI';
      case MerchantCriteria.small:
        return 'UKE';
      case MerchantCriteria.medium:
        return 'UME';
      case MerchantCriteria.large:
        return 'UBE';
      case MerchantCriteria.regular:
        return 'URE';
    }
  }

  /// Retrieves the MDR percentage based on the merchant's size.
  ///
  /// - For "UMI", returns 0.3
  /// - For "UKE", "UME", and "UBE", returns 0.7
  /// - For additional categories such as "Pendidikan", "SPBU", "BLU", and "PSO", returns their respective MDR percentages.
  ///
  /// Source: https://www.bi.go.id/id/publikasi/ruang-media/cerita-bi/Pages/mdr-qris.aspx
  double get mdrPercentage {
    const mdrPercentages = {
      'UMI': 0.3,
      'UKE': 0.7,
      'UME': 0.7,
      'UBE': 0.7,
      'Pendidikan': 0.6,
      'SPBU': 0.4,
      'BLU': 0.4,
      'PSO': 0.4,
    };

    // Match the string representation of the criteria to the MDR percentage
    return mdrPercentages[criteriaString] ??
        0.0; // Return 0.0 if no match found
  }
}

extension MerchantCriteriaStringExtension on String {
  /// Converts a string to the corresponding [MerchantCriteria].
  ///
  /// - "UMI" -> [MerchantCriteria.micro]
  /// - "UKE" -> [MerchantCriteria.small]
  /// - "UME" -> [MerchantCriteria.medium]
  /// - "UBE" -> [MerchantCriteria.large]
  /// - "URE" -> [MerchantCriteria.regular]
  MerchantCriteria get toMerchantCriteria {
    switch (this) {
      case 'UMI':
        return MerchantCriteria.micro;
      case 'UKE':
        return MerchantCriteria.small;
      case 'UME':
        return MerchantCriteria.medium;
      case 'UBE':
        return MerchantCriteria.large;
      case 'URE':
        return MerchantCriteria.regular;
      default:
        return MerchantCriteria.regular;
    }
  }
}
