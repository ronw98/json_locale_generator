T? safeCast<T>(dynamic obj) {
  if (obj == null) {
    return null;
  }
  return (obj is T) ? obj : null;
}

extension StringExt on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}
