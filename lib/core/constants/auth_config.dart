/// Configuration for Firebase Authentication
class AuthConfig {
  // Test phone numbers for development/testing
  // Add your Firebase Console test numbers here
  static const Map<String, String> testPhoneNumbers = {
    // US numbers
    '+1234567890': '123456',
    '+12345678901': '567890',
    '+15551234567': '123456',

    // Indian (+91) numbers
    '+919876543210': '123456',
    '+919999999999': '567890',
    '+918888888888': '111111',
    '+917777777777': '222222',
    '+916666666666': '333333',

    // Add your actual test numbers from Firebase Console here
    // Format: 'phone_number': 'verification_code'
  };

  /// Check if a phone number is configured as a test number
  static bool isTestNumber(String phoneNumber) {
    return testPhoneNumbers.containsKey(phoneNumber);
  }

  /// Get the test verification code for a test phone number
  static String? getTestCode(String phoneNumber) {
    return testPhoneNumbers[phoneNumber];
  }

  /// Debug method to show all configured test numbers
  static void debugPrintTestNumbers() {
    print('=== DEBUG: Configured Test Numbers ===');
    testPhoneNumbers.forEach((phone, code) {
      print('Phone: $phone -> Code: $code');
    });
    print('=====================================');
  }
}
