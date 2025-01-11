# CHANGELOG FLUTTER QRIS

## [1.0.0]

### Initial Release

## DATE

- 2025-01-10

### RELEASE LOG

- **Qris Library** initial version.
- Currently, the library supports **MPM (Merchant Profile Message)** decoder functionality.
- Added the necessary components for QR code generation and decoding for QRIS in Indonesia.
- Provided a simple API for decoding the QRIS QR codes for merchant-related data.

This version lays the foundation for future features and enhancements.

---

## [1.0.1]

### DATE

- 2025-01-10

### RELEASE LOG

- **Example Project**: Added a full example project showcasing the usage of the QRIS library for both decoding and displaying the parsed merchant data.
- **Core Decoder Improvements**: Improved the core QRIS MPM decoder functionality, optimizing performance and enhancing error handling capabilities.
- **QRIS MPM Data Structure Update**: Reworked the internal structure of QRIS Merchant Profile Message (MPM) data to make it more modular and extendable for future updates.
  - Added additional fields to enhance decoding accuracy.
  - Improved handling of edge cases for invalid or incomplete QR codes.
- Updated documentation for the decoder functions and QR code handling processes.
- ADD new QRIS MPM TIP details.
