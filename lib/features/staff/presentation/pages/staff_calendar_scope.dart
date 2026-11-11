part of 'staff_calendar_page.dart';

/// Supplies calendar callbacks down the tree.
final class _StaffCalendarScope extends InheritedWidget {
  const _StaffCalendarScope({
    required this.onAppointmentTap,
    required super.child,
  });

  /// Hook invoked when a scheduled appointment block is tapped.
  final ValueChanged<Appointment>? onAppointmentTap;

  /// Looks up the nearest [_StaffCalendarScope] in the widget tree.
  static _StaffCalendarScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_StaffCalendarScope>();
  }

  @override
  bool updateShouldNotify(_StaffCalendarScope oldWidget) {
    return onAppointmentTap != oldWidget.onAppointmentTap;
  }
}
