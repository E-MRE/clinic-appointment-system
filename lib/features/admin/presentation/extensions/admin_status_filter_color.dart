import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_status_filter.dart';
import 'package:flutter/material.dart';

/// Resolves each administrator status group to its theme foreground color.
extension AdminStatusFilterColor on AdminStatusFilter {
  /// The status color used for chart segments and legend markers.
  Color color(BuildContext context) {
    final colors = context.statusColors;
    return switch (this) {
      AdminStatusFilter.pending => colors.pendingFg,
      AdminStatusFilter.approved => colors.approvedFg,
      AdminStatusFilter.rejected => colors.rejectedFg,
      AdminStatusFilter.completed => colors.completedFg,
      AdminStatusFilter.noShow => colors.noShowFg,
      AdminStatusFilter.cancelled => colors.cancelledFg,
    };
  }
}
