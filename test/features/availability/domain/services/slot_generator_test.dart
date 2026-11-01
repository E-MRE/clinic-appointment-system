import 'package:clinic_appointment_system/core/constants/medical_service_constants.dart';
import 'package:clinic_appointment_system/features/availability/domain/services/slot_generator.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/availability_fixture.dart';
import '../support/excluded_slot.dart';

void main() {
  const fixture = AvailabilityFixture();
  const generator = SlotGenerator();
  group('SlotGenerator split', () {
    test('fills the window back to back at twenty minutes', () {
      final slots = generator.split(
        fixture.range(540, 600),
        ServiceDuration(20),
      );
      expect(slots, [
        fixture.range(540, 560),
        fixture.range(560, 580),
        fixture.range(580, 600),
      ]);
      expect(
        generator.slotCount(fixture.range(540, 600), ServiceDuration(20)),
        3,
      );
    });
    test('discards an uneven remainder', () {
      expect(generator.split(fixture.range(540, 590), ServiceDuration(20)), [
        fixture.range(540, 560),
        fixture.range(560, 580),
      ]);
      expect(
        generator.slotCount(fixture.range(540, 590), ServiceDuration(20)),
        2,
      );
    });
    test('supports the minimum five-minute duration', () {
      final duration = ServiceDuration(
        MedicalServiceConstants.minDurationMinutes,
      );
      expect(generator.split(fixture.range(540, 550), duration), [
        fixture.range(540, 545),
        fixture.range(545, 550),
      ]);
      expect(generator.slotCount(fixture.range(540, 550), duration), 2);
    });
    test('supports the maximum 240-minute duration', () {
      final duration = ServiceDuration(
        MedicalServiceConstants.maxDurationMinutes,
      );
      expect(generator.split(fixture.range(540, 1020), duration), [
        fixture.range(540, 780),
        fixture.range(780, 1020),
      ]);
      expect(generator.slotCount(fixture.range(540, 1020), duration), 2);
    });
    test('returns no slots when the duration exceeds the window', () {
      expect(
        generator.split(fixture.range(540, 559), ServiceDuration(20)),
        isEmpty,
      );
      expect(
        generator.slotCount(fixture.range(540, 559), ServiceDuration(20)),
        0,
      );
    });
    test('never constructs a clock time beyond the 23:59 boundary', () {
      expect(generator.split(fixture.range(1380, 1439), ServiceDuration(20)), [
        fixture.range(1380, 1400),
        fixture.range(1400, 1420),
      ]);
      expect(generator.split(fixture.range(1434, 1439), ServiceDuration(5)), [
        fixture.range(1434, 1439),
      ]);
      expect(
        generator.slotCount(fixture.range(1380, 1439), ServiceDuration(20)),
        2,
      );
    });
  });

  group('SlotGenerator slotsFor', () {
    test('preserves the gap between morning and afternoon windows', () {
      final availability = fixture.empty
          .adding(fixture.weekly(810, 990))
          .adding(fixture.weekly(540, 720));
      final slots = generator.slotsFor(
        availability: availability,
        date: fixture.monday,
        duration: ServiceDuration(30),
        branchHours: fixture.hours,
      );
      expect(slots, [
        fixture.range(540, 570),
        fixture.range(570, 600),
        fixture.range(600, 630),
        fixture.range(630, 660),
        fixture.range(660, 690),
        fixture.range(690, 720),
        fixture.range(810, 840),
        fixture.range(840, 870),
        fixture.range(870, 900),
        fixture.range(900, 930),
        fixture.range(930, 960),
        fixture.range(960, 990),
      ]);
    });
    test(
      'merges weekly and extra windows by start without bridging their edges',
      () {
        final availability = fixture.empty
            .adding(fixture.weekly(900, 940))
            .adding(fixture.oneOff(540, 580))
            .adding(fixture.weekly(600, 620));
        expect(
          generator.slotsFor(
            availability: availability,
            date: fixture.monday,
            duration: ServiceDuration(20),
            branchHours: fixture.hours,
          ),
          [
            fixture.range(540, 560),
            fixture.range(560, 580),
            fixture.range(600, 620),
            fixture.range(900, 920),
            fixture.range(920, 940),
          ],
        );
      },
    );
    test('returns empty when the date has no windows', () {
      expect(
        generator.slotsFor(
          availability: fixture.empty.adding(fixture.weekly(540, 600)),
          date: fixture.tuesday,
          duration: ServiceDuration(30),
          branchHours: fixture.hours,
        ),
        isEmpty,
      );
    });
    test('returns empty when the duration exceeds every window', () {
      expect(
        generator.slotsFor(
          availability: fixture.empty
              .adding(fixture.weekly(540, 560))
              .adding(fixture.oneOff(780, 800)),
          date: fixture.monday,
          duration: ServiceDuration(30),
          branchHours: fixture.hours,
        ),
        isEmpty,
      );
    });
    test('does not offer stored windows outside changed branch hours', () {
      final availability = fixture.empty
          .adding(fixture.weekly(540, 600))
          .adding(fixture.oneOff(660, 840));
      final changedHours = WorkingHours({
        fixture.monday.weekday: [
          fixture.range(570, 720),
          fixture.range(780, 1080),
        ],
      });
      expect(
        generator.slotsFor(
          availability: availability,
          date: fixture.monday,
          duration: ServiceDuration(20),
          branchHours: changedHours,
        ),
        isEmpty,
      );
      expect(availability.windowsOn(fixture.monday), hasLength(2));
    });
    test('exclusion removes only the specified slot on the specified date', () {
      final availability = fixture.empty.adding(fixture.weekly(540, 600));
      final exclusion = ExcludedSlot(
        date: fixture.monday,
        slot: fixture.range(560, 580),
      );
      expect(
        generator.slotsFor(
          availability: availability,
          date: fixture.monday,
          duration: ServiceDuration(20),
          branchHours: fixture.hours,
          exclusion: exclusion,
        ),
        [fixture.range(540, 560), fixture.range(580, 600)],
      );
      expect(
        exclusion.excludes(fixture.tuesday, fixture.range(560, 580)),
        isFalse,
      );
    });
  });
}
