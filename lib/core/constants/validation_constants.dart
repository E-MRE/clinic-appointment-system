/// Shared input rules used by form validators across the application.
abstract final class ValidationConstants {
  static final emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static const minimumPasswordLength = 6;
}
