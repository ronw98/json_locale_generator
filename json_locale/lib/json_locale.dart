library json_locale;

class Translatable {
  const Translatable(
    this.key,
    this.params,
  );

  final String key;

  final Map<String, String> params;
}

class TranslatablePlural {
  const TranslatablePlural(
    this.key,
    this.cardinality,
  );

  final String key;
  final int cardinality;
}
