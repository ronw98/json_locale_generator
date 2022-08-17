class InvalidJsonKeyFormatException implements Exception {
  final String key;

  InvalidJsonKeyFormatException(this.key);
}

class InvalidJsonFormatException implements Exception {
  final String jsonContent;
  final Uri fileUri;
  final String invalidContent;

  InvalidJsonFormatException(
    this.jsonContent,
    this.fileUri,
    this.invalidContent,
  );

  @override
  String toString() {
    return _errorPrinter?.print() ??
        'An unknown error happened in file $fileUri';
  }

  _ErrorPrinter? get _errorPrinter {
    final jsonLines = jsonContent.split('\n');
    for (int i = 0; i < jsonLines.length; i++) {
      final line = jsonLines[i];
      final index = line.indexOf(invalidContent);
      if (index != -1) {
        return _ErrorPrinter(
          fileUri: fileUri,
          lineNb: i,
          line: line,
          offset: index,
          errorLength: invalidContent.length,
        );
      }
    }
    return null;
  }
}

class _ErrorPrinter {
  final Uri fileUri;
  final int lineNb;
  final int offset;
  final String line;
  final int errorLength;

  const _ErrorPrinter({
    required this.fileUri,
    required this.lineNb,
    required this.offset,
    required this.line,
    required this.errorLength,
  });

  String print() {
    return '''
Error when validating file `$fileUri`:$lineNb:$offset
    $line
    ${' ' * offset}${'^' * errorLength}
Illegal character. json keys can not contain \$, . or \\
''';
  }
}
