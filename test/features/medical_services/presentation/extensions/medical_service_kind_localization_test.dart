import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/medical_service_kind_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';

void main() {
  const scheme = ColorScheme.light();

  testWidgets('resolves labels and icons for all service kinds', (
    tester,
  ) async {
    await loadTestTranslations(tester);

    expect(MedicalServiceKind.examination.label, 'Muayene');
    expect(
      MedicalServiceKind.examination.icon,
      Icons.medical_services_outlined,
    );
    expect(
      MedicalServiceKind.examination.containerColor(scheme),
      scheme.surfaceContainerHighest,
    );
    expect(
      MedicalServiceKind.examination.foregroundColor(scheme),
      scheme.onSurfaceVariant,
    );

    expect(MedicalServiceKind.radiology.label, 'Radyoloji');
    expect(
      MedicalServiceKind.radiology.icon,
      Icons.center_focus_strong_outlined,
    );
    expect(
      MedicalServiceKind.radiology.containerColor(scheme),
      scheme.secondaryContainer,
    );
    expect(
      MedicalServiceKind.radiology.foregroundColor(scheme),
      scheme.onSecondaryContainer,
    );

    expect(MedicalServiceKind.lab.label, 'Laboratuvar');
    expect(MedicalServiceKind.lab.icon, Icons.science_outlined);
    expect(
      MedicalServiceKind.lab.containerColor(scheme),
      scheme.tertiaryContainer,
    );
    expect(
      MedicalServiceKind.lab.foregroundColor(scheme),
      scheme.onTertiaryContainer,
    );
  });
}
