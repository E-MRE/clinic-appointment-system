import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:equatable/equatable.dart';

/// The staff and branch identifying one availability record.
final class AvailabilitySubject extends Equatable {
  /// Creates a subject from explicit identifiers.
  const AvailabilitySubject({required this.staffId, required this.branchId});

  /// Uses the identifiers of the given staff profile.
  factory AvailabilitySubject.ofStaff(Staff staff) {
    return AvailabilitySubject(staffId: staff.id, branchId: staff.branchId);
  }

  /// The staff profile identifier.
  final String staffId;

  /// The staff member's assigned branch identifier.
  final String branchId;

  /// The staff and branch identifiers defining value identity.
  @override
  List<Object> get props => [staffId, branchId];
}
