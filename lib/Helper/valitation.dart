import 'package:flutter/services.dart';

class NumericInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any non-numeric characters from the new value
    String filteredValue = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Return the updated value with the numeric characters only
    return TextEditingValue(
      text: filteredValue,
      selection: TextSelection.collapsed(offset: filteredValue.length),
    );
  }
}

class AlphabeticInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any non-alphabetic characters from the new value
    String filteredValue = newValue.text.replaceAll(RegExp(r'[^a-zA-Z]'), '');

    // Return the updated value with alphabetic characters only
    return TextEditingValue(
      text: filteredValue,
      selection: TextSelection.collapsed(offset: filteredValue.length),
    );
  }
}

class MyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Implement your custom logic here to modify the input.
    // You can check oldValue and newValue to apply specific rules.
    // For example, you can enforce lowercase, limit the length, or restrict characters.

    // Here's a simple example that converts the text to uppercase:
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
