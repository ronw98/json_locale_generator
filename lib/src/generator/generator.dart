import 'package:build/build.dart';
import 'package:json_locale_generator/src/generator/json_class_generator.dart';
import 'package:json_locale_generator/src/model/resources.dart';

Future<String> generate(BuildStep buildStep, Resources res) async {
  const ignores =
      '// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names';

  final code = <String>[ignores];

  for (final asset in res.jsonAssets) {
    code.add(await generateJsonAsset(buildStep, asset));
  }
  return code.join('\n');
}
