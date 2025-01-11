# Flutter QRIS Library

This is a Flutter library for handling QRIS (QR Code Indonesian Standard) QR codes, which includes functionalities for decoding QRIS merchant data and transaction details.

## Features

- **MPM Decoder**: Decode both static and dynamic QRIS QR codes to retrieve merchant information.
- **QRISMPM Class**: Represents the data structure for QRIS MPM and contains all relevant fields such as merchant information, transaction details, and CRC (Cyclic Redundancy Check).

## Getting Started

To use the `flutter_qris` library in your Flutter project, add the following dependency to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_qris: 1.0.1
```

Make sure to run `flutter pub get` to install the dependencies.

## Usage

The library provides an easy-to-use interface for decoding QRIS QR codes. Below are examples of how to use the MPM decoder to decode both static and dynamic QRIS data:

### Example: Decoding QRIS Data

```dart
import 'package:flutter/material.dart';
import 'package:flutter_qris/qris.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter QRIS Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example QRIS Data
    final String exampleData = "00020101021126590013ID.CO.BNI.WWW011893600009150305256502096102070790303UBE51440014ID.CO.QRIS.WWW0215ID20222337822690303UBE5204472253033605802ID5912VFS GLOBAL 66015JAKARTA SELATAN61051294062070703A016304D7C5";

    return Scaffold(
      appBar: AppBar(
        title: Text('QRIS Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final qRISMPM = QRISMPM(exampleData);

              // Example of debugging QRIS data
              qRISMPM.tlv.logDebugingTLV();
              debugPrint(qRISMPM.tlvtoMap(qRISMPM.tlv).toPrettyString());
              await Future.delayed(const Duration(milliseconds: 20));
              qRISMPM.additionalData.logDebugingAdditionalData();
              await Future.delayed(const Duration(milliseconds: 20));

              // Example of extracting data
              final pan = qRISMPM.merchant.pan;
              final currency = qRISMPM.currency.code;
              final qrisType = qRISMPM.pointOfInitiationMethod.name;

              debugPrint('PAN: $pan');
              debugPrint('Currency: $currency');
              debugPrint('QRIS Type: $qrisType');
            } on TLVException catch (e) {
              debugPrint(e.toString());
            } catch (e) {
              debugPrint(e.toString());
            }
          },
          child: Text('Decode QRIS Data'),
        ),
      ),
    );
  }
}
```

## Additional Information

- The **QRIS** library is designed to help Flutter developers handle QRIS data for Indonesian payment systems.
- You can contribute to the project or report issues by visiting the [GitHub repository](https://github.com/RohmanBenyRiyanto/qris).
- To scan QRIS codes from an image or using the camera, you can use the [`mobile_scanner`](https://pub.dev/packages/mobile_scanner) package. It allows you to scan QR codes with your phone's camera to get the QR string, which can then be decoded using the [`flutter_qris`](https://pub.dev/packages/flutter_qris) package.

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

### Thank You

If you have any questions or suggestions, feel free to open an issue or contribute directly to the repository.
