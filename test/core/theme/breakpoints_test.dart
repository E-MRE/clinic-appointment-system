import 'package:clinic_appointment_system/core/theme/breakpoints.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('resolves width boundaries', () {
    expect(Breakpoints.resolve(0), ScreenSize.mobile);
    expect(Breakpoints.resolve(599), ScreenSize.mobile);
    expect(Breakpoints.resolve(600), ScreenSize.tablet);
    expect(Breakpoints.resolve(839), ScreenSize.tablet);
    expect(Breakpoints.resolve(840), ScreenSize.desktop);
    expect(Breakpoints.resolve(2000), ScreenSize.desktop);
  });
}
