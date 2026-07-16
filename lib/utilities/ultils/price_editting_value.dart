import 'package:flutter/services.dart';

class PriceTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      var value = newValue.text;
      if (newValue.text.isNotEmpty) {
        value = value.replaceAll(RegExp(r'\D'), '');

        value = value.replaceAllMapped(
            RegExp(r'^([^,.]*[.,])|\D+'),
            (Match m) =>
                m[1] != null ? m[1]!.replaceAll(RegExp(r'[^0-9,.]+'), '') : '');
        value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      }
      return TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(
            offset: value.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}

class DecimalTextFormatter extends TextInputFormatter {
  final RegExp _decimalRegex = RegExp(r'^([\d,]{0,15}|[\d,]{0,15}\.\d{0,2})$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      if (!_decimalRegex.hasMatch(newValue.text)) {
        return oldValue;
      }

      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      var value = newValue.text;
      if (newValue.text.isNotEmpty) {
        if (value.endsWith(',')) {
          value = '${value.substring(0, value.length - 1)}.';
        }

        value = value.replaceAll(RegExp(r'[^0-9.]'), '');

        value = value.replaceAllMapped(
            RegExp(r'^([^,.]*[,.])|[^0-9.]+'),
            (Match m) =>
                m[1] != null ? m[1]!.replaceAll(RegExp(r'[^0-9,.]+'), '') : '');
        value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      }
      return TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(
            offset: value.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}
