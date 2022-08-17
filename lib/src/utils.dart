

T? safeCast<T>(dynamic obj) {
  if (obj == null) {
    return null;
  }
  return (obj is T) ? obj : null;
}

extension StringExt on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';

  bool get isKeyword => dartKeywords.contains(this);

  String get sanitize {
    if (isKeyword) {
      return '${this}_';
    }
    String res = this;
    final captureLeadingNumbers = RegExp('[^a-zA-Z_]*');
    final match = captureLeadingNumbers.matchAsPrefix(this);
    final prefix = match?[0];
    if (prefix?.isNotEmpty ?? false) {
      res = res.replaceFirst(prefix!, '');
      // final nonNumericStart = RegExp('[^0-9]*').matchAsPrefix(prefix);
      // final nonNumericPrefixEnd =
      //     RegExp(r'[^0-9]+$').allMatches(prefix).lastOrNull;
      String cleanPrefix = prefix;
      // Remove trailing illegal characters
      // if (nonNumericPrefixEnd?[0]?.isNotEmpty ?? false) {
      //   cleanPrefix = cleanPrefix.replaceRange(
      //     nonNumericPrefixEnd!.start,
      //     nonNumericPrefixEnd.end,
      //     '',
      //   );
      // }
      cleanPrefix =
          cleanPrefix.replaceAllMapped(RegExp('^[^0-9]*'), (match) => '');
      cleanPrefix =
          cleanPrefix.replaceAllMapped(RegExp(r'[^0-9]*$'), (match) => '');
      // Check if the key starts with non alphanum characters and if so remove them
      // if (nonNumericStart?[0]?.isNotEmpty ?? false) {
      //   cleanPrefix = prefix.replaceFirst(nonNumericStart![0]!, '');
      // }
      cleanPrefix = cleanPrefix.replaceNonAlphaNumChars();

      res = '${res}_$cleanPrefix';
    }

    return res.replaceAll(RegExp('[^a-zA-Z0-9_]'), '_');
  }

  String replaceNonAlphaNumChars() => replaceAll(RegExp('[^a-zA-Z0-9_]'), '_');
}

const List<String> dartKeywords = [
  'abstract',
  'as',
  'assert',
  'async',
  'await',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'covariant',
  'default',
  'deferred',
  'do',
  'dynamic',
  'else',
  'enum',
  'export',
  'extends',
  'extension',
  'external',
  'factory',
  'false',
  'final',
  'finally',
  'for',
  'function',
  'get',
  'hide',
  'if',
  'implements',
  'import',
  'in',
  'interface',
  'is',
  'late',
  'library',
  'mixin',
  'new',
  'null',
  'on',
  'operator',
  'part',
  'required',
  'rethrow',
  'return',
  'set',
  'show',
  'static',
  'super',
  'switch',
  'sync',
  'this',
  'throw',
  'true',
  'try',
  'typedef',
  'var',
  'void',
  'while',
  'with',
  'yield',
];
