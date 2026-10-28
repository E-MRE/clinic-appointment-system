import 'package:clinic_appointment_system/generated/colors.gen.dart';
import 'package:flutter/material.dart';

/// Appointment status shown in the UI.
// TODO: replaced by the domain appointment status in a later issue.
enum AppointmentStatus {
  pending,
  approved,
  rejected,
  completed,
  noShow,
  cancelled,
}

/// Background and foreground color of a status badge.
typedef StatusColorPair = ({Color bg, Color fg});

/// Theme extension holding the colors of every appointment status.
@immutable
final class AppointmentStatusColors
    extends ThemeExtension<AppointmentStatusColors> {
  const AppointmentStatusColors({
    required this.pendingBg,
    required this.pendingFg,
    required this.approvedBg,
    required this.approvedFg,
    required this.rejectedBg,
    required this.rejectedFg,
    required this.completedBg,
    required this.completedFg,
    required this.noShowBg,
    required this.noShowFg,
    required this.cancelledBg,
    required this.cancelledFg,
  });

  static const AppointmentStatusColors light = AppointmentStatusColors(
    pendingBg: AppColors.pendingLightBg,
    pendingFg: AppColors.pendingLightFg,
    approvedBg: AppColors.approvedLightBg,
    approvedFg: AppColors.approvedLightFg,
    rejectedBg: AppColors.rejectedLightBg,
    rejectedFg: AppColors.rejectedLightFg,
    completedBg: AppColors.completedLightBg,
    completedFg: AppColors.completedLightFg,
    noShowBg: AppColors.noShowLightBg,
    noShowFg: AppColors.noShowLightFg,
    cancelledBg: AppColors.cancelledLightBg,
    cancelledFg: AppColors.cancelledLightFg,
  );

  static const AppointmentStatusColors dark = AppointmentStatusColors(
    pendingBg: AppColors.pendingDarkBg,
    pendingFg: AppColors.pendingDarkFg,
    approvedBg: AppColors.approvedDarkBg,
    approvedFg: AppColors.approvedDarkFg,
    rejectedBg: AppColors.rejectedDarkBg,
    rejectedFg: AppColors.rejectedDarkFg,
    completedBg: AppColors.completedDarkBg,
    completedFg: AppColors.completedDarkFg,
    noShowBg: AppColors.noShowDarkBg,
    noShowFg: AppColors.noShowDarkFg,
    cancelledBg: AppColors.cancelledDarkBg,
    cancelledFg: AppColors.cancelledDarkFg,
  );

  final Color pendingBg;
  final Color pendingFg;
  final Color approvedBg;
  final Color approvedFg;
  final Color rejectedBg;
  final Color rejectedFg;
  final Color completedBg;
  final Color completedFg;
  final Color noShowBg;
  final Color noShowFg;
  final Color cancelledBg;
  final Color cancelledFg;

  /// Returns the (bg, fg) pair for [status].
  StatusColorPair resolve(AppointmentStatus status) {
    return switch (status) {
      AppointmentStatus.pending => (bg: pendingBg, fg: pendingFg),
      AppointmentStatus.approved => (bg: approvedBg, fg: approvedFg),
      AppointmentStatus.rejected => (bg: rejectedBg, fg: rejectedFg),
      AppointmentStatus.completed => (bg: completedBg, fg: completedFg),
      AppointmentStatus.noShow => (bg: noShowBg, fg: noShowFg),
      AppointmentStatus.cancelled => (bg: cancelledBg, fg: cancelledFg),
    };
  }

  @override
  AppointmentStatusColors copyWith({
    Color? pendingBg,
    Color? pendingFg,
    Color? approvedBg,
    Color? approvedFg,
    Color? rejectedBg,
    Color? rejectedFg,
    Color? completedBg,
    Color? completedFg,
    Color? noShowBg,
    Color? noShowFg,
    Color? cancelledBg,
    Color? cancelledFg,
  }) {
    return AppointmentStatusColors(
      pendingBg: pendingBg ?? this.pendingBg,
      pendingFg: pendingFg ?? this.pendingFg,
      approvedBg: approvedBg ?? this.approvedBg,
      approvedFg: approvedFg ?? this.approvedFg,
      rejectedBg: rejectedBg ?? this.rejectedBg,
      rejectedFg: rejectedFg ?? this.rejectedFg,
      completedBg: completedBg ?? this.completedBg,
      completedFg: completedFg ?? this.completedFg,
      noShowBg: noShowBg ?? this.noShowBg,
      noShowFg: noShowFg ?? this.noShowFg,
      cancelledBg: cancelledBg ?? this.cancelledBg,
      cancelledFg: cancelledFg ?? this.cancelledFg,
    );
  }

  @override
  AppointmentStatusColors lerp(
    covariant ThemeExtension<AppointmentStatusColors>? other,
    double t,
  ) {
    if (other is! AppointmentStatusColors) {
      return this;
    }
    return AppointmentStatusColors(
      pendingBg: Color.lerp(pendingBg, other.pendingBg, t) ?? pendingBg,
      pendingFg: Color.lerp(pendingFg, other.pendingFg, t) ?? pendingFg,
      approvedBg: Color.lerp(approvedBg, other.approvedBg, t) ?? approvedBg,
      approvedFg: Color.lerp(approvedFg, other.approvedFg, t) ?? approvedFg,
      rejectedBg: Color.lerp(rejectedBg, other.rejectedBg, t) ?? rejectedBg,
      rejectedFg: Color.lerp(rejectedFg, other.rejectedFg, t) ?? rejectedFg,
      completedBg: Color.lerp(completedBg, other.completedBg, t) ?? completedBg,
      completedFg: Color.lerp(completedFg, other.completedFg, t) ?? completedFg,
      noShowBg: Color.lerp(noShowBg, other.noShowBg, t) ?? noShowBg,
      noShowFg: Color.lerp(noShowFg, other.noShowFg, t) ?? noShowFg,
      cancelledBg: Color.lerp(cancelledBg, other.cancelledBg, t) ?? cancelledBg,
      cancelledFg: Color.lerp(cancelledFg, other.cancelledFg, t) ?? cancelledFg,
    );
  }
}
