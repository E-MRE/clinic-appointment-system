import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/list_tile/app_list_tile.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state_variant.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/core/widgets/text_field/app_text_field.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_save_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_save_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/extensions/institution_error_code_localization.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/institution_list_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'department_section_state.dart';
part 'department_list.dart';
part 'department_rows.dart';
part 'department_add_row.dart';
part 'department_save_error.dart';
part 'department_edit_content.dart';

/// Branch departments with inline create and row edit actions.
final class DepartmentSection extends StatelessWidget {
  const DepartmentSection({required this.branchId, super.key});
  final String branchId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DepartmentSaveCubit>(
      create: (_) => AppDependency.injector.get<DepartmentSaveCubit>(),
      child: _DepartmentSectionContent(branchId: branchId),
    );
  }
}

/// Connects department actions to the section's request Cubit.
final class _DepartmentSectionContent extends StatefulWidget {
  const _DepartmentSectionContent({required this.branchId});

  final String branchId;

  @override
  State<_DepartmentSectionContent> createState() => _DepartmentSectionState();
}

final class _DepartmentSectionState extends State<_DepartmentSectionContent>
    with _DepartmentSectionStateMixin {
  @override
  Widget build(BuildContext context) {
    return AppSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText.sectionTitle(LocaleKeys.institution_departments.tr()),
          const EmptySize.s12Height(),
          const _DepartmentList(),
          const EmptySize.s12Height(),
          _DepartmentAddRow(controller: controller, onAdd: add),
          const _DepartmentSaveError(),
        ],
      ),
    );
  }
}

/// Edits one department name and shows request feedback.
final class _DepartmentEditDialog extends StatefulWidget {
  const _DepartmentEditDialog({required this.item});

  final Department item;

  @override
  State<_DepartmentEditDialog> createState() => _DepartmentEditDialogState();
}

final class _DepartmentEditDialogState extends State<_DepartmentEditDialog> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.item.name);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentSaveCubit, InstitutionSaveState<Department>>(
      builder: (context, state) => AlertDialog(
        title: AppText.sectionTitle(LocaleKeys.institution_departments.tr()),
        content: _DepartmentEditContent(controller: controller, state: state),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText.label(LocaleKeys.institution_cancel.tr()),
          ),
          FilledButton(
            onPressed: state is InstitutionSaveSaving<Department>
                ? null
                : _save,
            child: AppText.label(
              LocaleKeys.institution_save.tr(),
              tone: TextTone.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final save = context.read<DepartmentSaveCubit>();
    await save.update(widget.item, controller.text.trim());
    if (mounted && save.state is InstitutionSaveSaved<Department>) {
      Navigator.pop(context);
    }
  }
}
