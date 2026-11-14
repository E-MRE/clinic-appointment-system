import 'package:clinic_appointment_system/core/extensions/relative_time_label.dart';
import 'package:clinic_appointment_system/core/localization/localization_extension.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/generated/localization/lang/locale_keys.g.dart';

/// Subtitle text formatting for the staff requests header.
extension StaffRequestsHeaderSubtitle on Iterable<Appointment> {
  int get _noRequests => 0;

  /// The earliest creation instant among all request histories, or null when
  /// empty or histories contain no entries.
  DateTime? get oldestCreatedAt {
    DateTime? oldest;
    for (final request in this) {
      if (request.history.isEmpty) continue;
      final at = request.history.first.at;
      if (oldest == null || at.isBefore(oldest)) {
        oldest = at;
      }
    }
    return oldest;
  }

  /// Builds a localized subtitle with the request count and oldest request age.
  String headerSubtitle(Clock clock) {
    final count = length;
    final oldest = oldestCreatedAt;
    if (count == _noRequests || oldest == null) {
      return LocaleKeys.staffRequests_headerSubtitleCountOnly.translate(
        args: ['$count'],
      );
    }
    final relative = oldest.relativeLabel(clock.now());
    return LocaleKeys.staffRequests_headerSubtitle.translate(
      args: ['$count', relative],
    );
  }
}
