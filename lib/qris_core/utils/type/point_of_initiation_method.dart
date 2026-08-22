import '../../constant.dart';

/// Enum representing the Point of Initiation Method.
///
/// - `static`: Represents a static QR code.
/// - `dynamic`: Represents a dynamic QR code.
/// - `unknown`: Represents an unknown QR code.
enum PointOfInitiationMethod { static, dynamic, unknown }

/// Extension for [PointOfInitiationMethod] providing additional utilities.
extension PointOfInitiationMethodExtension on PointOfInitiationMethod {
  /// Retrieves the name of the enumeration value as a string.
  String get name => toString().split('.').last;

  /// Checks if the method is `static`.
  bool get isStatic => this == PointOfInitiationMethod.static;

  /// Checks if the method is `dynamic`.
  bool get isDynamic => this == PointOfInitiationMethod.dynamic;

  /// Checks if the method is `unknown`.
  bool get isUnknown => this == PointOfInitiationMethod.unknown;

  /// Converts the method to its raw representation (`11` for static, `12` for dynamic).
  ///
  /// ### Returns:
  /// - `"11"` if the method is static.
  /// - `"12"` if the method is dynamic.
  String toRAWPointOfInitiationMethod() {
    switch (this) {
      case PointOfInitiationMethod.static:
        return '11';
      case PointOfInitiationMethod.dynamic:
        return '12';
      default:
        return '';
    }
  }
}

/// Extension for [String] to handle raw Point of Initiation Method values.
extension PointOfInitiationMethodExtensionString on String? {
  /// Converts the raw representation (`"11"` or `"12"`) to a descriptive string.
  ///
  /// ### Returns:
  /// - A constant value from [Constant.static] or [Constant.dynamic].
  /// - The original string if the raw value is unrecognized.
  String fromRAWPointOfInitiationMethodToString() {
    switch (this) {
      case '11':
        return Constant.static;
      case '12':
        return Constant.dynamic;
      default:
        return this ?? '';
    }
  }

  /// Converts the raw representation (`"11"` or `"12"`) to a [PointOfInitiationMethod].
  ///
  /// ### Returns:
  /// - [PointOfInitiationMethod.static] if the raw value is `"11"`.
  /// - [PointOfInitiationMethod.dynamic] if the raw value is `"12"`.
  /// - Defaults to [PointOfInitiationMethod.unknown] for unrecognized values.
  PointOfInitiationMethod toPointOfInitiationMethodFromRAW() {
    switch (this) {
      case '11':
        return PointOfInitiationMethod.static;
      case '12':
        return PointOfInitiationMethod.dynamic;
      default:
        return PointOfInitiationMethod.unknown;
    }
  }
}
