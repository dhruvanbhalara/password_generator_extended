# Changelog

## [Unreleased]

### Added

- Implemented `isStrongPassword` method to evaluate password strength based on criteria such as length, character variety (uppercase, lowercase, numbers, special characters).
- Enhanced `refreshPassword` method to regenerate passwords until a strong password is produced.
- Updated minimum password length requirement from 8 to 12 characters.
- Added logic to ensure generated passwords do not repeat characters.

### Changed

- Updated password generation logic to include checks for at least one character from each selected type (uppercase, lowercase, numbers, special characters).
- Improved error handling for cases where not enough unique characters are available for password generation.

## 0.0.1

- Initial version.
