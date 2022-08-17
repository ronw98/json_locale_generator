import 'package:build/build.dart';

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
