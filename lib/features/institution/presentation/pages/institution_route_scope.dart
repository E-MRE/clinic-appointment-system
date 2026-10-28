import 'dart:async';

import 'package:clinic_appointment_system/core/di/app_dependency.dart';

import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection_scope.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/institution_list_view.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/institution_not_found.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'institution_route_scope_state_mixin.dart';
part 'institution_route_guard.dart';

/// Owns one subscription per institution list across nested routes.
final class InstitutionRouteScope extends StatelessWidget {
  const InstitutionRouteScope({
    required this.child,
    this.routeClinicId,
    super.key,
  });

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
      child: _InstitutionRouteScopeContent(
        routeClinicId: routeClinicId,
        child: child,
      ),
    );
  }
}

/// Connects route selection to the list Cubits owned by the route scope.
final class _InstitutionRouteScopeContent extends StatefulWidget {
  const _InstitutionRouteScopeContent({
    required this.child,
    this.routeClinicId,
  });

  final Widget child;
  final String? routeClinicId;

  @override
  State<_InstitutionRouteScopeContent> createState() =>
      _InstitutionRouteScopeState();
}

final class _InstitutionRouteScopeState
    extends State<_InstitutionRouteScopeContent>
    with _InstitutionRouteScopeStateMixin {
  @override
  Widget build(BuildContext context) {
    return InstitutionSelectionScope(
      selection: selection,
      child: _InstitutionRouteGuard(
        routeClinicId: widget.routeClinicId,
        child: widget.child,
      ),
    );
  }
}
