import 'dart:async';

import 'package:build/build.dart';
import 'package:json_locale_generator/src/arguments.dart';
import 'package:json_locale_generator/src/converter/json_asset_converter.dart';
import 'package:json_locale_generator/src/generator/generator.dart';
import 'package:json_locale_generator/src/model/resources.dart';
import 'package:json_locale_generator/src/utils.dart';
import 'package:yaml/yaml.dart';

Resources createResources(String package, Config config) {
  final jsonAssets = config.jsonFileArguments
      .map(
        (jsonFileArgument) =>
            convertJsonFileArgumentToAsset(package, jsonFileArgument),
      )
      .toList();
  return Resources(jsonAssets: jsonAssets);
}

class JsonBuilder extends Builder {
  @override
  Future<void>? build(BuildStep buildStep) async {
    final input = buildStep.inputId;

    final output = AssetId(input.package, 'lib/jsons.dart');

    final pubspecFile = AssetId(input.package, 'pubspec.yaml');

    final yamlRaw = safeCast<YamlMap>(
      loadYaml(
        await buildStep.readAsString(pubspecFile),
      ),
    );

    final config = Config.fromPubspec(yamlRaw ?? YamlMap());
    final resources = createResources(input.package, config);

    final generated = generate(buildStep, resources);

    await buildStep.writeAsString(output, generated);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': ['jsons.dart']
      };
}

Builder builder(BuilderOptions builderOptions) {
  log.info('creating JsonBuilder');
  return JsonBuilder();
}
