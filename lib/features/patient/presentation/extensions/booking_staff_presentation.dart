import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// Localized text of a staff card on the booking page.
extension BookingStaffPresentation on Staff {
  /// Returns the staff member's department and branch as a localized label.
  String bookingCaption(ClinicCatalog catalog) {
    final missing = LocaleKeys.common_notAvailable.translate();
    return LocaleKeys.patient_book_staffCaption.translate(
      args: [
        catalog.departmentById(departmentId)?.name ?? missing,
        catalog.branchById(branchId)?.name ?? missing,
      ],
    );
  }
}
