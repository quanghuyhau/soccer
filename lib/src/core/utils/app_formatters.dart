import 'package:flutter/material.dart';

class AppFormatters {
  const AppFormatters._();

  static String dateTime(DateTime value) {
    final local = value.toLocal();
    return '${_two(local.hour)}:${_two(local.minute)} '
        '${_two(local.day)}/${_two(local.month)}/${local.year}';
  }

  static String date(DateTime value) {
    final local = value.toLocal();
    return '${local.year}-${_two(local.month)}-${_two(local.day)}';
  }

  static String time(DateTime value) {
    final local = value.toLocal();
    return '${_two(local.hour)}:${_two(local.minute)}';
  }

  static String money(num value) {
    final text = value.round().toString();
    final buffer = StringBuffer();

    for (var i = 0; i < text.length; i++) {
      final reverseIndex = text.length - i;
      buffer.write(text[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write('.');
      }
    }

    return '$bufferđ';
  }

  static Color statusColor(BuildContext context, String status) {
    final colors = Theme.of(context).colorScheme;

    return switch (status) {
      'CONFIRMED' => Colors.green,
      'CANCELLED' => colors.error,
      'COMPLETED' => Colors.blueGrey,
      _ => Colors.orange,
    };
  }

  static String _two(int value) => value.toString().padLeft(2, '0');
}
