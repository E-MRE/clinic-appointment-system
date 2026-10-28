import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
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
import 'package:clinic_appointment_system/features/institution/presentation/widgets/institution_not_found.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/working_hours_editor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'branch_form_fields.dart';
part 'branch_form_save_error.dart';
part 'branch_form_actions.dart';
part 'branch_form_provider.dart';

/// Creates or edits a branch after resolving route ids from the shared list.
final class BranchFormPage extends StatelessWidget {
  const BranchFormPage({this.branchId, super.key});
  final String? branchId;

  @override
  Widget build(BuildContext context) {
    if (branchId == null) return const _BranchFormProvider();
    return InstitutionListView<Branch, BranchListCubit>(
      emptyTitle: LocaleKeys.institution_notFound.tr(),
      emptyMessage: LocaleKeys.institution_notFoundDescription.tr(),
      onRetry: context.read<BranchListCubit>().retry,
      loadedBuilder: (items) {
        final matches = items.where((item) => item.id == branchId);
        if (matches.isNotEmpty) {
          return _BranchFormProvider(branch: matches.first);
        }
        return const InstitutionNotFound();
      },
    );
  }
}

final class _BranchForm extends StatefulWidget {
  const _BranchForm({required this.branch});
  final Branch? branch;

  @override
  State<_BranchForm> createState() => _BranchFormState();
}

final class _BranchFormState extends State<_BranchForm> {
  late final TextEditingController name;
  late final TextEditingController address;
  late final WorkingHoursEditorCubit editor;
  late final BranchSaveCubit save;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.branch?.name);
    address = TextEditingController(text: widget.branch?.address);
    editor = context.read<WorkingHoursEditorCubit>();
    save = context.read<BranchSaveCubit>();
  }

  @override
  void dispose() {
    name.dispose();
    address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BranchSaveCubit, InstitutionSaveState<Branch>>(
      listener: _onSaveState,
      child: AppScaffold(
        child: Column(
          children: [
            PageHeader(
              title:
                  widget.branch?.name ?? LocaleKeys.institution_newBranch.tr(),
            ),
            Expanded(
              child: _BranchFormFields(name: name, address: address),
            ),
            const EmptySize.s12Height(),
            _BranchFormActions(onSave: _save),
          ],
        ),
      ),
    );
  }

  void _onSaveState(BuildContext context, InstitutionSaveState<Branch> state) {
    if (state is InstitutionSaveSaved<Branch>) {
      InstitutionSelectionScope.of(context).selectBranch(state.value.id);
      context.go(
        context.screenSize.isMobile
            ? AppRoutes.branchDetail(state.value.clinicId, state.value.id)
            : AppRoutes.institution,
      );
    }
  }

  void _save() {
    final hours = editor.build();
    if (hours == null) return;
    final branch = widget.branch;
    if (branch == null) {
      final clinicId = InstitutionSelectionScope.of(context).clinicId;
      if (clinicId == null) return;
      save.create(
        BranchDraft(
          clinicId: clinicId,
          name: name.text.trim(),
          address: address.text.trim(),
          workingHours: hours,
        ),
      );
    } else {
      save.update(
        Branch(
          id: branch.id,
          clinicId: branch.clinicId,
          name: name.text.trim(),
          address: address.text.trim(),
          workingHours: hours,
        ),
      );
    }
  }
}
