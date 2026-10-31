import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection_scope.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_department_list_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_list_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_service_list_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_list_overview.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Resolves the current clinic catalogue for reactive list presentation.
extension StaffOverviewContext on BuildContext {
  /// Watches list dependencies and excludes branches of other clinics.
  StaffListOverview get staffOverview {
    final clinicId = InstitutionSelectionScope.of(this).clinicId;
    final branchState = watch<BranchListCubit>().state;
    final staffState = watch<StaffListCubit>().state;
    final departmentState = watch<StaffDepartmentListCubit>().state;
    final serviceState = watch<StaffServiceListCubit>().state;
    return StaffListOverview(
      staff: staffState is InstitutionListLoaded<Staff>
          ? staffState.items
          : const [],
      branches: [
        if (branchState is InstitutionListLoaded<Branch>)
          for (final branch in branchState.items)
            if (clinicId != null && branch.clinicId == clinicId) branch,
      ],
      departments: departmentState is InstitutionListLoaded<Department>
          ? departmentState.items
          : const [],
      services: serviceState is InstitutionListLoaded<MedicalService>
          ? serviceState.items
          : const [],
    );
  }
}
