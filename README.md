<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

A generation tool that builds a class to get your json locale paths from dart code.

## Getting started

1. Add dependencies in your `pubspec.yaml`:

```yaml
dev_dependencies:
  json_locale_generator: ^0.1.3
  build_runner: ^2.0.4
```

2. Configure the json files to generate code for in your `pubspec.yaml`:

```yaml
json_to_dart:
  sample_files:
    # The file assets/en.json will be converted to dart code and values can be accessed via the Locale class
    - source: assets/en.json
      class_name: Locale
    - source: assets/other.json
      class_name: Other
```

3. Execute `[dart|flutter] pub run build_runner build`. The file `jsons.dart` will be generated
   into `lib/jsons.dart`
4. Import `jsons.dart` and start using it:

```dart
import 'jsons.dart';

FlutterI18n.translate(context, Locale.core.app_title);
```

5. To avoid warnings in the generated code, add `lib/jsons.dart` to your `analysis_options.yaml` file:
```yaml
analyzer:
  exclude:
    - lib/jsons.dart
```

## Features

Converts a json such as

```json
{
  "ok": "OK",
  "core": {
    "app_name": "WordSing Battle"
  },
  "home": {
    "title": "No card in the deck"
  }
}
```

To dart code where each path can be accessed easily. For above example,
doing `GeneratedClass.core.app_name` will return the String `'core.app_name'`

JsonKeys that are keywords in dart (`continue`, `if`...) are generated with a trailing
underscore (`continue_`, `if_`)

JsonKeys that have non proper characters in their names (non alphanum + _ characters) will have
these characters replaced by '_'

JsonKeys that start with a number will have this number put at the end, prefixed by an
underscore: `0word` will be `word_0` in dart code

