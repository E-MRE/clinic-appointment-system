import 'package:clinic_appointment_system/core/theme/breakpoints.dart';
import 'package:clinic_appointment_system/core/theme/screen_size.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('resolves width boundaries', () {
    expect(BreakpointsConstants.resolve(0, 800), ScreenSize.mobile);
    expect(BreakpointsConstants.resolve(599, 800), ScreenSize.mobile);
    expect(BreakpointsConstants.resolve(600, 800), ScreenSize.tablet);
    expect(BreakpointsConstants.resolve(839, 800), ScreenSize.tablet);
    expect(BreakpointsConstants.resolve(840, 800), ScreenSize.desktop);
    expect(BreakpointsConstants.resolve(2000, 800), ScreenSize.desktop);
  });

  test('short viewports such as landscape phones resolve to mobile', () {
    expect(BreakpointsConstants.resolve(844, 390), ScreenSize.mobile);
    expect(BreakpointsConstants.resolve(1400, 479), ScreenSize.mobile);
    expect(BreakpointsConstants.resolve(1400, 480), ScreenSize.desktop);
  });

  test('ScreenSize helpers and select match active variant', () {
    expect(ScreenSize.mobile.isMobile, isTrue);
    expect(ScreenSize.mobile.isTablet, isFalse);
    expect(ScreenSize.mobile.isDesktop, isFalse);
    expect(
      ScreenSize.mobile.select(mobile: 'm', tablet: 't', desktop: 'd'),
      'm',
    );

    expect(ScreenSize.tablet.isTablet, isTrue);
    expect(
      ScreenSize.tablet.select(mobile: 'm', tablet: 't', desktop: 'd'),
      't',
    );

    expect(ScreenSize.desktop.isDesktop, isTrue);
    expect(
      ScreenSize.desktop.select(mobile: 'm', tablet: 't', desktop: 'd'),
      'd',
    );
  });
}
