import 'package:get/get.dart';

import 'const_utils.dart';

/// REGULAR EXPRESSION
class RegularExpression {
  /// TextField Enter Pattern Expression
  static String emailPattern = r"([a-zA-Z0-9_@.])";
  static String alphabetPattern = r"[a-zA-Z]";
  static String alphabetSpacePattern = r"[a-zA-Z. ]";
  static String alphabetDigitSpacePattern = r"[a-zA-Z0-9#&$%_@.'?+ ]";
  static String alphabetDigitsPattern = r"[a-zA-Z0-9 ]";
  static String alphabetDigitsWithoutSpacePattern = r"[a-z0-9_]";
  static String alphabetDigitsSpacePlusPattern = r"[a-zA-Z0-9+ ]";
  static String alphabetDigitsSpecialSymbolPattern = r"[a-zA-Z0-9#&$%_@.]";
  static String alphabetDigitsDashPattern = r"[a-zA-Z0-9- ]";
  static String addressValidationPattern = r"[a-zA-Z0-9-@#&* ]";

  /// Validation Expression Pattern
  static String emailValidationPattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
}

/// VALIDATION MESSAGE WITH
class ValidationMsg {
  static String isRequired = "is required";
  static String somethingWentToWrong = "Something went Wrong";
  static String pleaseEnterValidEmail = "Please Enter Valid Email";
  static String mobileNoLength = 'Mobile No Must Be 10 Digit';
}

/// VALIDATION METHOD
class ValidationMethod {
  /// EMAIL VALIDATION METHOD
  static String? validateUserEmail(value) {
    bool regex =
        RegExp(RegularExpression.emailValidationPattern).hasMatch(value);
    if (value == null) {
      return ValidationMsg.isRequired.tr;
    } else if (regex == false) {
      return ValidationMsg.pleaseEnterValidEmail.tr;
    }
    return null;
  }

  /// MOBILE VALIDATION METHOD
  static String? validateMobNo(value) {
    if (value == null) {
      return ValidationMsg.isRequired.tr;
    } else if (value.length < ConstUtils.kPhoneNumberLength) {
      return ValidationMsg.mobileNoLength;
    }
    return null;
  }

  /// IS REQUIRED VALIDATION METHOD  (COMMON METHOD)
  static String? validateIsRequired(value) {
    if (value == null) {
      return ValidationMsg.isRequired.tr;
    }
    return null;
  }
}
