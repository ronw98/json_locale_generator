import 'dart:convert';
import 'dart:io';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:json_locale_generator/src/converter/json_parser.dart';
import 'package:json_locale_generator/src/errors/invalid_json_format.dart';
import 'package:json_locale_generator/src/generator/json_class_generator.dart';
import 'package:json_locale_generator/src/model/resources.dart';

/// Generation entry point
Future<String> generate(BuildStep buildStep, Resources res) async {
  final List<GenerationEntry> parsedJsons = [];
  for (final asset in res.jsonAssets) {
    final fileContent = await buildStep.readAsString(asset.id);

    final fileJson = jsonDecode(fileContent) as Map<String, dynamic>;
    try {
      final jsonToConvert = jsonCleaner(
        fileJson,
        asset.pluralMatcher,
      );
      parsedJsons.add(
        GenerationEntry(jsonToConvert, asset.outputClass, asset.pluralMatcher),
      );
    } on InvalidJsonKeyFormatException catch (exception) {
      throw InvalidJsonFormatException(
        fileContent,
        File(asset.id.path).absolute.uri,
        exception.key,
      );
    }
  }
  final fileToWrite = Library(
    (l) {
      l.body.add(Directive.import('package:json_locale/json_locale.dart'));
      for (final entry in parsedJsons) {
        l.body.addAll(
          generateParentClass(
            entry.outputClass,
            entry.data,
          ),
        );
      }
    },
  );

  final emitter = DartEmitter(
    allocator: Allocator.simplePrefixing(),
    orderDirectives: true,
    useNullSafetySyntax: true,
  );

  return DartFormatter().format(fileToWrite.accept(emitter).toString());
}
