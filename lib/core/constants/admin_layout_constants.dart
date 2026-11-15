import 'package:clinic_appointment_system/core/theme/theme.dart';

/// Layout dimensions used only by administrator pages.
abstract final class AdminLayoutConstants {
  /// Minimum width of a KPI card before the grid adds another column.
  /// value = 240
  static const double overviewMetricCardMinWidth = 240;

  /// Height of each overview metric card.
  /// value = 130
  static const double overviewMetricCardHeight = 130;

  /// Minimum width of a breakdown card before the row adds another column.
  /// value = 320
  static const double overviewBreakdownCardMinWidth = 320;

  /// Height shared by the overview breakdown cards.
  /// value = 340
  static const double overviewBreakdownCardHeight = 340;

  /// Maximum width of the overview content column.
  /// value = 1200
  static const double overviewContentMaxWidth = 1200;

  /// Width at which header actions fit beside the title.
  /// value = 720
  static const double overviewHeaderActionsInlineMinWidth = 720;

  /// Width of the branch selector in the overview header.
  /// value = 176
  static const double overviewBranchSelectWidth = 176;

  /// Minimum width of the horizontally scrollable pending requests table.
  /// value = 980
  static const double overviewPendingTableMinWidth = 980;

  /// Maximum width of the date column in the overview table.
  /// value = 160
  static const double overviewPendingDateColumnWidth = 160;

  /// Maximum width of the patient column in the overview table.
  /// value = 160
  static const double overviewPendingPatientColumnWidth = 160;

  /// Maximum width of the service column in the overview table.
  /// value = 190
  static const double overviewPendingServiceColumnWidth = 190;

  /// Maximum width of the staff column in the overview table.
  /// value = 160
  static const double overviewPendingStaffColumnWidth = 160;

  /// Maximum width of the request age column in the overview table.
  /// value = 120
  static const double overviewPendingAgeColumnWidth = 120;

  /// Maximum width of the row action column in the overview table.
  /// value = 176
  static const double overviewPendingActionsColumnWidth = 176;

  /// Number of overview metric cards.
  /// value = 4
  static const int overviewMetricCardCount = 4;

  /// Number of overview breakdown cards.
  /// value = 3
  static const int overviewBreakdownCardCount = 3;

  /// Minimum number of columns used by overview cards.
  /// value = 1
  static const int overviewMinimumColumnCount = 1;

  /// Width of the staff progress indicator in a breakdown row.
  /// value = 72
  static const double overviewStaffProgressWidth = 72;

  /// Width reserved for a count at the end of a breakdown row.
  /// value = 32
  static const double overviewBreakdownCountWidth = 32;

  /// Height of the stacked status distribution bar.
  /// value = 14
  static const double overviewStackedBarHeight = 14;

  /// Diameter of a status color marker in the legend.
  /// value = 8
  static const double overviewLegendDotSize = AppSizes.s8;

  /// Height of each staff entry in the overview card.
  /// value = 44
  static const double overviewStaffRowHeight = 44;

  /// Gap between content rows inside a breakdown card.
  /// value = 12
  static const double overviewBreakdownRowGap = AppSizes.s12;

  /// Count used when a dashboard figure has no rows.
  /// value = 0
  static const int overviewEmptyCount = 0;

  /// Minimum width of the administrator appointments table before it scrolls.
  /// value = 1080
  static const double appointmentsTableMinWidth = 1080;

  /// Maximum width of the date column in the administrator appointments table.
  /// value = 140
  static const double appointmentDateColumnMaxWidth = 140;

  /// Maximum width of the patient column in the administrator appointments table.
  /// value = 110
  static const double appointmentPatientColumnMaxWidth = 110;

  /// Maximum width of the service column in the administrator appointments table.
  /// value = 150
  static const double appointmentServiceColumnMaxWidth = 150;

  /// Maximum width of the staff column in the administrator appointments table.
  /// value = 120
  static const double appointmentStaffColumnMaxWidth = 120;

  /// Maximum width of the location column in the administrator appointments table.
  /// value = 150
  static const double appointmentLocationColumnMaxWidth = 150;

  /// Maximum width of the status column in the administrator appointments table.
  /// value = 160
  static const double appointmentStatusColumnMaxWidth = 160;

  /// Maximum width of the action column in the administrator appointments table.
  /// value = 180
  static const double appointmentActionsColumnMaxWidth = 180;

  /// Number of appointment filter columns on mobile.
  /// value = 1
  static const int appointmentsFilterMobileColumns = 1;

  /// Number of appointment filter columns on tablet.
  /// value = 2
  static const int appointmentsFilterTabletColumns = 2;

  /// Number of appointment filter columns on desktop.
  /// value = 4
  static const int appointmentsFilterDesktopColumns = 4;
}
