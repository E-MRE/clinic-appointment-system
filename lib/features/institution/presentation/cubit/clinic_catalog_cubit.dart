import 'dart:async';

import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/states/keyed_list_watch.dart';
import 'package:clinic_appointment_system/core/usecases/no_params.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_clinics_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_of_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_catalog_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_services_of_branches_use_case.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/watch_staff_use_case.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Observes clinics, their branches, branch departments and services, and all
/// staff as one [ClinicCatalog]. Dependent streams are replaced only when the
/// parent id set changes. Any failure cancels all observations until [watch].
final class ClinicCatalogCubit extends Cubit<ClinicCatalogState> {
  /// Injects the use cases that observe each clinic directory collection.
  ClinicCatalogCubit(
    this._watchClinics,
    this._watchBranches,
    this._watchDepartments,
    this._watchServices,
    this._watchStaff,
  ) : super(const ClinicCatalogLoading()) {
    _branchWatch = KeyedListWatch<String, Branch>(
      onChanged: _onBranches,
      onFailure: _fail,
    );
    _departmentWatch = KeyedListWatch<List<String>, Department>(
      onChanged: (List<Department> items) {
        _departments = items;
        _emitIfComplete();
      },
      onFailure: _fail,
    );
    _serviceWatch = KeyedListWatch<List<String>, MedicalService>(
      onChanged: (List<MedicalService> items) {
        _services = items;
        _emitIfComplete();
      },
      onFailure: _fail,
    );
  }

  final WatchClinicsUseCase _watchClinics;
  final WatchBranchesUseCase _watchBranches;
  final WatchDepartmentsOfBranchesUseCase _watchDepartments;
  final WatchServicesOfBranchesUseCase _watchServices;
  final WatchStaffUseCase _watchStaff;

  late final KeyedListWatch<String, Branch> _branchWatch;
  late final KeyedListWatch<List<String>, Department> _departmentWatch;
  late final KeyedListWatch<List<String>, MedicalService> _serviceWatch;
  StreamSubscription<DataResult<List<Clinic>>>? _clinicSubscription;
  StreamSubscription<DataResult<List<Staff>>>? _staffSubscription;

  List<String>? _clinicIds;
  List<String>? _branchIds;
  List<Clinic>? _clinics;
  List<Branch>? _branches;
  List<Department>? _departments;
  List<MedicalService>? _services;
  List<Staff>? _staff;
  bool _isClosing = false;

  bool get _isClosingOrClosed => _isClosing || isClosed;

  /// Starts, or restarts after a failure, every clinic directory observation.
  void watch() {
    if (_isClosingOrClosed) return;
    _cancelAll();
    emit(const ClinicCatalogLoading());
    try {
      _clinicSubscription = _watchClinics.call(const NoParams()).listen((
        DataResult<List<Clinic>> result,
      ) {
        _onResult(result, _onClinics);
      }, onError: (Object _) => _fail());
      _staffSubscription = _watchStaff.call(const NoParams()).listen((
        DataResult<List<Staff>> result,
      ) {
        _onResult(result, (List<Staff> staff) {
          _staff = staff;
          _emitIfComplete();
        });
      }, onError: (Object _) => _fail());
    } on Exception {
      _fail();
    }
  }

  void _onResult<T>(DataResult<List<T>> result, void Function(List<T>) apply) {
    final items = result.data;
    if (result.isNotSuccess || items == null) {
      _fail();
      return;
    }
    apply(items);
  }

  void _onClinics(List<Clinic> clinics) {
    _clinics = clinics;
    final ids = _sortedIds(clinics.map((Clinic clinic) => clinic.id));
    if (!listEquals(ids, _clinicIds)) {
      _clinicIds = ids;
      _branches = null;
      _branchWatch.watch(ids, _watchBranches.call);
    }
    _emitIfComplete();
  }

  void _onBranches(List<Branch> branches) {
    _branches = branches;
    final ids = _sortedIds(branches.map((Branch branch) => branch.id));
    if (!listEquals(ids, _branchIds)) {
      _branchIds = ids;
      _departments = null;
      _services = null;
      final chunks = _chunks(ids);
      _departmentWatch.watch(chunks, _watchDepartments.call);
      _serviceWatch.watch(chunks, _watchServices.call);
    }
    _emitIfComplete();
  }

  void _emitIfComplete() {
    if (_isClosingOrClosed) return;
    final clinics = _clinics;
    final branches = _branches;
    final departments = _departments;
    final services = _services;
    final staff = _staff;
    if (clinics == null ||
        branches == null ||
        departments == null ||
        services == null ||
        staff == null) {
      return;
    }
    emit(
      ClinicCatalogLoaded(
        ClinicCatalog(
          clinics: clinics,
          branches: branches,
          departments: departments,
          services: services,
          staff: staff,
        ),
      ),
    );
  }

  void _fail() {
    if (_isClosingOrClosed) return;
    _cancelAll();
    emit(const ClinicCatalogFailure());
  }

  List<String> _sortedIds(Iterable<String> ids) => ids.toSet().toList()..sort();

  /// Splits [ids] into groups the provider accepts in one membership query.
  List<List<String>> _chunks(List<String> ids) {
    final chunks = <List<String>>[];
    Iterable<String> rest = ids;
    while (rest.isNotEmpty) {
      chunks.add(rest.take(FirestoreConstants.maxWhereInValues).toList());
      rest = rest.skip(FirestoreConstants.maxWhereInValues);
    }
    return chunks;
  }

  void _cancelAll() {
    unawaited(_clinicSubscription?.cancel());
    unawaited(_staffSubscription?.cancel());
    _clinicSubscription = null;
    _staffSubscription = null;
    _branchWatch.cancel();
    _departmentWatch.cancel();
    _serviceWatch.cancel();
    _clinicIds = null;
    _branchIds = null;
    _clinics = null;
    _branches = null;
    _departments = null;
    _services = null;
    _staff = null;
  }

  /// Cancels every observation before closing.
  @override
  Future<void> close() async {
    _isClosing = true;
    _cancelAll();
    await super.close();
  }
}
