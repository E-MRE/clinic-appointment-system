import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/medical_service_kind_localization.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/money_formatting.dart';
import 'package:clinic_appointment_system/features/patient/presentation/visitors/patient_preparation_note_visitor.dart';

/// Localized text of a service card on the booking page.
extension BookingServicePresentation on MedicalService {
  /// The service duration as a localized label.
  String get durationLabel {
    return LocaleKeys.services_durationMinutes.translate(
      args: ['${duration.minutes}'],
    );
  }

  /// The service fee as a localized label.
  String get feeLabel => fee.formatted();

  /// A localized summary with the service kind, duration and fee.
  String get bookingCaption {
    return LocaleKeys.patient_book_serviceCaption.translate(
      args: [kind.label, durationLabel, feeLabel],
    );
  }

  /// The preparation note when the service has one, else the department name.
  String bookingDetail(ClinicCatalog catalog) {
    return accept(const PatientPreparationNoteVisitor()) ??
        catalog.departmentById(departmentId)?.name ??
        LocaleKeys.common_notAvailable.translate();
  }
}
