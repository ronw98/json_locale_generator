import 'package:json_locale_generator/src/generator/json_class_generator.dart';
import 'package:json_locale_generator/src/model/resources.dart';

String generate(Resources res) {
  final classes = <String>[];

  for (final asset in res.jsonAssets) {
    classes.add(generateJsonAsset(asset));
  }
  return classes.join('\n  ');
}
