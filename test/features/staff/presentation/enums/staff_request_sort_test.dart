import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_request_sort.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_request_sort_ordering.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';

void main() {
  group('StaffRequestSort', () {
    testWidgets('exposes localized sort labels', (tester) async {
      await loadTestTranslations(tester);

      expect(StaffRequestSort.byDate.label, 'Tarihe göre');
      expect(StaffRequestSort.byRequestTime.label, 'Talep sırasına göre');
    });
  });
}
