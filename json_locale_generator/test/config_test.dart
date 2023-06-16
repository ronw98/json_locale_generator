import 'package:json_locale_generator/src/arguments.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import 'fixtures/fixtures.dart';

void main() {
  test(
    'test parse pubspec to config',
    () {
      final config = Config.fromPubspec(
        loadYaml(
          fixture('pubspec_to_config.yaml'),
        ) as YamlMap,
      );
      expect(config, const TypeMatcher<Config>());
    },
  );
}
