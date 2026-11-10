import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/features/patient/presentation/enums/booking_cell_style.dart';
import 'package:flutter/material.dart';

/// Theme colors of a [BookingCellStyle].
extension BookingCellStyleColors on BookingCellStyle {
  /// Fill color of the cell.
  Color background(ColorScheme colors) {
    return switch (this) {
      BookingCellStyle.available => colors.surface,
      BookingCellStyle.selected => colors.primary,
      BookingCellStyle.unavailable => colors.surfaceContainerLow,
      BookingCellStyle.taken => colors.surfaceContainer,
    };
  }

  /// Solid border; none for dashed and taken cells.
  BorderSide side(ColorScheme colors) {
    return switch (this) {
      BookingCellStyle.available => BorderSide(
        color: colors.outlineVariant,
        width: AppSizes.borderThin,
      ),
      BookingCellStyle.selected => BorderSide(
        color: colors.primary,
        width: AppSizes.borderThin,
      ),
      BookingCellStyle.unavailable || BookingCellStyle.taken => BorderSide.none,
    };
  }

  /// Text tone of the cell.
  TextTone get tone {
    return switch (this) {
      BookingCellStyle.available => TextTone.normal,
      BookingCellStyle.selected => TextTone.onPrimary,
      BookingCellStyle.unavailable || BookingCellStyle.taken => TextTone.muted,
    };
  }
}
