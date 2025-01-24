import 'package:flutter_qris/qris.dart';

extension Logger on String {
  bool isValidPAN({bool verbose = false, checkLuhn = true}) {
    String pan = this;
    int? digits;

    if (checkLuhn) {
      digits = pan.calculateCheckDigit();
      pan = pan + digits.toString();
    }

    // Log the start of the validation
    if (verbose) {
      '----------------------------------------'.myLog();
      'Starting PAN validation for: $pan'.myLog();
      '----------------------------------------'.myLog();
      '| Index | Digit | Processed | Sum      |'.myLog();
      '|-------|-------|-----------|----------|'.myLog();
    }

    if (!RegExp(r'^\d+$').hasMatch(pan)) {
      return false;
    }

    int sum = 0;
    bool isSecondDigit = false;

    for (int i = length - 1; i >= 0; i--) {
      int digit = int.parse(pan[i]);
      int processedDigit = digit;

      if (isSecondDigit) {
        processedDigit *= 2;
        if (processedDigit > 9) {
          processedDigit -= 9;
        }
      }

      sum += processedDigit;

      if (verbose) {
        '| ${i.toString().padLeft(5)} | ${digit.toString().padLeft(5)} | ${processedDigit.toString().padLeft(9)} | ${sum.toString().padLeft(8)} |'
            .myLog();
      }

      isSecondDigit = !isSecondDigit;
    }

    bool isValid = sum % 10 == 0;
    if (verbose) {
      '----------------------------------------'.myLog();
      'PAN Validation Result: ${isValid ? 'Valid' : 'Invalid'}'.myLog();
      '----------------------------------------'.myLog();
    }

    return isValid;
  }

  int calculateCheckDigit({bool verbose = false}) {
    if (verbose) {
      '----------------------------------------'.myLog();
      'Calculating Check Digit for: $this'.myLog();
      '----------------------------------------'.myLog();
      '| Index | Digit | Processed | Sum      |'.myLog();
      '|-------|-------|-----------|----------|'.myLog();
    }

    if (!RegExp(r'^\d+$').hasMatch(this)) {
      throw ArgumentError("PAN number must contain only digits.");
    }

    int sum = 0;
    bool isSecondDigit = true;

    for (int i = length - 1; i >= 0; i--) {
      int digit = int.parse(this[i]);
      int processedDigit = digit;

      if (isSecondDigit) {
        processedDigit *= 2;
        if (processedDigit > 9) {
          processedDigit -= 9;
        }
      }

      sum += processedDigit;

      if (verbose) {
        '| ${i.toString().padLeft(5)} | ${digit.toString().padLeft(5)} | ${processedDigit.toString().padLeft(9)} | ${sum.toString().padLeft(8)} |'
            .myLog();
      }

      isSecondDigit = !isSecondDigit;
    }

    int checkDigit = (10 - (sum % 10)) % 10;

    if (verbose) {
      '----------------------------------------'.myLog();
      'calculateMod10: $sum % 10 = $checkDigit'.myLog();
      '----------------------------------------'.myLog();
    }

    return checkDigit;
  }
}
