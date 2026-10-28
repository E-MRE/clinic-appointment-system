import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/department_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/create_department_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/update_department_use_case.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_save_cubit.dart';

/// Creates and updates departments for the institution screens.
final class DepartmentSaveCubit extends InstitutionSaveCubit<Department> {
  /// Injects both department operations used by this request cubit.
  DepartmentSaveCubit(this._createDepartment, this._updateDepartment);

  final CreateDepartmentUseCase _createDepartment;
  final UpdateDepartmentUseCase _updateDepartment;

  /// Creates a department inside [branchId] with [name].
  Future<void> create(String branchId, String name) {
    final draft = DepartmentDraft(branchId: branchId, name: name);
    return executeRequest(() => _createDepartment(draft));
  }

  /// Updates [department] with [name], preserving its identifier and branch.
  Future<void> update(Department department, String name) {
    final updatedDepartment = Department(
      id: department.id,
      branchId: department.branchId,
      name: name,
    );
    return executeRequest(() => _updateDepartment(updatedDepartment));
  }
}
