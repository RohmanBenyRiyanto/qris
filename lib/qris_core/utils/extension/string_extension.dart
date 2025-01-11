import 'package:flutter/foundation.dart';

extension StringExtensionLog on String? {
  void myLog() {
    if (kDebugMode) {
      debugPrint(this);
    }
  }
}
