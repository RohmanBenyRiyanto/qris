import 'package:flutter_qris/qris.dart';

extension LuhnAlgorithmExtension on String {
  int calculateMod10({bool verbose = false}) {
    final modSum = computeMod10Sum(verbose: verbose);
    final result = modSum % 10;

    if (verbose) {
      '----------------------------------------'.myLog();
      'calculateMod10: $modSum % 10 = $result'.myLog();
      '----------------------------------------'.myLog();
    }

    return result;
  }

  int computeMod10Sum({bool verbose = false}) {
    if (RegExp(r'\D').hasMatch(this)) {
      throw ArgumentError.value(
          this, 'String', 'is not a valid numeric string');
    }

    final length = this.length;
    int sum = 0;
    bool doubleDigit = false;

    if (verbose) {
      '----------------------------------------'.myLog();
      'Processing PAN: $this'.myLog();
      '----------------------------------------'.myLog();
      '| Index | Digit | Processed | Sum      |'.myLog();
      '|-------|-------|-----------|----------|'.myLog();
    }

    for (int i = length - 1; i >= 0; i--) {
      final digit = int.parse(this[i]);
      int processedDigit = digit;

      if (doubleDigit) {
        processedDigit *= 2;
        if (processedDigit > 9) {
          processedDigit -= 9;
        }
      }

      sum += processedDigit;
      doubleDigit = !doubleDigit;

      if (verbose) {
        '| ${i.toString().padLeft(5)} | ${digit.toString().padLeft(5)} | ${processedDigit.toString().padLeft(9)} | ${sum.toString().padLeft(8)} |'
            .myLog();
      }
    }

    if (verbose) {}

    return sum;
  }
}
