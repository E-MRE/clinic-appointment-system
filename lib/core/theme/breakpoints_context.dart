import 'package:clinic_appointment_system/core/theme/breakpoints.dart';
import 'package:flutter/widgets.dart';

/// Convenience access: `context.screenSize`.
extension BreakpointsContext on BuildContext {
  ScreenSize get screenSize =>
      Breakpoints.resolve(MediaQuery.sizeOf(this).width);
}
