import 'package:flutter/foundation.dart';

extension StringExtensionLog on String? {
  void qrLog() {
    if (kDebugMode) {
      debugPrint(this);
    }
  }
}
