import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service_visitor.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/fasting_hours_formatting.dart';

/// The localized preparation a patient needs before a service, or null.
final class PatientPreparationNoteVisitor
    implements MedicalServiceVisitor<String?> {
  /// Creates a stateless note visitor.
  const PatientPreparationNoteVisitor();

  /// Examinations need no preparation.
  @override
  String? visitExamination(Examination service) => null;

  /// Imaging uses the note entered for the service.
  @override
  String? visitRadiology(RadiologyService service) => service.preparationNote;

  /// Laboratory tests describe their fasting window, when one is required.
  @override
  String? visitLabTest(LabTest service) {
    final fasting = service.fastingHours;
    if (fasting == null) return null;
    return LocaleKeys.patient_appointments_fastingNote.translate(
      args: [fasting.formatted],
    );
  }
}
