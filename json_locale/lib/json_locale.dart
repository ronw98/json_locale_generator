library json_locale;

import 'package:collection/collection.dart';

class Translatable {
  const Translatable(
    this.key,
    this.params,
  );

  final String key;

  final Map<String, String> params;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Translatable &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          const MapEquality().equals(params, other.params);

  @override
  int get hashCode => key.hashCode ^ params.hashCode;
}

class TranslatablePlural {
  const TranslatablePlural(
    this.key,
    this.cardinality,
  );

  final String key;
  final int cardinality;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslatablePlural &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          cardinality == other.cardinality;

  @override
  int get hashCode => key.hashCode ^ cardinality.hashCode;
}
