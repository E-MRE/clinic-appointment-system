import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_rule_context.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/no_overlap_rule.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/availability_fixture.dart';

void main() {
  const fixture = AvailabilityFixture();
  const rule = NoOverlapRule();
  group('NoOverlapRule', () {
    test('carries the existing conflict across weekly and dated windows', () {
      final existing = fixture.weekly(540, 600);
      final context = AvailabilityRuleContext(
        current: fixture.empty.adding(existing),
        branchHours: fixture.hours,
        today: fixture.monday,
      );
      expect(
        () => rule.check(fixture.oneOff(570, 630), context),
        throwsA(
          isA<AvailabilityException>()
              .having(
                (error) => error.code,
                'code',
                AvailabilityErrorCode.overlappingWindow,
              )
              .having((error) => error.conflict, 'conflict', same(existing)),
        ),
      );
    });
    test('accepts touching edges and dates without a shared day', () {
      final context = AvailabilityRuleContext(
        current: fixture.empty.adding(fixture.oneOff(540, 600)),
        branchHours: fixture.hours,
        today: fixture.monday,
      );
      expect(
        () => rule.check(fixture.weekly(600, 660), context),
        returnsNormally,
      );
      expect(
        () => rule.check(
          fixture.oneOff(540, 600, date: fixture.tuesday),
          context,
        ),
        returnsNormally,
      );
    });
  });
}
