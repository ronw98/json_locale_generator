import 'package:json_locale_generator/src/converter/json_parser.dart';
import 'package:test/test.dart';

void main() {
  group('Group plural words', () {
    test('Plural words at root', () {
      final expected = {'word': 'value'};
      final input = {'word-0': 'value', 'word-1': 'value', 'word-2': 'value'};

      expect(jsonCleaner(input, r'-[0-9]*$'), expected);
    });
    test(
      'Plural words deep',
      () {
        final expected = {
          'intermediate': {'deep': 'value'}
        };
        final input = {
          'intermediate': {
            'deep-0': 'value',
            'deep-1': 'value',
            'deep-2': 'value',
          },
        };

        expect(jsonCleaner(input, r'-[0-9]*$'), expected);
      },
    );
  });

  group('Does not group words', () {
    test('No plural', () {
      final expected = {'word-0': 'value', 'word-1': 'value'};
      expect(jsonCleaner(expected, null), expected);
    });
    test('No regroup if not siblings', () {
      final expected = {
        'depth1': {
          'word': 'value',
        },
        'depth2': {'word': 'value'}
      };
      expect(jsonCleaner(expected, r'-[0-9]*$'), expected);
    });
  });
}
