import 'package:clinic_appointment_system/core/localization/app_formatters.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_calendar_header_title.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_calendar_layout.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';

void main() {
  setUpAll(() async {
    await AppFormatters.ensureInitialized();
  });

  StaffCalendarLayout makeLayout(List<CalendarDate> dates) {
    return StaffCalendarLayout(
      visibleDates: dates,
      appointments: const [],
      availability: StaffAvailability.empty(
        staffId: 'staff_1',
        branchId: 'branch_1',
      ),
      branchHours: WorkingHours.closed(),
      now: DateTime(2026, 10, 26, 10),
    );
  }

  testWidgets('formats same-month week title', (tester) async {
    await loadTestTranslations(tester);

    final start = CalendarDate(year: 2026, month: 10, day: 26);
    final end = CalendarDate(year: 2026, month: 10, day: 31);

    final layout = makeLayout([start, end]);
    expect(layout.headerTitle, '26 – 31 Ekim');
  });

  testWidgets('formats cross-month week title', (tester) async {
    await loadTestTranslations(tester);

    final start = CalendarDate(year: 2026, month: 10, day: 30);
    final end = CalendarDate(year: 2026, month: 11, day: 4);

    final layout = makeLayout([start, end]);
    expect(layout.headerTitle, '30 Eki – 4 Kas');
  });

  testWidgets('formats day title with full weekday and date', (tester) async {
    await loadTestTranslations(tester);

    final monday = CalendarDate(year: 2026, month: 10, day: 26);
    final layout = makeLayout([monday]);
    expect(layout.headerTitle, 'Pazartesi, 26 Ekim');
  });
}
