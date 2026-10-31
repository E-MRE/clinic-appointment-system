import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/enums/staff_role_filter.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_list_overview.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/presentation/extensions/user_role_staff_label.dart';
import 'package:easy_localization/easy_localization.dart';

/// Localized display copy assembled from the clinic-scoped overview.
extension StaffListOverviewPresentation on StaffListOverview {
  /// Compact count of staff and all branches of the selected clinic.
  String get mobileSubtitle => LocaleKeys.staff_mobileSubtitle.tr(
    args: [staff.length.toString(), branchCount.toString()],
  );

  /// Role counts and all branches for tablet and desktop headers.
  String get wideSubtitle => LocaleKeys.staff_wideSubtitle.tr(
    args: [
      doctorCount.toString(),
      technicianCount.toString(),
      branchCount.toString(),
    ],
  );

  /// Role filter label with an unfiltered clinic-wide count.
  String chipLabel(StaffRoleFilter filter) {
    final key = switch (filter) {
      StaffRoleFilter.all => LocaleKeys.staff_chipAll,
      StaffRoleFilter.doctor => LocaleKeys.staff_chipDoctor,
      StaffRoleFilter.technician => LocaleKeys.staff_chipTechnician,
    };
    return key.tr(args: [count(filter).toString()]);
  }

  /// Comma-separated known service names in assignment order.
  String serviceLabel(Staff member) => serviceNames(member).join(', ');

  /// Department and branch for the table placement column.
  String placement(Staff member) => [
    departmentName(member),
    branchName(member),
  ].where((name) => name.isNotEmpty).join(' · ');

  /// Role, department and branch for a mobile card.
  String subtitle(Staff member) => [
    member.role.staffLabel,
    placement(member),
  ].where((name) => name.isNotEmpty).join(' · ');
}
