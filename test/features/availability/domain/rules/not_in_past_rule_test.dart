import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_rule_context.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/not_in_past_rule.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/availability_fixture.dart';
import '../support/availability_matchers.dart';

void main() {
  const fixture = AvailabilityFixture();
  const matchers = AvailabilityMatchers();
  const rule = NotInPastRule();
  group('NotInPastRule', () {
    test(
      'rejects yesterday but accepts today, future and recurring windows',
      () {
        final context = AvailabilityRuleContext(
          current: fixture.empty,
          branchHours: fixture.hours,
          today: fixture.tuesday,
        );
        expect(
          () => rule.check(fixture.oneOff(540, 600), context),
          matchers.throwsCode(AvailabilityErrorCode.pastDate),
        );
        expect(
          () => rule.check(
            fixture.oneOff(540, 600, date: fixture.tuesday),
            context,
          ),
          returnsNormally,
        );
        expect(
          () => rule.check(
            fixture.oneOff(
              540,
              600,
              date: CalendarDate(year: 2030, month: 1, day: 1),
            ),
            context,
          ),
          returnsNormally,
        );
        expect(
          () => rule.check(fixture.weekly(540, 600), context),
          returnsNormally,
        );
      },
    );
  });
}
