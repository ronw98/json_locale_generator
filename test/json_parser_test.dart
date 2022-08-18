import 'package:json_locale_generator/src/converter/json_parser.dart';
import 'package:json_locale_generator/src/errors/invalid_json_format.dart';
import 'package:json_locale_generator/src/model/generation_key.dart';
import 'package:test/test.dart';

void main() {
  group('Group plural words', () {
    test('Plural words at root', () {
      final expected = {
        const GenerationKey(
          dartPropertyName: 'word',
          jsonKey: 'word',
        ): 'value',
      };
      final input = {'word-0': 'value', 'word-1': 'value', 'word-2': 'value'};

      expect(jsonCleaner(input, r'-[0-9]*$'), expected);
    });
    test(
      'Plural words deep',
      () {
        final expected = {
          const GenerationKey(
            dartPropertyName: 'intermediate',
            jsonKey: 'intermediate',
          ): {
            const GenerationKey(
              dartPropertyName: 'deep',
              jsonKey: 'deep',
            ): 'value'
          }
        };
        final input = {
          'intermediate': {
            'deep-0': 'value',
            'deep-1': 'value',
            'deep-2': 'value',
          },
        };

        expect(
          jsonCleaner(input, r'-[0-9]*$').toString(),
          expected.toString(),
        );
      },
    );
  });

  group('Does not group words', () {
    test('No plural', () {
      final expected = {
        const GenerationKey(
          dartPropertyName: 'word_0',
          jsonKey: 'word-0',
        ): 'value',
        const GenerationKey(
          dartPropertyName: 'word_1',
          jsonKey: 'word-1',
        ): 'value',
      };
      final input = {'word-0': 'value', 'word-1': 'value'};
      expect(jsonCleaner(input, null), expected);
    });
    test('No regroup if not siblings', () {
      final expected = {
        const GenerationKey(dartPropertyName: 'depth1', jsonKey: 'depth1'): {
          const GenerationKey(
            dartPropertyName: 'word',
            jsonKey: 'word',
          ): 'value',
        },
        const GenerationKey(dartPropertyName: 'depth2', jsonKey: 'depth2'): {
          const GenerationKey(
            dartPropertyName: 'word',
            jsonKey: 'word',
          ): 'value'
        }
      };
      final input = {
        'depth1': {
          'word-0': 'value',
        },
        'depth2': {'word-1': 'value'}
      };
      expect(jsonCleaner(input, r'-[0-9]*$'), expected);
    });
  });

  test('Throws error on invalid character', () {
    final input = {'stuff.z': 'value'};
    expect(
      () => jsonCleaner(input, null),
      throwsA(
        isA<InvalidJsonKeyFormatException>(),
      ),
    );
  });
}
