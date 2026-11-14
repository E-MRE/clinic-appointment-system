import 'package:clinic_appointment_system/core/constants/clock_constants.dart';
import 'package:clinic_appointment_system/core/localization/localization_extension.dart';
import 'package:clinic_appointment_system/generated/localization/lang/locale_keys.g.dart';

/// Converts an instant into a localized elapsed-time label.
extension RelativeTimeLabel on DateTime {
  /// value = 2
  int get _daysCountedFrom => 2;

  /// value = 1
  int get _relativeLimit => 1;

  /// The localized distance from this instant back from [now]:
  /// under a minute, then minutes, hours, then days.
  String relativeLabel(DateTime now) {
    final difference = now.difference(this);
    if (difference.inMinutes < _relativeLimit) {
      return LocaleKeys.common_relativeTime_justNow.translate();
    }
    if (difference.inHours < _relativeLimit) {
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
