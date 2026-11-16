import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_list_overview.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/services/staff_list_overview_factory.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the derived overview built from staff management catalogue updates.
final class StaffListOverviewCubit extends Cubit<StaffListOverview> {
  /// Injects the factory used to create each current overview.
  StaffListOverviewCubit(this._factory)
    : super(
        _factory.create(
          clinicId: null,
          staff: const [],
          branches: const [],
          departments: const [],
          services: const [],
        ),
      );

  final StaffListOverviewFactory _factory;

  /// Replaces the overview with the latest observed lists and clinic selection.
  void update({
    required String? clinicId,
    required List<Staff> staff,
    required List<Branch> branches,
    required List<Department> departments,
    required List<MedicalService> services,
  }) {
    emit(
      _factory.create(
        clinicId: clinicId,
        staff: staff,
        branches: branches,
        departments: departments,
        services: services,
      ),
    );
  }
}
