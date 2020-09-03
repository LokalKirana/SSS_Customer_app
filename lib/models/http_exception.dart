const Map<String, String> errorMessages = {
  "E001": "You do not have a store , Please contact Admin",
  "E002":
      "Please login via Login Screen to generate a OTP and procced with the OTP",
  "E003": "Unauthorized Access to Store App",
  "E004": "Device is Unidentified. Access denied",
  "E005": "Invalid Token",
  "E006": "Invalid User Key",
  "E007": "User address is already there",
  "E008": "Customer name mismatch",
  "E009": "Email already exists",
  "E010": "Phone Number not exixts"
};

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  String get getErrorMessage {
    String error;

    try {
      error = errorMessages[message];
    } catch (e) {
      error = 'Unknown Error Occured';
    }

    return error;
  }

  @override
  String toString() {
    return message;
  }
}
