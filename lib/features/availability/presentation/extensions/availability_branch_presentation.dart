import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/extensions/time_range_label.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/presentation/extensions/working_hours_summary.dart';

/// Branch-hour copy shared by the availability layouts and editor surfaces.
extension AvailabilityBranchPresentation on Branch {
  /// Localized branch identity and weekly opening summary.
  String get availabilityHoursMessage => LocaleKeys.availability_branchHours
      .translate(args: [name, workingHours.localizedSummary]);

  /// Explains the selected day's allowable working ranges.
  String availabilityHelper(Weekday day) =>
      LocaleKeys.availability_helper.translate(
        args: [
          workingHours.rangesOn(day).map((range) => range.label).join(', '),
        ],
      );
}
