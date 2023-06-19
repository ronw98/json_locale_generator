## 1.0.0

* **Breaking**:
  * Leaf generation generates methods returning `Translatable` objects.
  * This package can no longer be used as a standalone and mus tbe used with [json_locale](https://pub.dev/packages/json_locale)

## 0.2.4

* Add `const` private constructor to generated public classes to prevent instantiating them

## 0.2.3

* *Fix*: Fix mistake making the builder not usable

## 0.2.2

* *Fix*: Fix cleaning changing json key in generated strings

## 0.2.1

* Improve pub score

## 0.2.0

* **Feature**: Handle plural values with regexp matching
* *Fix*: Clean and validate input json files to avoid errors in generated dart code
* Improve test coverage

## 0.1.3

* Update readme

## 0.1.2

* *Fix*: Readme and changelog

## 0.1.1

* *Fix*: Keywords and '-' in json keys caused errors in generated dart code
* Improve pub score

## 0.1.0

* **Breaking**: `[dart|flutter] pub run json_locale_generator:generate` is no longer usable
* *Fix*: Modifications on json files now trigger rebuilds

## 0.0.3

* Ignore warnings in generated file

## 0.0.2

* Improve pub score

## 0.0.1

* Initial release.
