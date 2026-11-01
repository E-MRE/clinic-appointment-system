import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_rule_context.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/window_limit_rule.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/availability_fixture.dart';
import '../support/availability_matchers.dart';

void main() {
  const fixture = AvailabilityFixture();
  const matchers = AvailabilityMatchers();
  const rule = WindowLimitRule();
  group('WindowLimitRule', () {
    test(
      'allows the twelfth weekly window, rejects the thirteenth on that day',
      () {
        final eleven = StaffAvailability(
          staffId: 'staff',
          branchId: 'branch',
          weekly: List.generate(
            11,
            (index) => fixture.weekly(540 + index, 541 + index),
          ),
        );
        final candidate = fixture.weekly(600, 660);
        final context = AvailabilityRuleContext(
          current: eleven,
          branchHours: fixture.hours,
          today: fixture.monday,
        );
        expect(() => rule.check(candidate, context), returnsNormally);
        final full = AvailabilityRuleContext(
          current: eleven.adding(candidate),
          branchHours: fixture.hours,
          today: fixture.monday,
        );
        expect(
          () => rule.check(fixture.weekly(660, 720), full),
          matchers.throwsCode(AvailabilityErrorCode.tooManyWindows),
        );
        expect(
          () =>
              rule.check(fixture.weekly(540, 600, day: Weekday.tuesday), full),
          returnsNormally,
        );
        expect(
          () => rule.check(fixture.oneOff(540, 600), full),
          returnsNormally,
        );
      },
    );
    test('allows the sixtieth dated window, rejects the sixty-first', () {
      final fiftyNine = StaffAvailability(
        staffId: 'staff',
        branchId: 'branch',
        oneOff: List.generate(
          59,
          (index) => fixture.oneOff(540 + index, 541 + index),
        ),
      );
      final candidate = fixture.oneOff(660, 720);
      expect(
        () => rule.check(
          candidate,
          AvailabilityRuleContext(
            current: fiftyNine,
            branchHours: fixture.hours,
            today: fixture.monday,
          ),
        ),
        returnsNormally,
      );
      final full = AvailabilityRuleContext(
        current: fiftyNine.adding(candidate),
        branchHours: fixture.hours,
        today: fixture.monday,
      );
      expect(
        () => rule.check(fixture.oneOff(780, 840, date: fixture.tuesday), full),
        matchers.throwsCode(AvailabilityErrorCode.tooManyWindows),
      );
      expect(() => rule.check(fixture.weekly(540, 600), full), returnsNormally);
    });
  });
}
