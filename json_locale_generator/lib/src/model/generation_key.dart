import 'package:equatable/equatable.dart';

class GenerationParam extends Equatable {
  const GenerationParam(this.dartProperty, this.translationKey);

  final String dartProperty;
  final String translationKey;

  @override
  List<Object?> get props => [dartProperty, translationKey];
}

class GenerationKey extends Equatable {
  const GenerationKey({
    required this.dartPropertyName,
    required this.jsonKey,
    required this.plural,
  });

  final String dartPropertyName;

  final String jsonKey;

  final bool plural;

  @override
  String toString() => 'dart: $dartPropertyName, json: $jsonKey';

  @override
  List<Object?> get props => [dartPropertyName, jsonKey, plural];
}

class GenerationValue extends Equatable {
  const GenerationValue({
    required this.params,
  });

  final List<GenerationParam> params;

  @override
  List<Object?> get props => [params];
}
