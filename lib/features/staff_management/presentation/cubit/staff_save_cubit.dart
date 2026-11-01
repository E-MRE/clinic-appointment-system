import 'package:clinic_appointment_system/core/constants/entity_constants.dart';
import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/models/staff_assignment.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/models/staff_registration.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/create_staff_use_case.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/update_staff_use_case.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_save_state.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/extensions/user_role_staff_form_strategy.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_form_values.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Saves staff drafts with single-flight requests and separate account/profile failures.
/// Input validation belongs to the injected use cases.
final class StaffSaveCubit extends Cubit<StaffSaveState> {
  /// Injects staff creation and update operations.
  StaffSaveCubit(this._createStaff, this._updateStaff)
    : super(const StaffSaveInitial());

  final CreateStaffUseCase _createStaff;
  final UpdateStaffUseCase _updateStaff;
  bool _isRequestInFlight = false;
  bool _isClosing = false;

  bool get _isClosingOrClosed => _isClosing || isClosed;

  /// Builds a new profile and provisions it with the exact temporary password.
  Future<void> create(
    StaffFormValues values, {
    required List<MedicalService> availableServices,
  }) {
    return _executeRequest(() {
      final staff = values.role.staffFormStrategy.build(
        values,
        id: EntityConstants.unsavedId,
      );
      return _createStaff(
        StaffRegistration(
          staff: staff,
          availableServices: availableServices,
          password: values.password,
        ),
      );
    });
  }

  /// Saves editable fields while forcing role, email, branch and department
  /// from [original] before selecting a strategy or calling the use case.
  Future<void> update(
    StaffFormValues values, {
    required Staff original,
    required List<MedicalService> availableServices,
  }) {
    return _executeRequest(() {
      final lockedValues = values.copyWith(
        role: original.role,
        email: original.email,
        branchId: original.branchId,
        departmentId: original.departmentId,
      );
      final staff = lockedValues.role.staffFormStrategy.build(
        lockedValues,
        id: original.id,
      );
      return _updateStaff(
        StaffAssignment(staff: staff, availableServices: availableServices),
      );
    });
  }

  Future<void> _executeRequest(
    Future<DataResult<Staff>> Function() request,
  ) async {
    if (_isClosingOrClosed || _isRequestInFlight) return;
    _isRequestInFlight = true;
    emit(const StaffSaveSaving());
    try {
      final result = await request();
      if (_isClosingOrClosed) return;
      final staff = result.data;
      if (result.isNotSuccess || staff == null) {
        emit(const StaffSaveProfileFailure(UserErrorCode.unavailable));
        return;
      }
      emit(StaffSaveSaved(staff));
    } on AuthException catch (error) {
      _emitFailure(StaffSaveAuthFailure(error.code));
    } on UserException catch (error) {
      _emitFailure(StaffSaveProfileFailure(error.code));
    } catch (_) {
      _emitFailure(const StaffSaveAuthFailure(AuthErrorCode.unexpected));
    } finally {
      _isRequestInFlight = false;
    }
  }

  void _emitFailure(StaffSaveState failure) {
    if (_isClosingOrClosed) return;
    emit(failure);
  }

  /// Closes the cubit and ignores any pending request completion.
  @override
  Future<void> close() async {
    _isClosing = true;
    await super.close();
  }
}
