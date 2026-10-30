import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/institution_list_view.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/institution_not_found.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Resolves a route clinic before showing its nested page.
final class InstitutionRouteGuard extends StatelessWidget {
  const InstitutionRouteGuard({
    required this.child,
    this.routeClinicId,
    super.key,
  });

  final String? routeClinicId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final clinicId = routeClinicId;
    if (clinicId == null) return child;
    return InstitutionListView<Clinic, ClinicListCubit>(
      emptyTitle: LocaleKeys.institution_notFound.tr(),
      emptyMessage: LocaleKeys.institution_notFoundDescription.tr(),
      onRetry: context.read<ClinicListCubit>().retry,
      loadedBuilder: (items) {
        if (items.any((clinic) => clinic.id == clinicId)) return child;
        return const AppScaffold(child: InstitutionNotFound());
      },
    );
  }
}
