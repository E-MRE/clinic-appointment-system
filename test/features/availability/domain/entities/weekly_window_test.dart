import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/availability_fixture.dart';
import '../support/window_name_visitor.dart';

void main() {
  const fixture = AvailabilityFixture();
  group('WeeklyWindow', () {
    test('compares by weekday and range', () {
      final window = fixture.weekly(540, 600);
      expect(window, fixture.weekly(540, 600));
      expect(window.hashCode, fixture.weekly(540, 600).hashCode);
      expect(window.props, [Weekday.monday, fixture.range(540, 600)]);
      expect(window, isNot(fixture.weekly(540, 601)));
      expect(window, isNot(fixture.weekly(540, 600, day: Weekday.tuesday)));
      expect(window, isNot(fixture.oneOff(540, 600)));
    });

    test('recurs on its weekday and never expires', () {
      final window = fixture.weekly(540, 600);
      expect(window.fallsOnWeekday(Weekday.monday), isTrue);
      expect(window.fallsOnWeekday(Weekday.tuesday), isFalse);
      expect(window.fallsOnDate(fixture.monday), isTrue);
      expect(window.fallsOnDate(fixture.tuesday), isFalse);
      expect(window.hasExpiredBy(fixture.tuesday), isFalse);
    });

    test('dispatches to the weekly visitor method', () {
      expect(
        fixture.weekly(540, 600).accept(const WindowNameVisitor()),
        'weekly',
      );
    });
  });
}
