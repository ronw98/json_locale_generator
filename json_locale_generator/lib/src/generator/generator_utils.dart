import 'package:json_locale_generator/src/utils.dart';

String fieldAndParentClassToClassName(
  String fieldName,
  String parentClassName,
) {
  return '_$parentClassName${fieldName.capitalize()}'.sanitize;
}
