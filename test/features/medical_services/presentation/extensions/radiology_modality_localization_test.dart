import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/radiology_modality_localization.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';

void main() {
  testWidgets('resolves labels for all radiology modalities', (tester) async {
    await loadTestTranslations(tester);

    expect(RadiologyModality.xRay.label, 'Röntgen');
    expect(RadiologyModality.ultrasound.label, 'Ultrason');
    expect(RadiologyModality.mri.label, 'MR');
    expect(RadiologyModality.ct.label, 'BT');
  });
}
