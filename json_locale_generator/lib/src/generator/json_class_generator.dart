import 'package:code_builder/code_builder.dart';
import 'package:json_locale_generator/src/generator/leaf_method_generator.dart';
import 'package:json_locale_generator/src/generator/node_class_generator.dart';
import 'package:json_locale_generator/src/model/generation_key.dart';

List<Class> generateParentClass(
  String className,
  Map<GenerationKey, dynamic> json,
) {
  final leafMethods =
      json.entries.where((entry) => entry.value is GenerationValue).map(
            (entry) => generateLeafMethodDeclaration(
              entry.key,
              null,
              entry.value as GenerationValue,
              static: true,
            ),
          );

  final nodeClassesFields = json.entries
      .where((entry) => entry.value is Map<GenerationKey, dynamic>)
      .map(
        (entry) => generateNodeClassField(
          className,
          entry.key,
          static: true,
        ),
      );

  final nodeClasses = json.entries
      .where(
        (entry) => entry.value is Map<GenerationKey, dynamic>,
      )
      .map(
        (entry) => generateNodeClassAndDescendingClasses(
          className,
          entry.key,
          null,
          entry.value as Map<GenerationKey, dynamic>,
        ),
      )
      .fold<List<Class>>(
    [],
    (List<Class> previousValue, List<Class> element) => previousValue + element,
  );

  final generatedClasses = <Class>[];
  generatedClasses.add(generateTranslatableClass());
  generatedClasses.add(generateTranslatablePluralClass());
  generatedClasses.add(
    Class(
      (c) => c
        ..name = className
        ..constructors.add(
          Constructor(
            (c) => c
              ..name = '_'
              ..constant = true,
          ),
        )
        ..fields.addAll(nodeClassesFields)
        ..methods.addAll(leafMethods),
    ),
  );

  generatedClasses.addAll(nodeClasses);

  return generatedClasses;
}

Class generateTranslatableClass() {
  return Class(
    (c) => c
      ..name = 'Translatable'
      ..constructors.add(
        Constructor(
          (c) => c
            ..requiredParameters.addAll(
              [
                Parameter(
                  (p) => p
                    ..name = 'key'
                    ..toThis = true,
                ),
                Parameter(
                  (p) => p
                    ..name = 'params'
                    ..toThis = true,
                ),
              ],
            ),
        ),
      )
      ..fields.addAll(
        [
          Field(
            (f) => f
              ..modifier = FieldModifier.final$
              ..name = 'key'
              ..type = const Reference('String'),
          ),
          Field(
            (f) => f
              ..modifier = FieldModifier.final$
              ..name = 'params'
              ..type = const Reference('Map<String, String>'),
          ),
        ],
      ),
  );
}

Class generateTranslatablePluralClass() {
  return Class(
    (c) => c
      ..name = 'TranslatablePlural'
      ..extend = const Reference('Translatable')
      ..constructors.add(
        Constructor(
          (c) => c
            ..requiredParameters.addAll(
              [
                Parameter(
                  (p) => p
                    ..name = 'key'
                    ..toSuper = true,
                ),
                Parameter(
                  (p) => p
                    ..name = 'params'
                    ..toSuper = true,
                ),
                Parameter(
                  (p) => p
                    ..name = 'cardinality'
                    ..toThis = true,
                ),
              ],
            ),
        ),
      )
      ..fields.addAll(
        [
          Field(
                (f) => f
              ..modifier = FieldModifier.final$
              ..name = 'cardinality'
              ..type = const Reference('int'),
          ),
        ],
      ),
  );
}
