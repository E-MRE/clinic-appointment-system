import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';

/// An institution domain failure identified independently of its data provider.
final class InstitutionException extends AppException {
  /// Creates an institution failure with its typed [code].
  const InstitutionException(this.code);

  /// The reason the institution operation failed.
  final InstitutionErrorCode code;

  @override
  String toString() => 'InstitutionException: ${code.name}';
}
