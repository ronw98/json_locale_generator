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
        plural: entry.key.contains(findIgnore),
      );
    } else {
      generationKey = GenerationKey(
        dartPropertyName: entry.key.sanitize,
        jsonKey: entry.key,
        plural: false,
      );
    }
    dynamic generationValue;
    if (entry.value is Map<String, dynamic>) {
      generationValue = jsonCleaner(
        entry.value as Map<String, dynamic>,
        ignorePart,
      );
    } else if (entry.value is String) {
      final params = RegExp(r'\{(.*?)\}')
          .allMatches(entry.value as String)
          .map(
            (match) => match.group(1),
          )
          .whereType<String>();
      generationValue = GenerationValue(
        params: params
            .map((param) => GenerationParam(param.sanitize, param))
            .toList(),
      );
    }
    if (generationValue != null) {
      res[generationKey] = generationValue;
    }
  }
  return res;
}

void _validateJsonKey(String key) {
  if (RegExp(r'[\.\$\ ]').hasMatch(key)) {
    throw InvalidJsonKeyFormatException(key);
  }
}
