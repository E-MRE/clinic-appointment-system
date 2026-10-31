import 'dart:async';

import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection_scope.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_department_list_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_list_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_service_list_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'staff_management_route_scope_content.dart';
part 'staff_management_route_scope_state_mixin.dart';

/// Owns staff observation and the selected clinic's lookup catalogues.
final class StaffManagementRouteScope extends StatelessWidget {
  /// Provides one shared scope for the list and mobile form routes.
  const StaffManagementRouteScope({required this.child, super.key});

  /// The current staff route's content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StaffListCubit>(
          lazy: false,
          create: (_) => AppDependency.injector.get<StaffListCubit>()..watch(),
        ),
        BlocProvider<StaffDepartmentListCubit>(
          create: (_) => AppDependency.injector.get<StaffDepartmentListCubit>(),
        ),
        BlocProvider<StaffServiceListCubit>(
          create: (_) => AppDependency.injector.get<StaffServiceListCubit>(),
        ),
      ],
      child: _StaffManagementRouteScopeContent(child: child),
    );
  }
}
