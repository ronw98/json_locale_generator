class GenerationKey {
  const GenerationKey({
    required this.dartPropertyName,
    required this.jsonKey,
  });

  final String dartPropertyName;

  final String jsonKey;

  @override
  String toString() => 'dart: $dartPropertyName, json: $jsonKey';

  @override
  int get hashCode => Object.hash(
        runtimeType,
        dartPropertyName.hashCode,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GenerationKey &&
            other.dartPropertyName == dartPropertyName);
  }
}
