import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:flutter/material.dart';

/// Display labels, icons, and theme colors for medical service kinds.
extension MedicalServiceKindLocalization on MedicalServiceKind {
  /// Localized name of this service kind.
  String get label => labelKey.translate();

  /// Localization key for this service kind.
  String get labelKey => switch (this) {
    MedicalServiceKind.examination => LocaleKeys.services_kinds_examination,
    MedicalServiceKind.radiology => LocaleKeys.services_kinds_radiology,
    MedicalServiceKind.lab => LocaleKeys.services_kinds_lab,
  };

  /// Material icon representing this service kind.
  IconData get icon => switch (this) {
    MedicalServiceKind.examination => Icons.medical_services_outlined,
    MedicalServiceKind.radiology => Icons.center_focus_strong_outlined,
    MedicalServiceKind.lab => Icons.science_outlined,
  };

  /// Background container color for this kind's icon.
  Color containerColor(ColorScheme scheme) => switch (this) {
    MedicalServiceKind.examination => scheme.surfaceContainerHighest,
    MedicalServiceKind.radiology => scheme.secondaryContainer,
    MedicalServiceKind.lab => scheme.tertiaryContainer,
  };

  /// Foreground icon color for this kind's icon.
  Color foregroundColor(ColorScheme scheme) => switch (this) {
    MedicalServiceKind.examination => scheme.onSurfaceVariant,
    MedicalServiceKind.radiology => scheme.onSecondaryContainer,
    MedicalServiceKind.lab => scheme.onTertiaryContainer,
  };

  /// Container and foreground color pair for this kind.
  (Color container, Color foreground) iconColors(ColorScheme scheme) =>
      (containerColor(scheme), foregroundColor(scheme));
}
