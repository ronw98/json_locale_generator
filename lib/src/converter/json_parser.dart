import 'package:json_locale_generator/src/errors/invalid_json_format.dart';
import 'package:json_locale_generator/src/model/generation_key.dart';
import 'package:json_locale_generator/src/utils.dart';

Map<GenerationKey, dynamic> jsonCleaner(
  Map<String, dynamic> json,
  String? ignorePart,
) {
  final res = <GenerationKey, dynamic>{};
  for (final entry in json.entries) {
    _validateJsonKey(entry.key);
    final GenerationKey generationKey;
    if (ignorePart != null) {
      final findIgnore = RegExp(ignorePart);
      final wordPluralRoot =
          entry.key.replaceAllMapped(findIgnore, (match) => '');
      generationKey = GenerationKey(
        dartPropertyName: wordPluralRoot.sanitize,
        jsonKey: wordPluralRoot,
      );
    } else {
      generationKey = GenerationKey(
        dartPropertyName: entry.key.sanitize,
        jsonKey: entry.key,
      );
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
