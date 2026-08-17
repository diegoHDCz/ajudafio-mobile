import 'package:flutter/services.dart';

/// Formats digits as the user types into the Brazilian phone pattern
/// `(XX) XXXXX-XXXX` (2-digit area code + 9-digit mobile number).
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limitedDigits = digits.length > 11 ? digits.substring(0, 11) : digits;

    final buffer = StringBuffer();
    for (var i = 0; i < limitedDigits.length; i++) {
      if (i == 0) buffer.write('(');
      buffer.write(limitedDigits[i]);
      if (i == 1) buffer.write(') ');
      if (i == 6) buffer.write('-');
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Strips formatting, keeping only digits (e.g. for sending to the API/DB).
String sanitizePhone(String phone) => phone.replaceAll(RegExp(r'\D'), '');

/// Validates that [value] is a complete `(XX) XXXXX-XXXX` phone number.
String? phoneValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone is required';
  }
  final isComplete = RegExp(r'^\(\d{2}\) \d{5}-\d{4}$').hasMatch(value);
  if (!isComplete) {
    return 'Enter a valid phone, e.g. (45) 98409-0113';
  }
  return null;
}
