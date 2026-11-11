import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/watch_staff_availability_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branch_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_medical_services_use_case.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_workspace_state.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_workspace.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Observes workplace context for a signed-in staff member:
/// their availability schedule, branch, assigned department and medical services.
final class StaffWorkspaceCubit extends Cubit<StaffWorkspaceState> {
  /// Injects the workspace observation use cases.
  StaffWorkspaceCubit(
    this._watchAvailability,
    this._watchBranch,
    this._watchDepartments,
    this._watchServices,
  ) : super(const StaffWorkspaceLoading());

  final WatchStaffAvailabilityUseCase _watchAvailability;
  final WatchBranchUseCase _watchBranch;
  final WatchDepartmentsUseCase _watchDepartments;
  final WatchMedicalServicesUseCase _watchServices;

  StreamSubscription<DataResult<StaffAvailability>>? _availabilitySubscription;
  StreamSubscription<DataResult<Branch>>? _branchSubscription;
  StreamSubscription<DataResult<List<Department>>>? _departmentsSubscription;
  StreamSubscription<DataResult<List<MedicalService>>>? _servicesSubscription;

  Staff? _staff;
  StaffAvailability? _availability;
  Branch? _branch;
  List<Department>? _departments;
  List<MedicalService>? _services;
  bool _isClosing = false;

  bool get _isClosingOrClosed => _isClosing || isClosed;

  /// Starts or replaces observation of workplace data for [staff].
  void watch(Staff staff) {
    if (_isClosingOrClosed) return;
    _staff = staff;
    _cancelAll();
    emit(const StaffWorkspaceLoading());
    try {
      final subject = AvailabilitySubject.ofStaff(staff);
      _availabilitySubscription = _watchAvailability
          .call(subject)
          .listen(_onAvailability, onError: (Object _) => _fail());
      _branchSubscription = _watchBranch
          .call(staff.branchId)
          .listen(_onBranch, onError: (Object _) => _fail());
      _departmentsSubscription = _watchDepartments
          .call(staff.branchId)
          .listen(_onDepartments, onError: (Object _) => _fail());
      _servicesSubscription = _watchServices
          .call(staff.branchId)
          .listen(_onServices, onError: (Object _) => _fail());
    } on Exception {
      _fail();
    }
  }

  /// Restarts observation with the last watched staff profile.
  void retry() {
    final staff = _staff;
    if (staff != null) watch(staff);
  }

  void _onAvailability(DataResult<StaffAvailability> result) {
    final data = result.data;
    if (result.isNotSuccess || data == null) {
      _fail();
      return;
    }
    _availability = data;
    _emitIfComplete();
  }

  void _onBranch(DataResult<Branch> result) {
    final data = result.data;
    if (result.isNotSuccess || data == null) {
      _fail();
      return;
    }
    _branch = data;
    _emitIfComplete();
  }

  void _onDepartments(DataResult<List<Department>> result) {
    final data = result.data;
    if (result.isNotSuccess || data == null) {
      _fail();
      return;
    }
    _departments = data;
    _emitIfComplete();
  }

  void _onServices(DataResult<List<MedicalService>> result) {
    final data = result.data;
    if (result.isNotSuccess || data == null) {
      _fail();
      return;
    }
    _services = data;
    _emitIfComplete();
  }

  void _emitIfComplete() {
    if (_isClosingOrClosed) return;
    final staff = _staff;
    final availability = _availability;
    final branch = _branch;
    final departments = _departments;
    final services = _services;

    if (staff == null ||
        availability == null ||
        branch == null ||
        departments == null ||
        services == null) {
      return;
    }

    final department = departments
        .where((item) => item.id == staff.departmentId)
        .firstOrNull;
    if (department == null) {
      _fail();
      return;
    }

    emit(
      StaffWorkspaceLoaded(
        StaffWorkspace(
          staff: staff,
          availability: availability,
          branch: branch,
          department: department,
          services: services,
        ),
      ),
    );
  }

  void _fail() {
    if (_isClosingOrClosed) return;
    _cancelAll();
    emit(const StaffWorkspaceFailure());
  }

  void _cancelAll() {
    unawaited(_availabilitySubscription?.cancel());
    unawaited(_branchSubscription?.cancel());
    unawaited(_departmentsSubscription?.cancel());
    unawaited(_servicesSubscription?.cancel());
    _availabilitySubscription = null;
    _branchSubscription = null;
    _departmentsSubscription = null;
    _servicesSubscription = null;
    _availability = null;
    _branch = null;
    _departments = null;
    _services = null;
  }

  @override
  Future<void> close() async {
    _isClosing = true;
    _cancelAll();
    await super.close();
  }
}
