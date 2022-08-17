import 'package:json_locale_generator/src/errors/invalid_json_format.dart';
import 'package:json_locale_generator/src/utils.dart';

Map<String, dynamic> jsonCleaner(
  Map<String, dynamic> json,
  String? ignorePart,
) {
  final res = <String, dynamic>{};
  for (final entry in json.entries) {
    _validateJsonKey(entry.key);
    final String generationKey;
    if (ignorePart != null) {
      final findIgnore = RegExp(ignorePart);
      generationKey =
          entry.key.replaceAllMapped(findIgnore, (match) => '').sanitize;
    } else {
      generationKey = entry.key;
    }
    final generationValue = entry.value is Map<String, dynamic>
        ? jsonCleaner(entry.value as Map<String, dynamic>, ignorePart)
        : entry.value;
    res[generationKey] = generationValue;
  }
  return res;
}

void _validateJsonKey(String key) {
  if (RegExp(r'[\.\$\ ]').hasMatch(key)) {
    throw InvalidJsonKeyFormatException(key);
  }
}
