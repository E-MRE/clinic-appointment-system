/// Turkish-aware case folding for searching and ordering [String] values.
extension TurkishCaseFolding on String {
  /// This string in lower case under Turkish rules ("I" → "ı", "İ" → "i").
  String get turkishLowercase {
    return replaceAll('I', 'ı').replaceAll('İ', 'i').toLowerCase();
  }

  /// Whether this string contains [query], ignoring case under Turkish rules.
  bool containsTurkishInsensitive(String query) {
    return turkishLowercase.contains(query.turkishLowercase);
  }
}
