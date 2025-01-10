import '../constant/qris_data_constant.dart';

/// Enum representing the Point of Initiation Method.
///
/// - `static`: Represents a static QR code.
/// - `dynamic`: Represents a dynamic QR code.
enum PointOfInitiationMethod { static, dynamic }

/// Extension for [PointOfInitiationMethod] providing additional utilities.
extension PointOfInitiationMethodExtension on PointOfInitiationMethod {
  /// Retrieves the name of the enumeration value as a string.
  String get name => toString().split('.').last;

  /// Checks if the method is `static`.
  bool get isStatic => this == PointOfInitiationMethod.static;

  /// Checks if the method is `dynamic`.
  bool get isDynamic => this == PointOfInitiationMethod.dynamic;

  /// Converts the method to its raw representation (`11` for static, `12` for dynamic).
  ///
  /// ### Returns:
  /// - `"11"` if the method is static.
  /// - `"12"` if the method is dynamic.
  String toRAWPointOfInitiationMethod() =>
      this == PointOfInitiationMethod.static ? '11' : '12';
}

/// Extension for [String] to handle raw Point of Initiation Method values.
extension PointOfInitiationMethodExtensionString on String {
  /// Converts the raw representation (`"11"` or `"12"`) to a descriptive string.
  ///
  /// ### Returns:
  /// - A constant value from [QrisDataConstant.static] or [QrisDataConstant.dynamic].
  /// - The original string if the raw value is unrecognized.
  String fromRAWPointOfInitiationMethodToString() {
    return this == '11'
        ? QrisDataConstant.static
        : this == '12'
            ? QrisDataConstant.dynamic
            : this;
  }

  /// Converts the raw representation (`"11"` or `"12"`) to a [PointOfInitiationMethod].
  ///
  /// ### Returns:
  /// - [PointOfInitiationMethod.static] if the raw value is `"11"`.
  /// - [PointOfInitiationMethod.dynamic] if the raw value is `"12"`.
  /// - Defaults to [PointOfInitiationMethod.static] for unrecognized values.
  PointOfInitiationMethod toPointOfInitiationMethodFromRAW() {
    return this == '11'
        ? PointOfInitiationMethod.static
        : this == '12'
            ? PointOfInitiationMethod.dynamic
            : PointOfInitiationMethod.static;
  }
}
