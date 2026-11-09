import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/widgets/status_badge/status_badge_variant.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/appointment_error_code_localization.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/appointment_status_presentation.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/data_result_appointment_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';

void main() {
  test('result codes resolve safely to appointment codes', () {
    expect(
      const DataResult<void>.error(
        errorCode: AppointmentErrorCode.patientOverlap,
      ).appointmentErrorCode,
      AppointmentErrorCode.patientOverlap,
    );
    expect(
      const DataResult<void>.error(
        errorCode: InstitutionErrorCode.unavailable,
      ).appointmentErrorCode,
      AppointmentErrorCode.unavailable,
    );
    expect(
      const DataResult<void>.error().appointmentErrorCode,
      AppointmentErrorCode.unavailable,
    );
  });

  testWidgets('every error code and status has a translated text', (
    tester,
  ) async {
    await loadTestTranslations(tester);
    for (final code in AppointmentErrorCode.values) {
      expect(code.message, isNot(startsWith('appointment.')), reason: '$code');
    }
    expect(
      AppointmentErrorCode.tooLate.message,
      'Başlamış bir randevu iptal edilemez.',
    );
    for (final status in AppointmentStatus.values) {
      expect(status.label, isNot(startsWith('appointment.')));
    }
    expect(AppointmentStatus.cancelledByStaff.label, 'İptal Edildi');
    expect(
      AppointmentStatus.cancelledByPatient.badgeVariant,
      StatusBadgeVariant.cancelled,
    );
    expect(AppointmentStatus.noShow.badgeVariant, StatusBadgeVariant.noShow);
  });
}
