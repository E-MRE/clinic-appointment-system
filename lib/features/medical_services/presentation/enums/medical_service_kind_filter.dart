import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';

/// Filter choices for medical service lists.
enum MedicalServiceKindFilter {
  /// Matches every service kind.
  all(kind: null, labelKey: LocaleKeys.services_all),

  /// Doctor examinations only.
  examination(
    kind: MedicalServiceKind.examination,
    labelKey: LocaleKeys.services_examination,
  ),

  /// Medical imaging only.
  radiology(
    kind: MedicalServiceKind.radiology,
    labelKey: LocaleKeys.services_radiology,
  ),

  /// Laboratory diagnostic tests only.
  lab(kind: MedicalServiceKind.lab, labelKey: LocaleKeys.services_labTest);

  const MedicalServiceKindFilter({required this.kind, required this.labelKey});

  /// Specific medical service kind matched by this filter, or null for all.
  final MedicalServiceKind? kind;

  /// Translation key for the filter button label.
  final String labelKey;

  /// Whether [service] belongs to this filter category.
  bool matches(MedicalService service) => kind == null || service.kind == kind;

  /// Counts the services matching this filter in [services].
  int countIn(List<MedicalService> services) => services.where(matches).length;
}
