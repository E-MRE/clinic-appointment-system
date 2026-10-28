part of 'branch_form_page.dart';

/// Displays a failed branch save request.
final class _BranchFormSaveError extends StatelessWidget {
  const _BranchFormSaveError();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchSaveCubit, InstitutionSaveState<Branch>>(
      builder: (context, state) {
        if (state is InstitutionSaveFailure<Branch>) {
          return AppText.caption(state.code.message, tone: TextTone.error);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
