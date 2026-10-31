import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_policy.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_rule_context.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/no_overlap_rule.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/not_in_past_rule.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/within_branch_hours_rule.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/availability_fixture.dart';
import '../support/availability_matchers.dart';

void main() {
  const fixture = AvailabilityFixture();
  const matchers = AvailabilityMatchers();
  group('AvailabilityPolicy', () {
    test(
      'standard policy reports pastDate before outside hours and overlap',
      () {
        final candidate = fixture.oneOff(480, 540);
        final context = AvailabilityRuleContext(
          current: fixture.empty.adding(candidate),
          branchHours: fixture.hours,
          today: fixture.tuesday,
        );
        expect(
          () => const AvailabilityPolicy.standard().check(candidate, context),
          matchers.throwsCode(AvailabilityErrorCode.pastDate),
        );
      },
    );
    test('standard policy reports branch hours before overlap', () {
      final candidate = fixture.weekly(480, 540);
      final context = AvailabilityRuleContext(
        current: fixture.empty.adding(candidate),
        branchHours: fixture.hours,
        today: fixture.monday,
      );
      expect(
        () => const AvailabilityPolicy.standard().check(candidate, context),
        matchers.throwsCode(AvailabilityErrorCode.outsideBranchHours),
      );
    });
    test('standard policy reports overlap before the window limit', () {
      final candidate = fixture.weekly(540, 600);
      final full = StaffAvailability(
        staffId: 'staff',
        branchId: 'branch',
        weekly: List.filled(12, candidate),
      );
      final context = AvailabilityRuleContext(
        current: full,
        branchHours: fixture.hours,
        today: fixture.monday,
      );
      expect(
        () => const AvailabilityPolicy.standard().check(candidate, context),
        matchers.throwsCode(AvailabilityErrorCode.overlappingWindow),
      );
    });
    test('standard policy accepts a valid window', () {
      final context = AvailabilityRuleContext(
        current: fixture.empty,
        branchHours: fixture.hours,
        today: fixture.monday,
      );
      expect(
        () => const AvailabilityPolicy.standard().check(
          fixture.weekly(540, 600),
          context,
        ),
        returnsNormally,
      );
    });
    test(
      'custom policy follows the supplied rule order and permits empty rules',
      () {
        final candidate = fixture.oneOff(480, 540);
        final context = AvailabilityRuleContext(
          current: fixture.empty.adding(candidate),
          branchHours: fixture.hours,
          today: fixture.tuesday,
        );
        expect(
          () => const AvailabilityPolicy([
            WithinBranchHoursRule(),
            NotInPastRule(),
            NoOverlapRule(),
          ]).check(candidate, context),
          matchers.throwsCode(AvailabilityErrorCode.outsideBranchHours),
        );
        expect(
          () => const AvailabilityPolicy([]).check(candidate, context),
          returnsNormally,
        );
      },
    );
  });
}
