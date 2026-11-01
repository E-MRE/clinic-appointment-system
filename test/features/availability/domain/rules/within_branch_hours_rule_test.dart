import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_rule_context.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/within_branch_hours_rule.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/availability_fixture.dart';
import '../support/availability_matchers.dart';

void main() {
  const fixture = AvailabilityFixture();
  const matchers = AvailabilityMatchers();
  const rule = WithinBranchHoursRule();
  group('WithinBranchHoursRule', () {
    final context = AvailabilityRuleContext(
      current: fixture.empty,
      branchHours: fixture.hours,
      today: fixture.monday,
    );
    test('rejects crossing lunch and starting before opening', () {
      for (final window in [
        fixture.weekly(660, 840),
        fixture.weekly(480, 540),
        fixture.oneOff(660, 840),
        fixture.weekly(1020, 1081),
      ]) {
        expect(
          () => rule.check(window, context),
          matchers.throwsCode(AvailabilityErrorCode.outsideBranchHours),
        );
      }
    });
    test('accepts exact morning and afternoon branch ranges', () {
      for (final window in [
        fixture.weekly(510, 720),
        fixture.weekly(780, 1080),
        fixture.oneOff(510, 720),
        fixture.oneOff(780, 1080),
      ]) {
        expect(() => rule.check(window, context), returnsNormally);
      }
    });
    test('reports branchClosed for Saturday', () {
      expect(
        () => rule.check(
          fixture.weekly(540, 600, day: Weekday.saturday),
          context,
        ),
        matchers.throwsCode(AvailabilityErrorCode.branchClosed),
      );
    });
  });
}
