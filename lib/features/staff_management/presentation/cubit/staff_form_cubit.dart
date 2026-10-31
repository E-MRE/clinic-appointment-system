import 'package:clinic_appointment_system/features/staff_management/domain/services/temporary_password_generator.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_form_values.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages staff drafts and clears assignments when their eligibility changes.
final class StaffFormCubit extends Cubit<StaffFormValues> {
  /// Injects the generator used for creation and password regeneration.
  StaffFormCubit(this._generator) : super(const StaffFormValues.empty());

  final TemporaryPasswordGenerator _generator;

  /// Clears the draft and generates a fresh temporary password.
  void startCreate() {
    emit(
      const StaffFormValues.empty().copyWith(password: _generator.generate()),
    );
  }

  /// Pre-fills an existing profile with an empty password.
  void startEdit(Staff staff) => emit(StaffFormValues.fromStaff(staff));

  /// Selects a role, clearing assignments only when the role changes.
  void selectRole(UserRole role) {
    if (role == state.role) return;
    emit(state.copyWith(role: role, serviceIds: const []));
  }

  /// Updates the full name input.
  void changeFullName(String fullName) =>
      emit(state.copyWith(fullName: fullName));

  /// Updates the doctor specialty input.
  void changeSpecialty(String specialty) =>
      emit(state.copyWith(specialty: specialty));

  /// Updates the email input.
  void changeEmail(String email) => emit(state.copyWith(email: email));

  /// Updates the exact temporary password input.
  void changePassword(String password) =>
      emit(state.copyWith(password: password));

  /// Replaces the password using the injected generator.
  void regeneratePassword() => changePassword(_generator.generate());

  /// Selects a branch, clearing department and assignments when it changes.
  void selectBranch(String id) {
    if (id == state.branchId) return;
    emit(state.copyWith(branchId: id, departmentId: '', serviceIds: const []));
  }

  /// Selects a department, clearing assignments when it changes.
  void selectDepartment(String id) {
    if (id == state.departmentId) return;
    emit(state.copyWith(departmentId: id, serviceIds: const []));
  }

  /// Adds or removes a service while preserving assignment order.
  void toggleService(String id) {
    final serviceIds = List<String>.of(state.serviceIds);
    if (serviceIds.contains(id)) {
      serviceIds.remove(id);
    } else {
      serviceIds.add(id);
    }
    emit(state.copyWith(serviceIds: List<String>.unmodifiable(serviceIds)));
  }
}
