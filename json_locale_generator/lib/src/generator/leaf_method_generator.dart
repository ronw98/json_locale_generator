import 'package:code_builder/code_builder.dart';
import 'package:json_locale_generator/src/model/generation_key.dart';

Method generateLeafMethodDeclaration(
  GenerationKey generationKey,
  String? currentPath,
  GenerationValue value, {
  required bool static,
}) {
  final methodName = generationKey.dartPropertyName;

  return Method(
    (m) => m
      ..static = static
      ..returns = generationKey.plural
          ? const Reference('TranslatablePlural')
          : const Reference('Translatable')
      ..body = generateMethodBody(currentPath, generationKey, value)
      ..name = methodName
      ..optionalParameters.addAll(
        generationKey.plural
            ? [
                Parameter(
                  (p) => p
                    ..name = 'cardinality'
                    ..type = const Reference('int')
                    ..required = true
                    ..named = true,
                ),
              ]
            : value.params.map(
                (param) => Parameter(
                  (p) => p
                    ..name = param.dartProperty
                    ..type = const Reference('String')
                    ..required = true
                    ..named = true,
                ),
              ),
      ),
  );
}

String generateFieldMethodType(GenerationValue generationValue) {
  return 'Translatable Function(${generateMethodParams(generationValue)})';
}

Code generateMethodBody(
  String? currentPath,
  GenerationKey key,
  GenerationValue value,
) {
  final entryPath =
      currentPath == null ? key.jsonKey : '$currentPath.${key.jsonKey}';

  if (key.plural) {
    return Code('''
    return TranslatablePlural(
  '$entryPath',
  {
  },
  cardinality,
);''');
  }

  final trailingComma = value.params.isEmpty ? '' : ',';
  return Code('''
return Translatable(
  '$entryPath',
  {
  ${value.params.map((param) => "'${param.dartProperty}': ${param.dartProperty}").join(',\n')}$trailingComma
  },
);''');
}

String generateMethodParams(GenerationValue value) {
  if (value.params.isEmpty) return '';
  return "{${value.params.map((param) => 'required String ${param.dartProperty}').join(',\n  ')},\n}";
}
