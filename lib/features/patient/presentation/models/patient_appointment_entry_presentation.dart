import 'package:flutter/material.dart';

/// Formatted labels and icon for one patient appointment entry.
final class PatientAppointmentEntryPresentation {
  /// Creates the display values produced for an appointment entry.
  const PatientAppointmentEntryPresentation({
    required this.serviceName,
    required this.staffName,
    required this.location,
    required this.fee,
    required this.durationLabel,
    required this.dateTimeLabel,
    required this.longDateTimeLabel,
    required this.monthLabel,
    required this.dayLabel,
    required this.weekdayLabel,
    required this.detailLine,
    required this.cancellationNote,
    required this.serviceCaption,
    required this.noteHeading,
    required this.kindIcon,
  });

  /// The catalog service name or the name captured when booking.
  final String serviceName;

  /// The assigned staff name or the localized missing-value label.
  final String staffName;

  /// The branch and department label.
  final String location;

  /// The fee captured when booking.
  final String fee;

  /// The booked duration label.
  final String durationLabel;

  /// The short date and time label used by appointment rows.
  final String dateTimeLabel;

  /// The full date and booked range label used by the details dialog.
  final String longDateTimeLabel;

  /// The upper-case abbreviated month used by the date tile.
  final String monthLabel;

  /// The calendar day number used by the date tile.
  final String dayLabel;

  /// The localized weekday name used by the date tile.
  final String weekdayLabel;

  /// The next-appointment summary line.
  final String detailLine;

  /// The localized cancellation note, or null when there is none.
  final String? cancellationNote;

  /// The table caption containing a cancellation note or service summary.
  final String serviceCaption;

  /// The heading of a preparation note for this appointment.
  final String noteHeading;

  /// The service kind icon or a generic medical icon when the service is missing.
  final IconData kindIcon;
}
