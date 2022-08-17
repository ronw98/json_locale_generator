import 'package:json_locale_generator/src/generator/json_class_generator.dart';
import 'package:test/test.dart';

import 'fixtures/fixtures.dart';

void main() {
  group('Generate field', () {
    test('Generate one non static String field', () {
      expect(
        generateNonStaticField('ClassName', 'value', 'class_name', 'value'),
        "final String value = 'class_name.value';",
      );
    });

    test('Generate one non static complex field', () {
      expect(
        generateNonStaticField('ParentClass', 'field', 'parent_class', {}),
        'final _ParentClassField field = const _ParentClassField();',
      );
    });

    test('Generate one static String field', () {
      expect(
        generateStaticField('ClassName', 'value', null, 'value'),
        "static const String value = 'value';",
      );
    });

    test('Generate one static complex field', () {
      expect(
        generateStaticField('ParentClass', 'field', '', {}),
        'static const _ParentClassField field = _ParentClassField();',
      );
    });
  });

  group('Generate sub class', () {
    test('Generate empty class', () {
      final result = generateSubClass('SubClass', 'sub_class', {});
      expect(result, fixture('empty_generated_class.text'));
    });

    test('Generate class with one String field and one non String field', () {
      final result = generateSubClass(
        'SubClass',
        'sub_class',
        {
          'stringField': 'value',
          'classField': <String, dynamic>{},
        },
      );
      expect(result, fixture('generated_subclass.text'));
    });
  });

  test('Generate public class', () {
    final result = generateParentClass(
      'TestClass',
      {
        'staticField': 'value',
        'staticClassField': {
          'subClassField': 'value',
          'subClassClassField': {
            'lastField': 'value',
          }
        }
      },
    );

    expect(result, fixture('public_class_full.text'));
  });

  test('Generate public class with unsafe words', () {
    final result = generateParentClass(
      'TestClass',
      {
        'break': 'value',
        'staticClassField': {
          '12-98-subClassField': 'value',
          '10-invalidField': {
            '/12-&lastField': 'value',
          }
        }
      },
    );

    expect(result, fixture('public_class_unsafe.text'));
  });
}
