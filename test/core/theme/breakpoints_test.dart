import 'package:clinic_appointment_system/core/theme/breakpoints.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('resolves width boundaries', () {
    expect(Breakpoints.resolve(0, 800), ScreenSize.mobile);
    expect(Breakpoints.resolve(599, 800), ScreenSize.mobile);
    expect(Breakpoints.resolve(600, 800), ScreenSize.tablet);
    expect(Breakpoints.resolve(839, 800), ScreenSize.tablet);
    expect(Breakpoints.resolve(840, 800), ScreenSize.desktop);
    expect(Breakpoints.resolve(2000, 800), ScreenSize.desktop);
  });

  test('short viewports such as landscape phones resolve to mobile', () {
    expect(Breakpoints.resolve(844, 390), ScreenSize.mobile);
    expect(Breakpoints.resolve(1400, 479), ScreenSize.mobile);
    expect(Breakpoints.resolve(1400, 480), ScreenSize.desktop);
  });
}
