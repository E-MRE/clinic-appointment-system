import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:clinic_appointment_system/core/widgets/state/empty_state.dart';
import 'package:clinic_appointment_system/core/widgets/text_field/app_text_field.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/branch_draft.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_save_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_save_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/working_hours_editor_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/extensions/institution_error_code_localization.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection_scope.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/institution_list_view.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/working_hours_editor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'branch_form.dart';
part 'branch_form_state.dart';

/// Creates or edits a branch after resolving route ids from the shared list.
final class BranchFormPage extends StatelessWidget {
  const BranchFormPage({this.branchId, super.key});
  final String? branchId;

  @override
  Widget build(BuildContext context) {
    if (branchId == null) return _form(null);
    return InstitutionListView<Branch, BranchListCubit>(
      emptyTitle: LocaleKeys.institution_notFound.tr(),
      emptyMessage: LocaleKeys.institution_notFoundDescription.tr(),
      onRetry: context.read<BranchListCubit>().retry,
      loadedBuilder: (items) {
        final matches = items.where((item) => item.id == branchId);
        if (matches.isNotEmpty) return _form(matches.first);
        return _missing(context);
      },
    );
  }

  Widget _form(Branch? branch) {
    return MultiBlocProvider(
      key: ValueKey(branch?.id),
      providers: [
        BlocProvider<WorkingHoursEditorCubit>(
          create: (_) =>
              AppDependency.injector.get<WorkingHoursEditorCubit>()
                ..initialize(branch?.workingHours),
        ),
        BlocProvider<BranchSaveCubit>(
          create: (_) => AppDependency.injector.get<BranchSaveCubit>(),
        ),
      ],
      child: _BranchForm(branch: branch),
    );
  }

  Widget _missing(BuildContext context) {
    return EmptyState(
      title: LocaleKeys.institution_notFound.tr(),
      message: LocaleKeys.institution_notFoundDescription.tr(),
      icon: const Icon(Icons.search_off),
      iconBackground: context.colorScheme.surfaceContainerHighest,
    );
  }
}
