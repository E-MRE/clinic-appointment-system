part of 'department_section.dart';

/// Displays a failed department create request.
final class _DepartmentSaveError extends StatelessWidget {
  const _DepartmentSaveError();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentSaveCubit, InstitutionSaveState<Department>>(
      builder: (context, state) {
        if (state is InstitutionSaveFailure<Department>) {
          return AppText.caption(state.code.message, tone: TextTone.error);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
