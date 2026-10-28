import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:easy_localization/easy_localization.dart';

/// Formats the selected clinic's branch and department counts.
final class InstitutionCounts {
  const InstitutionCounts({
    required this.branchCount,
    required this.departmentCount,
  });

  factory InstitutionCounts.fromStates(
    InstitutionListState<Branch> branches,
    InstitutionListState<Department> departments,
  ) {
    return InstitutionCounts(
      branchCount: branches is InstitutionListLoaded<Branch>
          ? branches.items.length
          : 0,
      departmentCount: departments is InstitutionListLoaded<Department>
          ? departments.items.length
          : 0,
    );
  }

  final int branchCount;
  final int departmentCount;

  String get label =>
      '${LocaleKeys.institution_branchesCount.tr(args: ['$branchCount'])} · ${LocaleKeys.institution_departmentsCount.tr(args: ['$departmentCount'])}';
}
