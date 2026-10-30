import 'package:clinic_appointment_system/features/institution/domain/models/institution_draft.dart';

/// Clinic creation input before a repository assigns its identifier.
final class ClinicDraft extends InstitutionDraft {
  /// Creates a clinic draft with its raw name.
  const ClinicDraft({required super.name});

  @override
  ClinicDraft trimmed() => ClinicDraft(name: name.trim());
}
