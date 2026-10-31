import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff_visitor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';

/// Localized staff identity subtitle without runtime role checks.
final class StaffRoleSubtitleVisitor implements StaffVisitor<String> {
  /// Creates a stateless subtitle visitor.
  const StaffRoleSubtitleVisitor();

  /// Displays a doctor's specialty beside the role.
  @override
  String visitDoctor(Doctor staff) =>
      LocaleKeys.availability_doctorSubtitle.translate(args: [staff.specialty]);

  /// Displays the technician role.
  @override
  String visitTechnician(Technician staff) =>
      LocaleKeys.availability_technicianSubtitle.translate();
}
