import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Appointment and informational badge appearances.
enum StatusBadgeVariant {
  /// Appointment is waiting for a decision.
  pending(Icons.schedule),

  /// Appointment is approved.
  approved(Icons.check_circle_outline),

  /// Appointment was rejected.
  rejected(Icons.cancel_outlined),

  /// Appointment was completed.
  completed(Icons.check_circle),

  /// Patient did not attend.
  noShow(Icons.person_off_outlined),

  /// Appointment was cancelled.
  cancelled(Icons.block_outlined),

  /// Neutral count or contextual badge.
  neutral(null),

  /// Informational count badge.
  info(null);

  const StatusBadgeVariant(this.icon);

  /// Leading icon; count badges have none.
  final IconData? icon;

  /// Appointment status represented by this variant, if any.
  AppointmentStatus? get appointmentStatus {
    return switch (this) {
      pending => AppointmentStatus.pending,
      approved => AppointmentStatus.approved,
      rejected => AppointmentStatus.rejected,
      completed => AppointmentStatus.completed,
      noShow => AppointmentStatus.noShow,
      cancelled => AppointmentStatus.cancelled,
      neutral || info => null,
    };
  }
}
