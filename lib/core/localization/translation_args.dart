/// Centralized keys and arguments for localized string interpolation.
abstract final class TranslationArgs {
  /// Parameter key for minimum password length in validation and hint strings.
  static const String minimumLength = 'minimumLength';

  /// Builds a `namedArgs` map interpolating [minimumLength].
  static Map<String, String> forMinimumLength(int length) {
    return <String, String>{minimumLength: '$length'};
  }
}
