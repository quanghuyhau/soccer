String jsonString(Object? value, {String fallback = ''}) {
  return value is String ? value : fallback;
}

List<String> jsonStringList(Object? value) {
  if (value is List) {
    return value.whereType<String>().toList();
  }

  return const [];
}

DateTime jsonDateTime(Object? value) {
  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  return DateTime.fromMillisecondsSinceEpoch(0);
}
