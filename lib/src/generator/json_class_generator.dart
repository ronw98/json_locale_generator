import 'package:json_locale_generator/src/model/generation_key.dart';
import 'package:json_locale_generator/src/utils.dart';

String generateParentClass(String className, Map<GenerationKey, dynamic> json) {
  final fields = json.entries.map(
    (entry) => generateStaticField(className, entry.key, null, entry.value),
  );

  final fieldsClasses = json.entries
      .where((entry) => entry.value is Map<GenerationKey, dynamic>)
      .map(
        (entry) => generateSubClass(
          fieldAndParentClassToClassName(entry.key.dartPropertyName, className),
          entry.key.jsonKey,
          entry.value as Map<GenerationKey, dynamic>,
        ),
      );
  return '''
class $className {
  const $className._();

${fields.isNotEmpty ? '''  ${fields.join('\n  ')}''' : ''}
}

${fieldsClasses.join('\n')}''';
}

String generateSubClass(
  String className,
  String? currentPath,
  Map<GenerationKey, dynamic> json,
) {
  final fields = json.entries.map(
    (entry) =>
        generateNonStaticField(className, entry.key, currentPath, entry.value),
  );

  final fieldsClasses = json.entries
      .where((entry) => entry.value is Map<GenerationKey, dynamic>)
      .map(
        (entry) => generateSubClass(
          fieldAndParentClassToClassName(entry.key.dartPropertyName, className),
          currentPath == null
              ? entry.key.jsonKey
              : '$currentPath.${entry.key.jsonKey}',
          entry.value as Map<GenerationKey, dynamic>,
        ),
      );
  return '''
class $className {
  const $className();
${fields.isNotEmpty ? '''\n  ${fields.join('\n  ')}''' : ''}
}
${fieldsClasses.isNotEmpty ? '''\n${fieldsClasses.join('\n\n')}''' : ''}''';
}

String generateNonStaticField(
  String parentClassName,
  GenerationKey generationKey,
  String? currentPath,
  dynamic value,
) {
  if (value is String) {
    final newPath = currentPath == null
        ? generationKey.jsonKey
        : '$currentPath.${generationKey.jsonKey}';
    return '''final String ${generationKey.dartPropertyName} = '$newPath';''';
  }
  final fieldType = fieldAndParentClassToClassName(
    generationKey.dartPropertyName,
    parentClassName,
  ).sanitize;
  return '''final $fieldType ${generationKey.dartPropertyName} = const $fieldType();''';
}

String generateStaticField(
  String parentClassName,
  GenerationKey generationKey,
  String? currentPath,
  dynamic value,
) {
  if (value is String) {
    final newPath = currentPath == null
        ? generationKey.jsonKey
        : '$currentPath.${generationKey.jsonKey}';
    return '''static const String ${generationKey.dartPropertyName} = '$newPath';''';
  }
  final fieldType = fieldAndParentClassToClassName(
    generationKey.dartPropertyName,
    parentClassName,
  ).sanitize;
  return '''static const $fieldType ${generationKey.dartPropertyName} = $fieldType();''';
}

String fieldAndParentClassToClassName(
  String fieldName,
  String parentClassName,
) =>
    '_$parentClassName${fieldName.capitalize()}';
