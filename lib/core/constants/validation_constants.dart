/// Shared input rules used by form validators across the application.
abstract final class ValidationConstants {
  static final RegExp emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static const int minimumPasswordLength = 8;
}
