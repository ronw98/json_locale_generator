import 'dart:convert';
import 'dart:io';

import 'package:build/build.dart';
import 'package:json_locale_generator/src/converter/json_parser.dart';
import 'package:json_locale_generator/src/errors/invalid_json_format.dart';
import 'package:json_locale_generator/src/generator/json_class_generator.dart';
import 'package:json_locale_generator/src/model/resources.dart';

Future<String> generate(BuildStep buildStep, Resources res) async {
  final code = [];
  for (final asset in res.jsonAssets) {
    final fileContent = await buildStep.readAsString(asset.id);

    final fileJson = jsonDecode(fileContent) as Map<String, dynamic>;
    try {
      final jsonToConvert = jsonCleaner(fileJson, asset.pluralMatcher);
      code.add(generateParentClass(asset.outputClass, jsonToConvert));
    } on InvalidJsonKeyFormatException catch (exception) {
      throw InvalidJsonFormatException(
        fileContent,
        File(asset.id.path).absolute.uri,
        exception.key,
      );
    }
  }
  return code.join('\n');
}
