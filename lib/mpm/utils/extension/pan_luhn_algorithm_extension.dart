import 'package:flutter/foundation.dart';

/// Extension to implement the Luhn Algorithm (Mod 10) for numeric strings.
///
/// The Luhn Algorithm, also known as Modulus 10 or Mod 10, is a simple checksum formula
/// used to validate identification numbers such as credit card numbers.
///
/// Reference: [Luhn Algorithm](https://en.wikipedia.org/wiki/Luhn_algorithm)
extension PanLuhnAlgorithmExtension on String {
  /// Computes the Modulus 10 (Mod 10) checksum of the string.
  ///
  /// ### Parameters:
  /// - `verbose`: (Optional) If `true`, prints debug information about the computation.
  ///
  /// ### Returns:
  /// - The checksum modulo 10 (an integer between 0 and 9).
  ///
  /// ### Example:
  /// ```dart
  /// final checksum = '7992739871'.getMod10();
  /// print(checksum); // Output: 3
  /// ```
  int getMod10({bool verbose = false}) {
    final modSum = getMod10Sum(verbose: verbose);
    final result = modSum % 10;

    if (verbose) {
      debugPrint('getMod10: $modSum % 10 = $result');
    }

    return result;
  }

  /// Computes the sum of digits according to the Luhn Algorithm.
  ///
  /// ### Parameters:
  /// - `verbose`: (Optional) If `true`, prints debug information about the computation process.
  ///
  /// ### Returns:
  /// - The computed sum as an integer.
  ///
  /// ### Throws:
  /// - `ArgumentError` if the string contains non-numeric characters.
  ///
  /// ### Example:
  /// ```dart
  /// final sum = '7992739871'.getMod10Sum();
  /// print(sum); // Output: 67
  /// ```
  int getMod10Sum({bool verbose = false}) {
    // Validate that the string contains only numeric characters.
    if (RegExp(r'\D').hasMatch(this)) {
      throw ArgumentError.value(
          this, 'String', 'is not a valid numeric string');
    }

    final length = this.length;
    int sum = 0;
    bool multiply = true;

    // Buffers for debugging information (optional).
    StringBuffer? debugBuffer;
    List<int>? debugValues;

    if (verbose) {
      debugBuffer = StringBuffer();
      debugValues = [];
    }

    // Traverse the string from right to left.
    for (int i = length - 1; i >= 0; i--) {
      final digit = int.parse(this[i]);
      final product = multiply ? 2 * digit : digit;
      final adjusted = product > 9 ? product - 9 : product;

      sum += adjusted;

      if (verbose) {
        debugValues?.add(adjusted);
      }

      // Toggle multiplication for every other digit.
      multiply = !multiply; 
    }

    if (verbose && debugBuffer != null && debugValues != null) {
      debugBuffer.write(debugValues.reversed.join(' + '));
      debugBuffer.write(' = $sum');
      debugPrint('Mod 10 calculation for $this: $debugBuffer');
    }

    return sum;
  }
}
