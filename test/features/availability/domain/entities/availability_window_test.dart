import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/availability_fixture.dart';

void main() {
  const fixture = AvailabilityFixture();
  group('AvailabilityWindow conflicts', () {
    test('touching weekly edges do not overlap; one minute does', () {
      final noon = fixture.weekly(720, 780);
      final afternoon = fixture.weekly(780, 840);
      final overlap = fixture.weekly(720, 781);
      expect(noon.conflictsWith(afternoon), isFalse);
      expect(afternoon.conflictsWith(noon), isFalse);
      expect(overlap.conflictsWith(afternoon), isTrue);
      expect(afternoon.conflictsWith(overlap), isTrue);
    });

    test('weekly windows on different weekdays do not conflict', () {
      expect(
        fixture
            .weekly(720, 780)
            .conflictsWith(fixture.weekly(720, 780, day: Weekday.tuesday)),
        isFalse,
      );
    });

    test('weekly and one-off conflicts are symmetric and weekday-specific', () {
      final weekly = fixture.weekly(720, 780);
      final extra = fixture.oneOff(750, 810);
      final tuesday = fixture.weekly(720, 780, day: Weekday.tuesday);
      expect(weekly.conflictsWith(extra), isTrue);
      expect(extra.conflictsWith(weekly), isTrue);
      expect(tuesday.conflictsWith(extra), isFalse);
      expect(extra.conflictsWith(tuesday), isFalse);
    });

    test('one-off conflicts require the same date', () {
      final first = fixture.oneOff(720, 780);
      final sameDate = fixture.oneOff(750, 810);
      final otherDate = fixture.oneOff(750, 810, date: fixture.tuesday);
      expect(first.conflictsWith(sameDate), isTrue);
      expect(sameDate.conflictsWith(first), isTrue);
      expect(first.conflictsWith(otherDate), isFalse);
      expect(otherDate.conflictsWith(first), isFalse);
      expect(first.conflictsWith(fixture.oneOff(780, 840)), isFalse);
    });

    test('fits only inside one branch range, including exact edges', () {
      expect(fixture.weekly(510, 720).fitsWithin(fixture.hours), isTrue);
      expect(fixture.oneOff(780, 1080).fitsWithin(fixture.hours), isTrue);
      expect(fixture.weekly(660, 840).fitsWithin(fixture.hours), isFalse);
      expect(
        fixture
            .weekly(540, 600, day: Weekday.saturday)
            .fitsWithin(fixture.hours),
        isFalse,
      );
    });
  });
}
