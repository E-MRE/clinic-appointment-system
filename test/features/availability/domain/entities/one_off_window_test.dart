import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/availability_fixture.dart';
import '../support/window_name_visitor.dart';

void main() {
  const fixture = AvailabilityFixture();
  group('OneOffWindow', () {
    test('compares by date and range', () {
      final window = fixture.oneOff(540, 600);
      expect(window, fixture.oneOff(540, 600));
      expect(window.hashCode, fixture.oneOff(540, 600).hashCode);
      expect(window.props, [fixture.monday, fixture.range(540, 600)]);
      expect(window, isNot(fixture.oneOff(540, 601)));
      expect(window, isNot(fixture.oneOff(540, 600, date: fixture.tuesday)));
    });

    test('belongs only to its date and expires strictly before today', () {
      final window = fixture.oneOff(540, 600);
      expect(window.weekday, Weekday.monday);
      expect(window.fallsOnWeekday(Weekday.monday), isTrue);
      expect(window.fallsOnWeekday(Weekday.tuesday), isFalse);
      expect(window.fallsOnDate(fixture.monday), isTrue);
      expect(
        window.fallsOnDate(CalendarDate(year: 2026, month: 11, day: 9)),
        isFalse,
      );
      expect(window.hasExpiredBy(fixture.monday), isFalse);
      expect(window.hasExpiredBy(fixture.tuesday), isTrue);
    });

    test('dispatches to the one-off visitor method', () {
      expect(
        fixture.oneOff(540, 600).accept(const WindowNameVisitor()),
        'one-off',
      );
    });
  });
}
