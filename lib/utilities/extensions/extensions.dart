import 'package:intl/intl.dart';

extension ExtendedIterable<E> on Iterable<E> {
  void forEachIndexed(void Function(E e, int i) f) {
    var i = 0;
    forEach((e) => f(e, i++));
  }
}

extension NullCheck on String? {
  bool get isNullOrEmpty {
    if (this == null || this == "") {
      return true;
    }

    return false;
  }

  String get orEmpty {
    if (!isNullOrEmpty) {
      return this!;
    }
    return '';
  }

  String get orDash {
    if (!isNullOrEmpty) {
      return this!;
    }
    return '-';
  }
}

extension IntComas on int? {
  bool get isNullOrZero {
    return this == null || this == 0;
  }

  int get orZero {
    if (this == null) {
      return 0;
    }
    return this!;
  }

  String? get comasFixZero {
    if (this == null) {
      return '0';
    }
    final format = NumberFormat("###,###", "en_US");
    return format.format(this!);
  }

  String? get comasFixZero1 {
    if (this == null) {
      return null;
    }
    final format = NumberFormat("###,###", "en_US");
    return format.format(this!);
  }
}

extension IntFormatter on int? {
  // To format number with comas only
  // Use case: Format quantity
  // Example: 100000 -> 100,0000
  String? get formatVol {
    if (isNullOrZero) {
      return '0';
    }
    final format = NumberFormat("###,###", "en_US");
    return format.format(this!);
  }

  String? get formatVolBaseUnit {
    if (isNullOrZero) {
      return '0';
    }

    return "${this!.comasFixZero.orEmpty} \$";
  }
}

extension DoubleConvert on double? {
  int? get toInt {
    if (this == null) {
      return null;
    }
    return this!.toInt();
  }
}

extension DoubleComas on double? {
  bool get isNullOrZero {
    return this == null || this == 0.0;
  }

  double get orZero {
    if (this == null) {
      return 0;
    }
    return this!;
  }

  String? get comasFixZero {
    if (this == null) {
      return '0';
    }
    final format = NumberFormat("###,###", "en_US");
    return format.format(this!);
  }

  String? get comasFixOne {
    if (this == null) {
      return '0';
    }
    final format = NumberFormat("###,###.#", "en_US");
    return format.format(this!);
  }

  // Format number to fixed one decimal
  // Ex: 19.80
  String? get comasFixOneZero {
    if (this == null) {
      return '0';
    }
    final format = NumberFormat("#,##0.0", "en_US");
    return format.format(this!);
  }

  String? get comasFixTwo {
    if (this == null) {
      return '0';
    }
    final format = NumberFormat("###,###.##", "en_US");
    return format.format(this!);
  }

  String? get comasFixThree {
    if (this == null) {
      return '0';
    }
    final format = NumberFormat("###,###.###", "en_US");
    return format.format(this!);
  }

  // Format number to fixed two decimal
  // Ex: 19.80
  String? get comasFixTwoZero {
    if (this == null) {
      return '0.00';
    }
    final format = NumberFormat("#,##0.00", "en_US");
    return format.format(this!);
  }

  String? get comasFixTwoOrNull {
    if (this == null) {
      return '0.00';
    }
    final format = NumberFormat("#,##0.00", "en_US");
    return format.format(this!);
  }

  String? get comasFixOneOrNull {
    if (this == null) {
      return '0.0';
    }
    final format = NumberFormat("#,##0.0#", "en_US");
    return format.format(this!);
  }

  String? get comasFixZeroOrNull {
    if (this == null) {
      return '0';
    }
    final format = NumberFormat("###,###", "en_US");
    return format.format(this!);
  }

  String? get comasFix {
    if (this == null) {
      return '0.0';
    }
    final format = NumberFormat("#,##0.0#", "en_US");
    return format.format(this!);
  }

  String? get comasFixThreeZero {
    if (this == null) {
      return '0.000';
    }
    final format = NumberFormat("#,##0.000", "en_US");
    return format.format(this!);
  }

  String? get removeRedundantZero {
    if (this == null) {
      return '0';
    }
    if (toString().endsWith('.0')) {
      return toString().replaceFirst('.0', '');
    }
    return toString();
  }

  String get parseToString {
    if (this == null) return '0';

    String stringValue = toString();

    if (stringValue.contains('.')) {
      stringValue = stringValue.replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
    }

    return stringValue;
  }
}

extension DateTimeStrExt on String? {
  String get convertDate {
    if (isNullOrEmpty) return '';

    try {
      DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
      DateTime date = format.parse(this!);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return '';
    }
  }

  String get convertDateTime {
    if (isNullOrEmpty) return '';

    try {
      DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
      DateTime date = format.parse(this!);
      return DateFormat('HH:mm:ss dd/MM/yyyy').format(date);
    } catch (_) {
      return '';
    }
  }

  DateTime get convertToDateTime {
    if (isNullOrEmpty) return DateTime.now();

    try {
      DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
      return format.parse(this!);
    } catch (_) {
      return DateTime.now();
    }
  }
}

extension DateTimeExt on DateTime? {
  String get convertDate {
    if (this == null) return '';

    try {
      return DateFormat('dd/MM/yyyy').format(this!);
    } catch (_) {
      return '';
    }
  }

  String get convertDateTime {
    if (this == null) return '';

    try {
      return DateFormat('yyyy-MM-dd 00:00:00').format(this!);
    } catch (_) {
      return '';
    }
  }

  String get convertDateTimeS {
    if (this == null) return '';

    try {
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(this!);
    } catch (_) {
      return '';
    }
  }
}

extension DateTimeIntExt on int? {
  DateTime get convertToDateTime {
    if (this == null) return DateTime.now();

    return DateTime.fromMillisecondsSinceEpoch(this! * 1000);
  }

  String get convertDateTime {
    if (this == null) return '';

    try {
      return DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(DateTime.fromMillisecondsSinceEpoch(this! * 1000));
    } catch (_) {
      return '';
    }
  }
}
