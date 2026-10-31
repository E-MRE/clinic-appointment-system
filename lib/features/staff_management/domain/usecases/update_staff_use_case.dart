import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/mixins/staff_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/models/staff_assignment.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/repositories/staff_repository.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// Validates staff assignments before updating editable profile fields.
final class UpdateStaffUseCase
    with StaffInputValidationMixin
    implements UseCase<DataResult<Staff>, StaffAssignment> {
  /// Injects the staff profile persistence boundary.
  const UpdateStaffUseCase(this._repository);

  final StaffRepository _repository;

  /// Trims and validates [assignment] before updating its staff profile.
  /// Throws [UserException] for invalid input or persistence failure.
  @override
  Future<DataResult<Staff>> call(StaffAssignment assignment) async {
    final Staff trimmed = assignment.staff.trimmed();
    ensureStaffValid(
      staffError(
        StaffAssignment(
          staff: trimmed,
          availableServices: assignment.availableServices,
        ),
      ),
    );
    return _repository.updateStaff(trimmed);
  }
}
