import 'package:code_builder/code_builder.dart';
import 'package:json_locale_generator/src/generator/generator_utils.dart';
import 'package:json_locale_generator/src/generator/leaf_method_generator.dart';
import 'package:json_locale_generator/src/model/generation_key.dart';

/// Returns all the classes needed for the generation of the given [generationKey] and associated [json]
List<Class> generateNodeClassAndDescendingClasses(
  String parentClassName,
  GenerationKey generationKey,
  String? currentPath,
  Map<GenerationKey, dynamic> json,
) {
  final className = fieldAndParentClassToClassName(
    generationKey.dartPropertyName,
    parentClassName,
  );

  final updatedCurrentPath = currentPath == null
      ? generationKey.jsonKey
      : '$currentPath.${generationKey.jsonKey}';

  final methods =
      json.entries.where((entry) => entry.value is GenerationValue).map(
            (entry) => generateLeafMethodDeclaration(
              entry.key,
              updatedCurrentPath,
              entry.value as GenerationValue,
              static: false,
            ),
          );

  final nodeClassesFields = json.entries
      .where((entry) => entry.value is Map<GenerationKey, dynamic>)
      .map(
        (entry) => generateNodeClassField(
          className,
          entry.key,
          static: false,
        ),
      );

  final descendingClasses = json.entries
      .where(
        (entry) => entry.value is Map<GenerationKey, dynamic>,
      )
      .map(
        (entry) => generateNodeClassAndDescendingClasses(
          className,
          entry.key,
          updatedCurrentPath,
          entry.value as Map<GenerationKey, dynamic>,
        ),
      )
      .fold<List<Class>>(
    [],
    (List<Class> previousValue, List<Class> element) => previousValue + element,
  );

  final generatedClasses = <Class>[];
  generatedClasses.add(
    Class(
      (c) => c
        ..name = className
        ..constructors.add(
          Constructor(
            (c) => c..constant = true,
          ),
        )
        ..methods.addAll(methods)
        ..fields.addAll(nodeClassesFields),
    ),
  );
  generatedClasses.addAll(descendingClasses);

  return generatedClasses;
}

Field generateNodeClassField(
  String parentClassName,
  GenerationKey generationKey, {
  required bool static,
}) {
  final fieldType = fieldAndParentClassToClassName(
    generationKey.dartPropertyName,
    parentClassName,
  );
  return Field(
    (f) => f
      ..name = generationKey.dartPropertyName
      ..assignment = Code('const $fieldType()')
      ..static = static
      ..type = Reference(fieldType)
      ..modifier = static ? FieldModifier.constant : FieldModifier.final$,
  );
}
