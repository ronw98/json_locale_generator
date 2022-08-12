import 'dart:async';

import 'package:build/build.dart';
import 'package:json_locale_generator/src/arguments.dart';
import 'package:json_locale_generator/src/converter/json_asset_converter.dart';
import 'package:json_locale_generator/src/generator/generator.dart';
import 'package:json_locale_generator/src/model/resources.dart';
import 'package:json_locale_generator/src/utils.dart';
import 'package:yaml/yaml.dart';

Resources createResources(Config config) {
  final jsonAssets = config.jsonFileArguments
      .map(
        (jsonFileArgument) => convertJsonFileArgumentToAsset(jsonFileArgument),
      )
      .toList();
  return Resources(jsonAssets: jsonAssets);
}

class JsonBuilder extends Builder {
  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final input = buildStep.inputId;

    final output = AssetId(input.package, 'lib/jsons.dart');

    final configId = AssetId(input.package, 'pubspec.yaml');

    final yamlRaw = safeCast<YamlMap>(
      loadYaml(
        await buildStep.readAsString(configId),
      ),
    );

    final config = Config.fromPubspec(yamlRaw ?? YamlMap());
    final resources = createResources(config);

    final generated = generate(resources);

    await buildStep.writeAsString(output, generated);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': ['jsons.dart']
      };
}

Builder builder(BuilderOptions builderOptions) {
  log.info('creating JsonBuilder()');
  return JsonBuilder();
}
