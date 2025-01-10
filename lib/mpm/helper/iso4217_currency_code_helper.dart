// ignore_for_file: unintended_html_in_doc_comment

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
    final currencies = _currencyData();
    try {
      final currency =
          currencies.firstWhere((currency) => currency.code == code);
      return currency._toJson();
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
    final currencies = _currencyData();
    try {
      final numCode = int.parse(code);
      final currency =
          currencies.firstWhere((currency) => currency.numCode == numCode);
      return currency._toJson();
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
  Map<String, dynamic> _toJson() {
    return {
      'code': code,
      'num_code': numCode,
      'digits': digits,
      'currency_name': currencyName,
      'locations': locations,
    };
  }

  /// Provides a list of predefined currency data for testing or initialization.
  ///
  /// This is a static method that returns a list of example currencies that are hardcoded
  /// for the purpose of demonstration or testing.
  ///
  /// You can modify this list as necessary to include additional currencies.
  ///
  /// Lates Update: Thu, 09 January 2025
  static List<ISO4217Currency> _currencyData() {
    return [
      ISO4217Currency(
          code: 'AED',
          numCode: 784,
          digits: 2,
          currencyName: 'United Arab Emirates dirham',
          locations: ['United Arab Emirates']),
      ISO4217Currency(
          code: 'AFN',
          numCode: 971,
          digits: 2,
          currencyName: 'Afghan afghani',
          locations: ['Afghanistan']),
      ISO4217Currency(
          code: 'ALL',
          numCode: 8,
          digits: 2,
          currencyName: 'Albanian lek',
          locations: ['Albania']),
      ISO4217Currency(
          code: 'AMD',
          numCode: 51,
          digits: 2,
          currencyName: 'Armenian dram',
          locations: ['Armenia']),
      ISO4217Currency(
          code: 'ANG',
          numCode: 532,
          digits: 2,
          currencyName: 'Netherlands Antillean guilder',
          locations: ['Curaçao', 'Sint Maarten']),
      ISO4217Currency(
          code: 'AOA',
          numCode: 973,
          digits: 2,
          currencyName: 'Angolan kwanza',
          locations: ['Angola']),
      ISO4217Currency(
          code: 'ARS',
          numCode: 32,
          digits: 2,
          currencyName: 'Argentine peso',
          locations: ['Argentina']),
      ISO4217Currency(
          code: 'AUD',
          numCode: 36,
          digits: 2,
          currencyName: 'Australian dollar',
          locations: [
            'Australia',
            'Christmas Island',
            'Cocos (Keeling) Islands',
            'Heard Island and McDonald Islands',
            'Kiribati',
            'Nauru',
            'Norfolk Island',
            'Tuvalu'
          ]),
      ISO4217Currency(
          code: 'AWG',
          numCode: 533,
          digits: 2,
          currencyName: 'Aruban florin',
          locations: ['Aruba']),
      ISO4217Currency(
          code: 'AZN',
          numCode: 944,
          digits: 2,
          currencyName: 'Azerbaijani manat',
          locations: ['Azerbaijan']),
      ISO4217Currency(
          code: 'BAM',
          numCode: 977,
          digits: 2,
          currencyName: 'Bosnia and Herzegovina convertible mark',
          locations: ['Bosnia and Herzegovina']),
      ISO4217Currency(
          code: 'BBD',
          numCode: 52,
          digits: 2,
          currencyName: 'Barbados dollar',
          locations: ['Barbados']),
      ISO4217Currency(
          code: 'BDT',
          numCode: 50,
          digits: 2,
          currencyName: 'Bangladeshi taka',
          locations: ['Bangladesh']),
      ISO4217Currency(
          code: 'BGN',
          numCode: 975,
          digits: 2,
          currencyName: 'Bulgarian lev',
          locations: ['Bulgaria']),
      ISO4217Currency(
          code: 'BHD',
          numCode: 48,
          digits: 3,
          currencyName: 'Bahraini dinar',
          locations: ['Bahrain']),
      ISO4217Currency(
          code: 'BIF',
          numCode: 108,
          digits: 0,
          currencyName: 'Burundian franc',
          locations: ['Burundi']),
      ISO4217Currency(
          code: 'BMD',
          numCode: 60,
          digits: 2,
          currencyName: 'Bermudian dollar',
          locations: ['Bermuda']),
      ISO4217Currency(
          code: 'BND',
          numCode: 96,
          digits: 2,
          currencyName: 'Brunei dollar',
          locations: ['Brunei Darussalam']),
      ISO4217Currency(
          code: 'BOB',
          numCode: 68,
          digits: 2,
          currencyName: 'Boliviano',
          locations: ['Bolivia']),
      ISO4217Currency(
          code: 'BOV',
          numCode: 984,
          digits: 2,
          currencyName: 'Bolivian Mvdol (funds code)',
          locations: ['Bolivia']),
      ISO4217Currency(
          code: 'BRL',
          numCode: 986,
          digits: 2,
          currencyName: 'Brazilian real',
          locations: ['Brazil']),
      ISO4217Currency(
          code: 'BSD',
          numCode: 44,
          digits: 2,
          currencyName: 'Bahamian dollar',
          locations: ['Bahamas']),
      ISO4217Currency(
          code: 'BTN',
          numCode: 64,
          digits: 2,
          currencyName: 'Bhutanese ngultrum',
          locations: ['Bhutan']),
      ISO4217Currency(
          code: 'BWP',
          numCode: 72,
          digits: 2,
          currencyName: 'Botswana pula',
          locations: ['Botswana']),
      ISO4217Currency(
          code: 'BYN',
          numCode: 933,
          digits: 2,
          currencyName: 'Belarusian ruble',
          locations: ['Belarus']),
      ISO4217Currency(
          code: 'BZD',
          numCode: 84,
          digits: 2,
          currencyName: 'Belize dollar',
          locations: ['Belize']),
      ISO4217Currency(
          code: 'CAD',
          numCode: 124,
          digits: 2,
          currencyName: 'Canadian dollar',
          locations: ['Canada']),
      ISO4217Currency(
          code: 'CDF',
          numCode: 976,
          digits: 2,
          currencyName: 'Congolese franc',
          locations: ['Democratic Republic of the Congo']),
      ISO4217Currency(
          code: 'CHE',
          numCode: 947,
          digits: 2,
          currencyName: 'WIR euro (complementary currency)',
          locations: ['Switzerland']),
      ISO4217Currency(
          code: 'CHF',
          numCode: 756,
          digits: 2,
          currencyName: 'Swiss franc',
          locations: ['Switzerland', 'Liechtenstein']),
      ISO4217Currency(
          code: 'CHW',
          numCode: 948,
          digits: 2,
          currencyName: 'WIR franc (complementary currency)',
          locations: ['Switzerland']),
      ISO4217Currency(
          code: 'CLF',
          numCode: 990,
          digits: 4,
          currencyName: 'Unidad de Fomento (funds code)',
          locations: ['Chile']),
      ISO4217Currency(
          code: 'CLP',
          numCode: 152,
          digits: 0,
          currencyName: 'Chilean peso',
          locations: ['Chile']),
      ISO4217Currency(
          code: 'CNY',
          numCode: 156,
          digits: 2,
          currencyName: 'Renminbi',
          locations: ['China']),
      ISO4217Currency(
          code: 'COP',
          numCode: 170,
          digits: 2,
          currencyName: 'Colombian peso',
          locations: ['Colombia']),
      ISO4217Currency(
          code: 'COU',
          numCode: 970,
          digits: 2,
          currencyName: 'Unidad de Valor Real (UVR) (funds code)',
          locations: ['Colombia']),
      ISO4217Currency(
          code: 'CRC',
          numCode: 188,
          digits: 2,
          currencyName: 'Costa Rican colon',
          locations: ['Costa Rica']),
      ISO4217Currency(
          code: 'CUP',
          numCode: 192,
          digits: 2,
          currencyName: 'Cuban peso',
          locations: ['Cuba']),
      ISO4217Currency(
          code: 'CVE',
          numCode: 132,
          digits: 2,
          currencyName: 'Cape Verdean escudo',
          locations: ['Cabo Verde']),
      ISO4217Currency(
          code: 'CZK',
          numCode: 203,
          digits: 2,
          currencyName: 'Czech koruna',
          locations: ['Czechia']),
      ISO4217Currency(
          code: 'DJF',
          numCode: 262,
          digits: 0,
          currencyName: 'Djiboutian franc',
          locations: ['Djibouti']),
      ISO4217Currency(
          code: 'DKK',
          numCode: 208,
          digits: 2,
          currencyName: 'Danish krone',
          locations: ['Denmark', 'Faroe Islands', 'Greenland']),
      ISO4217Currency(
          code: 'DOP',
          numCode: 214,
          digits: 2,
          currencyName: 'Dominican peso',
          locations: ['Dominican Republic']),
      ISO4217Currency(
          code: 'DZD',
          numCode: 12,
          digits: 2,
          currencyName: 'Algerian dinar',
          locations: ['Algeria']),
      ISO4217Currency(
          code: 'EGP',
          numCode: 818,
          digits: 2,
          currencyName: 'Egyptian pound',
          locations: ['Egypt']),
      ISO4217Currency(
          code: 'ERN',
          numCode: 232,
          digits: 2,
          currencyName: 'Eritrean nakfa',
          locations: ['Eritrea']),
      ISO4217Currency(
          code: 'ETB',
          numCode: 230,
          digits: 2,
          currencyName: 'Ethiopian birr',
          locations: ['Ethiopia']),
      ISO4217Currency(
          code: 'EUR',
          numCode: 978,
          digits: 2,
          currencyName: 'Euro',
          locations: [
            'Åland Islands',
            'Andorra',
            'Austria',
            'Belgium',
            'Croatia',
            'Cyprus',
            'Estonia',
            'European Union',
            'Finland',
            'France',
            'French Guiana',
            'French Southern and Antarctic Lands',
            'Germany',
            'Greece',
            'Guadeloupe',
            'Ireland',
            'Italy',
            'Kosovo',
            'Latvia',
            'Lithuania',
            'Luxembourg',
            'Malta',
            'Martinique',
            'Mayotte',
            'Monaco',
            'Montenegro',
            'Netherlands',
            'Portugal',
            'Réunion',
            'Saint Barthélemy',
            'Saint Martin',
            'Saint Pierre and Miquelon',
            'San Marino',
            'Slovakia',
            'Slovenia',
            'Spain',
            'Vatican City'
          ]),
      ISO4217Currency(
          code: 'FJD',
          numCode: 242,
          digits: 2,
          currencyName: 'Fiji dollar',
          locations: ['Fiji']),
      ISO4217Currency(
          code: 'FKP',
          numCode: 238,
          digits: 2,
          currencyName: 'Falkland Islands pound',
          locations: ['Falkland Islands']),
      ISO4217Currency(
          code: 'GBP',
          numCode: 826,
          digits: 2,
          currencyName: 'Pound sterling',
          locations: ['United Kingdom']),
      ISO4217Currency(
          code: 'GEL',
          numCode: 981,
          digits: 2,
          currencyName: 'Georgian lari',
          locations: ['Georgia']),
      ISO4217Currency(
          code: 'GHS',
          numCode: 288,
          digits: 2,
          currencyName: 'Ghanaian cedi',
          locations: ['Ghana']),
      ISO4217Currency(
          code: 'GIP',
          numCode: 292,
          digits: 2,
          currencyName: 'Gibraltar pound',
          locations: ['Gibraltar']),
      ISO4217Currency(
          code: 'GMD',
          numCode: 270,
          digits: 2,
          currencyName: 'Gambian dalasi',
          locations: ['Gambia']),
      ISO4217Currency(
          code: 'GNF',
          numCode: 324,
          digits: 0,
          currencyName: 'Guinean franc',
          locations: ['Guinea']),
      ISO4217Currency(
          code: 'GTQ',
          numCode: 320,
          digits: 2,
          currencyName: 'Guatemalan quetzal',
          locations: ['Guatemala']),
      ISO4217Currency(
          code: 'GYD',
          numCode: 328,
          digits: 2,
          currencyName: 'Guyanese dollar',
          locations: ['Guyana']),
      ISO4217Currency(
          code: 'HKD',
          numCode: 344,
          digits: 2,
          currencyName: 'Hong Kong dollar',
          locations: ['Hong Kong']),
      ISO4217Currency(
          code: 'HNL',
          numCode: 340,
          digits: 2,
          currencyName: 'Honduran lempira',
          locations: ['Honduras']),
      ISO4217Currency(
          code: 'HRK',
          numCode: 191,
          digits: 2,
          currencyName: 'Croatian kuna',
          locations: ['Croatia']),
      ISO4217Currency(
          code: 'HTG',
          numCode: 332,
          digits: 2,
          currencyName: 'Haitian gourde',
          locations: ['Haiti']),
      ISO4217Currency(
          code: 'HUF',
          numCode: 348,
          digits: 2,
          currencyName: 'Hungarian forint',
          locations: ['Hungary']),
      ISO4217Currency(
          code: 'IDR',
          numCode: 360,
          digits: 2,
          currencyName: 'Indonesian rupiah',
          locations: ['Indonesia']),
      ISO4217Currency(
          code: 'ILS',
          numCode: 376,
          digits: 2,
          currencyName: 'Israeli new shekel',
          locations: ['Israel']),
      ISO4217Currency(
          code: 'INR',
          numCode: 356,
          digits: 2,
          currencyName: 'Indian rupee',
          locations: ['India']),
      ISO4217Currency(
          code: 'IQD',
          numCode: 368,
          digits: 3,
          currencyName: 'Iraqi dinar',
          locations: ['Iraq']),
      ISO4217Currency(
          code: 'IRR',
          numCode: 364,
          digits: 2,
          currencyName: 'Iranian rial',
          locations: ['Iran']),
      ISO4217Currency(
          code: 'ISK',
          numCode: 352,
          digits: 0,
          currencyName: 'Icelandic króna',
          locations: ['Iceland']),
      ISO4217Currency(
          code: 'JMD',
          numCode: 388,
          digits: 2,
          currencyName: 'Jamaican dollar',
          locations: ['Jamaica']),
      ISO4217Currency(
          code: 'JOD',
          numCode: 400,
          digits: 3,
          currencyName: 'Jordanian dinar',
          locations: ['Jordan']),
      ISO4217Currency(
          code: 'JPY',
          numCode: 392,
          digits: 0,
          currencyName: 'Japanese yen',
          locations: ['Japan']),
      ISO4217Currency(
          code: 'KES',
          numCode: 404,
          digits: 2,
          currencyName: 'Kenyan shilling',
          locations: ['Kenya']),
      ISO4217Currency(
          code: 'KGS',
          numCode: 417,
          digits: 2,
          currencyName: 'Kyrgyzstani som',
          locations: ['Kyrgyzstan']),
      ISO4217Currency(
          code: 'KHR',
          numCode: 116,
          digits: 2,
          currencyName: 'Cambodian riel',
          locations: ['Cambodia']),
      ISO4217Currency(
          code: 'KMF',
          numCode: 174,
          digits: 0,
          currencyName: 'Comorian franc',
          locations: ['Comoros']),
      ISO4217Currency(
          code: 'KRW',
          numCode: 410,
          digits: 0,
          currencyName: 'South Korean won',
          locations: ['Republic of Korea']),
      ISO4217Currency(
          code: 'KWD',
          numCode: 414,
          digits: 3,
          currencyName: 'Kuwaiti dinar',
          locations: ['Kuwait']),
      ISO4217Currency(
          code: 'KYD',
          numCode: 136,
          digits: 2,
          currencyName: 'Cayman Islands dollar',
          locations: ['Cayman Islands']),
      ISO4217Currency(
          code: 'KZT',
          numCode: 398,
          digits: 2,
          currencyName: 'Kazakhstani tenge',
          locations: ['Kazakhstan']),
      ISO4217Currency(
          code: 'LAK',
          numCode: 418,
          digits: 2,
          currencyName: 'Lao kip',
          locations: ['Laos']),
      ISO4217Currency(
          code: 'LBP',
          numCode: 422,
          digits: 0,
          currencyName: 'Lebanese pound',
          locations: ['Lebanon']),
      ISO4217Currency(
          code: 'LKR',
          numCode: 144,
          digits: 2,
          currencyName: 'Sri Lankan rupee',
          locations: ['Sri Lanka']),
      ISO4217Currency(
          code: 'LRD',
          numCode: 430,
          digits: 2,
          currencyName: 'Liberian dollar',
          locations: ['Liberia']),
      ISO4217Currency(
          code: 'LSL',
          numCode: 426,
          digits: 2,
          currencyName: 'Lesotho loti',
          locations: ['Lesotho']),
      ISO4217Currency(
          code: 'LTL',
          numCode: 440,
          digits: 2,
          currencyName: 'Lithuanian litas',
          locations: ['Lithuania']),
      ISO4217Currency(
          code: 'LTT',
          numCode: 438,
          digits: 2,
          currencyName: 'Lithuanian talonas',
          locations: ['Lithuania']),
      ISO4217Currency(
          code: 'LUC',
          numCode: 989,
          digits: 2,
          currencyName: 'Luxembourg convertible franc',
          locations: ['Luxembourg']),
      ISO4217Currency(
          code: 'LUF',
          numCode: 442,
          digits: 0,
          currencyName: 'Luxembourg franc',
          locations: ['Luxembourg']),
      ISO4217Currency(
          code: 'LVL',
          numCode: 428,
          digits: 2,
          currencyName: 'Latvian lats',
          locations: ['Latvia']),
      ISO4217Currency(
          code: 'LYD',
          numCode: 434,
          digits: 3,
          currencyName: 'Libyan dinar',
          locations: ['Libya']),
      ISO4217Currency(
          code: 'MAD',
          numCode: 504,
          digits: 2,
          currencyName: 'Moroccan dirham',
          locations: ['Morocco']),
      ISO4217Currency(
          code: 'MAF',
          numCode: 950,
          digits: 0,
          currencyName: 'Moroccan franc (funds code)',
          locations: ['Morocco']),
      ISO4217Currency(
          code: 'MDL',
          numCode: 498,
          digits: 2,
          currencyName: 'Moldovan leu',
          locations: ['Moldova']),
      ISO4217Currency(
          code: 'MGA',
          numCode: 969,
          digits: 2,
          currencyName: 'Malagasy ariary',
          locations: ['Madagascar']),
      ISO4217Currency(
          code: 'MKD',
          numCode: 807,
          digits: 2,
          currencyName: 'Macedonian denar',
          locations: ['North Macedonia']),
      ISO4217Currency(
          code: 'MMK',
          numCode: 104,
          digits: 2,
          currencyName: 'Myanmar kyat',
          locations: ['Myanmar']),
      ISO4217Currency(
          code: 'MNT',
          numCode: 496,
          digits: 2,
          currencyName: 'Mongolian tugrik',
          locations: ['Mongolia']),
      ISO4217Currency(
          code: 'MOP',
          numCode: 446,
          digits: 2,
          currencyName: 'Macanese pataca',
          locations: ['Macao']),
      ISO4217Currency(
          code: 'MRU',
          numCode: 504,
          digits: 2,
          currencyName: 'Mauritanian ouguiya',
          locations: ['Mauritania']),
      ISO4217Currency(
          code: 'MUR',
          numCode: 480,
          digits: 2,
          currencyName: 'Mauritian rupee',
          locations: ['Mauritius']),
      ISO4217Currency(
          code: 'MWK',
          numCode: 454,
          digits: 2,
          currencyName: 'Malawian kwacha',
          locations: ['Malawi']),
      ISO4217Currency(
          code: 'MXN',
          numCode: 484,
          digits: 2,
          currencyName: 'Mexican peso',
          locations: ['Mexico']),
      ISO4217Currency(
          code: 'MYR',
          numCode: 458,
          digits: 2,
          currencyName: 'Malaysian ringgit',
          locations: ['Malaysia']),
      ISO4217Currency(
          code: 'MZN',
          numCode: 943,
          digits: 2,
          currencyName: 'Mozambican metical',
          locations: ['Mozambique']),
      ISO4217Currency(
          code: 'NAD',
          numCode: 516,
          digits: 2,
          currencyName: 'Namibian dollar',
          locations: ['Namibia']),
      ISO4217Currency(
          code: 'NGN',
          numCode: 566,
          digits: 2,
          currencyName: 'Nigerian naira',
          locations: ['Nigeria']),
      ISO4217Currency(
          code: 'NIO',
          numCode: 558,
          digits: 2,
          currencyName: 'Nicaraguan córdoba',
          locations: ['Nicaragua']),
      ISO4217Currency(
          code: 'NOK',
          numCode: 578,
          digits: 2,
          currencyName: 'Norwegian krone',
          locations: ['Norway', 'Svalbard', 'Jan Mayen']),
      ISO4217Currency(
          code: 'NPR',
          numCode: 524,
          digits: 2,
          currencyName: 'Nepalese rupee',
          locations: ['Nepal']),
      ISO4217Currency(
          code: 'NZD',
          numCode: 554,
          digits: 2,
          currencyName: 'New Zealand dollar',
          locations: [
            'New Zealand',
            'Cook Islands',
            'Niue',
            'Tokelau',
            'Wallis and Futuna'
          ]),
      ISO4217Currency(
          code: 'OMR',
          numCode: 512,
          digits: 3,
          currencyName: 'Omani rial',
          locations: ['Oman']),
      ISO4217Currency(
          code: 'PAB',
          numCode: 590,
          digits: 2,
          currencyName: 'Panamanian balboa',
          locations: ['Panama']),
      ISO4217Currency(
          code: 'PEN',
          numCode: 604,
          digits: 2,
          currencyName: 'Peruvian nuevo sol',
          locations: ['Peru']),
      ISO4217Currency(
          code: 'PGK',
          numCode: 598,
          digits: 2,
          currencyName: 'Papua New Guinean kina',
          locations: ['Papua New Guinea']),
      ISO4217Currency(
          code: 'PHP',
          numCode: 608,
          digits: 2,
          currencyName: 'Philippine peso',
          locations: ['Philippines']),
      ISO4217Currency(
          code: 'PKR',
          numCode: 586,
          digits: 2,
          currencyName: 'Pakistani rupee',
          locations: ['Pakistan']),
      ISO4217Currency(
          code: 'PLN',
          numCode: 985,
          digits: 2,
          currencyName: 'Polish złoty',
          locations: ['Poland']),
      ISO4217Currency(
          code: 'PGK',
          numCode: 598,
          digits: 2,
          currencyName: 'Papua New Guinean kina',
          locations: ['Papua New Guinea']),
      ISO4217Currency(
          code: 'PAB',
          numCode: 590,
          digits: 2,
          currencyName: 'Panamanian balboa',
          locations: ['Panama']),
      ISO4217Currency(
        code: 'PEN',
        numCode: 604,
        digits: 2,
        currencyName: 'Peruvian sol',
        locations: ['Peru'],
      ),
      ISO4217Currency(
        code: 'PGK',
        numCode: 598,
        digits: 2,
        currencyName: 'Papua New Guinean kina',
        locations: ['Papua New Guinea'],
      ),
      ISO4217Currency(
        code: 'PHP',
        numCode: 608,
        digits: 2,
        currencyName: 'Philippine peso',
        locations: ['Philippines'],
      ),
      ISO4217Currency(
        code: 'PKR',
        numCode: 586,
        digits: 2,
        currencyName: 'Pakistani rupee',
        locations: ['Pakistan'],
      ),
      ISO4217Currency(
        code: 'PLN',
        numCode: 985,
        digits: 2,
        currencyName: 'Polish złoty',
        locations: ['Poland'],
      ),
      ISO4217Currency(
        code: 'PYG',
        numCode: 600,
        digits: 0,
        currencyName: 'Paraguayan guaraní',
        locations: ['Paraguay'],
      ),
      ISO4217Currency(
        code: 'QAR',
        numCode: 634,
        digits: 2,
        currencyName: 'Qatari riyal',
        locations: ['Qatar'],
      ),
      ISO4217Currency(
        code: 'RON',
        numCode: 946,
        digits: 2,
        currencyName: 'Romanian leu',
        locations: ['Romania'],
      ),
      ISO4217Currency(
        code: 'RSD',
        numCode: 941,
        digits: 2,
        currencyName: 'Serbian dinar',
        locations: ['Serbia'],
      ),
      ISO4217Currency(
        code: 'RUB',
        numCode: 643,
        digits: 2,
        currencyName: 'Russian ruble',
        locations: ['Russia'],
      ),
      ISO4217Currency(
        code: 'RWF',
        numCode: 646,
        digits: 0,
        currencyName: 'Rwandan franc',
        locations: ['Rwanda'],
      ),
      ISO4217Currency(
        code: 'SAR',
        numCode: 682,
        digits: 2,
        currencyName: 'Saudi riyal',
        locations: ['Saudi Arabia'],
      ),
      ISO4217Currency(
        code: 'SBD',
        numCode: 90,
        digits: 2,
        currencyName: 'Solomon Islands dollar',
        locations: ['Solomon Islands'],
      ),
      ISO4217Currency(
        code: 'SCR',
        numCode: 690,
        digits: 2,
        currencyName: 'Seychelles rupee',
        locations: ['Seychelles'],
      ),
      ISO4217Currency(
        code: 'SDG',
        numCode: 938,
        digits: 2,
        currencyName: 'Sudanese pound',
        locations: ['Sudan'],
      ),
      ISO4217Currency(
        code: 'SEK',
        numCode: 752,
        digits: 2,
        currencyName: 'Swedish krona',
        locations: ['Sweden'],
      ),
      ISO4217Currency(
        code: 'SGD',
        numCode: 702,
        digits: 2,
        currencyName: 'Singapore dollar',
        locations: ['Singapore'],
      ),
      ISO4217Currency(
        code: 'SHP',
        numCode: 654,
        digits: 2,
        currencyName: 'Saint Helena pound',
        locations: ['Saint Helena', 'Ascension Island'],
      ),
      ISO4217Currency(
        code: 'SLE',
        numCode: 925,
        digits: 2,
        currencyName: 'Sierra Leonean leone',
        locations: ['Sierra Leone'],
      ),
      ISO4217Currency(
        code: 'SOS',
        numCode: 706,
        digits: 2,
        currencyName: 'Somalian shilling',
        locations: ['Somalia'],
      ),
      ISO4217Currency(
        code: 'SRD',
        numCode: 968,
        digits: 2,
        currencyName: 'Surinamese dollar',
        locations: ['Suriname'],
      ),
      ISO4217Currency(
        code: 'SSP',
        numCode: 728,
        digits: 2,
        currencyName: 'South Sudanese pound',
        locations: ['South Sudan'],
      ),
      ISO4217Currency(
        code: 'STN',
        numCode: 930,
        digits: 2,
        currencyName: 'São Tomé and Príncipe dobra',
        locations: ['São Tomé and Príncipe'],
      ),
      ISO4217Currency(
        code: 'SVC',
        numCode: 222,
        digits: 2,
        currencyName: 'Salvadoran colón',
        locations: ['El Salvador'],
      ),
      ISO4217Currency(
        code: 'SYP',
        numCode: 760,
        digits: 2,
        currencyName: 'Syrian pound',
        locations: ['Syria'],
      ),
      ISO4217Currency(
        code: 'SZL',
        numCode: 748,
        digits: 2,
        currencyName: 'Swazi lilangeni',
        locations: ['Eswatini'],
      ),
      ISO4217Currency(
        code: 'THB',
        numCode: 764,
        digits: 2,
        currencyName: 'Thai baht',
        locations: ['Thailand'],
      ),
      ISO4217Currency(
        code: 'TJS',
        numCode: 972,
        digits: 2,
        currencyName: 'Tajikistani somoni',
        locations: ['Tajikistan'],
      ),
      ISO4217Currency(
        code: 'TMT',
        numCode: 934,
        digits: 2,
        currencyName: 'Turkmenistan manat',
        locations: ['Turkmenistan'],
      ),
      ISO4217Currency(
        code: 'TND',
        numCode: 788,
        digits: 3,
        currencyName: 'Tunisian dinar',
        locations: ['Tunisia'],
      ),
      ISO4217Currency(
        code: 'TOP',
        numCode: 776,
        digits: 2,
        currencyName: 'Tongan paʻanga',
        locations: ['Tonga'],
      ),
      ISO4217Currency(
        code: 'TRY',
        numCode: 949,
        digits: 2,
        currencyName: 'Turkish lira',
        locations: ['Türkiye'],
      ),
      ISO4217Currency(
        code: 'TTD',
        numCode: 780,
        digits: 2,
        currencyName: 'Trinidad and Tobago dollar',
        locations: ['Trinidad and Tobago'],
      ),
      ISO4217Currency(
        code: 'TWD',
        numCode: 901,
        digits: 2,
        currencyName: 'New Taiwan dollar',
        locations: ['Taiwan'],
      ),
      ISO4217Currency(
        code: 'TZS',
        numCode: 834,
        digits: 2,
        currencyName: 'Tanzanian shilling',
        locations: ['Tanzania'],
      ),
      ISO4217Currency(
        code: 'UAH',
        numCode: 980,
        digits: 2,
        currencyName: 'Ukrainian hryvnia',
        locations: ['Ukraine'],
      ),
      ISO4217Currency(
        code: 'UGX',
        numCode: 800,
        digits: 0,
        currencyName: 'Ugandan shilling',
        locations: ['Uganda'],
      ),
      ISO4217Currency(
        code: 'USD',
        numCode: 840,
        digits: 2,
        currencyName: 'United States dollar',
        locations: [
          'United States',
          'American Samoa',
          'British Indian Ocean Territory',
          'British Virgin Islands',
          'Bonaire, Sint Eustatius and Saba',
          'Ecuador',
          'El Salvador',
          'Guam',
          'Marshall Islands',
          'Federated States of Micronesia',
          'Northern Mariana Islands',
          'Palau',
          'Panama',
          'Puerto Rico',
          'Timor-Leste',
          'Turks and Caicos Islands',
          'U.S. Virgin Islands',
          'United States Minor Outlying Islands'
        ],
      ),
      ISO4217Currency(
        code: 'USN',
        numCode: 997,
        digits: 2,
        currencyName: 'United States dollar (next day) (funds code)',
        locations: ['United States'],
      ),
      ISO4217Currency(
        code: 'UYI',
        numCode: 940,
        digits: 0,
        currencyName: 'Uruguay Peso en Unidades Indexadas (funds code)',
        locations: ['Uruguay'],
      ),
      ISO4217Currency(
        code: 'UYU',
        numCode: 858,
        digits: 2,
        currencyName: 'Uruguayan peso',
        locations: ['Uruguay'],
      ),
      ISO4217Currency(
        code: 'UYW',
        numCode: 927,
        digits: 4,
        currencyName: 'Unidad previsional',
        locations: ['Uruguay'],
      ),
      ISO4217Currency(
        code: 'UZS',
        numCode: 860,
        digits: 2,
        currencyName: 'Uzbekistani sum',
        locations: ['Uzbekistan'],
      ),
      ISO4217Currency(
        code: 'VED',
        numCode: 926,
        digits: 2,
        currencyName: 'Venezuelan digital bolívar',
        locations: ['Venezuela'],
      ),
      ISO4217Currency(
        code: 'VES',
        numCode: 928,
        digits: 2,
        currencyName: 'Venezuelan sovereign bolívar',
        locations: ['Venezuela'],
      ),
      ISO4217Currency(
        code: 'VND',
        numCode: 704,
        digits: 0,
        currencyName: 'Vietnamese đồng',
        locations: ['Vietnam'],
      ),
      ISO4217Currency(
        code: 'VUV',
        numCode: 548,
        digits: 0,
        currencyName: 'Vanuatu vatu',
        locations: ['Vanuatu'],
      ),
      ISO4217Currency(
        code: 'WST',
        numCode: 882,
        digits: 2,
        currencyName: 'Samoan tala',
        locations: ['Samoa'],
      ),
      ISO4217Currency(
        code: 'XAF',
        numCode: 950,
        digits: 0,
        currencyName: 'CFA franc BEAC',
        locations: [
          'Cameroon',
          'Central African Republic',
          'Republic of the Congo',
          'Chad',
          'Equatorial Guinea',
          'Gabon'
        ],
      ),
      ISO4217Currency(
        code: 'XAG',
        numCode: 961,
        digits: 0,
        currencyName: 'Silver (one troy ounce)',
        locations: [],
      ),
      ISO4217Currency(
        code: 'XAU',
        numCode: 959,
        digits: 0,
        currencyName: 'Gold (one troy ounce)',
        locations: [],
      ),
      ISO4217Currency(
        code: 'XBA',
        numCode: 955,
        digits: 0,
        currencyName: 'European Composite Unit (EURCO)',
        locations: [],
      ),
      ISO4217Currency(
        code: 'XBB',
        numCode: 956,
        digits: 0,
        currencyName: 'European Monetary Unit (E.M.U.-6) (bond market unit)',
        locations: [],
      ),
      ISO4217Currency(
        code: 'XBC',
        numCode: 957,
        digits: 0,
        currencyName:
            'European Unit of Account 9 (E.U.A.-9) (bond market unit)',
        locations: [],
      ),
      ISO4217Currency(
        code: 'XBD',
        numCode: 958,
        digits: 0,
        currencyName:
            'European Unit of Account 17 (E.U.A.-17) (bond market unit)',
        locations: [],
      ),
      ISO4217Currency(
        code: 'XCD',
        numCode: 951,
        digits: 2,
        currencyName: 'East Caribbean dollar',
        locations: [
          'Anguilla',
          'Antigua and Barbuda',
          'Dominica',
          'Grenada',
          'Montserrat',
          'Saint Kitts and Nevis',
          'Saint Lucia',
          'Saint Vincent and the Grenadines'
        ],
      ),
      ISO4217Currency(
        code: 'XDR',
        numCode: 960,
        digits: 0,
        currencyName: 'Special drawing rights',
        locations: ['International Monetary Fund'],
      ),
      ISO4217Currency(
        code: 'XOF',
        numCode: 952,
        digits: 0,
        currencyName: 'CFA franc BCEAO',
        locations: [
          'Benin',
          'Burkina Faso',
          'Côte d\'Ivoire',
          'Guinea-Bissau',
          'Mali',
          'Niger',
          'Senegal',
          'Togo'
        ],
      ),
      ISO4217Currency(
        code: 'XPD',
        numCode: 964,
        digits: 0,
        currencyName: 'Palladium (one troy ounce)',
        locations: [],
      ),
      ISO4217Currency(
        code: 'XPF',
        numCode: 953,
        digits: 0,
        currencyName: 'CFP franc (franc Pacifique)',
        locations: ['French Polynesia', 'New Caledonia', 'Wallis and Futuna'],
      ),
      ISO4217Currency(
        code: 'XPT',
        numCode: 962,
        digits: 0,
        currencyName: 'Platinum (one troy ounce)',
        locations: [],
      ),
      ISO4217Currency(
        code: 'XSU',
        numCode: 994,
        digits: 0,
        currencyName: 'SUCRE',
        locations: ['Unified System for Regional Compensation (SUCRE)'],
      ),
      ISO4217Currency(
        code: 'XTS',
        numCode: 963,
        digits: 0,
        currencyName: 'Code reserved for testing',
        locations: [],
      ),
      ISO4217Currency(
        code: 'XUA',
        numCode: 965,
        digits: 0,
        currencyName: 'ADB Unit of Account',
        locations: ['African Development Bank'],
      ),
      ISO4217Currency(
        code: 'XXX',
        numCode: 999,
        digits: 0,
        currencyName: 'No currency',
        locations: [],
      ),
      ISO4217Currency(
        code: 'YER',
        numCode: 886,
        digits: 2,
        currencyName: 'Yemeni rial',
        locations: ['Yemen'],
      ),
      ISO4217Currency(
        code: 'ZAR',
        numCode: 710,
        digits: 2,
        currencyName: 'South African rand',
        locations: ['South Africa', 'Eswatini', 'Lesotho', 'Namibia'],
      ),
      ISO4217Currency(
        code: 'ZMW',
        numCode: 967,
        digits: 2,
        currencyName: 'Zambian kwacha',
        locations: ['Zambia'],
      ),
      ISO4217Currency(
        code: 'ZWG',
        numCode: 924,
        digits: 2,
        currencyName: 'Zimbabwe Gold',
        locations: ['Zimbabwe'],
      ),
    ];
  }
}
