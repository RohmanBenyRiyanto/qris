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


  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'country_code': countryCode,
      'postal_code': postalCode,
    };
  }
}
