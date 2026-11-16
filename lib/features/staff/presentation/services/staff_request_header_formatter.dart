import 'package:clinic_appointment_system/core/extensions/relative_time_label.dart';
import 'package:clinic_appointment_system/core/localization/localization_extension.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/appointment_oldest_request.dart';
import 'package:clinic_appointment_system/generated/localization/lang/locale_keys.g.dart';

/// Formats the request count and oldest request age shown in the staff header.
final class StaffRequestHeaderFormatter {
  /// Creates the staff request header formatter.
  const StaffRequestHeaderFormatter();

  int get _noRequests => 0;

  /// Formats [requests] relative to [now] using the current locale.
  String format(Iterable<Appointment> requests, {required DateTime now}) {
    final count = requests.length;
    final oldest = requests.oldestRequestedAt;
    if (count == _noRequests || oldest == null) {
      return LocaleKeys.staffRequests_headerSubtitleCountOnly.translate(
        args: ['$count'],
      );
    }
    final relative = oldest.relativeLabel(now);
    return LocaleKeys.staffRequests_headerSubtitle.translate(
      args: ['$count', relative],
    );
  }
}
