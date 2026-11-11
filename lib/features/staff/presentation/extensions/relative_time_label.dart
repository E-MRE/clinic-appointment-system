import 'package:clinic_appointment_system/core/constants/clock_constants.dart';
import 'package:clinic_appointment_system/core/localization/localization_extension.dart';
import 'package:clinic_appointment_system/generated/localization/lang/locale_keys.g.dart';

/// Describes how long ago an instant was (`2 saat önce`, `dün`).
extension RelativeTimeLabel on DateTime {
  /// value = 2; from this many days on, the label counts days instead of
  /// saying "dün".
  static const int _daysCountedFrom = 2;

  /// The localized distance from this instant back from [now]:
  /// under a minute "az önce", then minutes, hours, "dün", then days.
  String relativeLabel(DateTime now) {
    final difference = now.difference(this);
    if (difference.inMinutes < 1) {
      return LocaleKeys.common_relativeTime_justNow.translate();
    }
    if (difference.inHours < 1) {
      return LocaleKeys.common_relativeTime_minutesAgo.translate(
        args: ['${difference.inMinutes}'],
      );
    }
    if (difference.inHours < ClockConstants.hoursPerDay) {
      return LocaleKeys.common_relativeTime_hoursAgo.translate(
        args: ['${difference.inHours}'],
      );
    }
    if (difference.inDays < _daysCountedFrom) {
      return LocaleKeys.common_relativeTime_yesterday.translate();
    }
    return LocaleKeys.common_relativeTime_daysAgo.translate(
      args: ['${difference.inDays}'],
    );
  }
}
