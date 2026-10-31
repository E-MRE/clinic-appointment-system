import 'package:clinic_appointment_system/features/availability/domain/services/no_slot_exclusion.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/availability_fixture.dart';

void main() {
  const fixture = AvailabilityFixture();
  test('NoSlotExclusion never excludes a candidate', () {
    const exclusion = NoSlotExclusion();
    expect(
      exclusion.excludes(fixture.monday, fixture.range(540, 560)),
      isFalse,
    );
    expect(
      exclusion.excludes(fixture.tuesday, fixture.range(1380, 1439)),
      isFalse,
    );
  });
}
