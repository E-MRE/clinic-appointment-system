import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/extensions/time_range_label.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/localization/weekday_localization.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/booking_service_presentation.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/calendar_date_week.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/booking_selection.dart';

/// Localized week label and summary values of the booking choices.
/// Values not chosen yet show [LocaleKeys.common_notAvailable].
extension BookingSelectionPresentation on BookingSelection {
  /// Returns the listed days of the shown week, including Sunday when the
  /// chosen staff member's branch opens that day.
  String weekLabel(ClinicCatalog catalog) {
    final dates = scheduleRequest(catalog)?.dates;
    final end = dates?.last ?? weekStart.addDays(Weekday.saturday.index);
    return AppFormatters.formatDayRange(weekStart.startOfDay, end.startOfDay);
  }

  /// The chosen service's name.
  String get serviceValue => service?.name ?? _missing;

  /// The chosen service's length.
  String get durationValue => service?.durationLabel ?? _missing;

  /// The chosen service's fee.
  String get feeValue => service?.feeLabel ?? _missing;

  /// The chosen staff member's full name.
  String get staffValue => staff?.fullName ?? _missing;

  /// Returns the branch and department of the chosen service.
  String locationValue(ClinicCatalog catalog) {
    final service = this.service;
    if (service == null) return _missing;
    return LocaleKeys.patient_book_locationValue.translate(
      args: [
        catalog.branchById(service.branchId)?.name ?? _missing,
        catalog.departmentById(service.departmentId)?.name ?? _missing,
      ],
    );
  }

  /// Returns the chosen day and slot as a localized label.
  String get dateTimeValue {
    final date = this.date;
    final slot = this.slot;
    if (date == null || slot == null) return _missing;
    return LocaleKeys.patient_book_dateTimeValue.translate(
      args: [
        date.weekday.label,
        AppFormatters.formatDayMonth(date.startOfDay),
        slot.label,
      ],
    );
  }

  /// Which staff member's hours are listed, and what a struck slot means.
  String get footnote {
    return LocaleKeys.patient_book_footnote.translate(args: [staffValue]);
  }

  String get _missing => LocaleKeys.common_notAvailable.translate();
}
