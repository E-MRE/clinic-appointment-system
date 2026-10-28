import 'dart:async';

import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/state/empty_state.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection_scope.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/institution_list_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'institution_route_scope_state.dart';

/// Owns one subscription per institution list across nested routes.
final class InstitutionRouteScope extends StatefulWidget {
  const InstitutionRouteScope({
    required this.createClinics,
    required this.createBranches,
    required this.createDepartments,
    required this.child,
    this.routeClinicId,
    super.key,
  });

  final ClinicListCubit Function() createClinics;
  final BranchListCubit Function() createBranches;
  final DepartmentListCubit Function() createDepartments;
  final Widget child;
  final String? routeClinicId;

  @override
  State<InstitutionRouteScope> createState() => _InstitutionRouteScopeState();
}
