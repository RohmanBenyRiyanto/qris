// ignore_for_file: unintended_html_in_doc_comment

import 'package:flutter/widgets.dart';
import 'package:flutter_qris/qris.dart';

import '../utils/data/iso_4217_currency_data.dart';

/// A class representing an ISO 4217 currency.
///
/// The `ISO4217Currency` class is used to define a currency based on its ISO 4217
/// code standard. It stores essential information such as the currency code, numeric
/// code, number of decimal digits, currency name, and the list of locations that
/// use the currency.
///
/// This class can be used for financial applications, currency conversion services,
/// and anywhere the ISO 4217 currency codes are required.
///
/// ### ISO 4217:
/// ISO 4217 is the international standard for currency codes. It defines three-letter
/// (alphabetic) codes, three-digit (numeric) codes, and the number of decimal digits
/// for each currency in use. The standard is maintained by the International Organization
/// for Standardization (ISO).
///
/// #### Source: https://en.wikipedia.org/wiki/ISO_4217 | https://www.iso.org/iso-4217-currency-codes.html
///
/// #### Example:
/// ```dart
/// final usd = ISO4217Currency(
///   code: 'USD',
///   numCode: 840,
///   digits: 2,
///   currencyName: 'United States Dollar',
///   locations: ['United States', 'American Samoa', 'British Virgin Islands'],
/// );
/// ```
class ISO4217Currency {
  /// The ISO 4217 code of the currency (3-letter code).
  ///
  /// This code uniquely identifies the currency, e.g., 'USD' for United States Dollar,
  /// 'EUR' for Euro, 'JPY' for Japanese Yen, etc.
  final String code;

  /// The numeric code associated with the currency (3-digit code).
  ///
  /// This code is a unique identifier for the currency based on the ISO 4217 standard.
  /// For example, the numeric code for 'USD' is 840, for 'EUR' it is 978, etc.
  final int numCode;

  /// The number of decimal digits used in the currency.
  ///
  /// This specifies how many decimal places are used in the currency.
  /// For example, USD uses 2 digits (e.g., 1.00), while the Japanese Yen (JPY) uses 0 digits.
  final int digits;

  /// The full name of the currency.
  ///
  /// This is the full, common name of the currency. For example, 'United States Dollar',
  /// 'Euro', or 'Japanese Yen'.
  final String currencyName;

  /// A list of locations (countries or regions) that use this currency.
  ///
  /// This is a list of all countries or regions where the currency is used. For example,
  /// the United States Dollar (USD) is used in the United States, American Samoa, and the British Virgin Islands.
  final List<String> locations;

  /// Creates a new instance of ISO4217Currency.
  ///
  /// The constructor initializes the currency with the provided code, numeric code,
  /// decimal digits, currency name, and the list of locations.
  ///
  /// Example:
  /// ```dart
  /// final usd = ISO4217Currency(
  ///   code: 'USD',
  ///   numCode: 840,
  ///   digits: 2,
  ///   currencyName: 'United States Dollar',
  ///   locations: ['United States', 'American Samoa', 'British Virgin Islands'],
  /// );
  /// ```
  ISO4217Currency({
    required this.code,
    required this.numCode,
    required this.digits,
    required this.currencyName,
    required this.locations,
  });

  /// Returns a string representation of the currency.
  ///
  /// This method overrides the `toString` method to return a user-friendly string
  /// that provides the currency's code, numeric code, number of decimal digits,
  /// currency name, and the list of locations.
  ///
  /// Example:
  /// ```dart
  /// print(usd.toString()); // Output: ISO4217Currency(code: USD, numCode: 840, digits: 2, currencyName: United States Dollar, locations: [United States, American Samoa, British Virgin Islands])
  /// ```
  @override
  String toString() {
    return 'ISO4217Currency(code: $code, numCode: $numCode, digits: $digits, currencyName: $currencyName, locations: $locations)';
  }

  /// Retrieves a currency based on its ISO 4217 code.
  ///
  /// This static method searches through the list of available currencies and returns
  /// the corresponding `ISO4217Currency` object for the given code.
  /// If no currency is found with the provided code, `null` is returned.
  ///
  /// Example:
  /// ```dart
  /// var currency = ISO4217Currency.getCurrencyByCode('USD');
  /// print(currency); // Output: ISO4217Currency(code: USD, numCode: 840, digits: 2, currencyName: United States Dollar, locations: [United States, American Samoa, British Virgin Islands])
  /// ```
  ///
  /// - `code`: The ISO 4217 3-letter currency code (e.g., 'USD').
  /// - Returns: An `ISO4217Currency` object if found, or `null` if the currency does not exist.
  static Map<String, dynamic> getCurrencyByCode(String code) {
    final currencies = ISO4217CurrencyData.currencyData();
    try {
      final currency = currencies
          .firstWhere((ISO4217Currency currency) => currency.code == code);
      return currency.toJson();
    } catch (e) {
      return {};
    }
  }

  /// Retrieves a currency based on its ISO 4217 numeric code.
  ///
  /// This static method searches through the list of available currencies and returns
  /// the corresponding `ISO4217Currency` object for the given numeric code.
  /// If no currency is found with the provided numeric code, `null` is returned.
  ///
  /// Example:
  /// ```dart
  /// var currency = ISO4217Currency.getCurrencyByNumCode(840);
  /// print(currency); // Output: ISO4217Currency(code: USD, numCode: 840, digits: 2, currencyName: United States Dollar, locations: [United States, American Samoa, British Virgin Islands])
  /// ```
  ///
  /// - `numCode`: The ISO 4217 3-digit numeric currency code (e.g., 840 for USD).
  /// - Returns: An `ISO4217Currency` object if found, or `null` if the currency does not exist.
  static Map<String, dynamic> getCurrencyByNumCode(String code) {
    final currencies = ISO4217CurrencyData.currencyData();
    try {
      final numCode = int.parse(code);
      final currency = currencies.firstWhere(
          (ISO4217Currency currency) => currency.numCode == numCode);
      return currency.toJson();
    } catch (e) {
      return {};
    }
  }

  /// Creates an `ISO4217Currency` instance from an ISO 4217 3-letter currency code.
  ///
  /// The `code` parameter is expected to be a valid ISO 4217 3-letter currency code.
  factory ISO4217Currency.fromNumCodetoObject(String code) {
    final currenciesMap = getCurrencyByNumCode(code);
    return ISO4217Currency.fromJson(currenciesMap);
  }

  /// Converts an `ISO4217Currency` instance to a raw code string.
  ///
  /// The `code` parameter is expected to be a valid ISO 4217 3-letter currency code.
  String toRawNumCode() => numCode.toString();

  /// Creates an `ISO4217Currency` instance from a JSON object.
  ///
  /// The `json` map is expected to contain the necessary fields:
  /// - `code` (String)
  /// - `numCode` (int)
  /// - `digits` (int)
  /// - `currencyName` (String)
  /// - `locations` (List<String>)
  factory ISO4217Currency.fromJson(Map<String, dynamic> json) {
    return ISO4217Currency(
      code: json['code'],
      numCode: json['num_code'],
      digits: json['digits'],
      currencyName: json['currency_name'],
      locations: List<String>.from(json['locations']),
    );
  }

  /// Converts an `ISO4217Currency` instance to a JSON object.
  ///
  /// The returned map will contain the same fields as the constructor:
  /// - `code` (String)
  /// - `numCode` (int)
  /// - `digits` (int)
  /// - `currencyName` (String)
  /// - `locations` (List<String>)
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'num_code': numCode,
      'digits': digits,
      'currency_name': currencyName,
      'locations': locations,
    };
  }

  @visibleForTesting
  void logDebugingCurrency() {
      return toJson().toPrettyString().myLog();
  }
}
