import 'dart:io';

import 'package:json_locale_generator/src/arguments.dart';
import 'package:json_locale_generator/src/model/resources.dart';
import 'package:json_locale_generator/src/utils.dart';
import 'package:path/path.dart';

JsonAsset convertJsonFileArgumentToAsset(JsonFileArgument argument) {
  final jsonFile = File(argument.jsonFilePath);
  final assetName = basenameWithoutExtension(jsonFile.path);
  return JsonAsset(
    name: assetName,
    path: jsonFile.path,
    fileUri: jsonFile.absolute.uri.toString(),
    outputClass: argument.className ?? assetName.capitalize(),
  );
}
