// ignore_for_file: invalid_use_of_visible_for_testing_member

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
    final String exampleData =
        // BNI
        // '00020101021126590013ID.CO.BNI.WWW011893600009150305256502096102070790303UBE51440014ID.CO.QRIS.WWW0215ID20222337822690303UBE5204472253033605802ID5912VFS GLOBAL 66015JAKARTA SELATAN61051294062070703A016304D7C5';
        // Mandiri
        "00020101021126690021ID.CO.BANKMANDIRI.WWW01189360000801688405040211716884050410303UMI51440014ID.CO.QRIS.WWW0215ID10243580827810303UMI5204274153033605802ID5910kedai  all6015Tangerang (Kab)61051533862070703A0163041A47";
    // Invalid
    // "fewijnfjnfjif2";

    return Scaffold(
      appBar: AppBar(
        title: Text('QRIS Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final qRISMPM = QRISMPM(exampleData);

              // EXAMPLE TO DEBUGING LOG
              qRISMPM.tlv.logDebugingTLV();
              debugPrint(qRISMPM.tlvtoMap(qRISMPM.tlv).toPrettyString());
              await Future.delayed(const Duration(milliseconds: 20));
              qRISMPM.additionalData.logDebugingAdditionalData();
              await Future.delayed(const Duration(milliseconds: 20));
              qRISMPM.tip.logDebugingTip();
              await Future.delayed(const Duration(milliseconds: 20));
              qRISMPM.logDebugingCRC();
              await Future.delayed(const Duration(milliseconds: 20));
              qRISMPM.merchant.logDebugMerchant();
              await Future.delayed(const Duration(milliseconds: 20));
              qRISMPM.mcc.loglogDebugingMCC();
              await Future.delayed(const Duration(milliseconds: 20));
              qRISMPM.currency.logDebugingCurrency();
              await Future.delayed(const Duration(milliseconds: 20));

              // EXAMPLE TO USING DATA
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
