import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/medical_service_kind_localization.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/money_formatting.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_catalog.dart';
import 'package:clinic_appointment_system/features/patient/presentation/visitors/patient_preparation_note_visitor.dart';

/// Localized text of a service card on the booking page.
extension BookingServicePresentation on MedicalService {
  /// The length (`20 dk`).
  String get durationLabel {
    return LocaleKeys.services_durationMinutes.translate(
      args: ['${duration.minutes}'],
    );
  }

  /// The fee (`₺950`).
  String get feeLabel => fee.formatted();

  /// Kind, length and fee (`Muayene · 20 dk · ₺950`).
  String get bookingCaption {
    return LocaleKeys.patient_book_serviceCaption.translate(
      args: [kind.label, durationLabel, feeLabel],
    );
  }

  /// The preparation note when the service has one, else the department name.
  String bookingDetail(PatientCatalog catalog) {
    return accept(const PatientPreparationNoteVisitor()) ??
        catalog.departmentById(departmentId)?.name ??
        LocaleKeys.common_notAvailable.translate();
  }
}
