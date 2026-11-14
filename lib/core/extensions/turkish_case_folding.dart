/// Turkish-aware case folding for searching and ordering [String] values.
extension TurkishCaseFolding on String {
  /// Converts this string to lower case using Turkish letter rules.
  String get turkishLowercase {
    return replaceAll('I', 'ı').replaceAll('İ', 'i').toLowerCase();
  }

  /// Whether this string contains [query], ignoring case under Turkish rules.
  bool containsTurkishInsensitive(String query) {
    return turkishLowercase.contains(query.turkishLowercase);
  }
}
