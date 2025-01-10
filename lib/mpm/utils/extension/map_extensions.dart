import 'dart:convert';

extension MapToString on Map<String, dynamic> {
  String toPrettyString() {
    return isNotEmpty ? JsonEncoder.withIndent('  ').convert(this) : '{}';
  }
}
