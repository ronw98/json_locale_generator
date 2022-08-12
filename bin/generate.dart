import 'dart:io';

import 'package:args/args.dart';
import 'package:build/build.dart';
import 'package:json_locale_generator/builder.dart';
import 'package:json_locale_generator/src/arguments.dart';
import 'package:json_locale_generator/src/generator/generator.dart';
import 'package:json_locale_generator/src/utils.dart';
import 'package:yaml/yaml.dart';

void main(List<String> args) {
  final arguments = CommandLineArguments()..parse(args);

  final configRaw = safeCast<YamlMap>(
    loadYaml(File(arguments.pubspecFilename).absolute.readAsStringSync()),
  );
  final config = Config.fromPubspec(configRaw ?? YamlMap());

  final res = createResources(config);
  final contents = generate(res);

  final outputFile = File(arguments.outputFilename);
  outputFile.writeAsStringSync(contents);

  log.info("${outputFile.path} generated successfully");
}

class CommandLineArguments {
  late String pubspecFilename;
  late String outputFilename;

  void parse(List<String> args) {
    ArgParser()
      ..addOption(
        "pubspec-file",
        defaultsTo: 'pubspec.yaml',
        callback: (value) => pubspecFilename = safeCast<String>(value)!,
        help: 'Specify the pubspec file.',
      )
      ..addOption(
        "output-file",
        defaultsTo: 'lib/jsons.dart',
        callback: (value) => outputFilename = safeCast<String>(value)!,
        help: 'Specify the output file.',
      )
      ..parse(args);
  }
}
