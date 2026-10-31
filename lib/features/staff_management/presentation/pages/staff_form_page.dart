import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state_variant.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:clinic_appointment_system/core/widgets/state/empty_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_list_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/widgets/staff_form.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
part 'staff_form_create_view.dart';
part 'staff_form_edit_body.dart';
part 'staff_form_edit_resolver.dart';
part 'staff_form_loading_view.dart';
part 'staff_form_not_found_view.dart';

/// Form page for creating or editing staff on mobile.
final class StaffFormPage extends StatelessWidget {
  /// Creates the staff editor page.
  const StaffFormPage({this.staffId, super.key});

  /// The identifier of the staff profile being edited, or null for creation.
  final String? staffId;

  @override
  Widget build(BuildContext context) {
    final id = staffId;
    if (id == null) {
      return const _StaffFormCreateView();
    }
    return _StaffFormEditResolver(staffId: id);
  }
}
