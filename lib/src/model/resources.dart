import 'package:build/build.dart';

class Resources {
  final List<JsonAsset> jsonAssets;

  Resources({required this.jsonAssets});
}

class JsonAsset {
  final AssetId id;
  final String outputClass;

  JsonAsset({
    required this.id,
    required this.outputClass,
  });
}
