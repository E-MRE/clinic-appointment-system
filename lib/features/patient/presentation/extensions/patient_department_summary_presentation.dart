import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_department_summary.dart';

/// Localized text of a department row.
extension PatientDepartmentSummaryPresentation on PatientDepartmentSummary {
  /// The number of bookable services (`4 hizmet`).
  String get serviceCountLabel {
    return LocaleKeys.patient_appointments_departmentServices.translate(
      args: ['$serviceCount'],
    );
  }
}
