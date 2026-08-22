import 'package:flutter_qris/qris.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QRIS MPM Parsing Tests', () {
    test('Valid QRIS data - BNI', () async {
      final String exampleData =
          '00020101021126590013ID.CO.BNI.WWW011893600009150305256502096102070790303UBE51440014ID.CO.QRIS.WWW0215ID20222337822690303UBE5204472253033605802ID5912VFS GLOBAL 66015JAKARTA SELATAN61051294062070703A016304D7C5';

      final qRISMPM = QRISMPM(exampleData);

      // Extract Merchant Data
      final pan = qRISMPM.merchant.pan;
      final currency = qRISMPM.currency.code;
      final qrisType = qRISMPM.pointOfInitiationMethod.isStatic;
      final panMethod = qRISMPM.merchant.panMerchantMethod;

      // Test the extracted data
      expect(pan, isNotEmpty);
      expect(currency, 'IDR'); // Assuming the currency code for BNI is IDR
      expect(qrisType, true); // The type for a static QR code
      expect(panMethod,
          PANMerchantMethod.debit); // The PAN method for a BNI QR code as debit
    });

    test('Valid QRIS data - Mandiri', () async {
      final String exampleData =
          "00020101021126690021ID.CO.BANKMANDIRI.WWW01189360000801688405040211716884050410303UMI51440014ID.CO.QRIS.WWW0215ID10243580827810303UMI5204274153033605802ID5910kedai  all6015Tangerang (Kab)61051533862070703A0163041A47";

      final qRISMPM = QRISMPM(exampleData);

      // Extract Merchant Data
      final pan = qRISMPM.merchant.pan;
      final currency = qRISMPM.currency.code;
      final qrisType = qRISMPM.pointOfInitiationMethod.isDynamic;

      // Test the extracted data
      expect(pan, isNotEmpty);
      expect(currency, 'IDR');
      expect(qrisType, false);
    });

    test('Invalid QRIS data', () async {
      final String invalidData = "fewijnfjnfjif2";

      try {
        QRISMPM(invalidData);
        // If no exception is thrown, the test should fail
        fail('Expected TLVException or an error but none occurred.');
      } on TLVException catch (e) {
        // Expect the TLVException to be thrown for invalid data
        expect(e.toString(), contains('TLVException: QRIS data is invalid'));
      } catch (e) {
        // Catch any unexpected errors
        fail('Unexpected exception occurred: $e');
      }
    });
  });
}
