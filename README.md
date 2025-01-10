# Flutter QRIS Library

This is a Flutter library for handling QRIS (QR Code Indonesian Standard) QR codes, which includes functionalities for decoding QRIS merchant data and transaction details.

## Features

- **MPM Decoder**: Decode the QRIS QR code and retrieve merchant information.
- **QRIS Class**: Represent the data structure for QRIS and contains all the relevant fields such as merchant information, transaction details, and CRC.

## Getting Started

To use the `flutter_qris` library in your Flutter project, add the following dependency to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_qris: ^1.0.0
```

Make sure to run `flutter pub get` to install the dependencies.

## Usage

The library provides an easy-to-use interface for decoding QRIS QR codes. Here are examples of how to use the MPM decoder:

### Decoding to an Object

```dart
import 'package:flutter_qris/flutter_qris.dart';

void main() async {
  final qrisObject = await QrisMpmDecoder.decodeToObject("010212...");
  print(qrisObject);
}
```

### Decoding to a Map

```dart
import 'package:flutter_qris/flutter_qris.dart';

void main() async {
  final decodedData = await QrisMpmDecoder.decodeToMap("010212...");
  print(decodedData);
}
```

## Additional Information

- The **QRIS** library is designed to help Flutter developers handle QRIS data for Indonesian payment systems.
- You can contribute to the project or report issues by visiting the [GitHub repository](https://github.com/RohmanBenyRiyanto/qris).
<!-- - For more detailed documentation, please refer to the [official QRIS guidelines](https://www.flutter_qris-indonesia.com/). -->

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

If you have any questions or suggestions, feel free to open an issue or contribute directly to the repository.
