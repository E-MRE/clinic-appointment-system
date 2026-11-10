import 'package:clinic_appointment_system/core/widgets/tab_bar/app_tab_style.dart';

/// Picks the [AppTabStyle] for a selection state.
extension AppTabStyleSelection on bool {
  /// The tab style for this selection state.
  AppTabStyle get tabStyle {
    if (this) return AppTabStyle.selected;
    return AppTabStyle.unselected;
  }
}
