import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection_scope.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_list_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'medical_services_route_scope_content.dart';

/// Provides [MedicalServiceListCubit] and watches services for the selected branch.
final class MedicalServicesRouteScope extends StatelessWidget {
  const MedicalServicesRouteScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MedicalServiceListCubit>(
      create: (_) => AppDependency.injector.get<MedicalServiceListCubit>(),
      child: _MedicalServicesRouteScopeContent(child: child),
    );
  }
}
