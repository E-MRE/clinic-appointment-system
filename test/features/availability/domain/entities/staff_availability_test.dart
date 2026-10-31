import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/availability_fixture.dart';

void main() {
  const fixture = AvailabilityFixture();
  group('StaffAvailability', () {
    test('sorts weekly by day/start and one-off by date/start', () {
      final early = fixture.weekly(540, 600);
      final late = fixture.weekly(900, 960);
      final tuesday = fixture.weekly(510, 570, day: Weekday.tuesday);
      final extraEarly = fixture.oneOff(600, 660);
      final extraLate = fixture.oneOff(780, 840);
      final extraTuesday = fixture.oneOff(510, 570, date: fixture.tuesday);
      final availability = StaffAvailability(
        staffId: 'staff',
        branchId: 'branch',
        weekly: [tuesday, late, early],
        oneOff: [extraTuesday, extraLate, extraEarly],
      );
      expect(availability.weekly, [early, late, tuesday]);
      expect(availability.oneOff, [extraEarly, extraLate, extraTuesday]);
      expect(availability.weeklyOn(Weekday.monday), [early, late]);
      expect(availability.windowsOn(fixture.monday), [
        early,
        extraEarly,
        extraLate,
        late,
      ]);
    });

    test('copies input and exposes immutable lists', () {
      final weekly = [fixture.weekly(540, 600)];
      final extras = [fixture.oneOff(780, 840)];
      final availability = StaffAvailability(
        staffId: 'staff',
        branchId: 'branch',
        weekly: weekly,
        oneOff: extras,
      );
      weekly.clear();
      extras.clear();
      expect(availability.weekly, hasLength(1));
      expect(availability.oneOff, hasLength(1));
      expect(() => availability.weekly.clear(), throwsUnsupportedError);
      expect(() => availability.oneOff.clear(), throwsUnsupportedError);
    });

    test('adds and removes both variants without changing the original', () {
      final original = fixture.empty;
      final weekly = fixture.weekly(540, 600);
      final extra = fixture.oneOff(780, 840);
      final added = original.adding(extra).adding(weekly);
      expect(original.weekly, isEmpty);
      expect(original.oneOff, isEmpty);
      expect(added.staffId, 'staff');
      expect(added.branchId, 'branch');
      expect(added.weekly, [weekly]);
      expect(added.oneOff, [extra]);
      expect(added.removing(weekly).removing(extra), original);
      expect(added.withWeekly([]).oneOff, [extra]);
      expect(added.withOneOff([]).weekly, [weekly]);
    });

    test('removing either absent variant throws windowNotFound', () {
      for (final missing in [
        fixture.weekly(540, 600),
        fixture.oneOff(540, 600),
      ]) {
        expect(
          () => fixture.empty.removing(missing),
          throwsA(
            isA<AvailabilityException>().having(
              (error) => error.code,
              'code',
              AvailabilityErrorCode.windowNotFound,
            ),
          ),
        );
      }
    });

    test('prunes yesterday, keeps today/future and recurring windows', () {
      final today = fixture.oneOff(780, 840, date: fixture.tuesday);
      final yesterday = fixture.oneOff(540, 600);
      final weekly = fixture.weekly(540, 600);
      final current = fixture.empty
          .adding(weekly)
          .adding(yesterday)
          .adding(today);
      expect(current.prunedBy(fixture.tuesday).oneOff, [today]);
      expect(current.prunedBy(fixture.monday), current);
      expect(current.prunedBy(fixture.tuesday).weekly, [weekly]);
      expect(current.oneOff, [yesterday, today]);
    });

    test('sums weekly minutes and handles an empty week', () {
      final availability = fixture.empty
          .adding(fixture.weekly(540, 600))
          .adding(fixture.weekly(780, 870))
          .adding(fixture.weekly(540, 570, day: Weekday.tuesday))
          .adding(fixture.oneOff(900, 960));
      expect(availability.minutesOn(Weekday.monday), 150);
      expect(availability.minutesOn(Weekday.wednesday), 0);
      expect(availability.weeklyMinutes, 180);
      expect(fixture.empty.weeklyMinutes, 0);
      expect(fixture.empty.minutesOn(Weekday.monday), 0);
      expect(fixture.empty.windowsOn(fixture.monday), isEmpty);
      expect(fixture.empty.conflictOf(fixture.weekly(540, 600)), isNull);
    });

    test('finds the first conflict in start order across both variants', () {
      final late = fixture.weekly(600, 660);
      final early = fixture.oneOff(540, 570);
      final current = fixture.empty.adding(late).adding(early);
      expect(current.conflictOf(fixture.oneOff(550, 650)), early);
      expect(current.conflictOf(fixture.weekly(550, 650)), early);
      expect(current.conflictOf(fixture.weekly(700, 720)), isNull);
    });

    test('retains stored windows excluded by changed branch hours', () {
      final valid = fixture.weekly(540, 600);
      final invalid = fixture.oneOff(660, 840);
      final current = fixture.empty.adding(invalid).adding(valid);
      expect(current.effectiveWindowsOn(fixture.monday, fixture.hours), [
        valid,
      ]);
      expect(
        current.effectiveWindowsOn(fixture.monday, WorkingHours.closed()),
        isEmpty,
      );
      expect(current.windowsOn(fixture.monday), [valid, invalid]);
    });

    test('equality includes subject and sorted window collections', () {
      final window = fixture.weekly(540, 600);
      final current = fixture.empty.adding(window);
      final equal = StaffAvailability(
        staffId: 'staff',
        branchId: 'branch',
        weekly: [window],
      );
      expect(current, equal);
      expect(current.hashCode, equal.hashCode);
      expect(current.props, [
        'staff',
        'branch',
        [window],
        const <Object>[],
      ]);
      expect(current, isNot(fixture.empty));
      expect(
        current,
        isNot(
          StaffAvailability(
            staffId: 'other',
            branchId: 'branch',
            weekly: [window],
          ),
        ),
      );
      expect(
        current,
        isNot(
          StaffAvailability(
            staffId: 'staff',
            branchId: 'other',
            weekly: [window],
          ),
        ),
      );
    });
  });
}
