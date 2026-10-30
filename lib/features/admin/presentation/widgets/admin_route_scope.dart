import 'dart:async';

import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'admin_route_scope_content.dart';
part 'admin_route_scope_state_mixin.dart';

/// Provides clinic, branch, and department list cubits and institution selection
/// across the admin shell.
final class AdminRouteScope extends StatelessWidget {
  const AdminRouteScope({required this.child, this.routeClinicId, super.key});

  final Widget child;
  final String? routeClinicId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ClinicListCubit>(
          create: (_) => AppDependency.injector.get<ClinicListCubit>(),
        ),
        BlocProvider<BranchListCubit>(
          create: (_) => AppDependency.injector.get<BranchListCubit>(),
        ),
        BlocProvider<DepartmentListCubit>(
          create: (_) => AppDependency.injector.get<DepartmentListCubit>(),
        ),
      ],
      child: _AdminRouteScopeContent(
        routeClinicId: routeClinicId,
        child: child,
      ),
    );
  }
}
