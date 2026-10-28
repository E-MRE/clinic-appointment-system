import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:clinic_appointment_system/core/widgets/state/empty_state.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_save_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection_scope.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/department_section.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/institution_list_view.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/working_hours_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'branch_detail_page_state.dart';

/// Mobile branch detail sharing the inline hours and department sections.
final class BranchDetailPage extends StatefulWidget {
  const BranchDetailPage({
    required this.branchId,
    required this.createDepartmentSaveCubit,
    super.key,
  });
  final String branchId;
  final DepartmentSaveCubit Function() createDepartmentSaveCubit;

  @override
  State<BranchDetailPage> createState() => _BranchDetailPageState();
}
