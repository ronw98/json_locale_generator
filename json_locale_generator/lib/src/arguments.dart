import 'package:json_locale_generator/src/utils.dart';
import 'package:yaml/yaml.dart';

class Config {
  final String pubspecFilename;
  final List<JsonFileArgument> jsonFileArguments;

  const Config({
    required this.pubspecFilename,
    this.jsonFileArguments = const [],
  });

  factory Config.fromPubspec(YamlMap yaml) {
    const pubspecFilename = 'pubspec.yaml';
    final jsonToDartConfig = safeCast<YamlMap>(yaml['json_to_dart']);
    if (jsonToDartConfig == null) {
      return const Config(pubspecFilename: pubspecFilename);
    }
    final sampleFiles = safeCast<YamlList>(jsonToDartConfig['sample_files']);
    final jsonFiles = sampleFiles
            ?.map((fileElement) => safeCast<YamlMap>(fileElement))
            .whereType<YamlMap>()
            .where(
              (fileElement) =>
                  fileElement['source'] is String &&
                  fileElement['class_name'] is String?,
            )
            .map(
              (fileElement) => JsonFileArgument(
                jsonFilePath: fileElement['source'] as String,
                className: fileElement['class_name'] as String?,
                pluralMatcher: fileElement['plural_matcher'] as String?,
              ),
            )
            .toList() ??
        [];
    return Config(
      pubspecFilename: pubspecFilename,
      jsonFileArguments: jsonFiles,
    );
  }
}

class JsonFileArgument {
  final String jsonFilePath;
  final String? className;
  final String? pluralMatcher;

  JsonFileArgument({
    required this.jsonFilePath,
    required this.className,
    required this.pluralMatcher,
  });
}
