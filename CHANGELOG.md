# CHANGELOG - Flutter QRIS

## [1.0.1+4]

### Release Date: 2025-01-15

### Release Log:

- **Add Conditional Mandatory Fields**: Added support for conditional mandatory fields in the QRIS MPM decoder.
- **Improve Merchant Detail Parser**: Refined the merchant data parser for more accurate merchant details.

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
