import 'package:build/build.dart';
import 'package:json_locale_generator/src/model/generation_key.dart';

class Resources {
  final List<JsonAsset> jsonAssets;

  Resources({required this.jsonAssets});
}

class JsonAsset {
  final AssetId id;
  final String outputClass;
  final String? pluralMatcher;

  JsonAsset({
    required this.id,
    required this.outputClass,
    this.pluralMatcher,
  });
}

class GenerationEntry {
  final Map<GenerationKey, dynamic> data;
  final String outputClass;
  final String? pluralMatcher;

  GenerationEntry(
    this.data,
    this.outputClass,
    this.pluralMatcher,
  );
}
