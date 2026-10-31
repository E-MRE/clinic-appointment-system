import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/features/availability/presentation/models/availability_timeline.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../domain/support/availability_fixture.dart';

void main() {
  const fixture = AvailabilityFixture();
  test('08:30–18:00 lunch-gap week shares one axis and two-hour ticks', () {
    final timeline = AvailabilityTimeline(fixture.hours);
    expect(timeline.isEmpty, isFalse);
    expect(timeline.axisStart, ClockTime.fromMinutes(510));
    expect(timeline.axisEnd, ClockTime.fromMinutes(1080));
    expect(timeline.ticks.map((tick) => '$tick'), [
      '09:00',
      '11:00',
      '13:00',
      '15:00',
      '17:00',
    ]);
    expect(timeline.fractionOf(ClockTime.fromMinutes(510)), 0);
    expect(timeline.fractionOf(ClockTime.fromMinutes(795)), 0.5);
    expect(timeline.fractionOf(ClockTime.fromMinutes(1080)), 1);
    final segment = timeline.segmentOf(fixture.range(540, 720));
    expect(segment.start, closeTo(30 / 570, 0.000001));
    expect(segment.width, closeTo(180 / 570, 0.000001));
  });
  test('fractions and partially or wholly outside segments are clipped', () {
    final timeline = AvailabilityTimeline(fixture.hours);
    expect(timeline.fractionOf(ClockTime.fromMinutes(420)), 0);
    expect(timeline.fractionOf(ClockTime.fromMinutes(1200)), 1);
    final clipped = timeline.segmentOf(fixture.range(420, 1200));
    expect(clipped.start, 0);
    expect(clipped.width, 1);
    expect(timeline.segmentOf(fixture.range(420, 480)).width, 0);
    expect(timeline.segmentOf(fixture.range(1140, 1200)).width, 0);
  });
  test('single open day uses that day and includes an exact end tick', () {
    final timeline = AvailabilityTimeline(
      WorkingHours({
        Weekday.wednesday: [fixture.range(540, 780)],
      }),
    );
    expect(timeline.axisLabel, '09:00–13:00');
    expect(timeline.ticks.map((tick) => '$tick'), ['09:00', '11:00', '13:00']);
    expect(timeline.segmentOf(fixture.range(600, 660)).start, 0.25);
    expect(timeline.segmentOf(fixture.range(600, 660)).width, 0.25);
  });
  test('all-closed branch has no ticks or visible geometry', () {
    final timeline = AvailabilityTimeline(WorkingHours.closed());
    expect(timeline.isEmpty, isTrue);
    expect(timeline.axisStart, timeline.axisEnd);
    expect(timeline.ticks, isEmpty);
    expect(timeline.fractionOf(ClockTime.fromMinutes(540)), 0);
    expect(timeline.segmentOf(fixture.range(540, 600)).width, 0);
  });
}
