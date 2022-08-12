class Resources {
  final List<JsonAsset> jsonAssets;

  Resources({required this.jsonAssets});
}

class JsonAsset {
  final String name;
  final String path;
  final String fileUri;
  final String outputClass;

  JsonAsset({
    required this.name,
    required this.path,
    required this.fileUri,
    required this.outputClass,
  });
}
