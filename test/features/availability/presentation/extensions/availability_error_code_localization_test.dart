import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/presentation/extensions/availability_error_code_localization.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';
import '../../domain/support/availability_fixture.dart';

void main() {
  testWidgets('every failure has distinct Turkish recovery copy', (
    tester,
  ) async {
    await loadTestTranslations(tester);
    expect(AvailabilityErrorCode.values.map((code) => code.message()), [
      'Bu aralık aynı gündeki başka bir aralıkla çakışıyor.',
      'Aralık şube çalışma saatlerinin dışına taşıyor.',
      'Şube bu gün kapalı.',
      'Geçmiş bir tarihe aralık eklenemez.',
      'Bu gün için aralık sınırına ulaşıldı.',
      'Aralık artık mevcut değil.',
      'Uygunluk kaydı okunamadı.',
      'Uygunluk şu anda yüklenemiyor. Lütfen tekrar deneyin.',
    ]);
    const fixture = AvailabilityFixture();
    expect(
      AvailabilityErrorCode.overlappingWindow.message(
        conflict: fixture.weekly(540, 720),
      ),
      'Bu aralık Pazartesi 09:00–12:00 ile çakışıyor. Mevcut aralığı genişletin ya da 12:00 sonrasını seçin.',
    );
    expect(
      AvailabilityErrorCode.outsideBranchHours.message(
        conflict: fixture.weekly(540, 720),
      ),
      'Aralık şube çalışma saatlerinin dışına taşıyor.',
    );
  });
}
