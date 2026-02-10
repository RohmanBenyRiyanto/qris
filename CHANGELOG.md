# CHANGELOG - Flutter QRIS

## [1.0.2]

### Release Date: 2025-02-10

### Critical Bug Fixes:

- **Fixed CRC Validation Regex Bug**:
  Fixed incorrect regex pattern in CRC validation (`crc_parser.dart`). The regex was using `\$` in a raw string which matched a literal `$` character instead of end-of-string anchor. Changed from `r'(63\d{2})([0-9A-Fa-f]{4})\$'` to `r'(63\d{2})([0-9A-Fa-f]{4})$'`. This caused all valid QRIS codes to fail CRC validation.

- **Fixed Luhn Algorithm PAN Validation Bug**:
  Fixed critical bug in Luhn algorithm validation (`luhn_algorithm_extension.dart`). The loop was using `length - 1` (original PAN length) instead of `pan.length - 1` (PAN with check digit), causing the check digit to be excluded from validation. This resulted in all valid PANs being incorrectly marked as invalid.

### Impact:
These fixes resolve validation failures for legitimate QRIS codes. All real QRIS data should now validate correctly.

## [1.0.1+8]

### Release Date: 2025-02-19

### Changelog:

- **Handled nullable MCC & Currency values:**
  Set default values when MCC or Currency data is unavailable in Dataset.

## [1.0.1+7]

### Release Date: 2025-01-29

### Changelog:

- **Update MPM Data Validation**:  
  Update MPM data validation in QRIS MPM tags.

## [1.0.1+7]

### Release Date: 2025-01-26

### Changelog:

- **Added getter method for retrieving values from sub-tags**:  
  Introduced a new method that simplifies extracting values from nested or sub-tags, improving flexibility in handling complex QRIS data structures.

- **Enhanced QRIS MPM mandatory tag validation**:  
  Improved the QRIS MPM validation logic to ensure more efficient and accurate checks for mandatory tags, streamlining the validation process and reducing unnecessary computations.

## [1.0.1+5]

### Release Date: 2025-01-24

### Release Log:

- **Update Luhn Algorithm**: Updated the Luhn algorithm to support additional PAN lengths.
- **Update PAN Validation**: Improved the PAN validation to handle PANs with different lengths.
- **Update PAN Check Digit Calculation**: Added support for calculating the check digit for PANs with different lengths.
- **ADD PAN Check Digit String Getter**: Added a getter for the check digit string for PANs with different lengths.

## [1.0.1+4]

### Release Date: 2025-01-15

### Release Log:

- **Add Conditional Mandatory Fields**: Added support for conditional mandatory fields in the QRIS MPM decoder.
- **Improve Merchant Detail Parser**: Refined the merchant data parser for more accurate merchant details.
- **Updated SDK Range**: Minimum Dart SDK version updated to `2.19.0`, maximum set to `<4.0.0`.

## [1.0.1+3]

### Release Date: 2025-01-12

### Release Log:

- **Updated Transaction Parser**: Enhanced the transaction parser to support additional tip indicators.
- **Improved Merchant Detail Parser**: Refined the merchant data parser for more accurate merchant details.

---

## [1.0.1+2]

### Release Date: 2025-01-12

### Release Log:

- **Enhanced Import Handling**: Improved the import process to gracefully handle missing dependencies.

---

## [1.0.1+1]

### Release Date: 2025-01-10

### Release Log:

- **Added Example Project**: Introduced a full example project demonstrating the usage of the QRIS library for decoding and displaying parsed merchant data.
- **Core Decoder Improvements**: Enhanced the core QRIS MPM decoder for better performance and improved error handling.
- **QRIS MPM Data Structure Update**: Reworked the internal structure of QRIS Merchant Profile Message (MPM) data to increase modularity and extensibility for future updates.
  - Added additional fields for improved decoding accuracy.
  - Enhanced handling of edge cases for incomplete or invalid QR codes.
- **Updated Documentation**: Revamped the documentation for the decoder functions and QR code handling processes.
- **New QRIS MPM TIP Details**: Added new details related to QRIS MPM tip functionality.

---

## [1.0.0]

### Release Date: 2025-01-10

### Initial Release:

- **Qris Library**: Initial version released.
- **MPM Decoder**: Supports Merchant Profile Message (MPM) decoding functionality.
- **QR Code Generation and Decoding**: Includes components for QR code generation and decoding specifically for QRIS in Indonesia.
- **API**: A simple API provided for decoding QRIS QR codes related to merchant data.
