import 'package:flutter/services.dart';

class PositiveNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Permitir solo números positivos
    if (newValue.text.isEmpty || double.tryParse(newValue.text) == null) {
      return newValue;
    }

    final value = double.parse(newValue.text);
    if (value < 0) {
      return oldValue; // Revertir al valor anterior si es negativo
    }

    return newValue;
  }
}