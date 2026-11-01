import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:clinic_appointment_system/features/availability/presentation/widgets/availability_body.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_department_list_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_list_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/extensions/staff_availability_subtitle.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/pages/staff_form_loading_view.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/pages/staff_form_not_found_view.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'staff_availability_header.dart';

/// Administrator availability destination for a staff profile.
final class StaffAvailabilityPage extends StatelessWidget {
  /// Creates a destination for the profile identified by [staffId].
  const StaffAvailabilityPage({required this.staffId, super.key});

  /// Identifier of the staff profile to resolve.
  final String staffId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StaffListCubit>().state;
    if (state is InstitutionListLoading<Staff>) {
      return const StaffFormLoadingView();
    }
    if (state is InstitutionListLoaded<Staff>) {
      final matches = state.items.where((member) => member.id == staffId);
      if (matches.isNotEmpty) {
        final staff = matches.first;
        return AvailabilityBody(
          staff: staff,
          header: _StaffAvailabilityHeader(staff: staff),
        );
      }
    }
    return const StaffFormNotFoundView();
  }
}
