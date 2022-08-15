import 'dart:io';

import 'package:build/build.dart';
import 'package:json_locale_generator/src/arguments.dart';
import 'package:json_locale_generator/src/model/resources.dart';
import 'package:json_locale_generator/src/utils.dart';
import 'package:path/path.dart';

JsonAsset convertJsonFileArgumentToAsset(String package, JsonFileArgument argument) {
  final jsonFile = File(argument.jsonFilePath);
  final assetName = basenameWithoutExtension(jsonFile.path);
  return JsonAsset(
    id: AssetId(package, argument.jsonFilePath),
    outputClass: argument.className ?? assetName.capitalize(),
  );
}
