import 'dart:convert';

import 'package:build/build.dart';
import 'package:json_locale_generator/src/model/resources.dart';
import 'package:json_locale_generator/src/utils.dart';

Future<String> generateJsonAsset(BuildStep buildStep, JsonAsset asset) async {
  return generateParentClass(
    asset.outputClass,
    jsonDecode(
      await buildStep.readAsString(asset.id),
    ) as Map<String, dynamic>,
  );
}

String generateParentClass(String className, Map<String, dynamic> json) {
  final fields = json.entries.map(
    (entry) => generateStaticField(className, entry.key, null, entry.value),
  );

  final fieldsClasses =
      json.entries.where((entry) => entry.value is Map<String, dynamic>).map(
            (entry) => generateSubClass(
              fieldAndParentClassToClassName(entry.key, className),
              entry.key,
              entry.value as Map<String, dynamic>,
            ),
          );
  return '''
class $className {
${fields.isNotEmpty ? '''  ${fields.join('\n  ')}''' : ''}
}

${fieldsClasses.join('\n')}''';
}

String generateSubClass(
  String className,
  String? currentPath,
  Map<String, dynamic> json,
) {
  final fields = json.entries.map(
    (entry) =>
        generateNonStaticField(className, entry.key, currentPath, entry.value),
  );

  final fieldsClasses =
      json.entries.where((entry) => entry.value is Map<String, dynamic>).map(
            (entry) => generateSubClass(
              fieldAndParentClassToClassName(entry.key, className),
              currentPath == null ? entry.key : '$currentPath.${entry.key}',
              entry.value as Map<String, dynamic>,
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
  String fieldName,
  String? currentPath,
  dynamic value,
) {
  if (value is String) {
    final newPath = currentPath == null ? fieldName : '$currentPath.$fieldName';
    return '''final String $fieldName = '$newPath';''';
  }
  final fieldType = fieldAndParentClassToClassName(fieldName, parentClassName);
  return '''final $fieldType $fieldName = const $fieldType();''';
}

String generateStaticField(
  String parentClassName,
  String fieldName,
  String? currentPath,
  dynamic value,
) {
  if (value is String) {
    final newPath = currentPath == null ? fieldName : '$currentPath.$fieldName';
    return '''static const String $fieldName = '$newPath';''';
  }
  final fieldType = fieldAndParentClassToClassName(fieldName, parentClassName);
  return '''static const $fieldType $fieldName = $fieldType();''';
}

String fieldAndParentClassToClassName(
  String fieldName,
  String parentClassName,
) =>
    '_$parentClassName${fieldName.capitalize()}';
