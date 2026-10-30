import 'package:clinic_appointment_system/features/medical_services/domain/enums/lab_result_time.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/lab_result_time_localization.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';

void main() {
  testWidgets('resolves labels and summary phrases for all lab result times', (
    tester,
  ) async {
    await loadTestTranslations(tester);

    expect(LabResultTime.sameDay.label, 'Aynı gün');
    expect(LabResultTime.sameDay.resultSummary, 'aynı gün');

    expect(LabResultTime.oneDay.label, '1 gün');
    expect(LabResultTime.oneDay.resultSummary, '1 gün');

    expect(LabResultTime.twoDays.label, '2 gün');
    expect(LabResultTime.twoDays.resultSummary, '2 gün');

    expect(LabResultTime.threeDays.label, '3 gün');
    expect(LabResultTime.threeDays.resultSummary, '3 gün');

    expect(LabResultTime.oneWeek.label, '1 hafta');
    expect(LabResultTime.oneWeek.resultSummary, '1 hafta');
  });
}
