import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/presentation/visitors/availability_window_label_visitor.dart';

/// Localized availability failures, preserving actionable overlap details.
extension AvailabilityErrorCodeLocalization on AvailabilityErrorCode {
  /// The localized failure, optionally naming the conflicting window.
  String message({AvailabilityWindow? conflict}) {
    if (this == AvailabilityErrorCode.overlappingWindow && conflict != null) {
      return LocaleKeys.availability_errors_overlapConflict.translate(
        args: [
          conflict.accept(const AvailabilityWindowLabelVisitor()),
          '${conflict.range.end}',
        ],
      );
    }
    return switch (this) {
      AvailabilityErrorCode.overlappingWindow =>
        LocaleKeys.availability_errors_overlappingWindow,
      AvailabilityErrorCode.outsideBranchHours =>
        LocaleKeys.availability_errors_outsideBranchHours,
      AvailabilityErrorCode.branchClosed =>
        LocaleKeys.availability_errors_branchClosed,
      AvailabilityErrorCode.pastDate => LocaleKeys.availability_errors_pastDate,
      AvailabilityErrorCode.tooManyWindows =>
        LocaleKeys.availability_errors_tooManyWindows,
      AvailabilityErrorCode.windowNotFound =>
        LocaleKeys.availability_errors_windowNotFound,
      AvailabilityErrorCode.invalidRecord =>
        LocaleKeys.availability_errors_invalidRecord,
      AvailabilityErrorCode.unavailable =>
        LocaleKeys.availability_errors_unavailable,
    }.translate();
  }

  /// Whether a save failure marks both time endpoints as invalid.
  bool get marksTimeFields =>
      this == AvailabilityErrorCode.overlappingWindow ||
      this == AvailabilityErrorCode.outsideBranchHours ||
      this == AvailabilityErrorCode.branchClosed;
}
