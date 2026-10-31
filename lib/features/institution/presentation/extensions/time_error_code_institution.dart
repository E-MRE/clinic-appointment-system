import 'package:clinic_appointment_system/core/enums/time_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';

/// Maps shared time validation failures to institution messages.
extension TimeErrorCodeInstitution on TimeErrorCode {
  /// The corresponding institution validation code.
  InstitutionErrorCode get institutionCode => switch (this) {
    TimeErrorCode.invalidTime => InstitutionErrorCode.invalidTime,
    TimeErrorCode.endBeforeStart => InstitutionErrorCode.closeBeforeOpen,
    TimeErrorCode.invalidDate => InstitutionErrorCode.invalidTime,
  };
}
